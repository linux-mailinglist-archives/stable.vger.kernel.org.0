Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 667651E2C30
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404177AbgEZTM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:12:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404170AbgEZTM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:12:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92525208DB;
        Tue, 26 May 2020 19:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520377;
        bh=DjlhHUZDtsooc2pYbEF4q0noeXu2UUg4RSSjcFAuF0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8j2OA3dHegzwLXXz+/vMf1iaZUp0hbW/6l7xbSHdayok+UmO9NkuAxgzTrHP6SU9
         B+yTSFyEunuCHlTimxBjT2uVIdrvJ8SjsrODwQySMQcIs3BVXNA79HNrMWTBy04xOs
         loUSBF/SRDOr8Pk84v4EGRsdHeX0sLzDBHyi3Z1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Yunfeng Ye <yeyunfeng@huawei.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 054/126] tools/bootconfig: Fix resource leak in apply_xbc()
Date:   Tue, 26 May 2020 20:53:11 +0200
Message-Id: <20200526183942.598735361@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfeng Ye <yeyunfeng@huawei.com>

[ Upstream commit 8842604446d1f005abcbf8c63c12eabdb5695094 ]

Fix the @data and @fd allocations that are leaked in the error path of
apply_xbc().

Link: http://lkml.kernel.org/r/583a49c9-c27a-931d-e6c2-6f63a4b18bea@huawei.com

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bootconfig/main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
index a9b97814d1a9..5dbe893cf00c 100644
--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -287,6 +287,7 @@ int apply_xbc(const char *path, const char *xbc_path)
 	ret = delete_xbc(path);
 	if (ret < 0) {
 		pr_err("Failed to delete previous boot config: %d\n", ret);
+		free(data);
 		return ret;
 	}
 
@@ -294,24 +295,26 @@ int apply_xbc(const char *path, const char *xbc_path)
 	fd = open(path, O_RDWR | O_APPEND);
 	if (fd < 0) {
 		pr_err("Failed to open %s: %d\n", path, fd);
+		free(data);
 		return fd;
 	}
 	/* TODO: Ensure the @path is initramfs/initrd image */
 	ret = write(fd, data, size + 8);
 	if (ret < 0) {
 		pr_err("Failed to apply a boot config: %d\n", ret);
-		return ret;
+		goto out;
 	}
 	/* Write a magic word of the bootconfig */
 	ret = write(fd, BOOTCONFIG_MAGIC, BOOTCONFIG_MAGIC_LEN);
 	if (ret < 0) {
 		pr_err("Failed to apply a boot config magic: %d\n", ret);
-		return ret;
+		goto out;
 	}
+out:
 	close(fd);
 	free(data);
 
-	return 0;
+	return ret;
 }
 
 int usage(void)
-- 
2.25.1



