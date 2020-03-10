Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D25DE17F9A3
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbgCJM6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729947AbgCJM6q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:58:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83D302468F;
        Tue, 10 Mar 2020 12:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845126;
        bh=mwjN8hfsJ70iYo/DqdT0bhvapEsZyom0oKwlV59xZoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5eD/Re+aAFaBhOU2XoPw0aQrkM/6sPUjBy4TtuQsb2NTh8BpIFIFiQw4aoD3E95Y
         qcuPzPDLfwXBquuSQUsmESyIV0I+vLnmyHVcUpPm+LPSwtotKNFJVL5ldk56uU2/l2
         NYsfuvBq/Q10nNkl4x24kSSF60b83jWyPRZsHXkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Richard Leitner <richard.leitner@skidata.com>
Subject: [PATCH 5.5 070/189] usb: usb251xb: fix regulator probe and error handling
Date:   Tue, 10 Mar 2020 13:38:27 +0100
Message-Id: <20200310123646.671236399@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

commit f06947f275f1838586792c17b6ab70da82ed7b43 upstream.

Commit 4d7201cda226 ("usb: usb251xb: add vdd supply support") didn't
covered the non-DT use-case and so the regualtor_enable() call during
probe will fail on those platforms. Also the commit didn't handled the
error case correctly.

Move devm_regulator_get() out of usb251xb_get_ofdata() to address the
1st issue. This can be done without worries because devm_regulator_get()
handles the non-DT use-case too. Add devm_add_action_or_reset() to
address the 2nd bug.

Fixes: 4d7201cda226 ("usb: usb251xb: add vdd supply support")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Cc: stable <stable@vger.kernel.org>
Acked-by: Richard Leitner <richard.leitner@skidata.com>
Link: https://lore.kernel.org/r/20200226072644.18490-1-m.felsch@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/usb251xb.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/usb/misc/usb251xb.c
+++ b/drivers/usb/misc/usb251xb.c
@@ -424,10 +424,6 @@ static int usb251xb_get_ofdata(struct us
 		return err;
 	}
 
-	hub->vdd = devm_regulator_get(dev, "vdd");
-	if (IS_ERR(hub->vdd))
-		return PTR_ERR(hub->vdd);
-
 	if (of_property_read_u16_array(np, "vendor-id", &hub->vendor_id, 1))
 		hub->vendor_id = USB251XB_DEF_VENDOR_ID;
 
@@ -640,6 +636,13 @@ static int usb251xb_get_ofdata(struct us
 }
 #endif /* CONFIG_OF */
 
+static void usb251xb_regulator_disable_action(void *data)
+{
+	struct usb251xb *hub = data;
+
+	regulator_disable(hub->vdd);
+}
+
 static int usb251xb_probe(struct usb251xb *hub)
 {
 	struct device *dev = hub->dev;
@@ -676,10 +679,19 @@ static int usb251xb_probe(struct usb251x
 	if (err)
 		return err;
 
+	hub->vdd = devm_regulator_get(dev, "vdd");
+	if (IS_ERR(hub->vdd))
+		return PTR_ERR(hub->vdd);
+
 	err = regulator_enable(hub->vdd);
 	if (err)
 		return err;
 
+	err = devm_add_action_or_reset(dev,
+				       usb251xb_regulator_disable_action, hub);
+	if (err)
+		return err;
+
 	err = usb251xb_connect(hub);
 	if (err) {
 		dev_err(dev, "Failed to connect hub (%d)\n", err);


