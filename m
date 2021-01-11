Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE372F148D
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731160AbhAKN0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:26:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732491AbhAKNQs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:16:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1B6D2253A;
        Mon, 11 Jan 2021 13:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370967;
        bh=Zb0+Gotnm49h8Kc3VmGdWRwaNDHW2+QNMG+cTq63ZXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xi8OSq8nyDfxIPcOCB8ZNlNgJVZUVXDrVqakyWD01A3tKKFNkCEC+I/bEYkiAShyL
         JPabnlKR3rc+AbCVf0fFVfIHm0hT9ItIDIL8OW8GEXO6Eun4nqj2lkRb9l3i2u1Ubw
         gAqrW0pH2F5RCUsEk2SaJUrRg7QGQ1aWSTut+ji8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zheng Zengkai <zhengzengkai@huawei.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 5.10 082/145] usb: dwc3: meson-g12a: disable clk on error handling path in probe
Date:   Mon, 11 Jan 2021 14:01:46 +0100
Message-Id: <20210111130052.470433171@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Zengkai <zhengzengkai@huawei.com>

commit a5ada3dfe6a20f41f91448b9034a1ef8da3dc87d upstream.

dwc3_meson_g12a_probe() does not invoke clk_bulk_disable_unprepare()
on one error handling path. This patch fixes that.

Fixes: 347052e3bf1b ("usb: dwc3: meson-g12a: fix USB2 PHY initialization on G12A and A1 SoCs")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Zengkai <zhengzengkai@huawei.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20201215025459.91794-1-zhengzengkai@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/dwc3-meson-g12a.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-meson-g12a.c
+++ b/drivers/usb/dwc3/dwc3-meson-g12a.c
@@ -754,7 +754,7 @@ static int dwc3_meson_g12a_probe(struct
 
 	ret = priv->drvdata->setup_regmaps(priv, base);
 	if (ret)
-		return ret;
+		goto err_disable_clks;
 
 	if (priv->vbus) {
 		ret = regulator_enable(priv->vbus);


