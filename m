Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2155328A49
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388275AbfEWTLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388268AbfEWTLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:11:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F1C62184E;
        Thu, 23 May 2019 19:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638707;
        bh=FtYbvIv3gOl5LAcrN+tt1XTYQKijAsSZSVhpgmTQNSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A81Db+NS+pEJudswf/t2J7YxkamVdGY9B3ucBrM2apapungm2S93sa8u10cDMb0te
         3FhFNqlHjCC0smb/Da/82kIp6dJsTyK7qtHekVAyC5ImN2aJWT+h5jnPPeQZPBTCj3
         X/++7eSZrTWo2T/XqalX/3F+UVu7N9B6YFbYv+ZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.14 18/77] p54: drop device reference count if fails to enable device
Date:   Thu, 23 May 2019 21:05:36 +0200
Message-Id: <20190523181722.764588353@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit 8149069db81853570a665f5e5648c0e526dc0e43 upstream.

The function p54p_probe takes an extra reference count of the PCI
device. However, the extra reference count is not dropped when it fails
to enable the PCI device. This patch fixes the bug.

Cc: stable@vger.kernel.org
Signed-off-by: Pan Bian <bianpan2016@163.com>
Acked-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intersil/p54/p54pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/intersil/p54/p54pci.c
+++ b/drivers/net/wireless/intersil/p54/p54pci.c
@@ -554,7 +554,7 @@ static int p54p_probe(struct pci_dev *pd
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "Cannot enable new PCI device\n");
-		return err;
+		goto err_put;
 	}
 
 	mem_addr = pci_resource_start(pdev, 0);
@@ -639,6 +639,7 @@ static int p54p_probe(struct pci_dev *pd
 	pci_release_regions(pdev);
  err_disable_dev:
 	pci_disable_device(pdev);
+err_put:
 	pci_dev_put(pdev);
 	return err;
 }


