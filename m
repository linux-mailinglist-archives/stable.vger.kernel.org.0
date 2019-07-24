Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A10973D2C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391924AbfGXUPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:15:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404303AbfGXTyO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:54:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC6782147A;
        Wed, 24 Jul 2019 19:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998054;
        bh=Gsj2tchzelCs7ctNMH0LBAgPG6rXairyn0i7xTigSAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FW2kas+1h02Y/G9T+pCVVLpCWPUt2+yztBl0hhK1jkCBZdNfnzikD+RR996c/BH5q
         7DptY+2san/1v3LJwqO7nZmR9+KKdHgaybd/InHJgh+qY1Sf3cGL3vxFwcp81bjBgH
         zh1z8D/TopGFXMyHZ+3o31XQpnlyPn+CFaklX0V0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Stan Johnson <userm57@yahoo.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.1 230/371] scsi: NCR5380: Handle PDMA failure reliably
Date:   Wed, 24 Jul 2019 21:19:42 +0200
Message-Id: <20190724191741.754419611@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

commit f9dfed1c785734b95b08d67600e05d2092508ab0 upstream.

A PDMA error is handled in the core driver by setting the device's 'borken'
flag and aborting the command. Unfortunately, do_abort() is not
dependable. Perform a SCSI bus reset instead, to make sure that the command
fails and gets retried.

Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: stable@vger.kernel.org # v4.20+
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Stan Johnson <userm57@yahoo.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/NCR5380.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1762,10 +1762,8 @@ static void NCR5380_information_transfer
 						scmd_printk(KERN_INFO, cmd,
 							"switching to slow handshake\n");
 						cmd->device->borken = 1;
-						sink = 1;
-						do_abort(instance);
-						cmd->result = DID_ERROR << 16;
-						/* XXX - need to source or sink data here, as appropriate */
+						do_reset(instance);
+						bus_reset_cleanup(instance);
 					}
 				} else {
 					/* Transfer a small chunk so that the


