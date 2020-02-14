Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D35ED15E849
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392379AbgBNQ64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:58:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404351AbgBNQRB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F27CE24681;
        Fri, 14 Feb 2020 16:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697020;
        bh=q2TutZycWO+06LIexJy5S4hJwrIdMx3yDfrCaRz7C08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GwYsnBWZj6eV+/ZHSFHPmaCbn9kv0sroAQbwKtZaIoFTLVDRy19pKmP5W8S8VkBXp
         DhNISsv61hxb4khbDikVF1yWZ0F+3274RZjHmuwUggCtAsqI6VEQb771cYBtqrvIyc
         kiOtSPvNSF6Q4oYCgz+1sjROfN/rx01RiDqUnkIA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>, devel@lists.orangefs.org
Subject: [PATCH AUTOSEL 4.19 249/252] help_next should increase position index
Date:   Fri, 14 Feb 2020 11:11:44 -0500
Message-Id: <20200214161147.15842-249-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161147.15842-1-sashal@kernel.org>
References: <20200214161147.15842-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 9f198a2ac543eaaf47be275531ad5cbd50db3edf ]

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/orangefs-debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/orangefs/orangefs-debugfs.c b/fs/orangefs/orangefs-debugfs.c
index 0732cb08173e9..e24738c691f66 100644
--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -305,6 +305,7 @@ static void *help_start(struct seq_file *m, loff_t *pos)
 
 static void *help_next(struct seq_file *m, void *v, loff_t *pos)
 {
+	(*pos)++;
 	gossip_debug(GOSSIP_DEBUGFS_DEBUG, "help_next: start\n");
 
 	return NULL;
-- 
2.20.1

