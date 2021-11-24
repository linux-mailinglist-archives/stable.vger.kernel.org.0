Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506D145C50D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345856AbhKXNyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:54:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354653AbhKXNwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:52:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AA266109E;
        Wed, 24 Nov 2021 13:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759082;
        bh=jc2yhZuGyLi/o6lCmR3w1DDCWz/qxeol8DSuNUcZmSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAfFsOrUB0GgGWcvJy7E/Q0sIewenBGwYBkjN8l5dtAhr+B+sWRukc2RXEOPT3PlY
         7XVUwZys68LAg5kIN8Pm8yJ1YsDf5Pp1SjiF9aywUik7fiMT9lWOjPtU+IDdKDKY7z
         LarSap5B/RUpPT4Bnr/PuSkSSf8Xwv4A9AhH5NiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/279] f2fs: fix wrong condition to trigger background checkpoint correctly
Date:   Wed, 24 Nov 2021 12:56:11 +0100
Message-Id: <20211124115721.617348914@linuxfoundation.org>
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

[ Upstream commit cd6d697a6e2013a0a85f8b261b16c8cfd50c1f5f ]

In f2fs_balance_fs_bg(), it needs to check both NAT_ENTRIES and INO_ENTRIES
memory usage to decide whether we should skip background checkpoint, otherwise
we may always skip checking INO_ENTRIES memory usage, so that INO_ENTRIES may
potentially cause high memory footprint.

Fixes: 493720a48543 ("f2fs: fix to avoid REQ_TIME and CP_TIME collision")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index a135d22474154..d716553bdc025 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -561,7 +561,7 @@ void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi, bool from_bg)
 		goto do_sync;
 
 	/* checkpoint is the only way to shrink partial cached entries */
-	if (f2fs_available_free_memory(sbi, NAT_ENTRIES) ||
+	if (f2fs_available_free_memory(sbi, NAT_ENTRIES) &&
 		f2fs_available_free_memory(sbi, INO_ENTRIES))
 		return;
 
-- 
2.33.0



