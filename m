Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACB6410191C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfKSFVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:21:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727435AbfKSFVg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:21:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E48221939;
        Tue, 19 Nov 2019 05:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140893;
        bh=bBNzdQlMeYPHoi8dE+HdBhdqalpqXz2JxKN1eL9SzEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQz5Lvmtw6jofX8+lMF6lPh1zRu42jVsxZhG2WKJCPPC2EzsP2LRv9LW3LKHdr/Bq
         Szr9orMCFC6dRU+1GMFbgpu+bULuKREF/Tkii8tsWRqhl8uZ6p0Xf1dFTJrKSV3BQN
         kBmKHDJdN90AyanCLzeuDQ7Ap5NwCw5fRJGh6X2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Duggan <aduggan@synaptics.com>,
        Simon Wood <simon@mungewell.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.3 22/48] Input: synaptics-rmi4 - disable the relative position IRQ in the F12 driver
Date:   Tue, 19 Nov 2019 06:19:42 +0100
Message-Id: <20191119051005.192906284@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Duggan <aduggan@synaptics.com>

commit f6aabe1ff1d9d7bad0879253011216438bdb2530 upstream.

This patch fixes an issue seen on HID touchpads which report finger
positions using RMI4 Function 12. The issue manifests itself as
spurious button presses as described in:
https://www.spinics.net/lists/linux-input/msg58618.html

Commit 24d28e4f1271 ("Input: synaptics-rmi4 - convert irq distribution
to irq_domain") switched the RMI4 driver to using an irq_domain to handle
RMI4 function interrupts. Functions with more then one interrupt now have
each interrupt mapped to their own IRQ and IRQ handler. The result of
this change is that the F12 IRQ handler was now getting called twice. Once
for the absolute data interrupt and once for the relative data interrupt.
For HID devices, calling rmi_f12_attention() a second time causes the
attn_data data pointer and size to be set incorrectly. When the touchpad
button is pressed, F30 will generate an interrupt and attempt to read the
F30 data from the invalid attn_data data pointer and report incorrect
button events.

This patch disables the F12 relative interrupt which prevents
rmi_f12_attention() from being called twice.

Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
Reported-by: Simon Wood <simon@mungewell.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191025002527.3189-2-aduggan@synaptics.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/rmi4/rmi_f12.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

--- a/drivers/input/rmi4/rmi_f12.c
+++ b/drivers/input/rmi4/rmi_f12.c
@@ -55,6 +55,9 @@ struct f12_data {
 
 	const struct rmi_register_desc_item *data15;
 	u16 data15_offset;
+
+	unsigned long *abs_mask;
+	unsigned long *rel_mask;
 };
 
 static int rmi_f12_read_sensor_tuning(struct f12_data *f12)
@@ -291,9 +294,18 @@ static int rmi_f12_write_control_regs(st
 static int rmi_f12_config(struct rmi_function *fn)
 {
 	struct rmi_driver *drv = fn->rmi_dev->driver;
+	struct f12_data *f12 = dev_get_drvdata(&fn->dev);
+	struct rmi_2d_sensor *sensor;
 	int ret;
 
-	drv->set_irq_bits(fn->rmi_dev, fn->irq_mask);
+	sensor = &f12->sensor;
+
+	if (!sensor->report_abs)
+		drv->clear_irq_bits(fn->rmi_dev, f12->abs_mask);
+	else
+		drv->set_irq_bits(fn->rmi_dev, f12->abs_mask);
+
+	drv->clear_irq_bits(fn->rmi_dev, f12->rel_mask);
 
 	ret = rmi_f12_write_control_regs(fn);
 	if (ret)
@@ -315,9 +327,12 @@ static int rmi_f12_probe(struct rmi_func
 	struct rmi_device_platform_data *pdata = rmi_get_platform_data(rmi_dev);
 	struct rmi_driver_data *drvdata = dev_get_drvdata(&rmi_dev->dev);
 	u16 data_offset = 0;
+	int mask_size;
 
 	rmi_dbg(RMI_DEBUG_FN, &fn->dev, "%s\n", __func__);
 
+	mask_size = BITS_TO_LONGS(drvdata->irq_count) * sizeof(unsigned long);
+
 	ret = rmi_read(fn->rmi_dev, query_addr, &buf);
 	if (ret < 0) {
 		dev_err(&fn->dev, "Failed to read general info register: %d\n",
@@ -332,10 +347,19 @@ static int rmi_f12_probe(struct rmi_func
 		return -ENODEV;
 	}
 
-	f12 = devm_kzalloc(&fn->dev, sizeof(struct f12_data), GFP_KERNEL);
+	f12 = devm_kzalloc(&fn->dev, sizeof(struct f12_data) + mask_size * 2,
+			GFP_KERNEL);
 	if (!f12)
 		return -ENOMEM;
 
+	f12->abs_mask = (unsigned long *)((char *)f12
+			+ sizeof(struct f12_data));
+	f12->rel_mask = (unsigned long *)((char *)f12
+			+ sizeof(struct f12_data) + mask_size);
+
+	set_bit(fn->irq_pos, f12->abs_mask);
+	set_bit(fn->irq_pos + 1, f12->rel_mask);
+
 	f12->has_dribble = !!(buf & BIT(3));
 
 	if (fn->dev.of_node) {


