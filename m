Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188A43031C4
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbhAYSpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:45:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729398AbhAYSoz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:44:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59BE92063A;
        Mon, 25 Jan 2021 18:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600254;
        bh=RXasSzsPwlyqWugfoG3XkngjRibGw7leLfBysKrf8B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qgM/wM2kTXznLLKqWgvXrz/6SMmahYxRe0NacICHbirhpVPToTAx8VLZdYoEWeYyy
         /CL+BGbfRMDFEHH5zPre3O0ow1JRq22TpbhhfksswsjJFQZ7e4LxUw5Z8vsIViZY4D
         6y0x5fERek4SJHFc75wTNLtXENszetqcIS98KSe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 31/86] x86/xen: Add xen_no_vector_callback option to test PCI INTX delivery
Date:   Mon, 25 Jan 2021 19:39:13 +0100
Message-Id: <20210125183202.377899895@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

[ Upstream commit b36b0fe96af13460278bf9b173beced1bd15f85d ]

It's useful to be able to test non-vector event channel delivery, to make
sure Linux will work properly on older Xen which doesn't have it.

It's also useful for those working on Xen and Xen-compatible hypervisors,
because there are guest kernels still in active use which use PCI INTX
even when vector delivery is available.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20210106153958.584169-4-dwmw2@infradead.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  4 ++++
 arch/x86/xen/enlighten_hvm.c                    | 11 ++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 74ba077e99e56..a19ae163c0589 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5452,6 +5452,10 @@
 			This option is obsoleted by the "nopv" option, which
 			has equivalent effect for XEN platform.
 
+	xen_no_vector_callback
+			[KNL,X86,XEN] Disable the vector callback for Xen
+			event channel interrupts.
+
 	xen_scrub_pages=	[XEN]
 			Boolean option to control scrubbing pages before giving them back
 			to Xen, for use by other domains. Can be also changed at runtime
diff --git a/arch/x86/xen/enlighten_hvm.c b/arch/x86/xen/enlighten_hvm.c
index e138f7de52d20..6024fafed1642 100644
--- a/arch/x86/xen/enlighten_hvm.c
+++ b/arch/x86/xen/enlighten_hvm.c
@@ -175,6 +175,8 @@ static int xen_cpu_dead_hvm(unsigned int cpu)
        return 0;
 }
 
+static bool no_vector_callback __initdata;
+
 static void __init xen_hvm_guest_init(void)
 {
 	if (xen_pv_domain())
@@ -194,7 +196,7 @@ static void __init xen_hvm_guest_init(void)
 
 	xen_panic_handler_init();
 
-	if (xen_feature(XENFEAT_hvm_callback_vector))
+	if (!no_vector_callback && xen_feature(XENFEAT_hvm_callback_vector))
 		xen_have_vector_callback = 1;
 
 	xen_hvm_smp_init();
@@ -220,6 +222,13 @@ static __init int xen_parse_nopv(char *arg)
 }
 early_param("xen_nopv", xen_parse_nopv);
 
+static __init int xen_parse_no_vector_callback(char *arg)
+{
+	no_vector_callback = true;
+	return 0;
+}
+early_param("xen_no_vector_callback", xen_parse_no_vector_callback);
+
 bool __init xen_hvm_need_lapic(void)
 {
 	if (xen_pv_domain())
-- 
2.27.0



