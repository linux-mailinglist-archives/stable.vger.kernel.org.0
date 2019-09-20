Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2AABB92AF
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392116AbfITOet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:34:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36228 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388190AbfITOZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:06 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-0004y7-8i; Fri, 20 Sep 2019 15:25:01 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqE-0007tN-Kr; Fri, 20 Sep 2019 15:24:58 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "Christian Lamparter" <chunkeey@gmail.com>,
        "Pan Bian" <bianpan2016@163.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.50110479@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 060/132] p54: drop device reference count if fails to
 enable device
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pan Bian <bianpan2016@163.com>

commit 8149069db81853570a665f5e5648c0e526dc0e43 upstream.

The function p54p_probe takes an extra reference count of the PCI
device. However, the extra reference count is not dropped when it fails
to enable the PCI device. This patch fixes the bug.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/p54/p54pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -551,7 +551,7 @@ static int p54p_probe(struct pci_dev *pd
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "Cannot enable new PCI device\n");
-		return err;
+		goto err_put;
 	}
 
 	mem_addr = pci_resource_start(pdev, 0);
@@ -636,6 +636,7 @@ static int p54p_probe(struct pci_dev *pd
 	pci_release_regions(pdev);
  err_disable_dev:
 	pci_disable_device(pdev);
+err_put:
 	pci_dev_put(pdev);
 	return err;
 }

