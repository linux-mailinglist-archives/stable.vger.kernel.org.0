Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 619D3CAC7D
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732655AbfJCQK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732319AbfJCQKx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:10:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C73520865;
        Thu,  3 Oct 2019 16:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119053;
        bh=L0puDj6EOMIlhC8WFpOtzc8+0fGLqddlKkZvB4yIPBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GotfNlUZvsef1I+M2uLfSI+bmw5azox4qi+fwAAOi8WbVQB78yhZ9ntbgrnKckR6a
         Q5VGelFGReJx3TXnTkgEewjs+oF2HunwXCobntXS2BUHL5Z/CGrREgD7XzWPtHUBqm
         QY68tEsW3tBOzB3vkjiEA8JC5cZvRZGoNA4h9l2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 108/185] media: saa7134: fix terminology around saa7134_i2c_eeprom_md7134_gate()
Date:   Thu,  3 Oct 2019 17:53:06 +0200
Message-Id: <20191003154503.377787598@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
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
index 8f2ed632840f7..f70a799836840 100644
--- a/drivers/media/pci/saa7134/saa7134-i2c.c
+++ b/drivers/media/pci/saa7134/saa7134-i2c.c
@@ -351,7 +351,11 @@ static struct i2c_client saa7134_client_template = {
 
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



