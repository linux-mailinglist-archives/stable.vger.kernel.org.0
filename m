Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891263290C5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243102AbhCAUOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:14:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242811AbhCAUEI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:04:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28A05653A0;
        Mon,  1 Mar 2021 17:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621496;
        bh=eITzPkw4zzb73jnNnryBS8HhDfCDDfZbl6FiYhqnhe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MDal+YyILpEKJGEnqUUe+gkpSHsWFLDPZAHSVnPUNSgvbvsLwAKfF8CXUtnmzlkyE
         F+flFII03SEnm8/DodIFth69kb+Mo2n59fjODBL8V9Ak82X5vV9fmypvtfWjc66C+C
         btpcmnwQlPijyr3lKSkq0Ao9HYMBYFk16yJJPOg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 538/775] dpaa_eth: fix the access method for the dpaa_napi_portal
Date:   Mon,  1 Mar 2021 17:11:46 +0100
Message-Id: <20210301161228.069612957@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Camelia Groza <camelia.groza@nxp.com>

[ Upstream commit 433dfc99aa3e0acbf655b961d98eb690162f758f ]

The current use of container_of is flawed and unnecessary. Obtain
the dpaa_napi_portal reference from the private percpu data instead.

Fixes: a1e031ffb422 ("dpaa_eth: add XDP_REDIRECT support")
Reported-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Link: https://lore.kernel.org/r/20210218182106.22613-1-camelia.groza@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 6faa20bed4885..9905caeaeee3e 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2672,7 +2672,6 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 	u32 hash;
 	u64 ns;
 
-	np = container_of(&portal, struct dpaa_napi_portal, p);
 	dpaa_fq = container_of(fq, struct dpaa_fq, fq_base);
 	fd_status = be32_to_cpu(fd->status);
 	fd_format = qm_fd_get_format(fd);
@@ -2687,6 +2686,7 @@ static enum qman_cb_dqrr_result rx_default_dqrr(struct qman_portal *portal,
 
 	percpu_priv = this_cpu_ptr(priv->percpu_priv);
 	percpu_stats = &percpu_priv->stats;
+	np = &percpu_priv->np;
 
 	if (unlikely(dpaa_eth_napi_schedule(percpu_priv, portal, sched_napi)))
 		return qman_cb_dqrr_stop;
-- 
2.27.0



