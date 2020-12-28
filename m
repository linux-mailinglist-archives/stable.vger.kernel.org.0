Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C8B2E3F9B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502178AbgL1O1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:27:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503578AbgL1O0G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:26:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B1C422B40;
        Mon, 28 Dec 2020 14:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165525;
        bh=MJb6rgT/CLr74sfiJb2dNz0DdNWAxqXSu6EFZIFb3qc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MO5MwaZN6hlZHM4NeergFBimZc2XnhTkAwJRCqFurH68pGXN1kx/ncW0iG06T32mA
         64df6XkQf8okW83fcYocsc9N/+6E2ordXgqpKzFbjdqCRKt1p3+WiIrvs3Bv6Ta9FV
         2WjljDZ1WWcumS93z+j5owGZUYyR0STnTaXiK2ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH 5.10 562/717] ASoC: AMD Raven/Renoir - fix the PCI probe (PCI revision)
Date:   Mon, 28 Dec 2020 13:49:20 +0100
Message-Id: <20201228125047.848721184@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

commit 55d8e6a85bce21f748c42eedea63681219f70523 upstream.

The Raven and Renoir ACP can be distinguished by the PCI revision.
Let's do the check very early, otherwise the wrong probe code
can be run.

Link: https://lore.kernel.org/alsa-devel/2e4587f8-f602-cf23-4845-fd27a32b1cfc@amd.com/
Cc: <stable@kernel.org>
Cc: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://lore.kernel.org/r/20201208181233.2745726-1-perex@perex.cz
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/amd/raven/pci-acp3x.c     |    4 ++++
 sound/soc/amd/renoir/rn-pci-acp3x.c |    4 ++++
 2 files changed, 8 insertions(+)

--- a/sound/soc/amd/raven/pci-acp3x.c
+++ b/sound/soc/amd/raven/pci-acp3x.c
@@ -118,6 +118,10 @@ static int snd_acp3x_probe(struct pci_de
 	int ret, i;
 	u32 addr, val;
 
+	/* Raven device detection */
+	if (pci->revision != 0x00)
+		return -ENODEV;
+
 	if (pci_enable_device(pci)) {
 		dev_err(&pci->dev, "pci_enable_device failed\n");
 		return -ENODEV;
--- a/sound/soc/amd/renoir/rn-pci-acp3x.c
+++ b/sound/soc/amd/renoir/rn-pci-acp3x.c
@@ -188,6 +188,10 @@ static int snd_rn_acp_probe(struct pci_d
 	int ret, index;
 	u32 addr;
 
+	/* Renoir device check */
+	if (pci->revision != 0x01)
+		return -ENODEV;
+
 	if (pci_enable_device(pci)) {
 		dev_err(&pci->dev, "pci_enable_device failed\n");
 		return -ENODEV;


