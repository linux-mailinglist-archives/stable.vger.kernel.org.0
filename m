Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BECF81CAF86
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgEHMlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728710AbgEHMk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB97A24968;
        Fri,  8 May 2020 12:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941658;
        bh=OKUqUsMF/GSfd3r2wfBBACozUoRiXEVwUIIrInx4V04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C/Dm/Ab2cHmBuOhoTT/ZXmFl3m+CkQbUn6X0rFO/o80C44sCxzWjEmG5BA5FVTbVU
         L3rNPxKLSkCcd7aGAIsuZntm4wJ7Ul5o97whJud9ZRNqcnxO63IfKhYilAieyvt16J
         2P/98BhT1NGXNnWMOAUmn/WxU0Qd+gBXzAI8iBsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.4 121/312] Input: gpio-keys - fix check for disabling unsupported keys
Date:   Fri,  8 May 2020 14:31:52 +0200
Message-Id: <20200508123132.963839150@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 8679ee4204cfd5cf78b996508ccadc1ec6130f1a upstream.

Commit 4ea14a53d8f881034fa9e186653821c4e3d9a8fb ("Input: gpio-keys - report
error when disabling unsupported key") tried let user know that they
attempted to disable an unsupported key, unfortunately the check is wrong
as it believes that all codes are invalid. Fix it by ensuring that keys
that we try to disable are subset of keys (or switches) that device
reports.

Fixes: 4ea14a53d8f8 ("Input: gpio-keys - report error when disabling unsupported key")
Reported-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Tested-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/keyboard/gpio_keys.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -96,7 +96,7 @@ struct gpio_keys_drvdata {
  * Return value of this function can be used to allocate bitmap
  * large enough to hold all bits for given type.
  */
-static inline int get_n_events_by_type(int type)
+static int get_n_events_by_type(int type)
 {
 	BUG_ON(type != EV_SW && type != EV_KEY);
 
@@ -104,6 +104,22 @@ static inline int get_n_events_by_type(i
 }
 
 /**
+ * get_bm_events_by_type() - returns bitmap of supported events per @type
+ * @input: input device from which bitmap is retrieved
+ * @type: type of button (%EV_KEY, %EV_SW)
+ *
+ * Return value of this function can be used to allocate bitmap
+ * large enough to hold all bits for given type.
+ */
+static const unsigned long *get_bm_events_by_type(struct input_dev *dev,
+						  int type)
+{
+	BUG_ON(type != EV_SW && type != EV_KEY);
+
+	return (type == EV_KEY) ? dev->keybit : dev->swbit;
+}
+
+/**
  * gpio_keys_disable_button() - disables given GPIO button
  * @bdata: button data for button to be disabled
  *
@@ -213,6 +229,7 @@ static ssize_t gpio_keys_attr_store_help
 					   const char *buf, unsigned int type)
 {
 	int n_events = get_n_events_by_type(type);
+	const unsigned long *bitmap = get_bm_events_by_type(ddata->input, type);
 	unsigned long *bits;
 	ssize_t error;
 	int i;
@@ -226,6 +243,11 @@ static ssize_t gpio_keys_attr_store_help
 		goto out;
 
 	/* First validate */
+	if (!bitmap_subset(bits, bitmap, n_events)) {
+		error = -EINVAL;
+		goto out;
+	}
+
 	for (i = 0; i < ddata->pdata->nbuttons; i++) {
 		struct gpio_button_data *bdata = &ddata->data[i];
 
@@ -239,11 +261,6 @@ static ssize_t gpio_keys_attr_store_help
 		}
 	}
 
-	if (i == ddata->pdata->nbuttons) {
-		error = -EINVAL;
-		goto out;
-	}
-
 	mutex_lock(&ddata->disable_lock);
 
 	for (i = 0; i < ddata->pdata->nbuttons; i++) {


