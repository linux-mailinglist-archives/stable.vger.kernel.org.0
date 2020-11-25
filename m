Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745AD2C4379
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731328AbgKYPiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:38:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731317AbgKYPiI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:38:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD32C221FC;
        Wed, 25 Nov 2020 15:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318687;
        bh=BLpDHJXsLbFm+jhZgDkPU4498QvMt5QF3U3XuNtEE+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1vdcbJGowDVeHGX6hvIO7ScveFxYjVU2E2pu/TYVuBDPbFVi++kMDrH9Vo3XaX+WP
         4X70emWZQ51BnPReBD6Tj8k/tcxrC89vniIHgYHjtOrIsHT7w0ATO/VvvQZCVpe0uA
         fYE0f0duA315TgUNtYmwAV8PQk0rMCo8QHOwrHs4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sami Tolvanen <samitolvanen@google.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.9 10/10] perf/x86: fix sysfs type mismatches
Date:   Wed, 25 Nov 2020 10:37:53 -0500
Message-Id: <20201125153753.810973-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153753.810973-1-sashal@kernel.org>
References: <20201125153753.810973-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit ebd19fc372e3e78bf165f230e7c084e304441c08 ]

This change switches rapl to use PMU_FORMAT_ATTR, and fixes two other
macros to use device_attribute instead of kobj_attribute to avoid
callback type mismatches that trip indirect call checking with Clang's
Control-Flow Integrity (CFI).

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lkml.kernel.org/r/20201113183126.1239404-1-samitolvanen@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/cstate.c |  6 +++---
 arch/x86/events/intel/rapl.c   | 14 +-------------
 arch/x86/events/intel/uncore.c |  4 ++--
 arch/x86/events/intel/uncore.h | 12 ++++++------
 4 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/arch/x86/events/intel/cstate.c b/arch/x86/events/intel/cstate.c
index 72d09340c24d2..88ba013d08d49 100644
--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -98,14 +98,14 @@
 MODULE_LICENSE("GPL");
 
 #define DEFINE_CSTATE_FORMAT_ATTR(_var, _name, _format)		\
-static ssize_t __cstate_##_var##_show(struct kobject *kobj,	\
-				struct kobj_attribute *attr,	\
+static ssize_t __cstate_##_var##_show(struct device *dev,	\
+				struct device_attribute *attr,	\
 				char *page)			\
 {								\
 	BUILD_BUG_ON(sizeof(_format) >= PAGE_SIZE);		\
 	return sprintf(page, _format "\n");			\
 }								\
-static struct kobj_attribute format_attr_##_var =		\
+static struct device_attribute format_attr_##_var =		\
 	__ATTR(_name, 0444, __cstate_##_var##_show, NULL)
 
 static ssize_t cstate_get_attr_cpumask(struct device *dev,
diff --git a/arch/x86/events/intel/rapl.c b/arch/x86/events/intel/rapl.c
index 4c1b7ea185415..38dae3d1391b5 100644
--- a/arch/x86/events/intel/rapl.c
+++ b/arch/x86/events/intel/rapl.c
@@ -115,18 +115,6 @@ static const char *const rapl_domain_names[NR_RAPL_DOMAINS] __initconst = {
  * any other bit is reserved
  */
 #define RAPL_EVENT_MASK	0xFFULL
-
-#define DEFINE_RAPL_FORMAT_ATTR(_var, _name, _format)		\
-static ssize_t __rapl_##_var##_show(struct kobject *kobj,	\
-				struct kobj_attribute *attr,	\
-				char *page)			\
-{								\
-	BUILD_BUG_ON(sizeof(_format) >= PAGE_SIZE);		\
-	return sprintf(page, _format "\n");			\
-}								\
-static struct kobj_attribute format_attr_##_var =		\
-	__ATTR(_name, 0444, __rapl_##_var##_show, NULL)
-
 #define RAPL_CNTR_WIDTH 32
 
 #define RAPL_EVENT_ATTR_STR(_name, v, str)					\
@@ -548,7 +536,7 @@ static struct attribute_group rapl_pmu_events_group = {
 	.attrs = NULL, /* patched at runtime */
 };
 
-DEFINE_RAPL_FORMAT_ATTR(event, event, "config:0-7");
+PMU_FORMAT_ATTR(event, "config:0-7");
 static struct attribute *rapl_formats_attr[] = {
 	&format_attr_event.attr,
 	NULL,
diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index 4f365267b12fe..9f572bf6c6216 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -90,8 +90,8 @@ struct pci2phy_map *__find_pci2phy_map(int segment)
 	return map;
 }
 
-ssize_t uncore_event_show(struct kobject *kobj,
-			  struct kobj_attribute *attr, char *buf)
+ssize_t uncore_event_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
 {
 	struct uncore_event_desc *event =
 		container_of(attr, struct uncore_event_desc, attr);
diff --git a/arch/x86/events/intel/uncore.h b/arch/x86/events/intel/uncore.h
index ad986c1e29bcc..f699783114ee3 100644
--- a/arch/x86/events/intel/uncore.h
+++ b/arch/x86/events/intel/uncore.h
@@ -124,7 +124,7 @@ struct intel_uncore_box {
 #define UNCORE_BOX_FLAG_CTL_OFFS8	1 /* event config registers are 8-byte apart */
 
 struct uncore_event_desc {
-	struct kobj_attribute attr;
+	struct device_attribute attr;
 	const char *config;
 };
 
@@ -136,8 +136,8 @@ struct pci2phy_map {
 
 struct pci2phy_map *__find_pci2phy_map(int segment);
 
-ssize_t uncore_event_show(struct kobject *kobj,
-			  struct kobj_attribute *attr, char *buf);
+ssize_t uncore_event_show(struct device *dev,
+			  struct device_attribute *attr, char *buf);
 
 #define INTEL_UNCORE_EVENT_DESC(_name, _config)			\
 {								\
@@ -146,14 +146,14 @@ ssize_t uncore_event_show(struct kobject *kobj,
 }
 
 #define DEFINE_UNCORE_FORMAT_ATTR(_var, _name, _format)			\
-static ssize_t __uncore_##_var##_show(struct kobject *kobj,		\
-				struct kobj_attribute *attr,		\
+static ssize_t __uncore_##_var##_show(struct device *dev,		\
+				struct device_attribute *attr,		\
 				char *page)				\
 {									\
 	BUILD_BUG_ON(sizeof(_format) >= PAGE_SIZE);			\
 	return sprintf(page, _format "\n");				\
 }									\
-static struct kobj_attribute format_attr_##_var =			\
+static struct device_attribute format_attr_##_var =			\
 	__ATTR(_name, 0444, __uncore_##_var##_show, NULL)
 
 static inline unsigned uncore_pci_box_ctl(struct intel_uncore_box *box)
-- 
2.27.0

