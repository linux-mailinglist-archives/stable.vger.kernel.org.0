Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327243033C1
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730885AbhAZFEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:04:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:39970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731237AbhAYSxO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF1C8224D4;
        Mon, 25 Jan 2021 18:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600754;
        bh=B8OETbxqQFd1YIx7PZw7y3bg3I1KVNkhVCJMsuQEu9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oii12KBlaEwNnFOn5HbQZQ0m5tlTEEBc7nvquQtPaLlcc7qPCqOgrZE6xQXHSnkq/
         Ovn4NrzkrWmyLXb809G/dLJd9Rbv64ri80L6mbS1AR6AeLEMvFqB2TKfPLLg0bc7dc
         F1xG90AVh/YniHC8oOLkd2bVdaadNZXh6xZfrIrg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@nxp.com>
Subject: [PATCH 5.10 139/199] usb: cdns3: imx: fix cant create core device the second time issue
Date:   Mon, 25 Jan 2021 19:39:21 +0100
Message-Id: <20210125183222.082867008@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit 2ef02b846ee2526249a562a66d6dcb25fcbca9d8 upstream.

The cdns3 core device is populated by calling of_platform_populate,
the flag OF_POPULATED is set for core device node, if this flag
is not cleared, when calling of_platform_populate the second time
after loading parent module again, the OF code will not try to create
platform device for core device.

To fix it, it uses of_platform_depopulate to depopulate the core
device which the parent created, and the flag OF_POPULATED for
core device node will be cleared accordingly.

Cc: <stable@vger.kernel.org>
Fixes: 1e056efab993 ("usb: cdns3: add NXP imx8qm glue layer")
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/cdns3/cdns3-imx.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/usb/cdns3/cdns3-imx.c
+++ b/drivers/usb/cdns3/cdns3-imx.c
@@ -218,20 +218,11 @@ err:
 	return ret;
 }
 
-static int cdns_imx_remove_core(struct device *dev, void *data)
-{
-	struct platform_device *pdev = to_platform_device(dev);
-
-	platform_device_unregister(pdev);
-
-	return 0;
-}
-
 static int cdns_imx_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 
-	device_for_each_child(dev, NULL, cdns_imx_remove_core);
+	of_platform_depopulate(dev);
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;


