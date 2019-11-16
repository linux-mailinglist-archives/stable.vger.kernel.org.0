Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 491EAFEFD4
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbfKPQBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:01:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:34330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731195AbfKPPxS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:53:18 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D270218AE;
        Sat, 16 Nov 2019 15:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919597;
        bh=S6U2qzUqNJVgEYYa4WE0Mi8QIFME/YpoalQe60XZ0+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6DgqJZVkUsEw0e98aMbKducB12bA4MbKw8GIqd17eKuAM/2ySbiIQHKHJk92cjrs
         KqXKoWq2uvK6yEXl98meiy81vVJ1uVW4EL/UabNxSBmA4h/+V1vHo1txj3+L2J8aJc
         h1SysufhnTiAf98A+E8jsPfMFJA4jI+REB5LINZc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 85/99] scsi: megaraid_sas: Fix msleep granularity
Date:   Sat, 16 Nov 2019 10:50:48 -0500
Message-Id: <20191116155103.10971-85-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

[ Upstream commit 9155cf30a3c4ef97e225d6daddf9bd4b173267e8 ]

In megasas_transition_to_ready() driver waits 180seconds for controller to
change FW state. Here we are calling msleep(1) in a loop for this.  As
explained in timers-howto.txt, msleep(1) will actually sleep longer than
1ms. If a faulty controller is connected, we will end up waiting for much
more than 180 seconds causing unnecessary delays during load.

Change the granularity of msleep() call from 1ms to 1000ms.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d90693b2767fd..c5cc002dfdd5c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3694,12 +3694,12 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 		/*
 		 * The cur_state should not last for more than max_wait secs
 		 */
-		for (i = 0; i < (max_wait * 1000); i++) {
+		for (i = 0; i < max_wait; i++) {
 			curr_abs_state = instance->instancet->
 				read_fw_status_reg(instance->reg_set);
 
 			if (abs_state == curr_abs_state) {
-				msleep(1);
+				msleep(1000);
 			} else
 				break;
 		}
-- 
2.20.1

