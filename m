Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFC51671C8
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbgBUH5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:57:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:56722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729897AbgBUH5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:57:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F2C8206ED;
        Fri, 21 Feb 2020 07:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271832;
        bh=KtHUM5HyImmGo6KestKDTwrLLid3F9tW3NA7FWlzLew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5+HVXx4o1Gzya03F53825UQZnw4YtkZg0uZEj+rpIRQygg/4W/EXu0bJHWb3sOb0
         +0+QWAyB3/ULBX5Dtcc5KGttMSmbDNMj7uF0Fo+A2Sk0QECoNBobx3782YQOKp85iU
         YdegIWRqCzuzO4YcV8qF/Pn+PPly7C55zRdel1lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 278/399] PM / devfreq: Add debugfs support with devfreq_summary file
Date:   Fri, 21 Feb 2020 08:40:03 +0100
Message-Id: <20200221072429.075862459@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chanwoo Choi <cw00.choi@samsung.com>

[ Upstream commit 490a421bc575d1bf391a6ad5b582dcfbd0037724 ]

Add debugfs interface to provide debugging information of devfreq device.
It contains 'devfreq_summary' entry to show the summary of registered
devfreq devices as following and the additional debugfs file will be added.
- /sys/kernel/debug/devfreq/devfreq_summary

[Detailed description of each field of 'devfreq_summary' debugfs file]
- dev_name	: Device name of h/w
- dev		: Device name made by devfreq core
- parent_dev	: If devfreq device uses the passive governor,
		  show parent devfreq device name. Otherwise, show 'null'.
- governor	: Devfreq governor name
- polling_ms	: If devfreq device uses the simple_ondemand governor,
		  polling_ms is necessary for the period. (unit: millisecond)
- cur_freq_Hz	: Current frequency (unit: Hz)
- min_freq_Hz	: Minimum frequency (unit: Hz)
- max_freq_Hz	: Maximum frequency (unit: Hz)

[For example on Exynos5422-based Odroid-XU3 board]
$ cat /sys/kernel/debug/devfreq/devfreq_summary
dev_name                       dev        parent_dev governor        polling_ms  cur_freq_Hz  min_freq_Hz  max_freq_Hz
------------------------------ ---------- ---------- --------------- ---------- ------------ ------------ ------------
10c20000.memory-controller     devfreq0   null       simple_ondemand          0    165000000    165000000    825000000
soc:bus_wcore                  devfreq1   null       simple_ondemand         50    532000000     88700000    532000000
soc:bus_noc                    devfreq2   devfreq1   passive                  0    111000000     66600000    111000000
soc:bus_fsys_apb               devfreq3   devfreq1   passive                  0    222000000    111000000    222000000
soc:bus_fsys                   devfreq4   devfreq1   passive                  0    200000000     75000000    200000000
soc:bus_fsys2                  devfreq5   devfreq1   passive                  0    200000000     75000000    200000000
soc:bus_mfc                    devfreq6   devfreq1   passive                  0    333000000     83250000    333000000
soc:bus_gen                    devfreq7   devfreq1   passive                  0    266000000     88700000    266000000
soc:bus_peri                   devfreq8   devfreq1   passive                  0     66600000     66600000     66600000
soc:bus_g2d                    devfreq9   devfreq1   passive                  0    333000000     83250000    333000000
soc:bus_g2d_acp                devfreq10  devfreq1   passive                  0    266000000     66500000    266000000
soc:bus_jpeg                   devfreq11  devfreq1   passive                  0    300000000     75000000    300000000
soc:bus_jpeg_apb               devfreq12  devfreq1   passive                  0    166500000     83250000    166500000
soc:bus_disp1_fimd             devfreq13  devfreq1   passive                  0    200000000    120000000    200000000
soc:bus_disp1                  devfreq14  devfreq1   passive                  0    300000000    120000000    300000000
soc:bus_gscl_scaler            devfreq15  devfreq1   passive                  0    300000000    150000000    300000000
soc:bus_mscl                   devfreq16  devfreq1   passive                  0    666000000     84000000    666000000

[lkp: Reported the build error]
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/devfreq.c | 82 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 554d155106a5f..e99f082d15df5 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/kmod.h>
 #include <linux/sched.h>
+#include <linux/debugfs.h>
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -33,6 +34,7 @@
 #define HZ_PER_KHZ	1000
 
 static struct class *devfreq_class;
+static struct dentry *devfreq_debugfs;
 
 /*
  * devfreq core provides delayed work based load monitoring helper
@@ -1614,6 +1616,81 @@ static struct attribute *devfreq_attrs[] = {
 };
 ATTRIBUTE_GROUPS(devfreq);
 
+/**
+ * devfreq_summary_show() - Show the summary of the devfreq devices
+ * @s:		seq_file instance to show the summary of devfreq devices
+ * @data:	not used
+ *
+ * Show the summary of the devfreq devices via 'devfreq_summary' debugfs file.
+ * It helps that user can know the detailed information of the devfreq devices.
+ *
+ * Return 0 always because it shows the information without any data change.
+ */
+static int devfreq_summary_show(struct seq_file *s, void *data)
+{
+	struct devfreq *devfreq;
+	struct devfreq *p_devfreq = NULL;
+	unsigned long cur_freq, min_freq, max_freq;
+	unsigned int polling_ms;
+
+	seq_printf(s, "%-30s %-10s %-10s %-15s %10s %12s %12s %12s\n",
+			"dev_name",
+			"dev",
+			"parent_dev",
+			"governor",
+			"polling_ms",
+			"cur_freq_Hz",
+			"min_freq_Hz",
+			"max_freq_Hz");
+	seq_printf(s, "%30s %10s %10s %15s %10s %12s %12s %12s\n",
+			"------------------------------",
+			"----------",
+			"----------",
+			"---------------",
+			"----------",
+			"------------",
+			"------------",
+			"------------");
+
+	mutex_lock(&devfreq_list_lock);
+
+	list_for_each_entry_reverse(devfreq, &devfreq_list, node) {
+#if IS_ENABLED(CONFIG_DEVFREQ_GOV_PASSIVE)
+		if (!strncmp(devfreq->governor_name, DEVFREQ_GOV_PASSIVE,
+							DEVFREQ_NAME_LEN)) {
+			struct devfreq_passive_data *data = devfreq->data;
+
+			if (data)
+				p_devfreq = data->parent;
+		} else {
+			p_devfreq = NULL;
+		}
+#endif
+
+		mutex_lock(&devfreq->lock);
+		cur_freq = devfreq->previous_freq,
+		get_freq_range(devfreq, &min_freq, &max_freq);
+		polling_ms = devfreq->profile->polling_ms,
+		mutex_unlock(&devfreq->lock);
+
+		seq_printf(s,
+			"%-30s %-10s %-10s %-15s %10d %12ld %12ld %12ld\n",
+			dev_name(devfreq->dev.parent),
+			dev_name(&devfreq->dev),
+			p_devfreq ? dev_name(&p_devfreq->dev) : "null",
+			devfreq->governor_name,
+			polling_ms,
+			cur_freq,
+			min_freq,
+			max_freq);
+	}
+
+	mutex_unlock(&devfreq_list_lock);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(devfreq_summary);
+
 static int __init devfreq_init(void)
 {
 	devfreq_class = class_create(THIS_MODULE, "devfreq");
@@ -1630,6 +1707,11 @@ static int __init devfreq_init(void)
 	}
 	devfreq_class->dev_groups = devfreq_groups;
 
+	devfreq_debugfs = debugfs_create_dir("devfreq", NULL);
+	debugfs_create_file("devfreq_summary", 0444,
+				devfreq_debugfs, NULL,
+				&devfreq_summary_fops);
+
 	return 0;
 }
 subsys_initcall(devfreq_init);
-- 
2.20.1



