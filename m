Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E52A3D61C1
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbhGZPcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237810AbhGZP3Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6FF261051;
        Mon, 26 Jul 2021 16:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315724;
        bh=x2ea9C1VNUOcWDYm/FE+GejePiRouX+L7hmIegZxezs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5yuooOi57NJa/rBIbovtK9fJxBV0hn7RaW4WW6rK1IWDA8PZQkZMGKeY1sgt/sbq
         RvcBjX5xbhefzsHgmdeBUseav14/B6XnkiquxlVZ5V0S+WtoBrEtu62QhuZbiRBsSR
         vDe9woLlp7+C/dliaA8zOjTQ2olDWR3vdNEN1jYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 042/223] sfc: fix lack of XDP TX queues - error XDP TX failed (-22)
Date:   Mon, 26 Jul 2021 17:37:14 +0200
Message-Id: <20210726153847.626952746@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit f28100cb9c9645c07cbd22431278ac9492f6a01c ]

Fixes: e26ca4b53582 sfc: reduce the number of requested xdp ev queues

The buggy commit intended to allocate less channels for XDP in order to
be more unlikely to reach the limit of 32 channels of the driver.

The idea was to use each IRQ/eventqeue for more XDP TX queues than
before, calculating which is the maximum number of TX queues that one
event queue can handle. For example, in EF10 each event queue could
handle up to 8 queues, better than the 4 they were handling before the
change. This way, it would have to allocate half of channels than before
for XDP TX.

The problem is that the TX queues are also contained inside the channel
structs, and there are only 4 queues per channel. Reducing the number of
channels means also reducing the number of queues, resulting in not
having the desired number of 1 queue per CPU.

This leads to getting errors on XDP_TX and XDP_REDIRECT if they're
executed from a high numbered CPU, because there only exist queues for
the low half of CPUs, actually. If XDP_TX/REDIRECT is executed in a low
numbered CPU, the error doesn't happen. This is the error in the logs
(repeated many times, even rate limited):
sfc 0000:5e:00.0 ens3f0np0: XDP TX failed (-22)

This errors happens in function efx_xdp_tx_buffers, where it expects to
have a dedicated XDP TX queue per CPU.

Reverting the change makes again more likely to reach the limit of 32
channels in machines with many CPUs. If this happen, no XDP_TX/REDIRECT
will be possible at all, and we will have this log error messages:

At interface probe:
sfc 0000:5e:00.0: Insufficient resources for 12 XDP event queues (24 other channels, max 32)

At every subsequent XDP_TX/REDIRECT failure, rate limited:
sfc 0000:5e:00.0 ens3f0np0: XDP TX failed (-22)

However, without reverting the change, it makes the user to think that
everything is OK at probe time, but later it fails in an unpredictable
way, depending on the CPU that handles the packet.

It is better to restore the predictable behaviour. If the user sees the
error message at probe time, he/she can try to configure the best way it
fits his/her needs. At least, he/she will have 2 options:
- Accept that XDP_TX/REDIRECT is not available (he/she may not need it)
- Load sfc module with modparam 'rss_cpus' with a lower number, thus
  creating less normal RX queues/channels, letting more free resources
  for XDP, with some performance penalty.

Anyway, let the calculation of maximum TX queues that can be handled by
a single event queue, and use it only if it's less than the number of TX
queues per channel. This doesn't happen in practice, but could happen if
some constant values are tweaked in the future, such us
EFX_MAX_TXQ_PER_CHANNEL, EFX_MAX_EVQ_SIZE or EFX_MAX_DMAQ_SIZE.

Related mailing list thread:
https://lore.kernel.org/bpf/20201215104327.2be76156@carbon/

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx_channels.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index a3ca406a3561..5b71f8a03a6d 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -152,6 +152,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 	 * maximum size.
 	 */
 	tx_per_ev = EFX_MAX_EVQ_SIZE / EFX_TXQ_MAX_ENT(efx);
+	tx_per_ev = min(tx_per_ev, EFX_MAX_TXQ_PER_CHANNEL);
 	n_xdp_tx = num_possible_cpus();
 	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, tx_per_ev);
 
@@ -181,7 +182,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 		efx->xdp_tx_queue_count = 0;
 	} else {
 		efx->n_xdp_channels = n_xdp_ev;
-		efx->xdp_tx_per_channel = EFX_MAX_TXQ_PER_CHANNEL;
+		efx->xdp_tx_per_channel = tx_per_ev;
 		efx->xdp_tx_queue_count = n_xdp_tx;
 		n_channels += n_xdp_ev;
 		netif_dbg(efx, drv, efx->net_dev,
-- 
2.30.2



