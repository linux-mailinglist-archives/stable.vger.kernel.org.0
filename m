Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1284B3A0393
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbhFHTSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:18:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236109AbhFHTQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:16:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D80186146D;
        Tue,  8 Jun 2021 18:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178266;
        bh=hWSw338vaib2nmKg/NfWfYy527GoRmuHGQh+8qKetFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PY21N1A7XuZ4ZcB4XPkCOYfX/MIH3EN87sK0eqzxPIsNch4yoF1ICV0F82E+zm6Fh
         pOq1MHZvnZZH0YsX5ZZyVIxJX4/0yMV+kM1fjxeAh3F6QDvc5pxMqf8uqvKpnEdeCo
         4Bqv9M3yCk9ONcghOF6nZxeqaGW8upFm3UE0eBA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>
Subject: [PATCH 5.12 121/161] usb: dwc2: Fix build in periphal-only mode
Date:   Tue,  8 Jun 2021 20:27:31 +0200
Message-Id: <20210608175949.534254310@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Elwell <phil@raspberrypi.com>

In branches to which 24d209dba5a3 ("usb: dwc2: Fix hibernation between
host and device modes.") has been back-ported, the bus_suspended member
of struct dwc2_hsotg is only present in builds that support host-mode.
To avoid having to pull in several more non-Fix commits in order to
get it to compile, wrap the usage of the member in a macro conditional.

Fixes: 24d209dba5a3 ("usb: dwc2: Fix hibernation between host and device modes.")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc2/core_intr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -707,7 +707,11 @@ static inline void dwc_handle_gpwrdn_dis
 	dwc2_writel(hsotg, gpwrdn_tmp, GPWRDN);
 
 	hsotg->hibernated = 0;
+
+#if IS_ENABLED(CONFIG_USB_DWC2_HOST) ||	\
+	IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
 	hsotg->bus_suspended = 0;
+#endif
 
 	if (gpwrdn & GPWRDN_IDSTS) {
 		hsotg->op_state = OTG_STATE_B_PERIPHERAL;


