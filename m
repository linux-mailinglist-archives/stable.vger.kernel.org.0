Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BB436ADC5
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhDZHi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232789AbhDZHh2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:37:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68540613D4;
        Mon, 26 Apr 2021 07:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422537;
        bh=GN1FnzSl9rZW2yyvpcAqel0k8oxKcc8JHDVy1X8oPUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PLrmzL+tPEl90rtsxNsA3PvTvwpY2ExD6YQ5Wg0+LPX0Qi9PilHTXLamh2aX98rD3
         lngut4Euck8mtuOh1Xvn27gxuRgXrb0MB+Sx/5es/rtq+88sWxdlsnbYSKWEj9vzuC
         M5gNIVJajQOgqlVgZYxic4dwyYE7A+9AMUNmgtEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shujin Li <lishujin@kuaishou.com>,
        Jason Xing <xingwanli@kuaishou.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 30/49] i40e: fix the panic when running bpf in xdpdrv mode
Date:   Mon, 26 Apr 2021 09:29:26 +0200
Message-Id: <20210426072820.749417830@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.721586742@linuxfoundation.org>
References: <20210426072819.721586742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Xing <xingwanli@kuaishou.com>

commit 4e39a072a6a0fc422ba7da5e4336bdc295d70211 upstream.

Fix this panic by adding more rules to calculate the value of @rss_size_max
which could be used in allocating the queues when bpf is loaded, which,
however, could cause the failure and then trigger the NULL pointer of
vsi->rx_rings. Prio to this fix, the machine doesn't care about how many
cpus are online and then allocates 256 queues on the machine with 32 cpus
online actually.

Once the load of bpf begins, the log will go like this "failed to get
tracking for 256 queues for VSI 0 err -12" and this "setup of MAIN VSI
failed".

Thus, I attach the key information of the crash-log here.

BUG: unable to handle kernel NULL pointer dereference at
0000000000000000
RIP: 0010:i40e_xdp+0xdd/0x1b0 [i40e]
Call Trace:
[2160294.717292]  ? i40e_reconfig_rss_queues+0x170/0x170 [i40e]
[2160294.717666]  dev_xdp_install+0x4f/0x70
[2160294.718036]  dev_change_xdp_fd+0x11f/0x230
[2160294.718380]  ? dev_disable_lro+0xe0/0xe0
[2160294.718705]  do_setlink+0xac7/0xe70
[2160294.719035]  ? __nla_parse+0xed/0x120
[2160294.719365]  rtnl_newlink+0x73b/0x860

Fixes: 41c445ff0f48 ("i40e: main driver core")
Co-developed-by: Shujin Li <lishujin@kuaishou.com>
Signed-off-by: Shujin Li <lishujin@kuaishou.com>
Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -8941,6 +8941,7 @@ static int i40e_sw_init(struct i40e_pf *
 {
 	int err = 0;
 	int size;
+	u16 pow;
 
 	/* Set default capability flags */
 	pf->flags = I40E_FLAG_RX_CSUM_ENABLED |
@@ -8959,6 +8960,11 @@ static int i40e_sw_init(struct i40e_pf *
 	pf->rss_table_size = pf->hw.func_caps.rss_table_size;
 	pf->rss_size_max = min_t(int, pf->rss_size_max,
 				 pf->hw.func_caps.num_tx_qp);
+
+	/* find the next higher power-of-2 of num cpus */
+	pow = roundup_pow_of_two(num_online_cpus());
+	pf->rss_size_max = min_t(int, pf->rss_size_max, pow);
+
 	if (pf->hw.func_caps.rss) {
 		pf->flags |= I40E_FLAG_RSS_ENABLED;
 		pf->alloc_rss_size = min_t(int, pf->rss_size_max,


