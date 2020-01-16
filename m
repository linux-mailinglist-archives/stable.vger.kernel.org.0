Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D143513F603
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389149AbgAPTAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:00:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388481AbgAPRGJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:06:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A403122522;
        Thu, 16 Jan 2020 17:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194368;
        bh=DIN3t0CL3qc9oQivN4pyYzvvL2OYzqK+JGu7m+2wO8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffdNfVSH0xKwPk6evCnL/w9ZxtSx4/AI3Hqy3ZTrzqX+X3CFKC4MxxtbJV+mqiFma
         4ITk3wIOvaSNXh7ZAzfBruALNB4013PNaOIz77zzrHsuSmmKVbD2oswda2mAmLCjOI
         NMG7pLNhuE+S+vtSxLCvUTmlicf5f60j3LW+XdHE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 302/671] selftests/ipc: Fix msgque compiler warnings
Date:   Thu, 16 Jan 2020 11:59:00 -0500
Message-Id: <20200116170509.12787-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit a147faa96f832f76e772b1e448e94ea84c774081 ]

This fixes the various compiler warnings when building the msgque
selftest. The primary change is using sys/msg.h instead of linux/msg.h
directly to gain the API declarations.

Fixes: 3a665531a3b7 ("selftests: IPC message queue copy feature test")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ipc/msgque.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/ipc/msgque.c b/tools/testing/selftests/ipc/msgque.c
index dac927e82336..4c156aeab6b8 100644
--- a/tools/testing/selftests/ipc/msgque.c
+++ b/tools/testing/selftests/ipc/msgque.c
@@ -1,9 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 #include <errno.h>
-#include <linux/msg.h>
+#include <sys/msg.h>
 #include <fcntl.h>
 
 #include "../kselftest.h"
@@ -73,7 +74,7 @@ int restore_queue(struct msgque_data *msgque)
 	return 0;
 
 destroy:
-	if (msgctl(id, IPC_RMID, 0))
+	if (msgctl(id, IPC_RMID, NULL))
 		printf("Failed to destroy queue: %d\n", -errno);
 	return ret;
 }
@@ -120,7 +121,7 @@ int check_and_destroy_queue(struct msgque_data *msgque)
 
 	ret = 0;
 err:
-	if (msgctl(msgque->msq_id, IPC_RMID, 0)) {
+	if (msgctl(msgque->msq_id, IPC_RMID, NULL)) {
 		printf("Failed to destroy queue: %d\n", -errno);
 		return -errno;
 	}
@@ -129,7 +130,7 @@ int check_and_destroy_queue(struct msgque_data *msgque)
 
 int dump_queue(struct msgque_data *msgque)
 {
-	struct msqid64_ds ds;
+	struct msqid_ds ds;
 	int kern_id;
 	int i, ret;
 
@@ -245,7 +246,7 @@ int main(int argc, char **argv)
 	return ksft_exit_pass();
 
 err_destroy:
-	if (msgctl(msgque.msq_id, IPC_RMID, 0)) {
+	if (msgctl(msgque.msq_id, IPC_RMID, NULL)) {
 		printf("Failed to destroy queue: %d\n", -errno);
 		return ksft_exit_fail();
 	}
-- 
2.20.1

