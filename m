Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5878406C3A
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhIJMiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:38:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234665AbhIJMgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:36:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC7ED6124B;
        Fri, 10 Sep 2021 12:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277317;
        bh=a4Lzupioy6saCybQPAd+d5Cp1xeBmgR+k/sKPmm0DZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyd0Jcp1+TwRNuTQOUGEkmvDvT1qmXWkyOl+FnGHZIWbMVSXlhnZhJUV96//te/cO
         E7kXVwpyCnz0rJGQxSxEJaNHb7ym5O1IJCySrnM5GjSDWJ0NirZwxJxpqw52ef9oSq
         ZlwXdYs6UX2zvWkC6/x64GgyCklUDTy/9iv8OmUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 5.4 32/37] usb: host: xhci-rcar: Dont reload firmware after the completion
Date:   Fri, 10 Sep 2021 14:30:35 +0200
Message-Id: <20210910122918.220329770@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122917.149278545@linuxfoundation.org>
References: <20210910122917.149278545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit 57f3ffdc11143f56f1314972fe86fe17a0dcde85 upstream.

According to the datasheet, "Upon the completion of FW Download,
there is no need to write or reload FW.". Otherwise, it's possible
to cause unexpected behaviors. So, adds such a condition.

Fixes: 4ac8918f3a73 ("usb: host: xhci-plat: add support for the R-Car H2 and M2 xHCI controllers")
Cc: stable@vger.kernel.org # v3.17+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20210827063227.81990-1-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-rcar.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/host/xhci-rcar.c
+++ b/drivers/usb/host/xhci-rcar.c
@@ -134,6 +134,13 @@ static int xhci_rcar_download_firmware(s
 	const struct soc_device_attribute *attr;
 	const char *firmware_name;
 
+	/*
+	 * According to the datasheet, "Upon the completion of FW Download,
+	 * there is no need to write or reload FW".
+	 */
+	if (readl(regs + RCAR_USB3_DL_CTRL) & RCAR_USB3_DL_CTRL_FW_SUCCESS)
+		return 0;
+
 	attr = soc_device_match(rcar_quirks_match);
 	if (attr)
 		quirks = (uintptr_t)attr->data;


