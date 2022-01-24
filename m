Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24D2499589
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442074AbiAXUwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:52:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48374 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351590AbiAXUtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:49:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95405B81061;
        Mon, 24 Jan 2022 20:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56B5C340E7;
        Mon, 24 Jan 2022 20:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057349;
        bh=XmiM38+z9vU9eF+cGw0W1GcTqYfEXX41IXLFTK4g0Iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYwbJp9AzgJxP5KO++iyjLFtltdC7Tnm+tmuS+wvPMWNbQ0thEzoeuNuWTp7X9nUA
         hBV6bSeRfJ6zYOgjN79IBeZubAVrmBu/AxY0SxT8hVh7dg9Nq/9rKfoieUudwsqPeb
         x6aa66xAJpU2picwLt8cj3KRZlwlXRsV8/XwKzto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 782/846] f2fs: fix to check available space of CP area correctly in update_ckpt_flags()
Date:   Mon, 24 Jan 2022 19:44:59 +0100
Message-Id: <20220124184127.931729694@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -1305,8 +1305,8 @@ static void update_ckpt_flags(struct f2f
 	unsigned long flags;
 
 	if (cpc->reason & CP_UMOUNT) {
-		if (le32_to_cpu(ckpt->cp_pack_total_block_count) >
-			sbi->blocks_per_seg - NM_I(sbi)->nat_bits_blocks) {
+		if (le32_to_cpu(ckpt->cp_pack_total_block_count) +
+			NM_I(sbi)->nat_bits_blocks > sbi->blocks_per_seg) {
 			clear_ckpt_flags(sbi, CP_NAT_BITS_FLAG);
 			f2fs_notice(sbi, "Disable nat_bits due to no space");
 		} else if (!is_set_ckpt_flags(sbi, CP_NAT_BITS_FLAG) &&


