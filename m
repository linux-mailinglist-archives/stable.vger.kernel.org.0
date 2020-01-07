Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C29133336
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbgAGVGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:06:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:54732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729363AbgAGVGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:06:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 530332077B;
        Tue,  7 Jan 2020 21:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431172;
        bh=Gp/vD1HcvuFOrxXK0RGDEN6nK/NDqbHsH7zaBdF7heY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+fsEd3MyDe356BcZCNDcZ0JLI3VDgPrLy92wMnqPKRfxteqj7u2Dd4c2Vdk7Ppr9
         F6kaC0FaMvMQx5RykH530MResWCNqItQewDonEL4Rmi7nSk+MLrWjzlIz3q++XMub8
         UhDnz2BsnHf7qvP3ZIIzg5V09Ziukj5EJBpciaVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 063/115] ata: ahci_brcm: Add missing clock management during recovery
Date:   Tue,  7 Jan 2020 21:54:33 +0100
Message-Id: <20200107205303.419870315@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit bf0e5013bc2dcac205417e1252205dca39dfc005 upstream.

The downstream implementation of ahci_brcm.c did contain clock
management recovery, but until recently, did that outside of the
libahci_platform helpers and this was unintentionally stripped out while
forward porting the patch upstream.

Add the missing clock management during recovery and sleep for 10
milliseconds per the design team recommendations to ensure the SATA PHY
controller and AFE have been fully quiesced.

Fixes: eb73390ae241 ("ata: ahci_brcm: Recover from failures to identify devices")
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci_brcm.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/ata/ahci_brcm.c
+++ b/drivers/ata/ahci_brcm.c
@@ -284,6 +284,13 @@ static unsigned int brcm_ahci_read_id(st
 	/* Perform the SATA PHY reset sequence */
 	brcm_sata_phy_disable(priv, ap->port_no);
 
+	/* Reset the SATA clock */
+	ahci_platform_disable_clks(hpriv);
+	msleep(10);
+
+	ahci_platform_enable_clks(hpriv);
+	msleep(10);
+
 	/* Bring the PHY back on */
 	brcm_sata_phy_enable(priv, ap->port_no);
 


