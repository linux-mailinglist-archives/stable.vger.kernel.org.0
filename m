Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1555F6D072D
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 15:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjC3NoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 09:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbjC3NoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 09:44:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719B3B457
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 06:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680183766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dMBYYLyfgZhPJMlJlU0M/wdSvmkWIhoOy3DzMIOwJ1w=;
        b=C1VPAjMjXF/HhCoVTs7HsJYyZGLcPXSw9JZ4OZq+BpPqso4hidG21KUcdrvIpuLMhk34bY
        r9CelShyq3X82j3+6vgUM2nVdPQnEIRXVB+p5o2ChqLMcTYgBP9dE0xL9wfFnq+OvdR1pk
        Dd0/fqkrrJMqzwmHjOy/7lNO80bl534=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-phDZn31VM7WEPRnFnizwEw-1; Thu, 30 Mar 2023 09:42:41 -0400
X-MC-Unique: phDZn31VM7WEPRnFnizwEw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A67C58028B3;
        Thu, 30 Mar 2023 13:42:40 +0000 (UTC)
Received: from dba62.ml3.eng.bos.redhat.com (dba62.ml3.eng.bos.redhat.com [10.19.176.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 508EE18EC6;
        Thu, 30 Mar 2023 13:42:40 +0000 (UTC)
From:   David Arcari <darcari@redhat.com>
To:     linux-pm@vger.kernel.org
Cc:     David Arcari <darcari@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Chen Yu <yu.c.chen@intel.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] thermal: intel: powerclamp: Fix cpumask and max_idle module parameters
Date:   Thu, 30 Mar 2023 09:42:18 -0400
Message-Id: <20230330134218.1897786-1-darcari@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When cpumask is specified as a module parameter the value is
overwritten by the module init routine.  This can easily be fixed
by checking to see if the mask has already been allocated in the
init routine.

When max_idle is specified as a module parameter a panic will occur.
The problem is that the idle_injection_cpu_mask is not allocated until
the module init routine executes. This can easily be fixed by allocating
the cpumask if it's not already allocated.

Fixes: ebf519710218 ("thermal: intel: powerclamp: Add two module parameters")

Signed-off-by: David Arcari <darcari@redhat.com>

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Amit Kucheria <amitk@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: David Arcari <darcari@redhat.com>
Cc: Chen Yu <yu.c.chen@intel.com>
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org

---
 drivers/thermal/intel/intel_powerclamp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/intel_powerclamp.c b/drivers/thermal/intel/intel_powerclamp.c
index c7ba5680cd48..91fc7e239497 100644
--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -235,6 +235,12 @@ static int max_idle_set(const char *arg, const struct kernel_param *kp)
 		goto skip_limit_set;
 	}
 
+	if (!cpumask_available(idle_injection_cpu_mask)) {
+		ret = allocate_copy_idle_injection_mask(cpu_present_mask);
+		if (ret)
+			goto skip_limit_set;
+	}
+
 	if (check_invalid(idle_injection_cpu_mask, new_max_idle)) {
 		ret = -EINVAL;
 		goto skip_limit_set;
@@ -791,7 +797,8 @@ static int __init powerclamp_init(void)
 		return retval;
 
 	mutex_lock(&powerclamp_lock);
-	retval = allocate_copy_idle_injection_mask(cpu_present_mask);
+	if (!cpumask_available(idle_injection_cpu_mask))
+		retval = allocate_copy_idle_injection_mask(cpu_present_mask);
 	mutex_unlock(&powerclamp_lock);
 
 	if (retval)
-- 
2.27.0

