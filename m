Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6AC76D48
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389479AbfGZPca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:32:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388709AbfGZPc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:32:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11AE022BF5;
        Fri, 26 Jul 2019 15:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155148;
        bh=m4IhzfkG4WdTewNI3DALy3vQUl8DeziHc2wi2kspGA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ycvs2dp65fGmKJIkJEBQ7eOP3YRf5ngVdJQioAyyKl4oYJBbNOq0uTLVudiIP5AaY
         +UJKGZyOBk9W/iLjfi9C3o1t6nWW+Q5HsHnwhIe0IE8W35qhosX2VY2wTo5yskdVZ5
         JehEjTXotxZjCWIqg4wYwo4CRHLzVU0i17ZgTnc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        Marcus Seyfarth <m.seyfarth@gmail.com>
Subject: [PATCH 4.19 19/50] sky2: Disable MSI on ASUS P6T
Date:   Fri, 26 Jul 2019 17:24:54 +0200
Message-Id: <20190726152302.551519581@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
References: <20190726152300.760439618@linuxfoundation.org>
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
@@ -4947,6 +4947,13 @@ static const struct dmi_system_id msi_bl
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
 


