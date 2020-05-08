Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DA41CA696
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 10:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgEHIw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 04:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgEHIw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 04:52:58 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F68CC05BD43
        for <stable@vger.kernel.org>; Fri,  8 May 2020 01:52:57 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id k12so9368576wmj.3
        for <stable@vger.kernel.org>; Fri, 08 May 2020 01:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=XHtY22wdqoD6kwX3h4YQdHgh33drKh8dmMkZ3FUswro=;
        b=a3M4eQ+WWaAMgC3KWWxjz92/gjVJbQg54xYUI2IMUPV8vbLXBByqWMB616+NYou7hB
         g0MfI5H3o1UxEtWkyOp7WJ/p0V92jf/07aCuzVW6zZclHr8hlc4js0grL/UvLee76ET7
         RKfEuIW0zS1x2pvxPGG/xk04NnL/eP5M7PX0g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XHtY22wdqoD6kwX3h4YQdHgh33drKh8dmMkZ3FUswro=;
        b=UJO4hVTKbG94DJkMdRZ52PDu2iIz/Je2eGwlH8GjkUIGw+XCsrSblfZEgwqE5+VoNK
         PnPQJfYEfKYv1vCncg9mF27OL6LLBnhUms6+k3h5OP5jSslVc8RFzGmTTRqpY/PFWa5j
         HI5+Q1hBqzR2QDgZSCSq+VBQ94RprdivBHiQ8Pv0zbjM50fquTpJfrAY2MhPiyQ18dZd
         fcEvKKWcYFW/ganCW9/ol6Sy89KTcWmUHRYjwnIwEUmMRBjzG4oH9qIM1r1pZWttfEsC
         3EhTdpkBmSGXLz5aUyWBwivDiH+mbwvOj/SAYsR4I5J/lruWWT0iOwprTcTlYY8KDj7l
         z9QQ==
X-Gm-Message-State: AGi0PubYRF1Xoe0yPsO4SO8HYiR+tBbKaF6q3uPde7WNvZDDLVwK1pi5
        t3zdnt46gp5WHisQZHwt0Ve2nw==
X-Google-Smtp-Source: APiQypKdriRs4YmjXWuUXd6zMQwRpYcVQtLFOq8GnpNc/A1T2Ibe50kATp5BITp4mlzmVAS0oN2d/w==
X-Received: by 2002:a1c:6042:: with SMTP id u63mr854070wmb.65.1588927976290;
        Fri, 08 May 2020 01:52:56 -0700 (PDT)
Received: from it_dev_server1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id f26sm12132333wmj.11.2020.05.08.01.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 01:52:55 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        stable@vger.kernel.org
Subject: [PATCH 4/5] megaraid_sas: TM command refire leads to controller firmware crash
Date:   Fri,  8 May 2020 14:22:42 +0530
Message-Id: <20200508085242.23406-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.9.5
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Issue: When TM command times-out driver invokes the controller
reset. Post reset, driver re-fires pended TM commands which leads
to firmware crash.

Fix: Post controller reset, return pended TM commands back to OS.

Cc: stable@vger.kernel.org
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 87f91a38..319f241 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4180,6 +4180,7 @@ static void megasas_refire_mgmt_cmd(struct megasas_instance *instance,
 	struct fusion_context *fusion;
 	struct megasas_cmd *cmd_mfi;
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	struct MPI2_RAID_SCSI_IO_REQUEST *scsi_io_req;
 	u16 smid;
 	bool refire_cmd = false;
 	u8 result;
@@ -4247,6 +4248,11 @@ static void megasas_refire_mgmt_cmd(struct megasas_instance *instance,
 			result = COMPLETE_CMD;
 		}
 
+		scsi_io_req = (struct MPI2_RAID_SCSI_IO_REQUEST *)
+				cmd_fusion->io_request;
+		if (scsi_io_req->Function == MPI2_FUNCTION_SCSI_TASK_MGMT)
+			result = RETURN_CMD;
+
 		switch (result) {
 		case REFIRE_CMD:
 			megasas_fire_cmd_fusion(instance, req_desc);
@@ -4475,7 +4481,6 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
 	if (!timeleft) {
 		dev_err(&instance->pdev->dev,
 			"task mgmt type 0x%x timed out\n", type);
-		cmd_mfi->flags |= DRV_DCMD_SKIP_REFIRE;
 		mutex_unlock(&instance->reset_mutex);
 		rc = megasas_reset_fusion(instance->host, MFI_IO_TIMEOUT_OCR);
 		mutex_lock(&instance->reset_mutex);
-- 
2.9.5

