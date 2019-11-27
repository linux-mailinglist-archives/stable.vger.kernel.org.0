Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9281610BFD3
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbfK0Vpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:45:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:35778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727771AbfK0UfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:35:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8266216C8;
        Wed, 27 Nov 2019 20:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886900;
        bh=detVZUwgRyHVtddSUN/iavcWIqSHjmcqFrt8yqmE6bQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2AWs4qmnUks1YM7QnH7ccn5A2rZYfUjlIOYgEn/eP0zWfRTWSrqNtHlhE9lv+f2o
         x3RB3/XKX803BkQyYsHrWmg4+4GensqV57bS52eVKZghZqsd6LdVzMtd/AORdbYtxz
         80a2jce17Ac5mFblQMQ4AEP8SqLOT+Gst/sH1nFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 037/132] scsi: isci: Change sci_controller_start_tasks return type to sci_status
Date:   Wed, 27 Nov 2019 21:30:28 +0100
Message-Id: <20191127202932.379168929@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 362b5da3dfceada6e74ecdd7af3991bbe42c0c0f ]

Clang warns when an enumerated type is implicitly converted to another.

drivers/scsi/isci/request.c:3476:13: warning: implicit conversion from
enumeration type 'enum sci_task_status' to different enumeration type
'enum sci_status' [-Wenum-conversion]
                        status = sci_controller_start_task(ihost,
                               ~ ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/isci/host.c:2744:10: warning: implicit conversion from
enumeration type 'enum sci_status' to different enumeration type 'enum
sci_task_status' [-Wenum-conversion]
                return SCI_SUCCESS;
                ~~~~~~ ^~~~~~~~~~~
drivers/scsi/isci/host.c:2753:9: warning: implicit conversion from
enumeration type 'enum sci_status' to different enumeration type 'enum
sci_task_status' [-Wenum-conversion]
        return status;
        ~~~~~~ ^~~~~~

Avoid all of these implicit conversion by just making
sci_controller_start_task use sci_status. This silences
Clang and has no functional change since sci_task_status
has all of its values mapped to something in sci_status.

Link: https://github.com/ClangBuiltLinux/linux/issues/153
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/isci/host.c | 8 ++++----
 drivers/scsi/isci/host.h | 2 +-
 drivers/scsi/isci/task.c | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 609dafd661d14..da4583a2fa23e 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -2717,9 +2717,9 @@ enum sci_status sci_controller_continue_io(struct isci_request *ireq)
  *    the task management request.
  * @task_request: the handle to the task request object to start.
  */
-enum sci_task_status sci_controller_start_task(struct isci_host *ihost,
-					       struct isci_remote_device *idev,
-					       struct isci_request *ireq)
+enum sci_status sci_controller_start_task(struct isci_host *ihost,
+					  struct isci_remote_device *idev,
+					  struct isci_request *ireq)
 {
 	enum sci_status status;
 
@@ -2728,7 +2728,7 @@ enum sci_task_status sci_controller_start_task(struct isci_host *ihost,
 			 "%s: SCIC Controller starting task from invalid "
 			 "state\n",
 			 __func__);
-		return SCI_TASK_FAILURE_INVALID_STATE;
+		return SCI_FAILURE_INVALID_STATE;
 	}
 
 	status = sci_remote_device_start_task(ihost, idev, ireq);
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 22a9bb1abae14..15dc6e0d8deb0 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -490,7 +490,7 @@ enum sci_status sci_controller_start_io(
 	struct isci_remote_device *idev,
 	struct isci_request *ireq);
 
-enum sci_task_status sci_controller_start_task(
+enum sci_status sci_controller_start_task(
 	struct isci_host *ihost,
 	struct isci_remote_device *idev,
 	struct isci_request *ireq);
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 6dcaed0c1fc8c..fb6eba331ac6e 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -258,7 +258,7 @@ static int isci_task_execute_tmf(struct isci_host *ihost,
 				 struct isci_tmf *tmf, unsigned long timeout_ms)
 {
 	DECLARE_COMPLETION_ONSTACK(completion);
-	enum sci_task_status status = SCI_TASK_FAILURE;
+	enum sci_status status = SCI_FAILURE;
 	struct isci_request *ireq;
 	int ret = TMF_RESP_FUNC_FAILED;
 	unsigned long flags;
@@ -301,7 +301,7 @@ static int isci_task_execute_tmf(struct isci_host *ihost,
 	/* start the TMF io. */
 	status = sci_controller_start_task(ihost, idev, ireq);
 
-	if (status != SCI_TASK_SUCCESS) {
+	if (status != SCI_SUCCESS) {
 		dev_dbg(&ihost->pdev->dev,
 			 "%s: start_io failed - status = 0x%x, request = %p\n",
 			 __func__,
-- 
2.20.1



