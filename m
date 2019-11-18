Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3E861004C2
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 12:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfKRLxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 06:53:22 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46910 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbfKRLxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 06:53:22 -0500
Received: by mail-lf1-f68.google.com with SMTP id o65so13544740lff.13;
        Mon, 18 Nov 2019 03:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iqquGNTbhqooLOOM/Rwf8ZlswYL2DwlmgvFypx4jJAU=;
        b=TOv64kLIKUZVBo2lZ9CSaI7QQ+wNu9AcpmxAghl90BX3nIOXbMSskJCe0NOCG0EYTw
         03w/6vj5VgyBiLTT+4kFQ7qv4vKLOoS9vVOAgPrih4wcfwHRCSx5kLj3i1g2SvhR5R+8
         watzbxx0Z1hR1/nkfvJwkmAo9oD0jpcVhNKlF6gT6lj19wm5QVf5dOPxCvH0rccsNS9j
         YycKNrnGfdgjPiACpqe8TQDDyv96WQDycx8u3X55wz4PRLHUh0MyU9TEwd4F0qNFbbDz
         G25XBb2X9i0vAH0uan40n+6zNVapS9ZrIYePBsXK8uVbtIh08Y1XsTVGLDquRREokMXK
         9ELA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iqquGNTbhqooLOOM/Rwf8ZlswYL2DwlmgvFypx4jJAU=;
        b=arUD7SYdDECLY9nGlZ5kV/193OFHsl/UiWfuCcUHz1s7aCQ/n1QSDna2IFq7TtRlxa
         XGQ/nVz9YJfheK80eHYjZR8c6rD3dECjzs9UFNlP4ZpUYboLpFGIrehf4uHYX/95d87w
         Nej5+PxGMmL+aYPNIbBe3iIo+XRobnpOljjBNwfZMx2HC5GjcpkP3/4tw8o4FIrQW6Rl
         GctyeUkORPzvhrRQ8c+J6HTREmix94dYSRnTmkAOGtj/brw7I83uz0FLRcceuYnVs465
         ob/YJseHiwyCBceIuQ2zp+Rj+J0sBUZqbSZ1X788uD/AXxFOC60q8hiZI4tv4i6agel/
         Yhcg==
X-Gm-Message-State: APjAAAWe0K4sWr3Y2P1S5kcUi8CPOdVMecOty1eVKpo7abzoMB/lAkAa
        cHpdcSyRkH7gKwlnE6INeIQ=
X-Google-Smtp-Source: APXvYqy9wgGHFC9Jcl7HS6ILoAc//S6FUvYtUqhsVyBY9P0YHnAJK/8TFU3VRV8yLSkuMMiSAAFAgg==
X-Received: by 2002:ac2:5305:: with SMTP id c5mr16899612lfh.55.1574077999724;
        Mon, 18 Nov 2019 03:53:19 -0800 (PST)
Received: from localhost.localdomain (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f14sm8046343ljn.105.2019.11.18.03.53.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 03:53:19 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Winnie Chang <winnie.chang@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        stable@vger.kernel.org
Subject: [PATCH FIX] brcmfmac: disable PCIe interrupts before bus reset
Date:   Mon, 18 Nov 2019 12:53:08 +0100
Message-Id: <20191118115308.21963-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Keeping interrupts on could result in brcmfmac freeing some resources
and then IRQ handlers trying to use them. That was obviously a straight
path for crashing a kernel.

Example:
CPU0                           CPU1
----                           ----
brcmf_pcie_reset
  brcmf_pcie_bus_console_read
  brcmf_detach
    ...
    brcmf_fweh_detach
    brcmf_proto_detach
                               brcmf_pcie_isr_thread
                                 ...
                                 brcmf_proto_msgbuf_rx_trigger
                                   ...
                                   drvr->proto->pd
    brcmf_pcie_release_irq

[  363.789218] Unable to handle kernel NULL pointer dereference at virtual address 00000038
[  363.797339] pgd = c0004000
[  363.800050] [00000038] *pgd=00000000
[  363.803635] Internal error: Oops: 17 [#1] SMP ARM
(...)
[  364.029209] Backtrace:
[  364.031725] [<bf243838>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf2471dc>] (brcmf_pcie_isr_thread+0x228/0x274 [brcmfmac])
[  364.043662]  r7:00000001 r6:c8ca0000 r5:00010000 r4:c7b4f800

Fixes: 4684997d9eea ("brcmfmac: reset PCIe bus on a firmware crash")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
Kalle: if you are planning another pull request for 5.4 you may push
       this to the wireless-drivers. Otherwise make it
       wireless-drivers-next and lets have stable maintainers pick it.
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 3184dab41a5e..f64ce5074a55 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1425,6 +1425,8 @@ static int brcmf_pcie_reset(struct device *dev)
 	struct brcmf_fw_request *fwreq;
 	int err;
 
+	brcmf_pcie_intr_disable(devinfo);
+
 	brcmf_pcie_bus_console_read(devinfo, true);
 
 	brcmf_detach(dev);
-- 
2.21.0

