Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A50FD664
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfKOGYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:24:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:50068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbfKOGVV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:21:21 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB3DE207DD;
        Fri, 15 Nov 2019 06:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798879;
        bh=+lOdOz5Bsl3ojARjkt8cEhh41nUL37Xc/V1jTZ75+ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2AbL3KKu9lPiWMX5g1EHOtReSSVnFBQqHzGgixznPp9HBfSmtPYvApe6XCRi+Rrw
         +DJhQFRGSem6BnHFmZUzjmKUZciBr+WS5nfT/3NWS4e+1jrsgjhrGuXD2DyH0+dEwG
         +jp9Bb0s23FFkq04O5pTxWUVtUx0u2aZjFD7GXGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Neelima Krishnan <neelima.krishnan@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 14/20] x86/speculation/taa: Add sysfs reporting for TSX Async Abort
Date:   Fri, 15 Nov 2019 14:20:43 +0800
Message-Id: <20191115062013.019072725@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062006.854443935@linuxfoundation.org>
References: <20191115062006.854443935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 6608b45ac5ecb56f9e171252229c39580cc85f0f upstream.

Add the sysfs reporting file for TSX Async Abort. It exposes the
vulnerability and the mitigation state similar to the existing files for
the other hardware vulnerabilities.

Sysfs file path is:
/sys/devices/system/cpu/vulnerabilities/tsx_async_abort

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Neelima Krishnan <neelima.krishnan@intel.com>
Reviewed-by: Mark Gross <mgross@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   23 +++++++++++++++++++++++
 drivers/base/cpu.c         |    9 +++++++++
 include/linux/cpu.h        |    3 +++
 3 files changed, 35 insertions(+)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1300,6 +1300,21 @@ static ssize_t mds_show_state(char *buf)
 		       sched_smt_active() ? "vulnerable" : "disabled");
 }
 
+static ssize_t tsx_async_abort_show_state(char *buf)
+{
+	if ((taa_mitigation == TAA_MITIGATION_TSX_DISABLED) ||
+	    (taa_mitigation == TAA_MITIGATION_OFF))
+		return sprintf(buf, "%s\n", taa_strings[taa_mitigation]);
+
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
+		return sprintf(buf, "%s; SMT Host state unknown\n",
+			       taa_strings[taa_mitigation]);
+	}
+
+	return sprintf(buf, "%s; SMT %s\n", taa_strings[taa_mitigation],
+		       sched_smt_active() ? "vulnerable" : "disabled");
+}
+
 static char *stibp_state(void)
 {
 	if (spectre_v2_enabled == SPECTRE_V2_IBRS_ENHANCED)
@@ -1365,6 +1380,9 @@ static ssize_t cpu_show_common(struct de
 	case X86_BUG_MDS:
 		return mds_show_state(buf);
 
+	case X86_BUG_TAA:
+		return tsx_async_abort_show_state(buf);
+
 	default:
 		break;
 	}
@@ -1401,4 +1419,9 @@ ssize_t cpu_show_mds(struct device *dev,
 {
 	return cpu_show_common(dev, attr, buf, X86_BUG_MDS);
 }
+
+ssize_t cpu_show_tsx_async_abort(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return cpu_show_common(dev, attr, buf, X86_BUG_TAA);
+}
 #endif
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -536,12 +536,20 @@ ssize_t __weak cpu_show_mds(struct devic
 	return sprintf(buf, "Not affected\n");
 }
 
+ssize_t __weak cpu_show_tsx_async_abort(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	return sprintf(buf, "Not affected\n");
+}
+
 static DEVICE_ATTR(meltdown, 0444, cpu_show_meltdown, NULL);
 static DEVICE_ATTR(spectre_v1, 0444, cpu_show_spectre_v1, NULL);
 static DEVICE_ATTR(spectre_v2, 0444, cpu_show_spectre_v2, NULL);
 static DEVICE_ATTR(spec_store_bypass, 0444, cpu_show_spec_store_bypass, NULL);
 static DEVICE_ATTR(l1tf, 0444, cpu_show_l1tf, NULL);
 static DEVICE_ATTR(mds, 0444, cpu_show_mds, NULL);
+static DEVICE_ATTR(tsx_async_abort, 0444, cpu_show_tsx_async_abort, NULL);
 
 static struct attribute *cpu_root_vulnerabilities_attrs[] = {
 	&dev_attr_meltdown.attr,
@@ -550,6 +558,7 @@ static struct attribute *cpu_root_vulner
 	&dev_attr_spec_store_bypass.attr,
 	&dev_attr_l1tf.attr,
 	&dev_attr_mds.attr,
+	&dev_attr_tsx_async_abort.attr,
 	NULL
 };
 
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -52,6 +52,9 @@ extern ssize_t cpu_show_l1tf(struct devi
 			     struct device_attribute *attr, char *buf);
 extern ssize_t cpu_show_mds(struct device *dev,
 			    struct device_attribute *attr, char *buf);
+extern ssize_t cpu_show_tsx_async_abort(struct device *dev,
+					struct device_attribute *attr,
+					char *buf);
 
 extern __printf(4, 5)
 struct device *cpu_device_create(struct device *parent, void *drvdata,


