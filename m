Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60ABE73EC7
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388905AbfGXTft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388884AbfGXTft (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:35:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B556A21951;
        Wed, 24 Jul 2019 19:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996948;
        bh=61i0o/cbhrmmFoEpZj1dE59plEfYxzY8AsKUoGE7LV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLaFwUTcbk06LtTuBbRsQP7yTtSBg7dcnGekvFGHp64DkxIqcw39vrF9ZXPHZfwyD
         A0CFd0uoZwVcRqBYBKqzA23SGsabi07LFQk/HN8BeJL6aFiGJYRTrzIlqmWmFZh7Iw
         d8L3kD4Bq4VNujSMUKUd7z/i/F57/tuZxcptRQgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Stan Johnson <userm57@yahoo.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.2 254/413] scsi: NCR5380: Handle PDMA failure reliably
Date:   Wed, 24 Jul 2019 21:19:05 +0200
Message-Id: <20190724191754.077822287@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
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
@@ -1761,10 +1761,8 @@ static void NCR5380_information_transfer
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


