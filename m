Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A8340E101
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241920AbhIPQ01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242110AbhIPQY1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:24:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 578A060F6C;
        Thu, 16 Sep 2021 16:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808982;
        bh=cjum1AsNWmvOrgUcR50d+tYsMXSVOPMkAp0BYQhLitU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Pxon7Erj8TZYPJIqc3fE0REGfLOPcAocQn2GNPnXGpZum/yCw1Yr3Zw24MevQAng
         QKbideaEGV5i69OoqFxjm7EKK84pADmcEvtlIX2XDE9NcOfBiFNg68R2+nEq3OPUAv
         Q+NvVBBSZZKQtp/jTxY1ro6FWMTf9H8dIdNbYDbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Hoffmann <jan@3e8.eu>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 295/306] net: dsa: lantiq_gswip: fix maximum frame length
Date:   Thu, 16 Sep 2021 18:00:40 +0200
Message-Id: <20210916155804.152506037@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Hoffmann <jan@3e8.eu>

commit 552799f8b3b0074d2617f53a63a088f9514a66e3 upstream.

Currently, outgoing packets larger than 1496 bytes are dropped when
tagged VLAN is used on a switch port.

Add the frame check sequence length to the value of the register
GSWIP_MAC_FLEN to fix this. This matches the lantiq_ppa vendor driver,
which uses a value consisting of 1518 bytes for the MAC frame, plus the
lengths of special tag and VLAN tags.

Fixes: 14fceff4771e ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Cc: stable@vger.kernel.org
Signed-off-by: Jan Hoffmann <jan@3e8.eu>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/lantiq_gswip.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -853,7 +853,8 @@ static int gswip_setup(struct dsa_switch
 
 	gswip_switch_mask(priv, 0, GSWIP_MAC_CTRL_2_MLEN,
 			  GSWIP_MAC_CTRL_2p(cpu_port));
-	gswip_switch_w(priv, VLAN_ETH_FRAME_LEN + 8, GSWIP_MAC_FLEN);
+	gswip_switch_w(priv, VLAN_ETH_FRAME_LEN + 8 + ETH_FCS_LEN,
+		       GSWIP_MAC_FLEN);
 	gswip_switch_mask(priv, 0, GSWIP_BM_QUEUE_GCTRL_GL_MOD,
 			  GSWIP_BM_QUEUE_GCTRL);
 


