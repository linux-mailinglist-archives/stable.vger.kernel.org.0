Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5802614849C
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388870AbgAXLmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:42:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389793AbgAXLOI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:14:08 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 753FA214AF;
        Fri, 24 Jan 2020 11:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864448;
        bh=8/oqdclhpk1k69f70hRYPn5lk3f5OjABvqhG0qkPPF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWX11zEHErUMzV7COB6Wt02d4sqQvSB1G3opMNdeuSlV1k0ttBDdcBXFHf1IKuZJ5
         5gbQRSbui29KPS8RQxtkSLSosOkXeAJJAOAc2fyOjE0zVwNb1Fq0C6paf0BpKTo2jJ
         KhwYsIKnvx5/mx84ywaG67ykcVkPreAV78v71FZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve Sistare <steven.sistare@oracle.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 255/639] scsi: megaraid_sas: reduce module load time
Date:   Fri, 24 Jan 2020 10:27:05 +0100
Message-Id: <20200124093118.649741900@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Sistare <steven.sistare@oracle.com>

[ Upstream commit 31b6a05f86e690e1818116fd23c3be915cc9d9ed ]

megaraid_sas takes 1+ seconds to load while waiting for firmware:

[2.822603] megaraid_sas 0000:03:00.0: Waiting for FW to come to ready state
[3.871003] megaraid_sas 0000:03:00.0: FW now in Ready state

This is due to the following loop in megasas_transition_to_ready(), which
waits a minimum of 1 second, even though the FW becomes ready in tens of
millisecs:

        /*
         * The cur_state should not last for more than max_wait secs
         */
        for (i = 0; i < max_wait; i++) {
                ...
                msleep(1000);
        ...
        dev_info(&instance->pdev->dev, "FW now in Ready state\n");

This is a regression, caused by a change of the msleep granularity from 1
to 1000 due to concern about waiting too long on systems with coarse
jiffies.

To fix, increase iterations and use msleep(20), which results in:

[2.670627] megaraid_sas 0000:03:00.0: Waiting for FW to come to ready state
[2.739386] megaraid_sas 0000:03:00.0: FW now in Ready state

Fixes: fb2f3e96d80f ("scsi: megaraid_sas: Fix msleep granularity")
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 2f31d266339f8..99469f9057eea 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3894,12 +3894,12 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 		/*
 		 * The cur_state should not last for more than max_wait secs
 		 */
-		for (i = 0; i < max_wait; i++) {
+		for (i = 0; i < max_wait * 50; i++) {
 			curr_abs_state = instance->instancet->
 				read_fw_status_reg(instance->reg_set);
 
 			if (abs_state == curr_abs_state) {
-				msleep(1000);
+				msleep(20);
 			} else
 				break;
 		}
-- 
2.20.1



