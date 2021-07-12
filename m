Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6DC3C48F1
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbhGLGl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34399 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237880AbhGLGjm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5CB661158;
        Mon, 12 Jul 2021 06:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071733;
        bh=E8sPoA8vsSi2KuwTNgsfdxDTeOsRs27sDlWG2rQHN5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AvYsP7Ea76DyVMxx6LUK18kXLAMi1u2+ACh8OaDPWu3Y+5iH2W19d6GhQaNDHho+M
         vK/putyvz/eumXWtKGfyBZfcKlcLwAZcbspu7D4VmMoCgRBSWXPeijVOIieCxwTrv5
         4XbcaTi501tEAP194Cj5KoCzMxUVw95u00aepVi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/593] EDAC/Intel: Do not load EDAC driver when running as a guest
Date:   Mon, 12 Jul 2021 08:05:54 +0200
Message-Id: <20210712060904.339989848@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luck, Tony <tony.luck@intel.com>

[ Upstream commit f0a029fff4a50eb01648810a77ba1873e829fdd4 ]

There's little to no point in loading an EDAC driver running in a guest:
1) The CPU model reported by CPUID may not represent actual h/w
2) The hypervisor likely does not pass in access to memory controller devices
3) Hypervisors generally do not pass corrected error details to guests

Add a check in each of the Intel EDAC drivers for X86_FEATURE_HYPERVISOR
and simply return -ENODEV in the init routine.

Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20210615174419.GA1087688@agluck-desk2.amr.corp.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i10nm_base.c | 3 +++
 drivers/edac/pnd2_edac.c  | 3 +++
 drivers/edac/sb_edac.c    | 3 +++
 drivers/edac/skx_base.c   | 3 +++
 4 files changed, 12 insertions(+)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index 7b52691c45d2..4912a7b88380 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -263,6 +263,9 @@ static int __init i10nm_init(void)
 	if (owner && strncmp(owner, EDAC_MOD_STR, sizeof(EDAC_MOD_STR)))
 		return -EBUSY;
 
+	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return -ENODEV;
+
 	id = x86_match_cpu(i10nm_cpuids);
 	if (!id)
 		return -ENODEV;
diff --git a/drivers/edac/pnd2_edac.c b/drivers/edac/pnd2_edac.c
index 928f63a374c7..c94ca1f790c4 100644
--- a/drivers/edac/pnd2_edac.c
+++ b/drivers/edac/pnd2_edac.c
@@ -1554,6 +1554,9 @@ static int __init pnd2_init(void)
 	if (owner && strncmp(owner, EDAC_MOD_STR, sizeof(EDAC_MOD_STR)))
 		return -EBUSY;
 
+	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return -ENODEV;
+
 	id = x86_match_cpu(pnd2_cpuids);
 	if (!id)
 		return -ENODEV;
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 93daa4297f2e..4c626fcd4dcb 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -3510,6 +3510,9 @@ static int __init sbridge_init(void)
 	if (owner && strncmp(owner, EDAC_MOD_STR, sizeof(EDAC_MOD_STR)))
 		return -EBUSY;
 
+	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return -ENODEV;
+
 	id = x86_match_cpu(sbridge_cpuids);
 	if (!id)
 		return -ENODEV;
diff --git a/drivers/edac/skx_base.c b/drivers/edac/skx_base.c
index 2c7db95df326..f887e3166651 100644
--- a/drivers/edac/skx_base.c
+++ b/drivers/edac/skx_base.c
@@ -656,6 +656,9 @@ static int __init skx_init(void)
 	if (owner && strncmp(owner, EDAC_MOD_STR, sizeof(EDAC_MOD_STR)))
 		return -EBUSY;
 
+	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR))
+		return -ENODEV;
+
 	id = x86_match_cpu(skx_cpuids);
 	if (!id)
 		return -ENODEV;
-- 
2.30.2



