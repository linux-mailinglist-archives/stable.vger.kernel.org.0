Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF962FC94B
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731689AbhATC3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:29:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:47420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730003AbhATB2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:28:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D81AE2333B;
        Wed, 20 Jan 2021 01:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105995;
        bh=sJhGEme1dz39LpSWoym7b5fWuUSGevs/wVnlhT0c6HE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mGQbE9eT+fbHSkrZwwq5IO2W3H/FeRVKvijaKLY7j7Ov67RFYWl6M3IkugULiaZxw
         pXmhwJ5whdwp5a4LLxs5UFv09iJeQw/2iD97WGK/I/aAu2Z9B2S+56SMWoEpdsQnTe
         lUNxwRKXzTSDGA79JFt+oF1Xt6APzTpONsZuy1N/aSWn8NaxgYI+MJ24OMv8HzAzT3
         zrDO/YIpCb3IO9WQb64IEHtOhUp3zp9hclyxDELXZrw0W7ElHRYAA8zL6Jcbgwqs9q
         J1CZV9occKup+9982ekd7/pBeLOdHNzT0Z0bu1nu5LMfXt5LTloWNm+vXVtLl/itVi
         Q7wUkNS151mTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Woodhouse <dwmw@amazon.co.uk>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-doc@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.10 25/45] x86/xen: Add xen_no_vector_callback option to test PCI INTX delivery
Date:   Tue, 19 Jan 2021 20:25:42 -0500
Message-Id: <20210120012602.769683-25-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index f6a1513dfb76c..26bfe7ae711b8 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5965,6 +5965,10 @@
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
index 9e87ab010c82b..ec50b7423a4c8 100644
--- a/arch/x86/xen/enlighten_hvm.c
+++ b/arch/x86/xen/enlighten_hvm.c
@@ -188,6 +188,8 @@ static int xen_cpu_dead_hvm(unsigned int cpu)
        return 0;
 }
 
+static bool no_vector_callback __initdata;
+
 static void __init xen_hvm_guest_init(void)
 {
 	if (xen_pv_domain())
@@ -207,7 +209,7 @@ static void __init xen_hvm_guest_init(void)
 
 	xen_panic_handler_init();
 
-	if (xen_feature(XENFEAT_hvm_callback_vector))
+	if (!no_vector_callback && xen_feature(XENFEAT_hvm_callback_vector))
 		xen_have_vector_callback = 1;
 
 	xen_hvm_smp_init();
@@ -233,6 +235,13 @@ static __init int xen_parse_nopv(char *arg)
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

