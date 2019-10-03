Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99980CA3CD
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389685AbfJCQTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:45872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389672AbfJCQTC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:19:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A9DA20865;
        Thu,  3 Oct 2019 16:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119541;
        bh=/HJvbzJRlJJiGsRssqDI4IrbcQ6A6pHz/L9DnUT+I6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JTPjmjIXXR77H6LfBJnqyGoixD+j5qQuKrowUdbIubyXrSnBO17rLQfzpgX7VMraQ
         KY+JWeZLdHiMZ/z7FgDomF3RkLis4MfybTWqUx9D5UHCAeeOk3+aiRGfynVM5EgGmD
         3dXQJ1n9YRzfmhak2SUrwZvi52TOu2sfQQJW3WfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 102/211] media: saa7134: fix terminology around saa7134_i2c_eeprom_md7134_gate()
Date:   Thu,  3 Oct 2019 17:52:48 +0200
Message-Id: <20191003154510.065803224@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

[ Upstream commit 9d802222a3405599d6e1984d9324cddf592ea1f4 ]

saa7134_i2c_eeprom_md7134_gate() function and the associated comment uses
an inverted i2c gate open / closed terminology.
Let's fix this.

Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[hverkuil-cisco@xs4all.nl: fix alignment checkpatch warning]
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7134/saa7134-i2c.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-i2c.c b/drivers/media/pci/saa7134/saa7134-i2c.c
index cf1e526de56ac..8a1128c60680b 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -351,7 +351,11 @@ static const struct i2c_client saa7134_client_template = {
 
 /* ----------------------------------------------------------- */
 
-/* On Medion 7134 reading EEPROM needs DVB-T demod i2c gate open */
+/*
+ * On Medion 7134 reading the SAA7134 chip config EEPROM needs DVB-T
+ * demod i2c gate closed due to an address clash between this EEPROM
+ * and the demod one.
+ */
 static void saa7134_i2c_eeprom_md7134_gate(struct saa7134_dev *dev)
 {
 	u8 subaddr = 0x7, dmdregval;
@@ -368,14 +372,14 @@ static void saa7134_i2c_eeprom_md7134_gate(struct saa7134_dev *dev)
 
 	ret = i2c_transfer(&dev->i2c_adap, i2cgatemsg_r, 2);
 	if ((ret == 2) && (dmdregval & 0x2)) {
-		pr_debug("%s: DVB-T demod i2c gate was left closed\n",
+		pr_debug("%s: DVB-T demod i2c gate was left open\n",
 			 dev->name);
 
 		data[0] = subaddr;
 		data[1] = (dmdregval & ~0x2);
 		if (i2c_transfer(&dev->i2c_adap, i2cgatemsg_w, 1) != 1)
-			pr_err("%s: EEPROM i2c gate open failure\n",
-			  dev->name);
+			pr_err("%s: EEPROM i2c gate close failure\n",
+			       dev->name);
 	}
 }
 
-- 
2.20.1



