Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE6CC13EC50
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394511AbgAPR4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:56:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394060AbgAPRoH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:44:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA43224754;
        Thu, 16 Jan 2020 17:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196646;
        bh=8tKu9aY8lqaLZzkhyKGvOPmvsQ468ZEdJIMNNfvE7TQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWaSthBHZbBe71qIb6JtZEpNDk5+S2sx0sIqvyK6dBv5dxo+OuM0lvQpreYt6LwFF
         3nIJ/icMPuo23+BhrXtZHxs5E1xvqcirukgy7to1RJHMVE8ct4vYc0h0KkSOK3i8T3
         b2H5IO0oPZan5/wGJMcjn/HkRVjz7C9NLYKNOIpc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve Sistare <steven.sistare@oracle.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 056/174] scsi: megaraid_sas: reduce module load time
Date:   Thu, 16 Jan 2020 12:40:53 -0500
Message-Id: <20200116174251.24326-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116174251.24326-1-sashal@kernel.org>
References: <20200116174251.24326-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 7be968f60b59..1efd876f0728 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3585,12 +3585,12 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
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

