Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C21E37C79E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbhELQBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237947AbhELP4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6007061417;
        Wed, 12 May 2021 15:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833345;
        bh=nLZ1e9tNA/NRzg99NLvbibdJY4Yb0Z6KJg+CdS/Ll94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Li7FThxfIzU1Ayvt1RwMb+iyzdRW5FdUt2UX35aXkzS5SUxytmnLsgxGKWqxFaxXq
         Pe4dLAU53ik5pfohvSs+d0eYO+3NAjWABoxfzcbscTsWTgypkQ5+3zNtajRg0qC24X
         uLKMlMaIwOBEqL1a32RXbSN7UKonRYfOfdC9vgH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 114/601] KVM: selftests: Always run vCPU thread with blocked SIG_IPI
Date:   Wed, 12 May 2021 16:43:11 +0200
Message-Id: <20210512144831.587621104@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit bf1e15a82e3b74ee86bb119d6038b41e1ed2b319 upstream.

The main thread could start to send SIG_IPI at any time, even before signal
blocked on vcpu thread.  Therefore, start the vcpu thread with the signal
blocked.

Without this patch, on very busy cores the dirty_log_test could fail directly
on receiving a SIGUSR1 without a handler (when vcpu runs far slower than main).

Reported-by: Peter Xu <peterx@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/dirty_log_test.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

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


