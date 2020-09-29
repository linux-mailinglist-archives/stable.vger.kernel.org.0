Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B1A27C96A
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbgI2MKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730185AbgI2Lhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C83420848;
        Tue, 29 Sep 2020 11:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378583;
        bh=goHehEleIuKTp8STem4gnEwPnlD4MLfNm+R8gc0hWIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oy8dRzTRITvLiWi6PVCv3xyvlqnGwhETDqq1zEb4JXhCEsNM8mkR9o/bgA11lD8nc
         +T+hFJMJXexcgEM+feHwn2PECcN3FVJnYiAQKll4InJWGbKcu9fN5yOc8i1i40ghvq
         vri1D4zcnKLugPbe3diSAvGU6B6LxYFFs2lSHDUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Smythies <dsmythies@telus.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/245] tools/power/x86/intel_pstate_tracer: changes for python 3 compatibility
Date:   Tue, 29 Sep 2020 12:58:36 +0200
Message-Id: <20200929105950.163904168@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2fa3c5757bcb5..dbed3d213bf17 100755
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
@@ -180,7 +180,7 @@ def plot_pstate_cpu_with_sample():
         g_plot('set xlabel "Samples"')
         g_plot('set ylabel "P-State"')
         g_plot('set title "{} : cpu pstate vs. sample : {:%F %H:%M}"'.format(testname, datetime.now()))
-        title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).replace('\n', ' ')
+        title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).decode('utf-8').replace('\n', ' ')
         plot_str = "plot for [i in title_list] i.'.csv' using {:d}:{:d} pt 7 ps 1 title i".format(C_SAMPLE, C_TO)
         g_plot('title_list = "{}"'.format(title_list))
         g_plot(plot_str)
@@ -197,7 +197,7 @@ def plot_pstate_cpu():
 #    the following command is really cool, but doesn't work with the CPU masking option because it aborts on the first missing file.
 #    plot_str = 'plot for [i=0:*] file=sprintf("cpu%03d.csv",i) title_s=sprintf("cpu%03d",i) file using 16:7 pt 7 ps 1 title title_s'
 #
-    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).replace('\n', ' ')
+    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).decode('utf-8').replace('\n', ' ')
     plot_str = "plot for [i in title_list] i.'.csv' using {:d}:{:d} pt 7 ps 1 title i".format(C_ELAPSED, C_TO)
     g_plot('title_list = "{}"'.format(title_list))
     g_plot(plot_str)
@@ -211,7 +211,7 @@ def plot_load_cpu():
     g_plot('set ylabel "CPU load (percent)"')
     g_plot('set title "{} : cpu loads : {:%F %H:%M}"'.format(testname, datetime.now()))
 
-    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).replace('\n', ' ')
+    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).decode('utf-8').replace('\n', ' ')
     plot_str = "plot for [i in title_list] i.'.csv' using {:d}:{:d} pt 7 ps 1 title i".format(C_ELAPSED, C_LOAD)
     g_plot('title_list = "{}"'.format(title_list))
     g_plot(plot_str)
@@ -225,7 +225,7 @@ def plot_frequency_cpu():
     g_plot('set ylabel "CPU Frequency (GHz)"')
     g_plot('set title "{} : cpu frequencies : {:%F %H:%M}"'.format(testname, datetime.now()))
 
-    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).replace('\n', ' ')
+    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).decode('utf-8').replace('\n', ' ')
     plot_str = "plot for [i in title_list] i.'.csv' using {:d}:{:d} pt 7 ps 1 title i".format(C_ELAPSED, C_FREQ)
     g_plot('title_list = "{}"'.format(title_list))
     g_plot(plot_str)
@@ -240,7 +240,7 @@ def plot_duration_cpu():
     g_plot('set ylabel "Timer Duration (MilliSeconds)"')
     g_plot('set title "{} : cpu durations : {:%F %H:%M}"'.format(testname, datetime.now()))
 
-    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).replace('\n', ' ')
+    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).decode('utf-8').replace('\n', ' ')
     plot_str = "plot for [i in title_list] i.'.csv' using {:d}:{:d} pt 7 ps 1 title i".format(C_ELAPSED, C_DURATION)
     g_plot('title_list = "{}"'.format(title_list))
     g_plot(plot_str)
@@ -254,7 +254,7 @@ def plot_scaled_cpu():
     g_plot('set ylabel "Scaled Busy (Unitless)"')
     g_plot('set title "{} : cpu scaled busy : {:%F %H:%M}"'.format(testname, datetime.now()))
 
-    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).replace('\n', ' ')
+    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).decode('utf-8').replace('\n', ' ')
     plot_str = "plot for [i in title_list] i.'.csv' using {:d}:{:d} pt 7 ps 1 title i".format(C_ELAPSED, C_SCALED)
     g_plot('title_list = "{}"'.format(title_list))
     g_plot(plot_str)
@@ -268,7 +268,7 @@ def plot_boost_cpu():
     g_plot('set ylabel "CPU IO Boost (percent)"')
     g_plot('set title "{} : cpu io boost : {:%F %H:%M}"'.format(testname, datetime.now()))
 
-    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).replace('\n', ' ')
+    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).decode('utf-8').replace('\n', ' ')
     plot_str = "plot for [i in title_list] i.'.csv' using {:d}:{:d} pt 7 ps 1 title i".format(C_ELAPSED, C_BOOST)
     g_plot('title_list = "{}"'.format(title_list))
     g_plot(plot_str)
@@ -282,7 +282,7 @@ def plot_ghz_cpu():
     g_plot('set ylabel "TSC Frequency (GHz)"')
     g_plot('set title "{} : cpu TSC Frequencies (Sanity check calculation) : {:%F %H:%M}"'.format(testname, datetime.now()))
 
-    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).replace('\n', ' ')
+    title_list = subprocess.check_output('ls cpu???.csv | sed -e \'s/.csv//\'',shell=True).decode('utf-8').replace('\n', ' ')
     plot_str = "plot for [i in title_list] i.'.csv' using {:d}:{:d} pt 7 ps 1 title i".format(C_ELAPSED, C_GHZ)
     g_plot('title_list = "{}"'.format(title_list))
     g_plot(plot_str)
-- 
2.25.1



