Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D15A776CA7
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfGZP0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727476AbfGZP0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:26:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A554F22CB9;
        Fri, 26 Jul 2019 15:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154774;
        bh=FRciB1yA1DxjbCHpmDO0WRMR7w5dHjxxxVzA/BzhcDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=etlYDkuD55wQbspm4z9clMDAlMpOxLLRXP63FfnCvBPG02+ZyvY1Vafak4fMiytKJ
         k+oDZESNOn5iOdwOORsIi58q4jMSj05arIIUJ5ZjqgpH7Dd6x0iAIzlf0nQE0SKPAG
         7KLRe8N2o9zfD/ZCm/q7m2vg8OsOZsPbD//ffgeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Marcus Seyfarth <m.seyfarth@gmail.com>
Subject: [PATCH 5.2 22/66] sky2: Disable MSI on ASUS P6T
Date:   Fri, 26 Jul 2019 17:24:21 +0200
Message-Id: <20190726152304.200997002@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a261e3797506bd561700be643fe1a85bf81e9661 ]

The onboard sky2 NIC on ASUS P6T WS PRO doesn't work after PM resume
due to the infamous IRQ problem.  Disabling MSI works around it, so
let's add it to the blacklist.

Unfortunately the BIOS on the machine doesn't fill the standard
DMI_SYS_* entry, so we pick up DMI_BOARD_* entries instead.

BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1142496
Reported-and-tested-by: Marcus Seyfarth <m.seyfarth@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/sky2.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4917,6 +4917,13 @@ static const struct dmi_system_id msi_bl
 			DMI_MATCH(DMI_PRODUCT_NAME, "P-79"),
 		},
 	},
+	{
+		.ident = "ASUS P6T",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "P6T"),
+		},
+	},
 	{}
 };
 


