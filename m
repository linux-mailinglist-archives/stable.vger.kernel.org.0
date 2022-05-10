Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7A8521900
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243734AbiEJNlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245169AbiEJNig (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62299263DA5;
        Tue, 10 May 2022 06:27:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3298615C8;
        Tue, 10 May 2022 13:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE23C385C2;
        Tue, 10 May 2022 13:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189273;
        bh=7YK7im3ERblhZ5O91Xt2vvBiiKK/aV4yCGuCiom7j9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=arxno62haOyilszwua/H/3Kb6J8jkBdzPmvNY/GIfwHMzP6DGyx0Ym5I6fENxIMCP
         7KVX3DOZsNzSMTZ0YgqJGQtLG5LBmdrWNuuwuRpwgNWD3y9xDzM8TGbJzidTrNKLO1
         cI7aM/BJwVIBZFNnCQTIpBqUnqElxZ11OhZd4S0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haimin Zhang <tcs.kernel@gmail.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Nobel Barakat <nobelbarakat@google.com>
Subject: [PATCH 5.10 66/70] block-map: add __GFP_ZERO flag for alloc_page in function bio_copy_kern
Date:   Tue, 10 May 2022 15:08:25 +0200
Message-Id: <20220510130734.798923810@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haimin Zhang <tcs.kernel@gmail.com>

commit cc8f7fe1f5eab010191aa4570f27641876fa1267 upstream.

Add __GFP_ZERO flag for alloc_page in function bio_copy_kern to initialize
the buffer of a bio.

Signed-off-by: Haimin Zhang <tcs.kernel@gmail.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220216084038.15635-1-tcs.kernel@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[nobelbarakat: Backported to 5.10: Manually added flag] 
Signed-off-by: Nobel Barakat <nobelbarakat@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-map.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -488,7 +488,7 @@ static struct bio *bio_copy_kern(struct
 		if (bytes > len)
 			bytes = len;
 
-		page = alloc_page(q->bounce_gfp | gfp_mask);
+		page = alloc_page(q->bounce_gfp | __GFP_ZERO | gfp_mask);
 		if (!page)
 			goto cleanup;
 


