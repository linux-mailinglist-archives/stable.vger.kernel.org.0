Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412B814812E
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390542AbgAXLRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:17:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:54740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390540AbgAXLRn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:17:43 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D5C820708;
        Fri, 24 Jan 2020 11:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864663;
        bh=V2ObQklqtp/hzvya5V7dIGtcFzFghzczuY3iesGWcG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdgWyYEBhDESH3DMN/EcnX2yu7a1fxFLbneNz9RV7oHwfo8rxm3BArmEVRTQ4ko8y
         fHGqZz+2LvU2H1uLyPCLT3xAinBR7041ueGJgNG8rpg2iePVad9Wa8XW0sixEPlxvD
         Hz1xMOmv7aCvKIhf1PLGGWKFtBYqosNUQuLKD5c4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 317/639] selftests/ipc: Fix msgque compiler warnings
Date:   Fri, 24 Jan 2020 10:28:07 +0100
Message-Id: <20200124093126.737890373@linuxfoundation.org>
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
index dac927e823363..4c156aeab6b80 100644
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
@@ -129,7 +130,7 @@ err:
 
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



