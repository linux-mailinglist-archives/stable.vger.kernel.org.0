Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393A52C9D0E
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389678AbgLAJKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:10:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389674AbgLAJKV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:10:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F46620671;
        Tue,  1 Dec 2020 09:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813805;
        bh=PpkHv6MRdo5REGwV+VLtx5I33j0C6wB/LT0a8qVxCOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwktQ557wgkAZq81CMxXnpNyWGdhwMzmNtG4V/qr/9lxKueWa8qmYUc5vrXclsQw/
         7koNlg5x5Rf8NWyo86iTyXug1GPqUNcDCJwSV3TFv9h1ZfO55Ed1xnqAOR9lTUOblD
         ME3bdvUjXiBHQJ3ynRIBFLzbr5oryLpkVj8Qk/wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 065/152] perf/x86: fix sysfs type mismatches
Date:   Tue,  1 Dec 2020 09:53:00 +0100
Message-Id: <20201201084720.448036043@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 arch/x86/events/intel/uncore.c |  4 ++--
 arch/x86/events/intel/uncore.h | 12 ++++++------
 arch/x86/events/rapl.c         | 14 +-------------
 4 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/arch/x86/events/intel/cstate.c b/arch/x86/events/intel/cstate.c
index 442e1ed4acd49..4eb7ee5fed72d 100644
--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -107,14 +107,14 @@
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
diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index d5c6d3b340c50..803601baa753d 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -92,8 +92,8 @@ end:
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
index 105fdc69825eb..c5744783e05d0 100644
--- a/arch/x86/events/intel/uncore.h
+++ b/arch/x86/events/intel/uncore.h
@@ -157,7 +157,7 @@ struct intel_uncore_box {
 #define UNCORE_BOX_FLAG_CFL8_CBOX_MSR_OFFS	2
 
 struct uncore_event_desc {
-	struct kobj_attribute attr;
+	struct device_attribute attr;
 	const char *config;
 };
 
@@ -179,8 +179,8 @@ struct pci2phy_map {
 struct pci2phy_map *__find_pci2phy_map(int segment);
 int uncore_pcibus_to_physid(struct pci_bus *bus);
 
-ssize_t uncore_event_show(struct kobject *kobj,
-			  struct kobj_attribute *attr, char *buf);
+ssize_t uncore_event_show(struct device *dev,
+			  struct device_attribute *attr, char *buf);
 
 static inline struct intel_uncore_pmu *dev_to_uncore_pmu(struct device *dev)
 {
@@ -201,14 +201,14 @@ extern int __uncore_max_dies;
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
 
 static inline bool uncore_pmc_fixed(int idx)
diff --git a/arch/x86/events/rapl.c b/arch/x86/events/rapl.c
index 67b411f7e8c41..abaed36212250 100644
--- a/arch/x86/events/rapl.c
+++ b/arch/x86/events/rapl.c
@@ -93,18 +93,6 @@ static const char *const rapl_domain_names[NR_RAPL_DOMAINS] __initconst = {
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
@@ -441,7 +429,7 @@ static struct attribute_group rapl_pmu_events_group = {
 	.attrs = attrs_empty,
 };
 
-DEFINE_RAPL_FORMAT_ATTR(event, event, "config:0-7");
+PMU_FORMAT_ATTR(event, "config:0-7");
 static struct attribute *rapl_formats_attr[] = {
 	&format_attr_event.attr,
 	NULL,
-- 
2.27.0



