Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7F95053F8
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240422AbiDRNDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241030AbiDRNCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:02:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE178326F7;
        Mon, 18 Apr 2022 05:42:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4205B80EDB;
        Mon, 18 Apr 2022 12:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6554C385A7;
        Mon, 18 Apr 2022 12:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285752;
        bh=xb0hS4BrdUP+xSIwy3hBDuYk5Yqiydpc9Eeeprbd1yE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lh/r3Y/BjpzewcspVSycNOkfQJ0826VpjMkiZMFvrUKqkKqDpm4I/w2kYkdhSjAjs
         Iu92u5WnRCda5ioi8fAP5PkZxoJAGMpMO9PqqlHjg+0C8x/emuJ6ePJJ0K97wuE0O4
         53Rwcp0nM7qeQB1ES/0aWcwpFKZprMUA9yMC72N0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 13/63] testing/selftests/mqueue: Fix mq_perf_tests to free the allocated cpu set
Date:   Mon, 18 Apr 2022 14:13:10 +0200
Message-Id: <20220418121135.027937801@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121134.149115109@linuxfoundation.org>
References: <20220418121134.149115109@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit ce64763c63854b4079f2e036638aa881a1fb3fbc ]

The selftest "mqueue/mq_perf_tests.c" use CPU_ALLOC to allocate
CPU set. This cpu set is used further in pthread_attr_setaffinity_np
and by pthread_create in the code. But in current code, allocated
cpu set is not freed.

Fix this issue by adding CPU_FREE in the "shutdown" function which
is called in most of the error/exit path for the cleanup. There are
few error paths which exit without using shutdown. Add a common goto
error path with CPU_FREE for these cases.

Fixes: 7820b0715b6f ("tools/selftests: add mq_perf_tests")
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/mqueue/mq_perf_tests.c  | 25 +++++++++++++------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mqueue/mq_perf_tests.c b/tools/testing/selftests/mqueue/mq_perf_tests.c
index b019e0b8221c..84fda3b49073 100644
--- a/tools/testing/selftests/mqueue/mq_perf_tests.c
+++ b/tools/testing/selftests/mqueue/mq_perf_tests.c
@@ -180,6 +180,9 @@ void shutdown(int exit_val, char *err_cause, int line_no)
 	if (in_shutdown++)
 		return;
 
+	/* Free the cpu_set allocated using CPU_ALLOC in main function */
+	CPU_FREE(cpu_set);
+
 	for (i = 0; i < num_cpus_to_pin; i++)
 		if (cpu_threads[i]) {
 			pthread_kill(cpu_threads[i], SIGUSR1);
@@ -551,6 +554,12 @@ int main(int argc, char *argv[])
 		perror("sysconf(_SC_NPROCESSORS_ONLN)");
 		exit(1);
 	}
+
+	if (getuid() != 0)
+		ksft_exit_skip("Not running as root, but almost all tests "
+			"require root in order to modify\nsystem settings.  "
+			"Exiting.\n");
+
 	cpus_online = min(MAX_CPUS, sysconf(_SC_NPROCESSORS_ONLN));
 	cpu_set = CPU_ALLOC(cpus_online);
 	if (cpu_set == NULL) {
@@ -589,7 +598,7 @@ int main(int argc, char *argv[])
 						cpu_set)) {
 					fprintf(stderr, "Any given CPU may "
 						"only be given once.\n");
-					exit(1);
+					goto err_code;
 				} else
 					CPU_SET_S(cpus_to_pin[cpu],
 						  cpu_set_size, cpu_set);
@@ -607,7 +616,7 @@ int main(int argc, char *argv[])
 				queue_path = malloc(strlen(option) + 2);
 				if (!queue_path) {
 					perror("malloc()");
-					exit(1);
+					goto err_code;
 				}
 				queue_path[0] = '/';
 				queue_path[1] = 0;
@@ -622,17 +631,12 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "Must pass at least one CPU to continuous "
 			"mode.\n");
 		poptPrintUsage(popt_context, stderr, 0);
-		exit(1);
+		goto err_code;
 	} else if (!continuous_mode) {
 		num_cpus_to_pin = 1;
 		cpus_to_pin[0] = cpus_online - 1;
 	}
 
-	if (getuid() != 0)
-		ksft_exit_skip("Not running as root, but almost all tests "
-			"require root in order to modify\nsystem settings.  "
-			"Exiting.\n");
-
 	max_msgs = fopen(MAX_MSGS, "r+");
 	max_msgsize = fopen(MAX_MSGSIZE, "r+");
 	if (!max_msgs)
@@ -740,4 +744,9 @@ int main(int argc, char *argv[])
 			sleep(1);
 	}
 	shutdown(0, "", 0);
+
+err_code:
+	CPU_FREE(cpu_set);
+	exit(1);
+
 }
-- 
2.35.1



