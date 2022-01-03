Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96016483273
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbiACO1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbiACO1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:27:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883AAC0698C3;
        Mon,  3 Jan 2022 06:27:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D76A8CE1109;
        Mon,  3 Jan 2022 14:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDB0C36AEB;
        Mon,  3 Jan 2022 14:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220017;
        bh=5D/gM1GEoK6AdJS5J3D0j/p7sN/TAOOZtnXhx9ZZTE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a8xZwFzhTSOeCfF6KEtO06JSkR4zbJ1WkXP5DHgil6UBGwpI1kqd4+i5CAgKSmPEn
         3At+qsHDaUWCqpkmVrX11cl7h20XNqCfiPWFMh2sDhN26Ml7KImM2/RtYW7Ka5r7rt
         SfEutyJxhyv6tTwkvmKCVsL0eC0Q6dbe4gsh7RKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianguo Wu <wujianguo@chinatelecom.cn>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/37] selftests/net: udpgso_bench_tx: fix dst ip argument
Date:   Mon,  3 Jan 2022 15:23:59 +0100
Message-Id: <20220103142052.529926044@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
References: <20220103142051.883166998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wujianguo <wujianguo@chinatelecom.cn>

[ Upstream commit 9c1952aeaa98b3cfc49e2a79cb2c7d6a674213e9 ]

udpgso_bench_tx call setup_sockaddr() for dest address before
parsing all arguments, if we specify "-p ${dst_port}" after "-D ${dst_ip}",
then ${dst_port} will be ignored, and using default cfg_port 8000.

This will cause test case "multiple GRO socks" failed in udpgro.sh.

Setup sockaddr after parsing all arguments.

Fixes: 3a687bef148d ("selftests: udp gso benchmark")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/ff620d9f-5b52-06ab-5286-44b945453002@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgso_bench_tx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
index 17512a43885e7..f1fdaa2702913 100644
--- a/tools/testing/selftests/net/udpgso_bench_tx.c
+++ b/tools/testing/selftests/net/udpgso_bench_tx.c
@@ -419,6 +419,7 @@ static void usage(const char *filepath)
 
 static void parse_opts(int argc, char **argv)
 {
+	const char *bind_addr = NULL;
 	int max_len, hdrlen;
 	int c;
 
@@ -446,7 +447,7 @@ static void parse_opts(int argc, char **argv)
 			cfg_cpu = strtol(optarg, NULL, 0);
 			break;
 		case 'D':
-			setup_sockaddr(cfg_family, optarg, &cfg_dst_addr);
+			bind_addr = optarg;
 			break;
 		case 'l':
 			cfg_runtime_ms = strtoul(optarg, NULL, 10) * 1000;
@@ -492,6 +493,11 @@ static void parse_opts(int argc, char **argv)
 		}
 	}
 
+	if (!bind_addr)
+		bind_addr = cfg_family == PF_INET6 ? "::" : "0.0.0.0";
+
+	setup_sockaddr(cfg_family, bind_addr, &cfg_dst_addr);
+
 	if (optind != argc)
 		usage(argv[0]);
 
-- 
2.34.1



