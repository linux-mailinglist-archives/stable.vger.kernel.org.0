Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D820A6AF564
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbjCGTYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbjCGTYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:24:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E62BC4893
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E817361522
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05110C433D2;
        Tue,  7 Mar 2023 19:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216218;
        bh=TX69eYVPL/l2Cr7xqU38S5xKf1yGcR63b2Li+V9I49E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3Vy3Mc86zWlvPJOn4hUO255RLxZ6nq1D5fRB0/6wDI6pOdMz+xSBhkUhIWwXTfak
         wnWbrkvLmoiW2aWStGAVbQl9ZfYb9AACpk0NxQMs7NE31K8t3nuD6Yrai7WHScgsTs
         1RTfB3VWctZ2Dzz40Zw2aLeUybiziTR8YmcEI5FY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.15 514/567] dm flakey: fix a bug with 32-bit highmem systems
Date:   Tue,  7 Mar 2023 18:04:10 +0100
Message-Id: <20230307165928.245824274@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 8eb29c4fbf9661e6bd4dd86197a37ffe0ecc9d50 upstream.

The function page_address does not work with 32-bit systems with high
memory. Use bvec_kmap_local/kunmap_local instead.

Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-flakey.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -305,8 +305,9 @@ static void corrupt_bio_data(struct bio
 			struct page *page = bio_iter_page(bio, iter);
 			if (unlikely(page == ZERO_PAGE(0)))
 				break;
-			segment = (page_address(page) + bio_iter_offset(bio, iter));
+			segment = bvec_kmap_local(&bvec);
 			segment[corrupt_bio_byte] = fc->corrupt_bio_value;
+			kunmap_local(segment);
 			DMDEBUG("Corrupting data bio=%p by writing %u to byte %u "
 				"(rw=%c bi_opf=%u bi_sector=%llu size=%u)\n",
 				bio, fc->corrupt_bio_value, fc->corrupt_bio_byte,


