Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E0049A4DE
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2372028AbiAYAK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2363975AbiAXXq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:46:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C997C034004;
        Mon, 24 Jan 2022 13:41:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28E0661491;
        Mon, 24 Jan 2022 21:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31F5C340E4;
        Mon, 24 Jan 2022 21:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060469;
        bh=clJKJIMLveFPr341YCQwA2mBwhvvUxBYHR+Sa1luDz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joH1g3i3h+XhkHuOmqoqDlVDfsPGDrEKPUOpqi3eBUeyd4yW7shZB6Lzd9u4fh1zD
         7XDKAwevdZ7PXBSOMKi2nBAUK7Fbri2g4HrmpGYGlgmOfdXkw2ZsbMT9NKksFT8Lbz
         EJNpyIaWiKg2Ab3Moh1tqkLYs1E1BgjQvzgkAQAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.16 0958/1039] f2fs: fix to check available space of CP area correctly in update_ckpt_flags()
Date:   Mon, 24 Jan 2022 19:45:47 +0100
Message-Id: <20220124184157.498540022@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

commit b702c83e2eaa2fa2d72e957c55c0321535cc8b9f upstream.

Otherwise, nat_bit area may be persisted across boundary of CP area during
nat_bit rebuilding.

Fixes: 94c821fb286b ("f2fs: rebuild nat_bits during umount")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/checkpoint.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1302,8 +1302,8 @@ static void update_ckpt_flags(struct f2f
 	unsigned long flags;
 
 	if (cpc->reason & CP_UMOUNT) {
-		if (le32_to_cpu(ckpt->cp_pack_total_block_count) >
-			sbi->blocks_per_seg - NM_I(sbi)->nat_bits_blocks) {
+		if (le32_to_cpu(ckpt->cp_pack_total_block_count) +
+			NM_I(sbi)->nat_bits_blocks > sbi->blocks_per_seg) {
 			clear_ckpt_flags(sbi, CP_NAT_BITS_FLAG);
 			f2fs_notice(sbi, "Disable nat_bits due to no space");
 		} else if (!is_set_ckpt_flags(sbi, CP_NAT_BITS_FLAG) &&


