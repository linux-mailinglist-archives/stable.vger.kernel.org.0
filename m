Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34C7346E77
	for <lists+stable@lfdr.de>; Wed, 24 Mar 2021 02:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhCXBHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 21:07:41 -0400
Received: from mail-m971.mail.163.com ([123.126.97.1]:38906 "EHLO
        mail-m971.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbhCXBHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 21:07:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=jDmKw
        smfdPUeQ2eaIc38URUQN8I2zqkw5DhJ8pout80=; b=SPtuT52q0vaeM/GhhmZzJ
        yCjUrA5GP8ifZY3wFsjXwZ2ZCJGzNqMjhzVMg90V5PWh0Dx/jY/0QdiG/tUO5ZAB
        JTbXguoLKjaE6gpGJ3RjWZnKwN0AGAaSAGQa7iQ9mpvWEDF0rj0C8WdbM+80q1ac
        6OfEdtzDlk6yeSp1G0krgA=
Received: from localhost.localdomain (unknown [36.112.33.106])
        by smtp1 (Coremail) with SMTP id GdxpCgDXDirLkFpgADDFBQ--.215S4;
        Wed, 24 Mar 2021 09:07:30 +0800 (CST)
From:   Zhen Zhao <zp_8483@163.com>
To:     stable@vger.kernel.org
Cc:     Zhen Zhao <zp_8483@163.com>
Subject: [PATCH v1] xfs: return err code if xfs_buf_associate_memory fail
Date:   Tue, 23 Mar 2021 21:06:53 -0400
Message-Id: <20210324010653.3006-1-zp_8483@163.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgDXDirLkFpgADDFBQ--.215S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF4DWF48AFy7Gr4fGFW8Xrb_yoW3CrX_Ga
        12kwn7Kw1kAryxta1UJr9aq3Wagrsakrn7Xr4fKa4ayr18AFnrJF4DJ3Z5Xr4UCr9xtFn5
        AwsYqryFvFW7CjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_yv37UUUUU==
X-Originating-IP: [36.112.33.106]
X-CM-SenderInfo: h2sbmkiyt6il2tof0z/xtbCtRJf4V0DcnnssgAAsS
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In kernel 3.10, when there is no memory left in the
system, fs_buf_associate_memory can fail, catch the
error and return.

Signed-off-by: Zhen Zhao <zp_8483@163.com>
---
 fs/xfs/xfs_log.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2e5581bc..32a41bf5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1916,8 +1916,11 @@ xlog_sync(
 	if (split) {
 		bp = iclog->ic_log->l_xbuf;
 		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
-		xfs_buf_associate_memory(bp,
+		error = xfs_buf_associate_memory(bp,
 				(char *)&iclog->ic_header + count, split);
+		if (error)
+			return error;
+
 		bp->b_fspriv = iclog;
 		bp->b_flags &= ~XBF_FLUSH;
 		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
-- 
2.27.0

