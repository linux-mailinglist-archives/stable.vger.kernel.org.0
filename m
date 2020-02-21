Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC1CF167539
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388667AbgBUIYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:24:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:37280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732961AbgBUIYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:24:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13037246AA;
        Fri, 21 Feb 2020 08:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273481;
        bh=q2TutZycWO+06LIexJy5S4hJwrIdMx3yDfrCaRz7C08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqCP/Y2kX6bT/BmHtD0HtQWbC2a2PxYYhTkDDgkP9Di3WY2MGXW7JIX+NMRLaaSoe
         bHcV4LARCHpRPKpSAKfq/JE9BsnAYEB7sUDN7d1s9Ai9XaOxkDFsLdiB59re2K16sI
         CvbbUkbeJT3KsTmNephs1bAZQ/ZZrFHRrs1mPm1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 187/191] help_next should increase position index
Date:   Fri, 21 Feb 2020 08:42:40 +0100
Message-Id: <20200221072313.291976267@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



