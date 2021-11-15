Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA911450ACC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbhKOROu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:14:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236816AbhKORNO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:13:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E5936322D;
        Mon, 15 Nov 2021 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996219;
        bh=yPnl2898nrE6RtHHU73x4+9hJWZEtVe9V0/DZ9UODN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2dUkMlyl811GYGUVo18EdDCzSJuaRjmtAh60qMzNgyIlJsYELn/islDKmzkc7L2rc
         ucNtqSnE2MU3k4DLo9vhAUGey784knO2z7q5PPF2F+DaVLyMwKAZ8txiwDZRXPmGpo
         gygfbAjDwO9YU6vy3Y8lSy8Fi0BdFcrfGaqflPvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Xiao <yu.xiao@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Niklas Soderlund <niklas.soderlund@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 058/355] nfp: bpf: relax prog rejection for mtu check through max_pkt_offset
Date:   Mon, 15 Nov 2021 17:59:42 +0100
Message-Id: <20211115165315.688815625@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Xiao <yu.xiao@corigine.com>

[ Upstream commit 90a881fc352a953f1c8beb61977a2db0818157d4 ]

MTU change is refused whenever the value of new MTU is bigger than
the max packet bytes that fits in NFP Cluster Target Memory (CTM).
However, an eBPF program doesn't always need to access the whole
packet data.

The maximum direct packet access (DPA) offset has always been
caculated by verifier and stored in the max_pkt_offset field of prog
aux data.

Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
Reviewed-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Niklas Soderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/bpf/main.c   | 16 +++++++++++-----
 drivers/net/ethernet/netronome/nfp/bpf/main.h   |  2 ++
 .../net/ethernet/netronome/nfp/bpf/offload.c    | 17 +++++++++++++----
 3 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
index 8f732771d3fad..bd2966eb6b7d3 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
@@ -182,15 +182,21 @@ static int
 nfp_bpf_check_mtu(struct nfp_app *app, struct net_device *netdev, int new_mtu)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
-	unsigned int max_mtu;
+	struct nfp_bpf_vnic *bv;
+	struct bpf_prog *prog;
 
 	if (~nn->dp.ctrl & NFP_NET_CFG_CTRL_BPF)
 		return 0;
 
-	max_mtu = nn_readb(nn, NFP_NET_CFG_BPF_INL_MTU) * 64 - 32;
-	if (new_mtu > max_mtu) {
-		nn_info(nn, "BPF offload active, MTU over %u not supported\n",
-			max_mtu);
+	if (nn->xdp_hw.prog) {
+		prog = nn->xdp_hw.prog;
+	} else {
+		bv = nn->app_priv;
+		prog = bv->tc_prog;
+	}
+
+	if (nfp_bpf_offload_check_mtu(nn, prog, new_mtu)) {
+		nn_info(nn, "BPF offload active, potential packet access beyond hardware packet boundary");
 		return -EBUSY;
 	}
 	return 0;
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.h b/drivers/net/ethernet/netronome/nfp/bpf/main.h
index fac9c6f9e197b..c74620fcc539c 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.h
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.h
@@ -560,6 +560,8 @@ bool nfp_is_subprog_start(struct nfp_insn_meta *meta);
 void nfp_bpf_jit_prepare(struct nfp_prog *nfp_prog);
 int nfp_bpf_jit(struct nfp_prog *prog);
 bool nfp_bpf_supported_opcode(u8 code);
+bool nfp_bpf_offload_check_mtu(struct nfp_net *nn, struct bpf_prog *prog,
+			       unsigned int mtu);
 
 int nfp_verify_insn(struct bpf_verifier_env *env, int insn_idx,
 		    int prev_insn_idx);
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/offload.c b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
index 88fab6a82acff..7ff388ecc7e3a 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/offload.c
@@ -477,19 +477,28 @@ int nfp_bpf_event_output(struct nfp_app_bpf *bpf, const void *data,
 	return 0;
 }
 
+bool nfp_bpf_offload_check_mtu(struct nfp_net *nn, struct bpf_prog *prog,
+			       unsigned int mtu)
+{
+	unsigned int fw_mtu, pkt_off;
+
+	fw_mtu = nn_readb(nn, NFP_NET_CFG_BPF_INL_MTU) * 64 - 32;
+	pkt_off = min(prog->aux->max_pkt_offset, mtu);
+
+	return fw_mtu < pkt_off;
+}
+
 static int
 nfp_net_bpf_load(struct nfp_net *nn, struct bpf_prog *prog,
 		 struct netlink_ext_ack *extack)
 {
 	struct nfp_prog *nfp_prog = prog->aux->offload->dev_priv;
-	unsigned int fw_mtu, pkt_off, max_stack, max_prog_len;
+	unsigned int max_stack, max_prog_len;
 	dma_addr_t dma_addr;
 	void *img;
 	int err;
 
-	fw_mtu = nn_readb(nn, NFP_NET_CFG_BPF_INL_MTU) * 64 - 32;
-	pkt_off = min(prog->aux->max_pkt_offset, nn->dp.netdev->mtu);
-	if (fw_mtu < pkt_off) {
+	if (nfp_bpf_offload_check_mtu(nn, prog, nn->dp.netdev->mtu)) {
 		NL_SET_ERR_MSG_MOD(extack, "BPF offload not supported with potential packet access beyond HW packet split boundary");
 		return -EOPNOTSUPP;
 	}
-- 
2.33.0



