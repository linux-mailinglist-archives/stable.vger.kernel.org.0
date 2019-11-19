Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFD51016CB
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732136AbfKSFyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:54:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:52552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732135AbfKSFyY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:54:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCF4D21D7B;
        Tue, 19 Nov 2019 05:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142864;
        bh=BBDr5XZmvudqT38/n9AWNa+7cdhu3U138aHUBryPFtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tBWIY5v/ix5WblnoDZTuSUzD85tfg0n0QdsBxaNosFdjYomGV+bwIQuJxiRd7NxZ1
         jDsjMZMHlNEgY307hbRv0lgVpmxI+sTjqUftWBGs4NyQ195SUEDOp3kCN2JPa+BgED
         pVWL4lJIqYqAdmu3vcbLv9Fp1Ab55ZoNhDSvmnfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 227/239] scsi: NCR5380: Handle BUS FREE during reselection
Date:   Tue, 19 Nov 2019 06:20:27 +0100
Message-Id: <20191119051340.769442775@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit ca694afad707cb3ae2fdef3b28454444d9ac726e ]

The X3T9.2 specification (draft) says, under "6.1.4.2 RESELECTION time-out
procedure", that a target may assert RST or go to BUS FREE phase if the
initiator does not respond within 200 us. Something like this has been
observed with AztecMonster II target. When it happens, all we can do is wait
for the target to try again.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 48f123601f575..a85c5155fcf40 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2045,6 +2045,9 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 
 	if (NCR5380_poll_politely(hostdata,
 	                          STATUS_REG, SR_REQ, SR_REQ, 2 * HZ) < 0) {
+		if ((NCR5380_read(STATUS_REG) & (SR_BSY | SR_SEL)) == 0)
+			/* BUS FREE phase */
+			return;
 		shost_printk(KERN_ERR, instance, "reselect: REQ timeout\n");
 		do_abort(instance);
 		return;
-- 
2.20.1



