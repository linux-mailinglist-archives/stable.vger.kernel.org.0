Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FC5461E5D
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379328AbhK2Sff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:35:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36612 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379317AbhK2Sbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:31:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E752AB815CF;
        Mon, 29 Nov 2021 18:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2A9C53FCD;
        Mon, 29 Nov 2021 18:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210506;
        bh=Pq95mlp34cyTx6DhFDsj5Fcc77dZx7mnTg5qrwePSMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6GQSEa5NOakiCqDENMh5qWLd+d2ZXqUZh69zQGaSGlTHG/GrwZEC+17OK0DGUMia
         BMfJonTgizAAD/SP8FFyeTdJtScNWZiPoQ1WAg7fnue0b7kDP9iaxnuIUG8LpnoE2e
         kP5Z1MmlVYet/u8GvBJNtgXbPy6EBOv4Nue7ZQpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.10 011/121] usb: chipidea: ci_hdrc_imx: fix potential error pointer dereference in probe
Date:   Mon, 29 Nov 2021 19:17:22 +0100
Message-Id: <20211129181712.026220448@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d4d2e5329ae9dfd6742c84d79f7d143d10410f1b upstream.

If the first call to devm_usb_get_phy_by_phandle(dev, "fsl,usbphy", 0)
fails with something other than -ENODEV then it leads to an error
pointer dereference.  For those errors we should just jump directly to
the error handling.

Fixes: 8253a34bfae3 ("usb: chipidea: ci_hdrc_imx: Also search for 'phys' phandle")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211117074923.GF5237@kili
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -425,15 +425,15 @@ static int ci_hdrc_imx_probe(struct plat
 	data->phy = devm_usb_get_phy_by_phandle(dev, "fsl,usbphy", 0);
 	if (IS_ERR(data->phy)) {
 		ret = PTR_ERR(data->phy);
-		if (ret == -ENODEV) {
-			data->phy = devm_usb_get_phy_by_phandle(dev, "phys", 0);
-			if (IS_ERR(data->phy)) {
-				ret = PTR_ERR(data->phy);
-				if (ret == -ENODEV)
-					data->phy = NULL;
-				else
-					goto err_clk;
-			}
+		if (ret != -ENODEV)
+			goto err_clk;
+		data->phy = devm_usb_get_phy_by_phandle(dev, "phys", 0);
+		if (IS_ERR(data->phy)) {
+			ret = PTR_ERR(data->phy);
+			if (ret == -ENODEV)
+				data->phy = NULL;
+			else
+				goto err_clk;
 		}
 	}
 


