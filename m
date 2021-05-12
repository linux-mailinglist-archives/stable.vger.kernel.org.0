Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AAA37CC77
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239616AbhELQpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:45:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243171AbhELQgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:36:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFA9661E12;
        Wed, 12 May 2021 16:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835282;
        bh=I3c+uGYzLLtbfqC7O1A6ku2DcbVzkVaaeoeOhbnidSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNDBiEH6fVEvFCm9YsCW5FCHphZn72uofs3bQoDhDaUiHzOc8n9kvkuabJ0kyBQh2
         zLUwFoYiPV3tJbl/Mgkwx6l1/PxJ3cUlCZP93ZDvs8OR4JiYfnNjMHw5CzSl4mhArh
         trJDNRjAFsg82nsFxVEgI2m8s6FerueuMxJoZzJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 281/677] ACPI: CPPC: Replace cppc_attr with kobj_attribute
Date:   Wed, 12 May 2021 16:45:27 +0200
Message-Id: <20210512144846.553252725@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 2bc6262c6117dd18106d5aa50d53e945b5d99c51 ]

All of the CPPC sysfs show functions are called via indirect call in
kobj_attr_show(), where they should be of type

ssize_t (*show)(struct kobject *kobj, struct kobj_attribute *attr, char *buf);

because that is the type of the ->show() member in
'struct kobj_attribute' but they are actually of type

ssize_t (*show)(struct kobject *kobj, struct attribute *attr, char *buf);

because of the ->show() member in 'struct cppc_attr', resulting in a
Control Flow Integrity violation [1].

$ cat /sys/devices/system/cpu/cpu0/acpi_cppc/highest_perf
3400

$ dmesg | grep "CFI failure"
[  175.970559] CFI failure (target: show_highest_perf+0x0/0x8):

As far as I can tell, the only difference between 'struct cppc_attr'
and 'struct kobj_attribute' aside from the type of the attr parameter
is the type of the count parameter in the ->store() member (ssize_t vs.
size_t), which does not actually matter because all of these nodes are
read-only.

Eliminate 'struct cppc_attr' in favor of 'struct kobj_attribute' to fix
the violation.

[1]: https://lore.kernel.org/r/20210401233216.2540591-1-samitolvanen@google.com/

Fixes: 158c998ea44b ("ACPI / CPPC: add sysfs support to compute delivered performance")
Link: https://github.com/ClangBuiltLinux/linux/issues/1343
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 69057fcd2c04..a5e6fd0bafa1 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -119,23 +119,15 @@ static DEFINE_PER_CPU(struct cpc_desc *, cpc_desc_ptr);
  */
 #define NUM_RETRIES 500ULL
 
-struct cppc_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct kobject *kobj,
-			struct attribute *attr, char *buf);
-	ssize_t (*store)(struct kobject *kobj,
-			struct attribute *attr, const char *c, ssize_t count);
-};
-
 #define define_one_cppc_ro(_name)		\
-static struct cppc_attr _name =			\
+static struct kobj_attribute _name =		\
 __ATTR(_name, 0444, show_##_name, NULL)
 
 #define to_cpc_desc(a) container_of(a, struct cpc_desc, kobj)
 
 #define show_cppc_data(access_fn, struct_name, member_name)		\
 	static ssize_t show_##member_name(struct kobject *kobj,		\
-					struct attribute *attr,	char *buf) \
+				struct kobj_attribute *attr, char *buf)	\
 	{								\
 		struct cpc_desc *cpc_ptr = to_cpc_desc(kobj);		\
 		struct struct_name st_name = {0};			\
@@ -161,7 +153,7 @@ show_cppc_data(cppc_get_perf_ctrs, cppc_perf_fb_ctrs, reference_perf);
 show_cppc_data(cppc_get_perf_ctrs, cppc_perf_fb_ctrs, wraparound_time);
 
 static ssize_t show_feedback_ctrs(struct kobject *kobj,
-		struct attribute *attr, char *buf)
+		struct kobj_attribute *attr, char *buf)
 {
 	struct cpc_desc *cpc_ptr = to_cpc_desc(kobj);
 	struct cppc_perf_fb_ctrs fb_ctrs = {0};
-- 
2.30.2



