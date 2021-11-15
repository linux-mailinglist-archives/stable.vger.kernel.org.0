Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C501A4512D6
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347482AbhKOTj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:39:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245053AbhKOTSr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D7F3634EE;
        Mon, 15 Nov 2021 18:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000854;
        bh=4SU+M9U1OCRiVdcWoAiCQcy6gGx7KwNB0uJU271r/hM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/YG8X6qD3DWOCCdzbPehaexIFfNLLISBvGO8lE4LJjTOSDLsNVWk3ojLcwycONJY
         Vk8s5gplUiMwoU2A3Ob05EWcvb/R0rBxM8U0GeeEkyImeupwa9ciL3KEZSY7AmBWK4
         tBCLOKvJ8KS45X1nXWrzvaeGTjxX5GIiSaHGshyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 784/849] selftests/net: udpgso_bench_rx: fix port argument
Date:   Mon, 15 Nov 2021 18:04:27 +0100
Message-Id: <20211115165446.761110163@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit d336509cb9d03970911878bb77f0497f64fda061 ]

The below commit added optional support for passing a bind address.
It configures the sockaddr bind arguments before parsing options and
reconfigures on options -b and -4.

This broke support for passing port (-p) on its own.

Configure sockaddr after parsing all arguments.

Fixes: 3327a9c46352 ("selftests: add functionals test for UDP GRO")
Reported-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index 76a24052f4b47..6a193425c367f 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -293,19 +293,17 @@ static void usage(const char *filepath)
 
 static void parse_opts(int argc, char **argv)
 {
+	const char *bind_addr = NULL;
 	int c;
 
-	/* bind to any by default */
-	setup_sockaddr(PF_INET6, "::", &cfg_bind_addr);
 	while ((c = getopt(argc, argv, "4b:C:Gl:n:p:rR:S:tv")) != -1) {
 		switch (c) {
 		case '4':
 			cfg_family = PF_INET;
 			cfg_alen = sizeof(struct sockaddr_in);
-			setup_sockaddr(PF_INET, "0.0.0.0", &cfg_bind_addr);
 			break;
 		case 'b':
-			setup_sockaddr(cfg_family, optarg, &cfg_bind_addr);
+			bind_addr = optarg;
 			break;
 		case 'C':
 			cfg_connect_timeout_ms = strtoul(optarg, NULL, 0);
@@ -341,6 +339,11 @@ static void parse_opts(int argc, char **argv)
 		}
 	}
 
+	if (!bind_addr)
+		bind_addr = cfg_family == PF_INET6 ? "::" : "0.0.0.0";
+
+	setup_sockaddr(cfg_family, bind_addr, &cfg_bind_addr);
+
 	if (optind != argc)
 		usage(argv[0]);
 
-- 
2.33.0



