Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DA7428FFC
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238984AbhJKODD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236853AbhJKOBC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:01:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED67761074;
        Mon, 11 Oct 2021 13:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960638;
        bh=r71fn1N77qRTbPyvZTU0sgvBwA9NqUXpG3rwpTP7M4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQfFH/Ip4y76YRHgLdWramdf2CSxpXalSO3oqGO7d6rcSQh/lGDk9wLp1szRSYqhb
         TLqX7ygMcmBErvJJNQeLL63nLjQAStyiiYmIl2F5D+JKp7VuZKgEOgNdOmnVtQfIlf
         IGtvJi0CbK/pRoyPD+TLrLoSQZVeUGX3KfDLsCDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Thiery <heiko.thiery@gmail.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Peter Chen <peter.chen@kernel.org>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 5.14 003/151] usb: chipidea: ci_hdrc_imx: Also search for phys phandle
Date:   Mon, 11 Oct 2021 15:44:35 +0200
Message-Id: <20211011134517.943587267@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit 8253a34bfae3278baca52fc1209b7c29270486ca upstream.

When passing 'phys' in the devicetree to describe the USB PHY phandle
(which is the recommended way according to
Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt) the
following NULL pointer dereference is observed on i.MX7 and i.MX8MM:

[    1.489344] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000098
[    1.498170] Mem abort info:
[    1.500966]   ESR = 0x96000044
[    1.504030]   EC = 0x25: DABT (current EL), IL = 32 bits
[    1.509356]   SET = 0, FnV = 0
[    1.512416]   EA = 0, S1PTW = 0
[    1.515569]   FSC = 0x04: level 0 translation fault
[    1.520458] Data abort info:
[    1.523349]   ISV = 0, ISS = 0x00000044
[    1.527196]   CM = 0, WnR = 1
[    1.530176] [0000000000000098] user address but active_mm is swapper
[    1.536544] Internal error: Oops: 96000044 [#1] PREEMPT SMP
[    1.542125] Modules linked in:
[    1.545190] CPU: 3 PID: 7 Comm: kworker/u8:0 Not tainted 5.14.0-dirty #3
[    1.551901] Hardware name: Kontron i.MX8MM N801X S (DT)
[    1.557133] Workqueue: events_unbound deferred_probe_work_func
[    1.562984] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
[    1.568998] pc : imx7d_charger_detection+0x3f0/0x510
[    1.573973] lr : imx7d_charger_detection+0x22c/0x510

This happens because the charger functions check for the phy presence
inside the imx_usbmisc_data structure (data->usb_phy), but the chipidea
core populates the usb_phy passed via 'phys' inside 'struct ci_hdrc'
(ci->usb_phy) instead.

This causes the NULL pointer dereference inside imx7d_charger_detection().

Fix it by also searching for 'phys' in case 'fsl,usbphy' is not found.

Tested on a imx7s-warp board.

Fixes: 746f316b753a ("usb: chipidea: introduce imx7d USB charger detection")
Cc: stable@vger.kernel.org
Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20210921113754.767631-1-festevam@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -420,11 +420,16 @@ static int ci_hdrc_imx_probe(struct plat
 	data->phy = devm_usb_get_phy_by_phandle(dev, "fsl,usbphy", 0);
 	if (IS_ERR(data->phy)) {
 		ret = PTR_ERR(data->phy);
-		/* Return -EINVAL if no usbphy is available */
-		if (ret == -ENODEV)
-			data->phy = NULL;
-		else
-			goto err_clk;
+		if (ret == -ENODEV) {
+			data->phy = devm_usb_get_phy_by_phandle(dev, "phys", 0);
+			if (IS_ERR(data->phy)) {
+				ret = PTR_ERR(data->phy);
+				if (ret == -ENODEV)
+					data->phy = NULL;
+				else
+					goto err_clk;
+			}
+		}
 	}
 
 	pdata.usb_phy = data->phy;


