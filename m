Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A7B6B47B3
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbjCJOxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbjCJOxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:53:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03CC125AD1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:49:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2959E60F55
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00234C4339B;
        Fri, 10 Mar 2023 14:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459726;
        bh=vRgMfeOexHw5neJBidKdK3+m3QFD2NsjH94XdW0v5g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2nBvasPxmQvQ227CEjMtCvCVNI0/tb9ognWCb5hFbYhDo8YvTO/JulV5TjuZgkSVT
         SFcK4lTaJ9Z17EQewHWmShRAacWWb4ldgEfHJVKxpEH/P3YlOtijkrcf8sIDKwgrvd
         bfpnjR5Ip9WOCv8DBy7Yaaw4zEbVB/6q2mo1GFkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/529] x86/microcode: Replace deprecated CPU-hotplug functions.
Date:   Fri, 10 Mar 2023 14:34:03 +0100
Message-Id: <20230310133809.602269171@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 2089f34f8c5b91f7235023ec72e71e3247261ecc ]

The functions get_online_cpus() and put_online_cpus() have been
deprecated during the CPU hotplug rework. They map directly to
cpus_read_lock() and cpus_read_unlock().

Replace deprecated CPU-hotplug functions with the official version.
The behavior remains unchanged.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20210803141621.780504-9-bigeasy@linutronix.de
Stable-dep-of: c0dd9245aa9e ("x86/microcode: Check CPU capabilities after late microcode update correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/core.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 0b1732b98e719..38a58819c1b9b 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -55,7 +55,7 @@ LIST_HEAD(microcode_cache);
  * All non cpu-hotplug-callback call sites use:
  *
  * - microcode_mutex to synchronize with each other;
- * - get/put_online_cpus() to synchronize with
+ * - cpus_read_lock/unlock() to synchronize with
  *   the cpu-hotplug-callback call sites.
  *
  * We guarantee that only a single cpu is being
@@ -431,7 +431,7 @@ static ssize_t microcode_write(struct file *file, const char __user *buf,
 		return ret;
 	}
 
-	get_online_cpus();
+	cpus_read_lock();
 	mutex_lock(&microcode_mutex);
 
 	if (do_microcode_update(buf, len) == 0)
@@ -441,7 +441,7 @@ static ssize_t microcode_write(struct file *file, const char __user *buf,
 		perf_check_microcode();
 
 	mutex_unlock(&microcode_mutex);
-	put_online_cpus();
+	cpus_read_unlock();
 
 	return ret;
 }
@@ -629,7 +629,7 @@ static ssize_t reload_store(struct device *dev,
 	if (val != 1)
 		return size;
 
-	get_online_cpus();
+	cpus_read_lock();
 
 	ret = check_online_cpus();
 	if (ret)
@@ -644,7 +644,7 @@ static ssize_t reload_store(struct device *dev,
 	mutex_unlock(&microcode_mutex);
 
 put:
-	put_online_cpus();
+	cpus_read_unlock();
 
 	if (ret == 0)
 		ret = size;
@@ -853,14 +853,14 @@ int __init microcode_init(void)
 	if (IS_ERR(microcode_pdev))
 		return PTR_ERR(microcode_pdev);
 
-	get_online_cpus();
+	cpus_read_lock();
 	mutex_lock(&microcode_mutex);
 
 	error = subsys_interface_register(&mc_cpu_interface);
 	if (!error)
 		perf_check_microcode();
 	mutex_unlock(&microcode_mutex);
-	put_online_cpus();
+	cpus_read_unlock();
 
 	if (error)
 		goto out_pdev;
@@ -892,13 +892,13 @@ int __init microcode_init(void)
 			   &cpu_root_microcode_group);
 
  out_driver:
-	get_online_cpus();
+	cpus_read_lock();
 	mutex_lock(&microcode_mutex);
 
 	subsys_interface_unregister(&mc_cpu_interface);
 
 	mutex_unlock(&microcode_mutex);
-	put_online_cpus();
+	cpus_read_unlock();
 
  out_pdev:
 	platform_device_unregister(microcode_pdev);
-- 
2.39.2



