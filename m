Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F8D2A5820
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731732AbgKCVs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:48:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731836AbgKCUuh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:50:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AB5E20719;
        Tue,  3 Nov 2020 20:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436637;
        bh=/KoFndIGYJbuT51BEtg0sokPNs1B3QruXjEtVFtxWtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eh2ivTT/cYO2VT1bET/N4uG2lGJqxP3j7U+X7lpN0zqFp7yZ8igd9WE/sGuVgHmm9
         3m3l3iN/8qQ0Pg5xzcFCyEVOLh17lv6JS5I39mHSzExsyut7y4cKWIw4XTyp6xoQE5
         W2/lLzdiWisXLtazbZyxoHlJLubt/Me+i9kPNLPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Lawall <julia.lawall@inria.fr>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.9 336/391] cpufreq: Avoid configuring old governors as default with intel_pstate
Date:   Tue,  3 Nov 2020 21:36:27 +0100
Message-Id: <20201103203409.801555020@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit db865272d9c4687520dc29f77e701a1b2669872f upstream.

Commit 33aa46f252c7 ("cpufreq: intel_pstate: Use passive mode by
default without HWP") was meant to cause intel_pstate to be used
in the passive mode with the schedutil governor on top of it, but
it missed the case in which either "ondemand" or "conservative"
was selected as the default governor in the existing kernel config,
in which case the previous old governor configuration would be used,
causing the default legacy governor to be used on top of intel_pstate
instead of schedutil.

Address this by preventing "ondemand" and "conservative" from being
configured as the default cpufreq governor in the case when schedutil
is the default choice for the default governor setting.

[Note that the default cpufreq governor can still be set via the
 kernel command line if need be and that choice is not limited,
 so if anyone really wants to use one of the legacy governors by
 default, it can be achieved this way.]

Fixes: 33aa46f252c7 ("cpufreq: intel_pstate: Use passive mode by default without HWP")
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Cc: 5.8+ <stable@vger.kernel.org> # 5.8+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -71,6 +71,7 @@ config CPU_FREQ_DEFAULT_GOV_USERSPACE
 
 config CPU_FREQ_DEFAULT_GOV_ONDEMAND
 	bool "ondemand"
+	depends on !(X86_INTEL_PSTATE && SMP)
 	select CPU_FREQ_GOV_ONDEMAND
 	select CPU_FREQ_GOV_PERFORMANCE
 	help
@@ -83,6 +84,7 @@ config CPU_FREQ_DEFAULT_GOV_ONDEMAND
 
 config CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
 	bool "conservative"
+	depends on !(X86_INTEL_PSTATE && SMP)
 	select CPU_FREQ_GOV_CONSERVATIVE
 	select CPU_FREQ_GOV_PERFORMANCE
 	help


