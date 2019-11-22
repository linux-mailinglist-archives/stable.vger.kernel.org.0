Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8214C10646D
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbfKVGN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:13:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:50686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729316AbfKVGN2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:13:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D01B620708;
        Fri, 22 Nov 2019 06:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403207;
        bh=u/ht6PC8dTaXSeedqZtbu1SzlGDMXer7QYkbRsHtsc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMxybB1Eq+E9auJUqUF8i/9SEBn61IF6rqiKGG71rpwlBbMfCXPsfrxUOEAibhGFN
         hqYokCuYVbHra9FHkUN/B3jnCanQE9Jv+nPBZVR3v8ldPfK3a5m3fffZxmyxL88n8/
         UeougtOFK3piCzphZS8GOE36dtz3jzbI11EFXwJM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Mueller <mimu@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 23/68] KVM: s390: unregister debug feature on failing arch init
Date:   Fri, 22 Nov 2019 01:12:16 -0500
Message-Id: <20191122061301.4947-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Mueller <mimu@linux.ibm.com>

[ Upstream commit 308c3e6673b012beecb96ef04cc65f4a0e7cdd99 ]

Make sure the debug feature and its allocated resources get
released upon unsuccessful architecture initialization.

A related indication of the issue will be reported as kernel
message.

Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Message-Id: <20181130143215.69496-2-mimu@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 3e46f62d32adf..b4032d625d225 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -185,17 +185,28 @@ void kvm_arch_hardware_unsetup(void)
 
 int kvm_arch_init(void *opaque)
 {
+	int rc;
+
 	kvm_s390_dbf = debug_register("kvm-trace", 32, 1, 7 * sizeof(long));
 	if (!kvm_s390_dbf)
 		return -ENOMEM;
 
 	if (debug_register_view(kvm_s390_dbf, &debug_sprintf_view)) {
-		debug_unregister(kvm_s390_dbf);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto out_debug_unreg;
 	}
 
 	/* Register floating interrupt controller interface. */
-	return kvm_register_device_ops(&kvm_flic_ops, KVM_DEV_TYPE_FLIC);
+	rc = kvm_register_device_ops(&kvm_flic_ops, KVM_DEV_TYPE_FLIC);
+	if (rc) {
+		pr_err("Failed to register FLIC rc=%d\n", rc);
+		goto out_debug_unreg;
+	}
+	return 0;
+
+out_debug_unreg:
+	debug_unregister(kvm_s390_dbf);
+	return rc;
 }
 
 void kvm_arch_exit(void)
-- 
2.20.1

