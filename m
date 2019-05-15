Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 333131F37D
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbfEOLDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727406AbfEOLDY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:03:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92DF320644;
        Wed, 15 May 2019 11:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918203;
        bh=u/K2cW4Q9SEf0uYS4B2Rx2sSgoiByXOMmPvBjsJHEyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvyJdGkP/ROQFIRL2WsYtd59+FAvysuF8CsfuLt7IiqmcHI/g1J+DWuw00P0VrfDP
         2+5+AArLhPqFFjAF5ay8tF0iXXFpHzkysWndKbeMgxZByzkXkxoNk91qFT2q6CWQlp
         aWGsrVdFBZWKB6koAjvyZtsiKqvn3y1fT7ihzxUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.4 044/266] powerpc64s: Show ori31 availability in spectre_v1 sysfs file not v2
Date:   Wed, 15 May 2019 12:52:31 +0200
Message-Id: <20190515090723.963137613@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 6d44acae1937b81cf8115ada8958e04f601f3f2e upstream.

When I added the spectre_v2 information in sysfs, I included the
availability of the ori31 speculation barrier.

Although the ori31 barrier can be used to mitigate v2, it's primarily
intended as a spectre v1 mitigation. Spectre v2 is mitigated by
hardware changes.

So rework the sysfs files to show the ori31 information in the
spectre_v1 file, rather than v2.

Currently we display eg:

  $ grep . spectre_v*
  spectre_v1:Mitigation: __user pointer sanitization
  spectre_v2:Mitigation: Indirect branch cache disabled, ori31 speculation barrier enabled

After:

  $ grep . spectre_v*
  spectre_v1:Mitigation: __user pointer sanitization, ori31 speculation barrier enabled
  spectre_v2:Mitigation: Indirect branch cache disabled

Fixes: d6fbe1c55c55 ("powerpc/64s: Wire up cpu_show_spectre_v2()")
Cc: stable@vger.kernel.org # v4.17+
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/security.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -118,25 +118,35 @@ ssize_t cpu_show_meltdown(struct device
 
 ssize_t cpu_show_spectre_v1(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	if (!security_ftr_enabled(SEC_FTR_BNDS_CHK_SPEC_BAR))
-		return sprintf(buf, "Not affected\n");
+	struct seq_buf s;
+
+	seq_buf_init(&s, buf, PAGE_SIZE - 1);
+
+	if (security_ftr_enabled(SEC_FTR_BNDS_CHK_SPEC_BAR)) {
+		if (barrier_nospec_enabled)
+			seq_buf_printf(&s, "Mitigation: __user pointer sanitization");
+		else
+			seq_buf_printf(&s, "Vulnerable");
 
-	if (barrier_nospec_enabled)
-		return sprintf(buf, "Mitigation: __user pointer sanitization\n");
+		if (security_ftr_enabled(SEC_FTR_SPEC_BAR_ORI31))
+			seq_buf_printf(&s, ", ori31 speculation barrier enabled");
 
-	return sprintf(buf, "Vulnerable\n");
+		seq_buf_printf(&s, "\n");
+	} else
+		seq_buf_printf(&s, "Not affected\n");
+
+	return s.len;
 }
 
 ssize_t cpu_show_spectre_v2(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	bool bcs, ccd, ori;
 	struct seq_buf s;
+	bool bcs, ccd;
 
 	seq_buf_init(&s, buf, PAGE_SIZE - 1);
 
 	bcs = security_ftr_enabled(SEC_FTR_BCCTRL_SERIALISED);
 	ccd = security_ftr_enabled(SEC_FTR_COUNT_CACHE_DISABLED);
-	ori = security_ftr_enabled(SEC_FTR_SPEC_BAR_ORI31);
 
 	if (bcs || ccd) {
 		seq_buf_printf(&s, "Mitigation: ");
@@ -152,9 +162,6 @@ ssize_t cpu_show_spectre_v2(struct devic
 	} else
 		seq_buf_printf(&s, "Vulnerable");
 
-	if (ori)
-		seq_buf_printf(&s, ", ori31 speculation barrier enabled");
-
 	seq_buf_printf(&s, "\n");
 
 	return s.len;


