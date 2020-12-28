Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771E72E3AE4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404335AbgL1Nm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:42:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403980AbgL1Nko (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:40:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2811720719;
        Mon, 28 Dec 2020 13:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162828;
        bh=9zyrPAlEvTT4BM8lGuO/XnPG08yCDOi8FVi8ovlf+78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bUqzYViPNseAyOwHKQl0iZTy6xEtUFC96OxlnPUFwOEAE6uSdESjrgaxd2u56cLBZ
         13evXv/H42FnixUef2NYHoOD4clVEDzKjwJBnd7u3l5iaqUWQXQNCLGqp4za+/wAVm
         eDyPQlrMk/talJ2ARM3rNe3O9b7kclB6pitMcJ70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/453] selftests: fix poll error in udpgro.sh
Date:   Mon, 28 Dec 2020 13:44:31 +0100
Message-Id: <20201228124938.953315786@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 38bf8cd821be292e7d8e6f6283d67c5d9708f887 ]

The test program udpgso_bench_rx always invokes the poll()
syscall with a timeout of 10ms. If a larger timeout is specified
via the command line, udpgso_bench_rx is supposed to do multiple
poll() calls till the timeout is expired or an event is received.

Currently the poll() loop errors out after the first invocation with
no events, and may causes self-tests failure alike:

failed
 GRO with custom segment size            ./udpgso_bench_rx: poll: 0x0 expected 0x1

This change addresses the issue allowing the poll() loop to consume
all the configured timeout.

Fixes: ada641ff6ed3 ("selftests: fixes for UDP GRO")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgso_bench_rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index db3d4a8b5a4c4..76a24052f4b47 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -113,6 +113,9 @@ static void do_poll(int fd, int timeout_ms)
 				interrupted = true;
 				break;
 			}
+
+			/* no events and more time to wait, do poll again */
+			continue;
 		}
 		if (pfd.revents != POLLIN)
 			error(1, errno, "poll: 0x%x expected 0x%x\n",
-- 
2.27.0



