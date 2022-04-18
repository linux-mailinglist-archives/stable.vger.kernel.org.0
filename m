Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF005053F9
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240848AbiDRNB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242513AbiDRNAB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:00:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE393134B;
        Mon, 18 Apr 2022 05:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D5DB61218;
        Mon, 18 Apr 2022 12:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9A8C385A1;
        Mon, 18 Apr 2022 12:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285688;
        bh=LQPRrzsPuk3UiGHZPzBJ3WvbKAYxjT0D/NxWnxfFlxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAIqGrCMoOsZ+8Ka+BQyhBE7fqVRr1L/sEn3ANbAp9zjDtlIKBsvQPbJpIuHyK2zS
         TbtNXxT3GZVNfi97kq+AyzSdAMyuYTkxPMSENWH4W+8voaep7vZ8VElC57yiPNyi4D
         LFEk+fNOKdsLtjh8nIWv+QJqg6fnTj59tPvhCDCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.10 091/105] dm integrity: fix memory corruption when tag_size is less than digest size
Date:   Mon, 18 Apr 2022 14:13:33 +0200
Message-Id: <20220418121149.218998572@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

commit 08c1af8f1c13bbf210f1760132f4df24d0ed46d6 upstream.

It is possible to set up dm-integrity in such a way that the
"tag_size" parameter is less than the actual digest size. In this
situation, a part of the digest beyond tag_size is ignored.

In this case, dm-integrity would write beyond the end of the
ic->recalc_tags array and corrupt memory. The corruption happened in
integrity_recalc->integrity_sector_checksum->crypto_shash_final.

Fix this corruption by increasing the tags array so that it has enough
padding at the end to accomodate the loop in integrity_recalc() being
able to write a full digest size for the last member of the tags
array.

Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4232,6 +4232,7 @@ try_smaller_buffer:
 	}
 
 	if (ic->internal_hash) {
+		size_t recalc_tags_size;
 		ic->recalc_wq = alloc_workqueue("dm-integrity-recalc", WQ_MEM_RECLAIM, 1);
 		if (!ic->recalc_wq ) {
 			ti->error = "Cannot allocate workqueue";
@@ -4245,8 +4246,10 @@ try_smaller_buffer:
 			r = -ENOMEM;
 			goto bad;
 		}
-		ic->recalc_tags = kvmalloc_array(RECALC_SECTORS >> ic->sb->log2_sectors_per_block,
-						 ic->tag_size, GFP_KERNEL);
+		recalc_tags_size = (RECALC_SECTORS >> ic->sb->log2_sectors_per_block) * ic->tag_size;
+		if (crypto_shash_digestsize(ic->internal_hash) > ic->tag_size)
+			recalc_tags_size += crypto_shash_digestsize(ic->internal_hash) - ic->tag_size;
+		ic->recalc_tags = kvmalloc(recalc_tags_size, GFP_KERNEL);
 		if (!ic->recalc_tags) {
 			ti->error = "Cannot allocate tags for recalculating";
 			r = -ENOMEM;


