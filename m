Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D28582EB9
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240261AbiG0RQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241590AbiG0RPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:15:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518155C37F;
        Wed, 27 Jul 2022 09:43:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96EE1B821AC;
        Wed, 27 Jul 2022 16:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D11C433C1;
        Wed, 27 Jul 2022 16:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940177;
        bh=D6lvZDOlW//hEWRg9C+IUetipLsoLf/v/3N28GN55mQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLq+Yo3k/kenBQnhpM6yd+mPMqVwcePi5EoGVDPf5WPtDuoKO58ZtZvlbrRZMHdHJ
         o34qvx9AwR11TJI59WMgVauMEBm49V/+qRgyVjm2X1fEGpUdBRL+omCfpy7L1zA57+
         T6X+2P7OiK3RCePNgEe/k5x1Gl3ER/8iqWnyBWqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Gavin Shan <gshan@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 132/201] KVM: selftests: Fix target thread to be migrated in rseq_test
Date:   Wed, 27 Jul 2022 18:10:36 +0200
Message-Id: <20220727161033.268900056@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gavin Shan <gshan@redhat.com>

commit e923b0537d28e15c9d31ce8b38f810b325816903 upstream.

In rseq_test, there are two threads, which are vCPU thread and migration
worker separately. Unfortunately, the test has the wrong PID passed to
sched_setaffinity() in the migration worker. It forces migration on the
migration worker because zeroed PID represents the calling thread, which
is the migration worker itself. It means the vCPU thread is never enforced
to migration and it can migrate at any time, which eventually leads to
failure as the following logs show.

  host# uname -r
  5.19.0-rc6-gavin+
  host# # cat /proc/cpuinfo | grep processor | tail -n 1
  processor    : 223
  host# pwd
  /home/gavin/sandbox/linux.main/tools/testing/selftests/kvm
  host# for i in `seq 1 100`; do \
        echo "--------> $i"; ./rseq_test; done
  --------> 1
  --------> 2
  --------> 3
  --------> 4
  --------> 5
  --------> 6
  ==== Test Assertion Failure ====
    rseq_test.c:265: rseq_cpu == cpu
    pid=3925 tid=3925 errno=4 - Interrupted system call
       1  0x0000000000401963: main at rseq_test.c:265 (discriminator 2)
       2  0x0000ffffb044affb: ?? ??:0
       3  0x0000ffffb044b0c7: ?? ??:0
       4  0x0000000000401a6f: _start at ??:?
    rseq CPU = 4, sched CPU = 27

Fix the issue by passing correct parameter, TID of the vCPU thread, to
sched_setaffinity() in the migration worker.

Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Message-Id: <20220719020830.3479482-1-gshan@redhat.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/rseq_test.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 4158da0da2bb..2237d1aac801 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -82,8 +82,9 @@ static int next_cpu(int cpu)
 	return cpu;
 }
 
-static void *migration_worker(void *ign)
+static void *migration_worker(void *__rseq_tid)
 {
+	pid_t rseq_tid = (pid_t)(unsigned long)__rseq_tid;
 	cpu_set_t allowed_mask;
 	int r, i, cpu;
 
@@ -106,7 +107,7 @@ static void *migration_worker(void *ign)
 		 * stable, i.e. while changing affinity is in-progress.
 		 */
 		smp_wmb();
-		r = sched_setaffinity(0, sizeof(allowed_mask), &allowed_mask);
+		r = sched_setaffinity(rseq_tid, sizeof(allowed_mask), &allowed_mask);
 		TEST_ASSERT(!r, "sched_setaffinity failed, errno = %d (%s)",
 			    errno, strerror(errno));
 		smp_wmb();
@@ -231,7 +232,8 @@ int main(int argc, char *argv[])
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	ucall_init(vm, NULL);
 
-	pthread_create(&migration_thread, NULL, migration_worker, 0);
+	pthread_create(&migration_thread, NULL, migration_worker,
+		       (void *)(unsigned long)gettid());
 
 	for (i = 0; !done; i++) {
 		vcpu_run(vm, VCPU_ID);
-- 
2.37.1



