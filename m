Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE43272EF9
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgIUQrf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:47:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728576AbgIUQre (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:47:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66E282223E;
        Mon, 21 Sep 2020 16:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706852;
        bh=2rs8eb9EJlhp2pZtnu8luvIlNE/S4asWeLrkFEF6i3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFboQbRH92A4qo6fMHO3oxX3jbOKQk9daKbqGo3SJuot1gZfupHp/zsju9fRb5s9V
         NJ+83UqcsOw61s9z40WdBIe36AP5Rj1y2necPBh/f79WNw7dhVRRr81a2nfOcf5u0t
         QFdEca7dDfvJ7NbLjQcZLH6z8eTNOMsU8uNCYdU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Volker=20R=C3=BCmelin?= <vr_qemu@t-online.de>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.8 091/118] i2c: i801: Fix resume bug
Date:   Mon, 21 Sep 2020 18:28:23 +0200
Message-Id: <20200921162040.586151198@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Volker Rümelin <vr_qemu@t-online.de>

commit 66d402e2e9455cf0213c42b97f22a0493372d7cc upstream.

On suspend the original host configuration gets restored. The
resume routine has to undo this, otherwise the SMBus master
may be left in disabled state or in i2c mode.

[JD: Rebased on v5.8, moved the write into i801_setup_hstcfg.]

Signed-off-by: Volker Rümelin <vr_qemu@t-online.de>
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-i801.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1706,6 +1706,16 @@ static inline int i801_acpi_probe(struct
 static inline void i801_acpi_remove(struct i801_priv *priv) { }
 #endif
 
+static unsigned char i801_setup_hstcfg(struct i801_priv *priv)
+{
+	unsigned char hstcfg = priv->original_hstcfg;
+
+	hstcfg &= ~SMBHSTCFG_I2C_EN;	/* SMBus timing */
+	hstcfg |= SMBHSTCFG_HST_EN;
+	pci_write_config_byte(priv->pci_dev, SMBHSTCFG, hstcfg);
+	return hstcfg;
+}
+
 static int i801_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	unsigned char temp;
@@ -1826,14 +1836,10 @@ static int i801_probe(struct pci_dev *de
 		return err;
 	}
 
-	pci_read_config_byte(priv->pci_dev, SMBHSTCFG, &temp);
-	priv->original_hstcfg = temp;
-	temp &= ~SMBHSTCFG_I2C_EN;	/* SMBus timing */
-	if (!(temp & SMBHSTCFG_HST_EN)) {
+	pci_read_config_byte(priv->pci_dev, SMBHSTCFG, &priv->original_hstcfg);
+	temp = i801_setup_hstcfg(priv);
+	if (!(priv->original_hstcfg & SMBHSTCFG_HST_EN))
 		dev_info(&dev->dev, "Enabling SMBus device\n");
-		temp |= SMBHSTCFG_HST_EN;
-	}
-	pci_write_config_byte(priv->pci_dev, SMBHSTCFG, temp);
 
 	if (temp & SMBHSTCFG_SMB_SMI_EN) {
 		dev_dbg(&dev->dev, "SMBus using interrupt SMI#\n");
@@ -1959,6 +1965,7 @@ static int i801_resume(struct device *de
 {
 	struct i801_priv *priv = dev_get_drvdata(dev);
 
+	i801_setup_hstcfg(priv);
 	i801_enable_host_notify(&priv->adapter);
 
 	return 0;


