Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6538C45C4A7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354428AbhKXNuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:50:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354221AbhKXNtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:49:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A07D61A50;
        Wed, 24 Nov 2021 13:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758954;
        bh=bdgE5lYpVo43pMp2r6By3qBAskT0XYAbiUokbSwtaHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qANrJQNbaMfUDYP3ssulAVOO9gwlEE0vELFzFTp8VcALyOOYtYXMCDchg+uV8tNZ0
         x25LYTHwDMvDUNJCueUtE7DD+1FR4+VpIJ9mWAcpF+TmY1HDwYhG5PL4scJKvLUQyV
         RxPRs0BT9KAXwlQqQpvwJF0UMFXgPRx060/tKYHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        tanghuan <tanghuan@vivo.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Fengnan Chang <changfengnan@vivo.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 083/279] f2fs: fix to use WHINT_MODE
Date:   Wed, 24 Nov 2021 12:56:10 +0100
Message-Id: <20211124115721.586062417@linuxfoundation.org>
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

From: Keoseong Park <keosung.park@samsung.com>

[ Upstream commit 011e0868e0cf1237675b22e36fffa958fb08f46e ]

Since active_logs can be set to 2 or 4 or NR_CURSEG_PERSIST_TYPE(6),
it cannot be set to NR_CURSEG_TYPE(8).
That is, whint_mode is always off.

Therefore, the condition is changed from NR_CURSEG_TYPE to NR_CURSEG_PERSIST_TYPE.

Cc: Chao Yu <chao@kernel.org>
Fixes: d0b9e42ab615 (f2fs: introduce inmem curseg)
Reported-by: tanghuan <tanghuan@vivo.com>
Signed-off-by: Keoseong Park <keosung.park@samsung.com>
Signed-off-by: Fengnan Chang <changfengnan@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index dbe040b66802c..4d24146b4f471 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1292,7 +1292,7 @@ default_check:
 	/* Not pass down write hints if the number of active logs is lesser
 	 * than NR_CURSEG_PERSIST_TYPE.
 	 */
-	if (F2FS_OPTION(sbi).active_logs != NR_CURSEG_TYPE)
+	if (F2FS_OPTION(sbi).active_logs != NR_CURSEG_PERSIST_TYPE)
 		F2FS_OPTION(sbi).whint_mode = WHINT_MODE_OFF;
 
 	if (f2fs_sb_has_readonly(sbi) && !f2fs_readonly(sbi->sb)) {
-- 
2.33.0



