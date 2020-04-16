Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A171AC6EF
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732826AbgDPOq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:46:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506797AbgDPN71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:59:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D2B922203;
        Thu, 16 Apr 2020 13:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045566;
        bh=W1TFNcL6d7PTuFQZwdR3ie9JKMjHoYNZuPHRwD0bY2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yhsGDobPb8TlPbGN2dKuZspQlGsb8kp4Omjft0LRdLYOwI0EXEt0nagqDMiKR3ex0
         Ac12JaooHktqudy0Rx1yZElVYEoWzwMedpo3jl6TnHsfzvb8424k6SVgEDE0ftw8iL
         poXlrP9i4SDA2S1llpqr/bOvE+s/DeKlXXqRs564=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Sroka <piotrs@cadence.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.6 146/254] mtd: rawnand: cadence: reinit completion before executing a new command
Date:   Thu, 16 Apr 2020 15:23:55 +0200
Message-Id: <20200416131344.795701960@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piotr Sroka <piotrs@cadence.com>

commit 0d7d6c8183aadb1dcc13f415941404a7913b46b3 upstream.

Reing the completion object before executing CDMA command to make sure
the 'done' flag is OK.

Fixes: ec4ba01e894d ("mtd: rawnand: Add new Cadence NAND driver to MTD subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Piotr Sroka <piotrs@cadence.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/1581328530-29966-4-git-send-email-piotrs@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/cadence-nand-controller.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -997,6 +997,7 @@ static int cadence_nand_cdma_send(struct
 		return status;
 
 	cadence_nand_reset_irq(cdns_ctrl);
+	reinit_completion(&cdns_ctrl->complete);
 
 	writel_relaxed((u32)cdns_ctrl->dma_cdma_desc,
 		       cdns_ctrl->reg + CMD_REG2);


