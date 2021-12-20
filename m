Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A682947AE5A
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238969AbhLTPA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239160AbhLTO63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA52C061395;
        Mon, 20 Dec 2021 06:49:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94A51B80EE5;
        Mon, 20 Dec 2021 14:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DA1C36AE9;
        Mon, 20 Dec 2021 14:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011775;
        bh=ZP7BExbkenyEiFUFz2o6A736QgLbwkeYfWrM5/cC3UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QY3VXJ1Kw+o3RZKOxFf7gkHtlWhQLQoZA7Bfti4YgVu7xdx6luCftT47iqr6iRmrb
         zchmPyL5pt20iPmQHFzF3u6ingVce7ixm02W5RHXZ4xtWPkjWWkElp4lKQCgkpRo8l
         mupg43QNhKjTZqouj0HLw0P1vKfhgziLHMnY+cYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        Amelie Delaunay <amelie.delaunay@foss.st.com>
Subject: [PATCH 5.10 69/99] usb: dwc2: fix STM ID/VBUS detection startup delay in dwc2_driver_probe
Date:   Mon, 20 Dec 2021 15:34:42 +0100
Message-Id: <20211220143031.719458456@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

commit fac6bf87c55f7f0733efb0375565fb6a50cf2caf upstream.

When activate_stm_id_vb_detection is enabled, ID and Vbus detection relies
on sensing comparators. This detection needs time to stabilize.
A delay was already applied in dwc2_resume() when reactivating the
detection, but it wasn't done in dwc2_probe().
This patch adds delay after enabling STM ID/VBUS detection. Then, ID state
is good when initializing gadget and host, and avoid to get a wrong
Connector ID Status Change interrupt.

Fixes: a415083a11cc ("usb: dwc2: add support for STM32MP15 SoCs USB OTG HS and FS")
Cc: stable <stable@vger.kernel.org>
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20211207124510.268841-1-amelie.delaunay@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/platform.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -542,6 +542,9 @@ static int dwc2_driver_probe(struct plat
 		ggpio |= GGPIO_STM32_OTG_GCCFG_IDEN;
 		ggpio |= GGPIO_STM32_OTG_GCCFG_VBDEN;
 		dwc2_writel(hsotg, ggpio, GGPIO);
+
+		/* ID/VBUS detection startup time */
+		usleep_range(5000, 7000);
 	}
 
 	retval = dwc2_drd_init(hsotg);


