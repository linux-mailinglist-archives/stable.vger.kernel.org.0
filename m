Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45141101561
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfKSFnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:43:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:38388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730750AbfKSFnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:43:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D680208C3;
        Tue, 19 Nov 2019 05:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142211;
        bh=OVPd61lh52XnKI/5MBHrjcApo0Y+YUQqhVuZpSLUWyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uz2XvfclTLKWySC5dQdduJnKSq97wEGkeCkr8Ju61aE9VF631IDGSuGE+ffj14D4P
         TG3CsGegcHeayQmpVAv8dDGaPOi5+7WI7+NpqWdJc/oO8JtmyDVGuq6HLTiN4W+7UR
         igCX3qwwXIQbYg1jd0xQBWVkcZ2zdGVA2C0mQfJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 403/422] scsi: NCR5380: Check for invalid reselection target
Date:   Tue, 19 Nov 2019 06:20:00 +0100
Message-Id: <20191119051425.275005083@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

[ Upstream commit 7ef55f6744c45e3d7c85a3f74ada39b67ac741dd ]

The X3T9.2 specification (draft) says, under "6.1.4.1 RESELECTION", that "the
initiator shall not respond to a RESELECTION phase if other than two SCSI ID
bits are on the DATA BUS." This issue (too many bits set) has been observed in
the wild, so add a check.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/NCR5380.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 90136942f4882..c67f476447372 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2008,6 +2008,11 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 	NCR5380_write(MODE_REG, MR_BASE);
 
 	target_mask = NCR5380_read(CURRENT_SCSI_DATA_REG) & ~(hostdata->id_mask);
+	if (!target_mask || target_mask & (target_mask - 1)) {
+		shost_printk(KERN_WARNING, instance,
+			     "reselect: bad target_mask 0x%02x\n", target_mask);
+		return;
+	}
 
 	dsprintk(NDEBUG_RESELECTION, instance, "reselect\n");
 
-- 
2.20.1



