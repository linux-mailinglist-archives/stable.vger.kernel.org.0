Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CA145C532
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352919AbhKXNzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349787AbhKXNvc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:51:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9796A63213;
        Wed, 24 Nov 2021 13:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759066;
        bh=g1PX9AtFkQdg83c94E5SjxeY6CKTnJmmzNl+9+mzTT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMd/tZaBf2Q98gls3EdqGteEeH1dedsHQ9Tc1kxbQGKtN+F4E7nqyJ93Ft/QSmzRj
         4ZLnGlKw3oMZ4i/XQ9ge/giXLlS17cEB50uSXz+UXlsoZrx3ckMvDDxNIS0zZoKgc8
         VtM5RCud8NNIB2E2gZCmnOCBxt5cIcotXXexoaIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/279] f2fs: fix incorrect return value in f2fs_sanity_check_ckpt()
Date:   Wed, 24 Nov 2021 12:56:16 +0100
Message-Id: <20211124115721.860637666@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <chao@kernel.org>

[ Upstream commit ca98d72141dd81f42893a9a43d7ededab3355fba ]

As Pavel Machek reported in [1]

This code looks quite confused: part of function returns 1 on
corruption, part returns -errno. The problem is not stable-specific.

[1] https://lkml.org/lkml/2021/9/19/207

Let's fix to make 'insane cp_payload case' to return 1 rater than
EFSCORRUPTED, so that return value can be kept consistent for all
error cases, it can avoid confusion of code logic.

Fixes: 65ddf6564843 ("f2fs: fix to do sanity check for sb/cp fields correctly")
Reported-by: Pavel Machek <pavel@denx.de>
Reviewed-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 4d24146b4f471..8795a5a8d4e89 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3487,7 +3487,7 @@ skip_cross:
 		NR_CURSEG_PERSIST_TYPE + nat_bits_blocks >= blocks_per_seg)) {
 		f2fs_warn(sbi, "Insane cp_payload: %u, nat_bits_blocks: %u)",
 			  cp_payload, nat_bits_blocks);
-		return -EFSCORRUPTED;
+		return 1;
 	}
 
 	if (unlikely(f2fs_cp_error(sbi))) {
-- 
2.33.0



