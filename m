Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD803653D4
	for <lists+stable@lfdr.de>; Tue, 20 Apr 2021 10:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhDTIRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Apr 2021 04:17:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45005 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229593AbhDTIQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Apr 2021 04:16:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618906588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XJFMVyj4cgN/sZsxR0u2d2bEIw2+LpoMcRwhutx6v+U=;
        b=aX/jw5Y58mF9GBFaVOBnXWZ2FO+w6OrVJJnhweCtERgS+ZiaQKtxV4QYqkkh/XclZy0u4C
        7AGL7uBtEliJXYiSwQNJOyNKQBnB2ZIX6G2z4GtPC5Xe+HkK8H1tWbx/dbAvBj2N2QpoLP
        GzuNDhMcvuxLohcZAJQpcVTgi9Xp/d4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-ZGHcG1ceOoCtUrwHvtHcNw-1; Tue, 20 Apr 2021 04:16:20 -0400
X-MC-Unique: ZGHcG1ceOoCtUrwHvtHcNw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 772C484B9B0;
        Tue, 20 Apr 2021 08:16:19 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B55591F04F;
        Tue, 20 Apr 2021 08:16:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] KVM: selftests: Always run vCPU thread with blocked SIG_IPI
Date:   Tue, 20 Apr 2021 04:16:14 -0400
Message-Id: <20210420081614.684787-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The main thread could start to send SIG_IPI at any time, even before signal
blocked on vcpu thread.  Therefore, start the vcpu thread with the signal
blocked.

Without this patch, on very busy cores the dirty_log_test could fail directly
on receiving a SIGUSR1 without a handler (when vcpu runs far slower than main).

Reported-by: Peter Xu <peterx@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index ffa4e2791926..81edbd23d371 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -527,9 +527,8 @@ static void *vcpu_worker(void *data)
 	 */
 	sigmask->len = 8;
 	pthread_sigmask(0, NULL, sigset);
+	sigdelset(sigset, SIG_IPI);
 	vcpu_ioctl(vm, VCPU_ID, KVM_SET_SIGNAL_MASK, sigmask);
-	sigaddset(sigset, SIG_IPI);
-	pthread_sigmask(SIG_BLOCK, sigset, NULL);
 
 	sigemptyset(sigset);
 	sigaddset(sigset, SIG_IPI);
@@ -858,6 +857,7 @@ int main(int argc, char *argv[])
 		.interval = TEST_HOST_LOOP_INTERVAL,
 	};
 	int opt, i;
+	sigset_t sigset;
 
 	sem_init(&sem_vcpu_stop, 0, 0);
 	sem_init(&sem_vcpu_cont, 0, 0);
@@ -916,6 +916,11 @@ int main(int argc, char *argv[])
 
 	srandom(time(0));
 
+	/* Ensure that vCPU threads start with SIG_IPI blocked.  */
+	sigemptyset(&sigset);
+	sigaddset(&sigset, SIG_IPI);
+	pthread_sigmask(SIG_BLOCK, &sigset, NULL);
+
 	if (host_log_mode_option == LOG_MODE_ALL) {
 		/* Run each log mode */
 		for (i = 0; i < LOG_MODE_NUM; i++) {
-- 
2.26.2

