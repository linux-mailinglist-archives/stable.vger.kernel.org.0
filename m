Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 942CBFF362
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbfKPQZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:25:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728152AbfKPPmH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:42:07 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C22602075B;
        Sat, 16 Nov 2019 15:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918926;
        bh=RePkeaheWKE+ZnVrEGtOO+X4ZsfaVqbtPRO0k4Nlf8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I0ZPuJPdB0reNl80Uci6AEXhYNOEWmBTU1E2QSETlVb9XazJR7wwBYH8IiLjQkbD2
         tlAniOadOqvxLEnqkQIguE43agQ64D/5hbwokLVbI7Jk2sD8ylEhxmQEsGdA9ULOKQ
         Eo9KqHeDN+xU7Fw9n6a8F/em4jDx2OCoBdlQi/rA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 052/237] scsi: isci: Change sci_controller_start_task's return type to sci_status
Date:   Sat, 16 Nov 2019 10:38:07 -0500
Message-Id: <20191116154113.7417-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 1ee3868ade079..7b5deae68d33b 100644
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
index b3539928073c6..6bc3f022630a2 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -489,7 +489,7 @@ enum sci_status sci_controller_start_io(
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

