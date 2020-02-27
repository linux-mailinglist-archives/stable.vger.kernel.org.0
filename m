Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33C23171FA1
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731375AbgB0OgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:36:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732563AbgB0N7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:59:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1795A2073D;
        Thu, 27 Feb 2020 13:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811945;
        bh=UKNtu5XRs/pDceewTzCYEE9giWtipSmHD1MFay/pACc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ip2KPLxBLY2JSiuBIcQPdO2kmRcjpF3gRtqxTllXcsaYlAnfF86Vimc20/x0pTRmE
         1QaQQ7jsELPUTOhkcpIZJ9AwHWGWOjSRYTiLkQq8UOntghxFzQf3sg1vVT9pQHOI8r
         CZUyWvgjs2kprCXdME1eaRjSkFGFZHmgzXMabbeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 163/237] help_next should increase position index
Date:   Thu, 27 Feb 2020 14:36:17 +0100
Message-Id: <20200227132308.489928813@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
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
index 1c59dff530dee..34d1cc98260d2 100644
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



