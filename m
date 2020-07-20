Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8582268AE
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732054AbgGTQJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:09:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387588AbgGTQJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:09:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 327182064B;
        Mon, 20 Jul 2020 16:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261392;
        bh=lye9nEJslbJYSdaSkBheYwWegDQY9ewGWMpaayLWwxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLNhHeD4OWEOLe9JL7J3uFCXveUprDo2UuKimQ3xfxag2nbdjg0yAzjMUqdoi9bhK
         9thuEXJzLBylJi3+NgBzFbVHFg8SbQBFMVfhv4GdBYgR567qVlMturyWhfA5/Wdb1C
         bD0e4KDplOEYMuXbmCwdsuojSd6iceFK0kbkjsQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ian Abbott <abbotti@mev.co.uk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 099/244] staging: comedi: verify array index is correct before using it
Date:   Mon, 20 Jul 2020 17:36:10 +0200
Message-Id: <20200720152830.541231823@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ef75e14a6c935eec82abac07ab68e388514e39bc ]

This code reads from the array before verifying that "trig" is a valid
index.  If the index is wildly out of bounds then reading from an
invalid address could lead to an Oops.

Fixes: a8c66b684efa ("staging: comedi: addi_apci_1500: rewrite the subdevice support functions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20200709102936.GA20875@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/comedi/drivers/addi_apci_1500.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1500.c b/drivers/staging/comedi/drivers/addi_apci_1500.c
index 45ad4ba92f94f..689acd69a1b9c 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1500.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1500.c
@@ -456,9 +456,9 @@ static int apci1500_di_cfg_trig(struct comedi_device *dev,
 	unsigned int lo_mask = data[5] << shift;
 	unsigned int chan_mask = hi_mask | lo_mask;
 	unsigned int old_mask = (1 << shift) - 1;
-	unsigned int pm = devpriv->pm[trig] & old_mask;
-	unsigned int pt = devpriv->pt[trig] & old_mask;
-	unsigned int pp = devpriv->pp[trig] & old_mask;
+	unsigned int pm;
+	unsigned int pt;
+	unsigned int pp;
 
 	if (trig > 1) {
 		dev_dbg(dev->class_dev,
@@ -471,6 +471,10 @@ static int apci1500_di_cfg_trig(struct comedi_device *dev,
 		return -EINVAL;
 	}
 
+	pm = devpriv->pm[trig] & old_mask;
+	pt = devpriv->pt[trig] & old_mask;
+	pp = devpriv->pp[trig] & old_mask;
+
 	switch (data[2]) {
 	case COMEDI_DIGITAL_TRIG_DISABLE:
 		/* clear trigger configuration */
-- 
2.25.1



