Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86ECC45C2EA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348600AbhKXNeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:34:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351569AbhKXNc2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:32:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0615F615A4;
        Wed, 24 Nov 2021 12:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758379;
        bh=CI7V8kf8FBuev+kJ24QH3lqRNZCPtEbUIUWBJCuILDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAq/R+MmKV0pei8/TVyfr4UNh0TsXsJZAPxhQXlG7OfYvycSKTp4gg9+PWJMw1JMw
         B4cwqm+5nHDOrfZkRA+JvvuFPR1y7qtrKm4+vfwj1jToDlNowxBH8aQv3uuPJuIzEx
         2xie950AJXq7B+hnezJn/gw6v7u9+8KQxFwN0tKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        tanghuan <tanghuan@vivo.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Fengnan Chang <changfengnan@vivo.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/154] f2fs: fix to use WHINT_MODE
Date:   Wed, 24 Nov 2021 12:57:27 +0100
Message-Id: <20211124115703.982619688@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
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
index de543168b3708..70b513e66af77 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1020,7 +1020,7 @@ static int parse_options(struct super_block *sb, char *options, bool is_remount)
 	/* Not pass down write hints if the number of active logs is lesser
 	 * than NR_CURSEG_PERSIST_TYPE.
 	 */
-	if (F2FS_OPTION(sbi).active_logs != NR_CURSEG_TYPE)
+	if (F2FS_OPTION(sbi).active_logs != NR_CURSEG_PERSIST_TYPE)
 		F2FS_OPTION(sbi).whint_mode = WHINT_MODE_OFF;
 	return 0;
 }
-- 
2.33.0



