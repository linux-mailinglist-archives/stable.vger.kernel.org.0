Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85990657B14
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbiL1PR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiL1PRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:17:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACC013F9D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:17:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8788261555
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987A9C433EF;
        Wed, 28 Dec 2022 15:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240671;
        bh=fynafiYg1CXyqNncemz0Iuu/0ZbQviEMUZ77osM7yr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKMlAt7sumLMBCDMASC1D9JqSk6f2ICP/0KRO+mvDVudS5Zpmqa/HkhuT9hXlxCf7
         Wb1RXab5xfNmQjDtmMLIJWCQRLg/08ph6vNn+FydQtaYkkWgbpPhtEn2T5A+YSXlB8
         EjQ6O4R4ubC+ruA25oMh77dYjCp2JlnqlwPgJnLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 380/731] f2fs: fix to destroy sbi->post_read_wq in error path of f2fs_fill_super()
Date:   Wed, 28 Dec 2022 15:38:07 +0100
Message-Id: <20221228144307.576836803@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit 7b02b2201893a71b881026cf574902019ab00db5 ]

In error path of f2fs_fill_super(), this patch fixes to call
f2fs_destroy_post_read_wq() once if we fail in f2fs_start_ckpt_thread().

Fixes: 261eeb9c1585 ("f2fs: introduce checkpoint_merge mount option")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index a0d1ef73b83e..f4e8de1f4789 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4428,9 +4428,9 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	f2fs_destroy_node_manager(sbi);
 free_sm:
 	f2fs_destroy_segment_manager(sbi);
-	f2fs_destroy_post_read_wq(sbi);
 stop_ckpt_thread:
 	f2fs_stop_ckpt_thread(sbi);
+	f2fs_destroy_post_read_wq(sbi);
 free_devices:
 	destroy_device_list(sbi);
 	kvfree(sbi->ckpt);
-- 
2.35.1



