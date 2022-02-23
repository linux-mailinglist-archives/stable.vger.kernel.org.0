Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309A14C1203
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 12:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbiBWL5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 06:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbiBWL5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 06:57:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E05BD48E6A
        for <stable@vger.kernel.org>; Wed, 23 Feb 2022 03:57:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645617424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FrHNPEyG6nsY8vSxBc+AukKgMz3uheQuxIiQLdF9C+U=;
        b=frKnHDmCtgAXuPkGtX3JvsyY/lIbTO36dPtssQ3o9PWf8VFk8apQZpeymZf0HBgn0DqfTd
        288NnBqlWpu6IqHcPscXnSYl+ZXmCV3f3OPBNVByRIeXGQuXqVK1FzWOXEVHMUIk6jHbuw
        nka/kzI02yZdHAFhYUOqrFMWMBimNxg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-8g0W7KG7MVeaeL96ezgi0g-1; Wed, 23 Feb 2022 06:57:02 -0500
X-MC-Unique: 8g0W7KG7MVeaeL96ezgi0g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBCBD1006AA6;
        Wed, 23 Feb 2022 11:57:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 934C884948;
        Wed, 23 Feb 2022 11:56:50 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] KVM: x86: nSVM: disallow userspace setting of MSR_AMD64_TSC_RATIO to non default value when tsc scaling disabled
Date:   Wed, 23 Feb 2022 13:56:49 +0200
Message-Id: <20220223115649.319134-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If nested tsc scaling is disabled, MSR_AMD64_TSC_RATIO should
never have non default value.

Due to way nested tsc scaling support was implmented in qemu,
it would set this msr to 0 when nested tsc scaling was disabled.
Ignore that value for now, as it causes no harm.


Fixes: 5228eb96a487 ("KVM: x86: nSVM: implement nested TSC scaling")
Cc: stable@vger.kernel.org

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7038c76fa841..b80ad471776f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2705,8 +2705,23 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	u64 data = msr->data;
 	switch (ecx) {
 	case MSR_AMD64_TSC_RATIO:
-		if (!msr->host_initiated && !svm->tsc_scaling_enabled)
-			return 1;
+
+		if (!svm->tsc_scaling_enabled) {
+
+			if (!msr->host_initiated)
+				return 1;
+			/*
+			 * In case TSC scaling is not enabled, always
+			 * leave this MSR at the default value.
+			 *
+			 * Due to bug in qemu 6.2.0, it would try to set
+			 * this msr to 0 if tsc scaling is not enabled.
+			 * Ignore this value as well.
+			 */
+			if (data != 0 && data != svm->tsc_ratio_msr)
+				return 1;
+			break;
+		}
 
 		if (data & TSC_RATIO_RSVD)
 			return 1;
-- 
2.26.3

