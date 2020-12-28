Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C275E2E3DD3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437759AbgL1OUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:20:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437756AbgL1OUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:20:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 861D2206E5;
        Mon, 28 Dec 2020 14:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165175;
        bh=4X371F7lEJI/Lc7h9xUNP6ceNwUzEUDsuASy1FPiDHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUpX2OeicOGSIo/+sk1S2H/HHMWH7ZHozpsdKYThpP+kLsU+WTcULAQChhvz/YKoS
         jBAy3IUb1OfTJnM8beWDiCELSYb+uYk4Fgh8dV9qYgZI/sWTqEOWJOEGaOKtPnkatN
         zY0RJWubeXHya35n4h7Vi+xkIVuG25Ofjs38SiVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 411/717] samples/bpf: Fix possible hang in xdpsock with multiple threads
Date:   Mon, 28 Dec 2020 13:46:49 +0100
Message-Id: <20201228125040.666742163@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 092fde0f863b72b67c4d6dc03844f5658fc00a35 ]

Fix a possible hang in xdpsock that can occur when using multiple
threads. In this case, one or more of the threads might get stuck in
the while-loop in tx_only after the user has signaled the main thread
to stop execution. In this case, no more Tx packets will be sent, so a
thread might get stuck in the aforementioned while-loop. Fix this by
introducing a test inside the while-loop to check if the benchmark has
been terminated. If so, return from the function.

Fixes: cd9e72b6f210 ("samples/bpf: xdpsock: Add option to specify batch size")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20201210163407.22066-1-magnus.karlsson@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdpsock_user.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 1149e94ca32fd..33c58de58626c 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1250,6 +1250,8 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
 	while (xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx) <
 				      batch_size) {
 		complete_tx_only(xsk, batch_size);
+		if (benchmark_done)
+			return;
 	}
 
 	for (i = 0; i < batch_size; i++) {
-- 
2.27.0



