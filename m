Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1CE1D3C4F
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgENSw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728475AbgENSwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:52:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A14F2074A;
        Thu, 14 May 2020 18:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482374;
        bh=TNfQUPHL871S8SzHAIrEd4FGcADJi70auZ4zXqmTUxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtQNypKtenVPoVbvmRc90TGo/C+f6Tk5edu9ERWSnYRLzXjqKWjh6atGy8g49iw8s
         iLzlQi6c1RqDCgHQeHuzctnIyeSxvx7j56QF6dzH4wGn4SX1ixJqiQVTlxICaXofU8
         tCdDlwWIpUGTf7g7L7Gc/UfGhEASg89ccXYPyqac=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunfeng Ye <yeyunfeng@huawei.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.6 52/62] tools/bootconfig: Fix resource leak in apply_xbc()
Date:   Thu, 14 May 2020 14:51:37 -0400
Message-Id: <20200514185147.19716-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a9b97814d1a93..5dbe893cf00cc 100644
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
2.20.1

