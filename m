Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9681C3C3175
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235212AbhGJClZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235820AbhGJCjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5F6E61444;
        Sat, 10 Jul 2021 02:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884573;
        bh=dRcdDPEWchcf4A2Upk4RQmNEzi/AkR4iSvDC7K6DNeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sC9qLdEUN6XsPD2CcPAyWTbnLnJGjffsd4U/M1bp1jw3TaGUNwLNPD/jFOI93+WD/
         I2IcaovaeC6pbUjkaggZTliQOY+rcWqzo2VDbUaqg29YqznytDABdl/BOxpxKV8z1O
         /zDSLkqfMhBjB08SJnJLUP+lx+3Sdr3Ktv5jynuvk7+cy0nvATDeHsuThHnB+q4XNK
         J7KuZgWrCw6q6Wk+0yQw4+T//zTFEoIoZcebS8n2gsYmNdiUxxM3TDSMpR6Rlb5hyB
         JK0DlXN+P3NJLSsJEM72iXsMRG7mCxYMNz1uZnxrbrL0fV6xrFsHp2FnkZfA8i4Wk4
         mSsAibtr4viBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.9 07/26] fs/jfs: Fix missing error code in lmLogInit()
Date:   Fri,  9 Jul 2021 22:35:45 -0400
Message-Id: <20210710023604.3172486-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023604.3172486-1-sashal@kernel.org>
References: <20210710023604.3172486-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 492109333c29e1bb16d8732e1d597b02e8e0bf2e ]

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'rc.

Eliminate the follow smatch warning:

fs/jfs/jfs_logmgr.c:1327 lmLogInit() warn: missing error code 'rc'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_logmgr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index a21ea8b3e5fa..12555c4eeb2b 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1338,6 +1338,7 @@ int lmLogInit(struct jfs_log * log)
 		} else {
 			if (memcmp(logsuper->uuid, log->uuid, 16)) {
 				jfs_warn("wrong uuid on JFS log device");
+				rc = -EINVAL;
 				goto errout20;
 			}
 			log->size = le32_to_cpu(logsuper->size);
-- 
2.30.2

