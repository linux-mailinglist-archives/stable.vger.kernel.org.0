Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5353112B6
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 21:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbhBES7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 13:59:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233062AbhBEPCT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:02:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F276364FDC;
        Fri,  5 Feb 2021 14:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534187;
        bh=49FKmkDTfT6OGAk1xDakZIzVmRL+oyoYE2jNTGqDvD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUC3EJ+n6rWgBO4iuqURmyTmM4aUT1hIb6K7ULfx0hZF+lFK6X3niKzWXp4kHCZTt
         KVQfGafuGIVhHZ+L5m7pLflIFqVx1S7UvBRHLLflJ3+u4CD9i43E+KQaUDIvqZ5MNr
         mIcle52IN3WgWAhWgktas2+qQj6Ny2fLlvdaB4lg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 20/57] tools/power/x86/intel-speed-select: Set higher of cpuinfo_max_freq or base_frequency
Date:   Fri,  5 Feb 2021 15:06:46 +0100
Message-Id: <20210205140656.842112693@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit bbaa2e95e23e74791dd75b90d5ad9aad535acc6e ]

In some case when BIOS disabled turbo, cpufreq cpuinfo_max_freq can be
lower than base_frequency at higher config level. So, in that case set
scaling_min_freq to base_frequency.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20201221071859.2783957-3-srinivas.pandruvada@linux.intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/intel-speed-select/isst-config.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/power/x86/intel-speed-select/isst-config.c b/tools/power/x86/intel-speed-select/isst-config.c
index 97755f35d9910..ead9e51f75ada 100644
--- a/tools/power/x86/intel-speed-select/isst-config.c
+++ b/tools/power/x86/intel-speed-select/isst-config.c
@@ -1457,6 +1457,16 @@ static void adjust_scaling_max_from_base_freq(int cpu)
 		set_cpufreq_scaling_min_max(cpu, 1, base_freq);
 }
 
+static void adjust_scaling_min_from_base_freq(int cpu)
+{
+	int base_freq, scaling_min_freq;
+
+	scaling_min_freq = parse_int_file(0, "/sys/devices/system/cpu/cpu%d/cpufreq/scaling_min_freq", cpu);
+	base_freq = get_cpufreq_base_freq(cpu);
+	if (scaling_min_freq < base_freq)
+		set_cpufreq_scaling_min_max(cpu, 0, base_freq);
+}
+
 static int set_clx_pbf_cpufreq_scaling_min_max(int cpu)
 {
 	struct isst_pkg_ctdp_level_info *ctdp_level;
@@ -1554,6 +1564,7 @@ static void set_scaling_min_to_cpuinfo_max(int cpu)
 			continue;
 
 		set_cpufreq_scaling_min_max_from_cpuinfo(i, 1, 0);
+		adjust_scaling_min_from_base_freq(i);
 	}
 }
 
-- 
2.27.0



