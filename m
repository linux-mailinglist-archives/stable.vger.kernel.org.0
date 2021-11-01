Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A124417A5
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbhKAJiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233303AbhKAJgC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:36:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA0B261288;
        Mon,  1 Nov 2021 09:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758784;
        bh=Wd1TMrG9bhlBcjNM+Eh5nn4puss28CY/8bKP/IUPYmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5rhSziS/q5hWo2umYJ2ljjzDib9IX3EXSFvvPuQTX+FvbMtewG+jJ8T7KiIEsFs6
         TIsrjaw9EQfaLZuk7Ce+3wz33MXG3ryPeg5SqDV+T3thMKGUh/AVi0D1dlrO6ZEK23
         OmHTBHgiFOIs/uqH1Ogw5cCTP9xx+TovyOCzdgNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuiko Oshino <yuiko.oshino@microchip.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 57/77] net: ethernet: microchip: lan743x: Fix driver crash when lan743x_pm_resume fails
Date:   Mon,  1 Nov 2021 10:17:45 +0100
Message-Id: <20211101082523.679279513@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuiko Oshino <yuiko.oshino@microchip.com>

commit d6423d2ec39cce2bfca418c81ef51792891576bc upstream.

The driver needs to clean up and return when the initialization fails on resume.

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3066,6 +3066,8 @@ static int lan743x_pm_resume(struct devi
 	if (ret) {
 		netif_err(adapter, probe, adapter->netdev,
 			  "lan743x_hardware_init returned %d\n", ret);
+		lan743x_pci_cleanup(adapter);
+		return ret;
 	}
 
 	/* open netdev when netdev is at running state while resume.


