Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC54045136B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348238AbhKOTvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:51:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343524AbhKOTVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B8DF635A4;
        Mon, 15 Nov 2021 18:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001685;
        bh=Q+02j20E5URT8I7GlwHrWTkLn5Vyy7jLaEV8BTTVDz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJZcbVoTGJLDrYRfcdIfK+Z+LS+iOs5Z14H5F9SKUkGsFdczKmuyGUGUimgS9SLq/
         3C28p54fmcc7ODOLl9G9h9u4LC5vJ+q43PKV52qDOCLuGtK5cuTnMKbmakS4oWqkCk
         x/KTFOQEl14DXvytA6YXuK5n18ycOWfvQa71QFnI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        David Yang <davidcomponentone@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 282/917] samples/bpf: Fix application of sizeof to pointer
Date:   Mon, 15 Nov 2021 17:56:17 +0100
Message-Id: <20211115165438.332613830@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Yang <davidcomponentone@gmail.com>

[ Upstream commit b599015f044df53e93ad0a2957b615bc1a26bf73 ]

The coccinelle check report:
"./samples/bpf/xdp_redirect_cpu_user.c:397:32-38:
ERROR: application of sizeof to pointer"
Using the "strlen" to fix it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: David Yang <davidcomponentone@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20211012111649.983253-1-davidcomponentone@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdp_redirect_cpu_user.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 6e25fba64c72b..d84e6949007cc 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -325,7 +325,6 @@ int main(int argc, char **argv)
 	int add_cpu = -1;
 	int ifindex = -1;
 	int *cpu, i, opt;
-	char *ifname;
 	__u32 qsize;
 	int n_cpus;
 
@@ -393,9 +392,8 @@ int main(int argc, char **argv)
 				fprintf(stderr, "-d/--dev name too long\n");
 				goto end_cpu;
 			}
-			ifname = (char *)&ifname_buf;
-			safe_strncpy(ifname, optarg, sizeof(ifname));
-			ifindex = if_nametoindex(ifname);
+			safe_strncpy(ifname_buf, optarg, strlen(ifname_buf));
+			ifindex = if_nametoindex(ifname_buf);
 			if (!ifindex)
 				ifindex = strtoul(optarg, NULL, 0);
 			if (!ifindex) {
-- 
2.33.0



