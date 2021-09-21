Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346B64132B1
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 13:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhIULji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 07:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbhIULjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 07:39:37 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBA3C061574;
        Tue, 21 Sep 2021 04:38:09 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id d8so6198494qtd.5;
        Tue, 21 Sep 2021 04:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tn8/yX11wK0bgine+Z8pU7yBncEG4rvAqWxGDadQAyk=;
        b=kEF4n8gfLIy1zkgTMM0LlesQ2D8iCsnW5D/2gOuaGyTjZERxN05B98+LmC1/5f3mOv
         ++vpQ5lEWT0c20i9s1UrodGx9AXUIYtq7oHQ7VdacwLMxAbDChldSBXBq+MmUn5AnGYN
         6oKDnrW50DG/PbhbQHgFL+lYYtJUxEaeu+Qz+FdMXyaBXch8b8rN72yYp4uFc4CrXfc0
         HdSkO2c+lZiJG9CYYSUrDGa3foQbp/HAswjaVWvzKO/qadzx4CUjuYY+n1C3mCOfWnhA
         UB4WGF2LR/ezbW/2SU+UQpNU8UFTKHETkxtKJZWV1COu3zJAWFUaa1xsP57LNlvF+fyN
         R1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Tn8/yX11wK0bgine+Z8pU7yBncEG4rvAqWxGDadQAyk=;
        b=BxHqWdD9XLqCGWdz2ouEs6QsmeYGjCRITggJ/AyXOmY7tzHY4qrhRMdDsj6r+MLF4t
         ev6pjmpnRhTvYM8n2TyqroO3X0naLyfCe9I5PQcJkILItc9INe21Zp4tDh18UdEzUKOp
         7SgQyqcjRzVGcTHL0WUG3CVXT33BaeOaPWMX6TBD/lYWKOc1yOfVNYxZAHSreDug6Axy
         vQ5SqrYQW5Fj9iRtfJ3G8Y9yttjK7jHLYVrU4A60Utah5CwlfypdN9ElUGrOC6ju79Oa
         +ZIWQ9xS0+5gVuZ4dlEe9GJt3KchN4s1XCSbtnjA4N/YxoUOvnZASbhbML7MQ93ksFG0
         xt1w==
X-Gm-Message-State: AOAM531BaHiLFI12EvANyfbfLAYBuwBGlTsScsKJrmSetBhUC2rMGuBm
        5Ed3XXoCF72dwiVRb+8+1xU=
X-Google-Smtp-Source: ABdhPJwCbu3NlAlSTJoA4Vmt+Wn7j+sBW70YtlWT7AbGGf/VRAfoPpoFNun+gSW3X4VdR0GljtVbww==
X-Received: by 2002:ac8:4b64:: with SMTP id g4mr27207226qts.263.1632224288550;
        Tue, 21 Sep 2021 04:38:08 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:504a:ec78:bbc7:c220:a982])
        by smtp.gmail.com with ESMTPSA id q84sm3787771qke.3.2021.09.21.04.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 04:38:08 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     peter.chen@kernel.org
Cc:     shawnguo@kernel.org, marex@denx.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, heiko.thiery@gmail.com,
        frieder.schrempf@kontron.de, Fabio Estevam <festevam@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v3] usb: chipidea: ci_hdrc_imx: Also search for 'phys' phandle
Date:   Tue, 21 Sep 2021 08:37:54 -0300
Message-Id: <20210921113754.767631-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Fixes: 746f316b753a ("usb: chipidea: introduce imx7d USB charger detection")
Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
---
Changes since v2:

- Added Frieder's reviewed-by tag.
- Cc stable
- Improved the commit log and fixed typo in 'dereferenced'

 drivers/usb/chipidea/ci_hdrc_imx.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index 8b7bc10b6e8b..f1d100671ee6 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -420,11 +420,16 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
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
-- 
2.25.1

