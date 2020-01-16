Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD7714000B
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390701AbgAPXUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:20:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390695AbgAPXUl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:20:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93BC82072B;
        Thu, 16 Jan 2020 23:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216841;
        bh=Fm0/cDZ3py/rdUm1OzZtR84gFuUeMZusfzAiMSq21p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4/TVVQGS+I2c4rVHxcdFqWom0GHFb/sxqgrCqyU8/ch3UQBvyXhaADmofTSMjTdc
         V7NoiR5UkI44XcfdAPxozoMqYHSfzrDBjBixz3BuxLfY5/Q+X4TeTesOd5mpJmIpS1
         CTbl0FaWWguJXN4GM3bgkLcyoR2NH46CLkDi5vcg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.4 041/203] ath9k: use iowrite32 over __raw_writel
Date:   Fri, 17 Jan 2020 00:15:58 +0100
Message-Id: <20200116231747.626939132@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

commit 22d0d5ae7a089967e9295a06694aa3e8a812b15e upstream.

This patch changes the ath9k_pci_owl_loader to use the
same iowrite32 memory accessor that ath9k_pci is using
to communicate with the PCI(e) chip.

This will fix endian issues that came up during testing
with loaned AVM Fritz!Box 7360 (Lantiq MIPS SoCs + AR9287).

Fixes: 5a4f2040fd07 ("ath9k: add loader for AR92XX (and older) pci(e)")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c
+++ b/drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c
@@ -84,7 +84,7 @@ static int ath9k_pci_fixup(struct pci_de
 			val = swahb32(val);
 		}
 
-		__raw_writel(val, mem + reg);
+		iowrite32(val, mem + reg);
 		usleep_range(100, 120);
 	}
 


