Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39030696AF2
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 18:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbjBNRMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 12:12:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232978AbjBNRLh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 12:11:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82E6C144
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 09:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676394604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4xhjIgOLD34GhGSF0bJgUI1/ZkWKw+rh+EHdWU9oeAM=;
        b=fPfPsamWbYwaiXT4ZxLQo9pgPfBpenfs2jMmwr7XKNQQJdVBI1Q2J6+2LWJgm0/n8Q3yT5
        1bhhGwW3Asl2PmWh8eXmuAy3v3pkfDT+hlXu1fwR0J6GZD9u5eXTSja61FAVM5E84YepdR
        oTFNrXCcDQpa3Ka/z+4E8TYGOrvbumM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-uqKBVgoXNqKpnA3laN9TUQ-1; Tue, 14 Feb 2023 12:10:00 -0500
X-MC-Unique: uqKBVgoXNqKpnA3laN9TUQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8839802C16;
        Tue, 14 Feb 2023 17:09:57 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 971C51121318;
        Tue, 14 Feb 2023 17:09:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org, thomas.lendacky@amd.com
Subject: [PATCH for-5.15 3/3] Documentation/hw-vuln: Add documentation for Cross-Thread Return Predictions
Date:   Tue, 14 Feb 2023 12:09:56 -0500
Message-Id: <20230214170956.1297309-4-pbonzini@redhat.com>
In-Reply-To: <20230214170956.1297309-1-pbonzini@redhat.com>
References: <20230214170956.1297309-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Add the admin guide for the Cross-Thread Return Predictions vulnerability.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Message-Id: <60f9c0b4396956ce70499ae180cb548720b25c7e.1675956146.git.thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../admin-guide/hw-vuln/cross-thread-rsb.rst  | 92 +++++++++++++++++++
 Documentation/admin-guide/hw-vuln/index.rst   |  1 +
 2 files changed, 93 insertions(+)
 create mode 100644 Documentation/admin-guide/hw-vuln/cross-thread-rsb.rst

diff --git a/Documentation/admin-guide/hw-vuln/cross-thread-rsb.rst b/Documentation/admin-guide/hw-vuln/cross-thread-rsb.rst
new file mode 100644
index 000000000000..ec6e9f5bcf9e
--- /dev/null
+++ b/Documentation/admin-guide/hw-vuln/cross-thread-rsb.rst
@@ -0,0 +1,92 @@
+
+.. SPDX-License-Identifier: GPL-2.0
+
+Cross-Thread Return Address Predictions
+=======================================
+
+Certain AMD and Hygon processors are subject to a cross-thread return address
+predictions vulnerability. When running in SMT mode and one sibling thread
+transitions out of C0 state, the other sibling thread could use return target
+predictions from the sibling thread that transitioned out of C0.
+
+The Spectre v2 mitigations protect the Linux kernel, as it fills the return
+address prediction entries with safe targets when context switching to the idle
+thread. However, KVM does allow a VMM to prevent exiting guest mode when
+transitioning out of C0. This could result in a guest-controlled return target
+being consumed by the sibling thread.
+
+Affected processors
+-------------------
+
+The following CPUs are vulnerable:
+
+    - AMD Family 17h processors
+    - Hygon Family 18h processors
+
+Related CVEs
+------------
+
+The following CVE entry is related to this issue:
+
+   ==============  =======================================
+   CVE-2022-27672  Cross-Thread Return Address Predictions
+   ==============  =======================================
+
+Problem
+-------
+
+Affected SMT-capable processors support 1T and 2T modes of execution when SMT
+is enabled. In 2T mode, both threads in a core are executing code. For the
+processor core to enter 1T mode, it is required that one of the threads
+requests to transition out of the C0 state. This can be communicated with the
+HLT instruction or with an MWAIT instruction that requests non-C0.
+When the thread re-enters the C0 state, the processor transitions back
+to 2T mode, assuming the other thread is also still in C0 state.
+
+In affected processors, the return address predictor (RAP) is partitioned
+depending on the SMT mode. For instance, in 2T mode each thread uses a private
+16-entry RAP, but in 1T mode, the active thread uses a 32-entry RAP. Upon
+transition between 1T/2T mode, the RAP contents are not modified but the RAP
+pointers (which control the next return target to use for predictions) may
+change. This behavior may result in return targets from one SMT thread being
+used by RET predictions in the sibling thread following a 1T/2T switch. In
+particular, a RET instruction executed immediately after a transition to 1T may
+use a return target from the thread that just became idle. In theory, this
+could lead to information disclosure if the return targets used do not come
+from trustworthy code.
+
+Attack scenarios
+----------------
+
+An attack can be mounted on affected processors by performing a series of CALL
+instructions with targeted return locations and then transitioning out of C0
+state.
+
+Mitigation mechanism
+--------------------
+
+Before entering idle state, the kernel context switches to the idle thread. The
+context switch fills the RAP entries (referred to as the RSB in Linux) with safe
+targets by performing a sequence of CALL instructions.
+
+Prevent a guest VM from directly putting the processor into an idle state by
+intercepting HLT and MWAIT instructions.
+
+Both mitigations are required to fully address this issue.
+
+Mitigation control on the kernel command line
+---------------------------------------------
+
+Use existing Spectre v2 mitigations that will fill the RSB on context switch.
+
+Mitigation control for KVM - module parameter
+---------------------------------------------
+
+By default, the KVM hypervisor mitigates this issue by intercepting guest
+attempts to transition out of C0. A VMM can use the KVM_CAP_X86_DISABLE_EXITS
+capability to override those interceptions, but since this is not common, the
+mitigation that covers this path is not enabled by default.
+
+The mitigation for the KVM_CAP_X86_DISABLE_EXITS capability can be turned on
+using the boolean module parameter mitigate_smt_rsb, e.g.:
+        kvm.mitigate_smt_rsb=1
diff --git a/Documentation/admin-guide/hw-vuln/index.rst b/Documentation/admin-guide/hw-vuln/index.rst
index 4df436e7c417..e0614760a99e 100644
--- a/Documentation/admin-guide/hw-vuln/index.rst
+++ b/Documentation/admin-guide/hw-vuln/index.rst
@@ -18,3 +18,4 @@ are configurable at compile, boot or run time.
    core-scheduling.rst
    l1d_flush.rst
    processor_mmio_stale_data.rst
+   cross-thread-rsb.rst
-- 
2.39.1

