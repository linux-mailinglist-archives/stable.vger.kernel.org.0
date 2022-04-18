Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C574F5052A5
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239312AbiDRMuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240229AbiDRMtS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:49:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014FB2126A;
        Mon, 18 Apr 2022 05:33:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D2BFB80EDC;
        Mon, 18 Apr 2022 12:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF234C385B7;
        Mon, 18 Apr 2022 12:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285205;
        bh=/5HPItxFIZfMlhG76iLXGwbpMNMv5fQZGhvnKRZ1lhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lq0dmgfbu+cmyIOCd6J+Ke95lXFgrd4R15NhN5r2TT7kqvlifhvV0Upcijdrx46mK
         eK3UzI/EsBe0IbGwhbRIDmREqthaSKBnUwiOfHlfsvYzWYdj4dFz+d6WVjKkrIBSqB
         G3+75IqnLcH0MrOye5O4M5EeUEMDu8SXQU43RX08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/189] drbd: set QUEUE_FLAG_STABLE_WRITES
Date:   Mon, 18 Apr 2022 14:12:36 +0200
Message-Id: <20220418121205.195742487@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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

From: Christoph Böhmwalder <christoph@boehmwalder.at>

[ Upstream commit 286901941fd18a52b2138fddbbf589ad3639eb00 ]

We want our pages not to change while they are being written.

Signed-off-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 55234a558e98..548e0dd53528 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2737,6 +2737,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	sprintf(disk->disk_name, "drbd%d", minor);
 	disk->private_data = device;
 
+	blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, disk->queue);
 	blk_queue_write_cache(disk->queue, true, true);
 	/* Setting the max_hw_sectors to an odd value of 8kibyte here
 	   This triggers a max_bio_size message upon first attach or connect */
-- 
2.35.1



