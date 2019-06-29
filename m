Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043525A7F2
	for <lists+stable@lfdr.de>; Sat, 29 Jun 2019 03:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbfF2BCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 21:02:25 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41846 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfF2BCZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 21:02:25 -0400
Received: by mail-pg1-f194.google.com with SMTP id q4so1829147pgj.8
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 18:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=azV1r3kI2De1UK1aLNSrZEl+F3quwpOsTs6ORAV3f/U=;
        b=exOxzW0mQUJI5jG9KbqHRNoEtMgv2Rk6OTpa4sq5AmInZp7kIDz5wW8eCeUZvUZQQ6
         vAzkWqb4TUo8i75aF8JJ+6smTY97vkOp/nEJ9HRHdDU7cE7O2t1Uux8dl0W0U4vAqp4S
         Sb9mTvaQMK60+HGFklKkt2Ma8/x7cydN+Q4SE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=azV1r3kI2De1UK1aLNSrZEl+F3quwpOsTs6ORAV3f/U=;
        b=U0OUPjO/LdNhG9E496zeCSqOkcP79afvQ3ak0xu4enh9OisdbwYbX9LLO8GBwvEshT
         oHy3kInS4jjvFAIr17mttS+6DBYxym1XZhoi+l/LnLHTHHiF2kM+2elqEp1CQ6nxIZTJ
         Aq6+rp5LrnD8hDpOS1oEGujK49EToPPc40vVDZVarQRAGtRAi98dwN5YQYF4fqrNzUnr
         iRXaCV/3bl2PKSDxDsTO2ojQZ+UmgEM9HdalSgD3GKl1TExh/VqSafhPLcNwy2P3hRc5
         q7foxSwlXtfoztviQ1N9nOoDhAkAqO2AgNRMY3y25mz6TTLBQ4Wb6eydhfrBsIGeAGmp
         HUfw==
X-Gm-Message-State: APjAAAUM9eC+877nHUq3vCNip2BHk5trK5AtIdpiPhbSnxQhzqm8Hoev
        5wo69WMs+lrufeOv3FxbBQd1GQ==
X-Google-Smtp-Source: APXvYqzTmJqFv9iZ58G6kS5r6RDqAvDjBNIfFiKxg+4MA/CpalepPWTgL0XwhJu0nY0gTU8kXl8Hdw==
X-Received: by 2002:a63:2326:: with SMTP id j38mr12264025pgj.134.1561770144267;
        Fri, 28 Jun 2019 18:02:24 -0700 (PDT)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y11sm5400868pfb.119.2019.06.28.18.02.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 18:02:22 -0700 (PDT)
From:   Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, chandrakanth.patil@broadcom.com,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] megaraid_sas: Fix calculation of target ID
Date:   Fri, 28 Jun 2019 18:02:12 -0700
Message-Id: <1561770132-27408-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In megasas_get_target_prop(), driver is incorrectly calculating the
target ID for devices with channel 1 and 3.
Due to this, firmware will either fail the command (if there is no
device with the target id sent from driver) or could return the
properties for a target which was not intended.
Devices could end up with the wrong queue depth due to this.

Fix target id calculation for channel 1 and 3.

Fixes: 96188a89cc6d ("scsi: megaraid_sas: NVME interface target prop added")
Cc: stable@vger.kernel.org
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b4c0bbc..9321878 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6558,7 +6558,8 @@ megasas_get_target_prop(struct megasas_instance *instance,
 	int ret;
 	struct megasas_cmd *cmd;
 	struct megasas_dcmd_frame *dcmd;
-	u16 targetId = (sdev->channel % 2) + sdev->id;
+	u16 targetId = ((sdev->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) +
+			sdev->id;
 
 	cmd = megasas_get_cmd(instance);
 
-- 
2.9.5

