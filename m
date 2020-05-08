Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710BD1CB00D
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgEHMiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:38:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728361AbgEHMiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3340824953;
        Fri,  8 May 2020 12:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941496;
        bh=6EpYPvYO1+sINqVASOs6kkWsUXdW4cYycCif/PvmMC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSY4dpqiOZdDvI+Livh2zrYMfncfLcIiV5+xnOHXbk6vO4FwQ2M022e2gkFrePcLI
         nfrCFSR5Gdpo2XgOcb/FwpSRAPVmR+g6O+e3Ui02U5pzQmLM//OzbKYPPSsnORA18N
         jBj9nSOE7f/raf6XCoBVBL1uvgTZBoMGvYs/yTF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amitkumar Karwar <akarwar@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.4 054/312] mwifiex: add missing check for PCIe8997 chipset
Date:   Fri,  8 May 2020 14:30:45 +0200
Message-Id: <20200508123128.355460097@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amitkumar Karwar <akarwar@marvell.com>

commit f3b35f28096895f2438c10ef719ef67d2951a8c9 upstream.

This patch ensures mwifiex_pcie_txbd_empty() does take care
of 8997 chipset.

Fixes: 6d85ef00d9dfe ("mwifiex: add support for 8997 chipset")
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/pcie.h |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/mwifiex/pcie.h
+++ b/drivers/net/wireless/mwifiex/pcie.h
@@ -342,6 +342,7 @@ mwifiex_pcie_txbd_empty(struct pcie_serv
 			return 1;
 		break;
 	case PCIE_DEVICE_ID_MARVELL_88W8897:
+	case PCIE_DEVICE_ID_MARVELL_88W8997:
 		if (((card->txbd_wrptr & reg->tx_mask) ==
 		     (rdptr & reg->tx_mask)) &&
 		    ((card->txbd_wrptr & reg->tx_rollover_ind) ==


