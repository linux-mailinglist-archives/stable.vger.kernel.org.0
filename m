Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD80F2C0795
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732905AbgKWMmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:42:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:55230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732901AbgKWMmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:42:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF318208C3;
        Mon, 23 Nov 2020 12:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135341;
        bh=APMwNvLMuXo23SHMJmAKotbo0FcG9tdlvq9d7IOVkyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3UDAtW/g+S43QPSyOGYhLFMMAGpoSo0kkIkVoEcikprnWOurykNiSo50nO2w3jnF
         ABlBX1QPjBaLYVa0N+G/mohfRZoukOBcFZvldMm6V0hEZSwMDRFvYmjKDXR/vyh+be
         tmG5h3AutD5CNMKE2FYAsi8shW4jMz/PttLppdfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe ROULLIER <christophe.roullier@st.com>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 033/252] net: stmmac: Use rtnl_lock/unlock on netif_set_real_num_rx_queues() call
Date:   Mon, 23 Nov 2020 13:19:43 +0100
Message-Id: <20201123121837.188095386@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@intel.com>

[ Upstream commit 8e5debed39017836a850c6c7bfacc93299d19bad ]

Fix an issue where dump stack is printed on suspend resume flow due to
netif_set_real_num_rx_queues() is not called with rtnl_lock held().

Fixes: 686cff3d7022 ("net: stmmac: Fix incorrect location to set real_num_rx|tx_queues")
Reported-by: Christophe ROULLIER <christophe.roullier@st.com>
Tested-by: Christophe ROULLIER <christophe.roullier@st.com>
Cc: Alexandre TORGUE <alexandre.torgue@st.com>
Reviewed-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
Link: https://lore.kernel.org/r/20201115074210.23605-1-vee.khee.wong@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5170,6 +5170,7 @@ int stmmac_resume(struct device *dev)
 			return ret;
 	}
 
+	rtnl_lock();
 	mutex_lock(&priv->lock);
 
 	stmmac_reset_queues_param(priv);
@@ -5185,6 +5186,7 @@ int stmmac_resume(struct device *dev)
 	stmmac_enable_all_queues(priv);
 
 	mutex_unlock(&priv->lock);
+	rtnl_unlock();
 
 	if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
 		rtnl_lock();


