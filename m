Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3A23C4BB6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240858AbhGLG64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239628AbhGLG6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:58:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 329ED613C2;
        Mon, 12 Jul 2021 06:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072926;
        bh=ColcVunOEivafELs8vpM14A7pTRl7GBX15wcEfwa6gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=thcNHfc9eFkAHn2i4apUwhd8bMITUZQSzPW+FeEpKUXYrhpVCF9fvOdD+/5q6IDWH
         +37lEAE1as/sMIm41IzB0IhBIAKWaMT3j8lU5DvqWnQRwiVr1E7ZtHecS3s57tILZe
         46xUYcr/vx4N6pXUrC89SwWbKVyTqi1BvS4D1Xes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.12 067/700] bus: mhi: pci-generic: Add missing pci_disable_pcie_error_reporting() calls
Date:   Mon, 12 Jul 2021 08:02:30 +0200
Message-Id: <20210712060934.178689634@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit a25d144fb883c73506ba384de476bbaff8220a95 upstream.

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call

Add the missing call in the error handling path of the probe and in the
remove function.

Cc: <stable@vger.kernel.org>
Fixes: b012ee6bfe2a ("mhi: pci_generic: Add PCI error handlers")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/f70c14701f4922d67e717633c91b6c481b59f298.1623445348.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210621161616.77524-6-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bus/mhi/pci_generic.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -470,7 +470,7 @@ static int mhi_pci_probe(struct pci_dev
 
 	err = mhi_register_controller(mhi_cntrl, mhi_cntrl_config);
 	if (err)
-		return err;
+		goto err_disable_reporting;
 
 	/* MHI bus does not power up the controller by default */
 	err = mhi_prepare_for_power_up(mhi_cntrl);
@@ -496,6 +496,8 @@ err_unprepare:
 	mhi_unprepare_after_power_down(mhi_cntrl);
 err_unregister:
 	mhi_unregister_controller(mhi_cntrl);
+err_disable_reporting:
+	pci_disable_pcie_error_reporting(pdev);
 
 	return err;
 }
@@ -514,6 +516,7 @@ static void mhi_pci_remove(struct pci_de
 	}
 
 	mhi_unregister_controller(mhi_cntrl);
+	pci_disable_pcie_error_reporting(pdev);
 }
 
 static void mhi_pci_shutdown(struct pci_dev *pdev)


