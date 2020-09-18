Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762A226EF73
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgIRCNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:13:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728131AbgIRCNB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:13:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 239CD23787;
        Fri, 18 Sep 2020 02:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395180;
        bh=Pz1lgifjrH0HIFF3P5340FkHxRykTB4RBRQcn/nL0i8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQrcYS+OX+dxddjzYeYomPKCcnxbm2yDWSOkJlT14KbwsoSNFVy2L9bjezls8cneN
         IZBoArW8FkNSsgwDBJfugiT0KDLAF0IshImCZIBaLNsTkg+deu4A3EZLDFsCFPGvj/
         ksBVcNXgS/PRmdVCg1foSEPZPtv6hMiDH5++d4dI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Doug Smythies <doug.smythies@gmail.com>,
        Doug Smythies <dsmythies@telus.net>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 036/127] tools/power/x86/intel_pstate_tracer: changes for python 3 compatibility
Date:   Thu, 17 Sep 2020 22:10:49 -0400
Message-Id: <20200918021220.2066485-36-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Smythies <doug.smythies@gmail.com>

[ Upstream commit e749e09db30c38f1a275945814b0109e530a07b0 ]

Some syntax needs to be more rigorous for python 3.
Backwards compatibility tested with python 2.7

Signed-off-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel_pstate_tracer.py                    | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/power/x86/intel_pstate_tracer/intel_pstate_tracer.py b/tools/power/x86/intel_pstate_tracer/intel_pstate_tracer.py
index 0b24dd9d01ff2..98c9f2df8aa71 100755
--- a/tools/power/x86/intel_pstate_tracer/intel_pstate_tracer.py
+++ b/tools/power/x86/intel_pstate_tracer/intel_pstate_tracer.py
@@ -10,11 +10,11 @@ then this utility enables and collects trace data for a user specified interval
 and generates performance plots.
 
 Prerequisites:
-    Python version 2.7.x
+    Python version 2.7.x or higher
     gnuplot 5.0 or higher
-    gnuplot-py 1.8
+    gnuplot-py 1.8 or higher
     (Most of the distributions have these required packages. They may be called
-     gnuplot-py, phython-gnuplot. )
+     gnuplot-py, phython-gnuplot or phython3-gnuplot, gnuplot-nox, ... )
 
     HWP (Hardware P-States are disabled)
     Kernel config for Linux trace is enabled
@@ -178,7 +178,7 @@ def plot_pstate_cpu_with_sample():
         g_plot('set xlabel "Samples"')
         g_plot('set ylabel "P-State"')
         g_plot('set title "{} : cpu pstate vs. sample : {:%F %H:%M}"'.format(testname, datetime.now()))
-        title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).replace('\n', ' ')
+        title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).decode('utf-8').replace('\n', ' ')
         plot_str = "plot for [i in title_list] i.'.csv' using {:d}:{:d} pt 7 ps 1 title i".format(C_SAMPLE, C_TO)
         g_plot('title_list = "{}"'.format(title_list))
         g_plot(plot_str)
@@ -195,7 +195,7 @@ def plot_pstate_cpu():
 #    the following command is really cool, but doesn't work with the CPU masking option because it aborts on the first missing file.
 #    plot_str = 'plot for [i=0:*] file=sprintf("cpu%03d.csv",i) title_s=sprintf("cpu%03d",i) file using 16:7 pt 7 ps 1 title title_s'
 #
-    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).replace('\n', ' ')
+    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).decode('utf-8').replace('\n', ' ')
     plot_str = "plot for [i in title_list] i.'.csv' using {:d}:{:d} pt 7 ps 1 title i".format(C_ELAPSED, C_TO)
     g_plot('title_list = "{}"'.format(title_list))
     g_plot(plot_str)
@@ -209,7 +209,7 @@ def plot_load_cpu():
     g_plot('set ylabel "CPU load (percent)"')
     g_plot('set title "{} : cpu loads : {:%F %H:%M}"'.format(testname, datetime.now()))
 
-    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).replace('\n', ' ')
+    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).decode('utf-8').replace('\n', ' ')
     plot_str = "plot for [i in title_list] i.'.csv' using {:d}:{:d} pt 7 ps 1 title i".format(C_ELAPSED, C_LOAD)
     g_plot('title_list = "{}"'.format(title_list))
     g_plot(plot_str)
@@ -223,7 +223,7 @@ def plot_frequency_cpu():
     g_plot('set ylabel "CPU Frequency (GHz)"')
     g_plot('set title "{} : cpu frequencies : {:%F %H:%M}"'.format(testname, datetime.now()))
 
-    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).replace('\n', ' ')
+    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).decode('utf-8').replace('\n', ' ')
     plot_str = "plot for [i in title_list] i.'.csv' using {:d}:{:d} pt 7 ps 1 title i".format(C_ELAPSED, C_FREQ)
     g_plot('title_list = "{}"'.format(title_list))
     g_plot(plot_str)
@@ -238,7 +238,7 @@ def plot_duration_cpu():
     g_plot('set ylabel "Timer Duration (MilliSeconds)"')
     g_plot('set title "{} : cpu durations : {:%F %H:%M}"'.format(testname, datetime.now()))
 
-    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).replace('\n', ' ')
+    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).decode('utf-8').replace('\n', ' ')
     plot_str = "plot for [i in title_list] i.'.csv' using {:d}:{:d} pt 7 ps 1 title i".format(C_ELAPSED, C_DURATION)
     g_plot('title_list = "{}"'.format(title_list))
     g_plot(plot_str)
@@ -252,7 +252,7 @@ def plot_scaled_cpu():
     g_plot('set ylabel "Scaled Busy (Unitless)"')
     g_plot('set title "{} : cpu scaled busy : {:%F %H:%M}"'.format(testname, datetime.now()))
 
-    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).replace('\n', ' ')
+    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).decode('utf-8').replace('\n', ' ')
     plot_str = "plot for [i in title_list] i.'.csv' using {:d}:{:d} pt 7 ps 1 title i".format(C_ELAPSED, C_SCALED)
     g_plot('title_list = "{}"'.format(title_list))
     g_plot(plot_str)
@@ -266,7 +266,7 @@ def plot_boost_cpu():
     g_plot('set ylabel "CPU IO Boost (percent)"')
     g_plot('set title "{} : cpu io boost : {:%F %H:%M}"'.format(testname, datetime.now()))
 
-    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).replace('\n', ' ')
+    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).decode('utf-8').replace('\n', ' ')
     plot_str = "plot for [i in title_list] i.'.csv' using {:d}:{:d} pt 7 ps 1 title i".format(C_ELAPSED, C_BOOST)
     g_plot('title_list = "{}"'.format(title_list))
     g_plot(plot_str)
@@ -280,7 +280,7 @@ def plot_ghz_cpu():
     g_plot('set ylabel "TSC Frequency (GHz)"')
     g_plot('set title "{} : cpu TSC Frequencies (Sanity check calculation) : {:%F %H:%M}"'.format(testname, datetime.now()))
 
-    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).replace('\n', ' ')
+    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).decode('utf-8').replace('\n', ' ')
     plot_str = "plot for [i in title_list] i.'.csv' using {:d}:{:d} pt 7 ps 1 title i".format(C_ELAPSED, C_GHZ)
     g_plot('title_list = "{}"'.format(title_list))
     g_plot(plot_str)
-- 
2.25.1

