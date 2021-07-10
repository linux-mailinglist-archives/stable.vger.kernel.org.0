Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E473C31D0
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbhGJCpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235342AbhGJCnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:43:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F1C9613F0;
        Sat, 10 Jul 2021 02:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884760;
        bh=7RVlGp/VCGgNC+AZUVJrD/WDe+wKEsOz8Qdzjhn0Hbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNQTdg8BixqXQ9AOCMS2wn2ZKht/U6iOedUppzsFC6tzn/fecYXPobYixSYV1Om6S
         y1vyRdNkVO1J3IM32T3dRLWd2g0aUR3veHiEg4/tUmrvHL0ldLSpKtiex6jWL2vGdT
         8E5nMhgEybz40z6HBiQog2z7C5OdYgkFIIW2AWi0ebn7Td4xFoQ7VJDXvcYeGcknUm
         m6spsd6Ozkvho2J4GZu21hYFNCwSYSUAdQAAXFGyUp+Lce9kqqn2bMUVJ63esOPUlk
         9ktzjgTeL7D8VAuQfTcIumvwt0lpOqMUuVo1UyO10Bn+4p5xAFztmQiavdC7AXDjyd
         IA/BasSV9vTsw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.4 06/23] fs/jfs: Fix missing error code in lmLogInit()
Date:   Fri,  9 Jul 2021 22:38:55 -0400
Message-Id: <20210710023912.3172972-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023912.3172972-1-sashal@kernel.org>
References: <20210710023912.3172972-1-sashal@kernel.org>
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
index a69bdf2a1085..d19542a88c2c 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -1339,6 +1339,7 @@ int lmLogInit(struct jfs_log * log)
 		} else {
 			if (memcmp(logsuper->uuid, log->uuid, 16)) {
 				jfs_warn("wrong uuid on JFS log device");
+				rc = -EINVAL;
 				goto errout20;
 			}
 			log->size = le32_to_cpu(logsuper->size);
-- 
2.30.2

