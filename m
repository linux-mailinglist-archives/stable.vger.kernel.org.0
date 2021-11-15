Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9381445129E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347055AbhKOTiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:38:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244902AbhKOTSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49CD763280;
        Mon, 15 Nov 2021 18:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000712;
        bh=CetfNMgAKZlEJwEoEBexEWFzrY/qhFBW5oH6L+yRd68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJDcZ5xYheeFjO2s+YQd0LsSx4xZeakycL+BdRkUiGnCtvhZsxqjSx80XpmkXcPcY
         gF1bzzmN3wPDl5jUuMHvB0mpublb5wKDRnnZFGUxkALukA9HJxl50mgCOPuEyFbFeV
         NEO/MCBIy+gSNBp6dg/EVVG9GTdadBAE3fPyYAyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jussi Maki <joamaki@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 763/849] bpf, sockmap: Remove unhash handler for BPF sockmap usage
Date:   Mon, 15 Nov 2021 18:04:06 +0100
Message-Id: <20211115165446.062554275@linuxfoundation.org>
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

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit b8b8315e39ffaca82e79d86dde26e9144addf66b ]

We do not need to handle unhash from BPF side we can simply wait for the
close to happen. The original concern was a socket could transition from
ESTABLISHED state to a new state while the BPF hook was still attached.
But, we convinced ourself this is no longer possible and we also improved
BPF sockmap to handle listen sockets so this is no longer a problem.

More importantly though there are cases where unhash is called when data is
in the receive queue. The BPF unhash logic will flush this data which is
wrong. To be correct it should keep the data in the receive queue and allow
a receiving application to continue reading the data. This may happen when
tcp_abort() is received for example. Instead of complicating the logic in
unhash simply moving all this to tcp_close() hook solves this.

Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Jussi Maki <joamaki@gmail.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20211103204736.248403-3-john.fastabend@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 9d068153c3168..cd6c2ebc1185c 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -488,7 +488,6 @@ static void tcp_bpf_rebuild_protos(struct proto prot[TCP_BPF_NUM_CFGS],
 				   struct proto *base)
 {
 	prot[TCP_BPF_BASE]			= *base;
-	prot[TCP_BPF_BASE].unhash		= sock_map_unhash;
 	prot[TCP_BPF_BASE].close		= sock_map_close;
 	prot[TCP_BPF_BASE].recvmsg		= tcp_bpf_recvmsg;
 	prot[TCP_BPF_BASE].stream_memory_read	= tcp_bpf_stream_read;
-- 
2.33.0



