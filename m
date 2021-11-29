Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8C4461EBE
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379679AbhK2Sjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:39:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42396 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378948AbhK2Sho (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:37:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93072B815D2;
        Mon, 29 Nov 2021 18:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54D7C53FAD;
        Mon, 29 Nov 2021 18:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210864;
        bh=xBvFteyNs9NBIruntnAVsbNTeZIF4ouQXM+mu+7SOlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s68OL3077L6bjqGLlYdHuroytZuvi8oPVFXEEvjkxI+I8qT5Eby+2JfdK19n2iWli
         aozhe9VGSEz4VV7XWhbzzknmHhjsZCJkEQOwMk8+eFxZLNhmtQAvPg55FqAfzhb2FK
         aH9eEYnFDm/2LmWHGezxgh+xzsm2o7HNH6BBZFPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 003/179] ACPI: CPPC: Add NULL pointer check to cppc_get_perf()
Date:   Mon, 29 Nov 2021 19:16:37 +0100
Message-Id: <20211129181719.034781329@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 935dff305da2be7957a5ce8f07f45d6c4c1c6984 upstream.

Check cpc_desc against NULL in cppc_get_perf(), so it doesn't crash
down the road if cpc_desc is NULL.

Fixes: 0654cf05d17b ("ACPI: CPPC: Introduce cppc_get_nominal_perf()")
Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 5.15+ <stable@vger.kernel.org> # 5.15+
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1011,7 +1011,14 @@ static int cpc_write(int cpu, struct cpc
 static int cppc_get_perf(int cpunum, enum cppc_regs reg_idx, u64 *perf)
 {
 	struct cpc_desc *cpc_desc = per_cpu(cpc_desc_ptr, cpunum);
-	struct cpc_register_resource *reg = &cpc_desc->cpc_regs[reg_idx];
+	struct cpc_register_resource *reg;
+
+	if (!cpc_desc) {
+		pr_debug("No CPC descriptor for CPU:%d\n", cpunum);
+		return -ENODEV;
+	}
+
+	reg = &cpc_desc->cpc_regs[reg_idx];
 
 	if (CPC_IN_PCC(reg)) {
 		int pcc_ss_id = per_cpu(cpu_pcc_subspace_idx, cpunum);


