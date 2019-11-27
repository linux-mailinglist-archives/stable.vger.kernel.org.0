Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5505210BDD4
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbfK0Uxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:53:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730755AbfK0Uxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:53:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1931D21850;
        Wed, 27 Nov 2019 20:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888018;
        bh=8b+zj0+DXJml/xNJPstz9a1AxF/molanvs40WN1AvBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTEd1vlnLfEwOGGd6H6ojGDmnlLIEOwzeaSk+YrScc2BJv/ZPjV5FM1ZXMeO36FfV
         VfUadTwp2ZK0hr1lNXp9t80HvPc5rGC+aS3fwHKpsFKAl4awBRDsqFrYLv2XK5/e8n
         +9xMKNDZQqwp9+BsVkBGmuthK6tHhY9F6sJJHA9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 143/211] scsi: megaraid_sas: Fix msleep granularity
Date:   Wed, 27 Nov 2019 21:31:16 +0100
Message-Id: <20191127203107.514426507@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8595d83229b77..23a9f0777fa62 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3823,12 +3823,12 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
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



