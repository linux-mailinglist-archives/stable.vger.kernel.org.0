Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29AED111ED0
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729834AbfLCWvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:51:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729829AbfLCWvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:51:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05ABF2054F;
        Tue,  3 Dec 2019 22:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413465;
        bh=jbC6ZhBxthZDxgG7DkeDeiHxtbSvJq26q5IiyQFNSwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lus3WQy6Pfrr+DL/VwSxegBxAwgevSkjB6tKiFgGwJBj0dd6ZUodW5xOUd2gentiz
         LhAKeIwZmtlEQcfDs8EdjxxI+FR2dDHOBMSq0elyq9As46X04mUNdd+LJViLvz8w7h
         gNtjQK5m3av33xNQB6GR7AqAYNrALjx4ahXwKGYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Mueller <mimu@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 139/321] KVM: s390: unregister debug feature on failing arch init
Date:   Tue,  3 Dec 2019 23:33:25 +0100
Message-Id: <20191203223434.392479435@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3c317bc6b7997..db3196aebaa1c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -416,19 +416,30 @@ static void kvm_s390_cpu_feat_init(void)
 
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
 
 	kvm_s390_cpu_feat_init();
 
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



