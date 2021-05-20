Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C2038A3B6
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234097AbhETJ4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234313AbhETJx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:53:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 759C261184;
        Thu, 20 May 2021 09:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503400;
        bh=9n2ISZ5wq35iHre4XxwZIhR0ApHezsCxogiSqSbLiTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZpYUuAJ1n+fE7Byo7mR+9bEZ6B3zz0WTjuymSzKTWoBmqbXXv2FlzE4bF4TirZZ9
         WN5g5zgidl9Jx5ftt1fXKFjeZr3Tv4Iy61Wxp4kDPSnhhPUtIPZdaB/ZEsGduyDWbT
         Q/QXuJw3v+iqWCGWN81fsYPpgrXorKu9+GvGBecg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 204/425] ACPI: CPPC: Replace cppc_attr with kobj_attribute
Date:   Thu, 20 May 2021 11:19:33 +0200
Message-Id: <20210520092138.118398066@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 5c6ecbb66608..1b43f8ebfabe 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -122,23 +122,15 @@ static DEFINE_PER_CPU(struct cpc_desc *, cpc_desc_ptr);
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
@@ -164,7 +156,7 @@ show_cppc_data(cppc_get_perf_ctrs, cppc_perf_fb_ctrs, reference_perf);
 show_cppc_data(cppc_get_perf_ctrs, cppc_perf_fb_ctrs, wraparound_time);
 
 static ssize_t show_feedback_ctrs(struct kobject *kobj,
-		struct attribute *attr, char *buf)
+		struct kobj_attribute *attr, char *buf)
 {
 	struct cpc_desc *cpc_ptr = to_cpc_desc(kobj);
 	struct cppc_perf_fb_ctrs fb_ctrs = {0};
-- 
2.30.2



