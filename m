Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 216BCCA4FC
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391636AbfJCQ36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391024AbfJCQ34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:29:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6C082054F;
        Thu,  3 Oct 2019 16:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120195;
        bh=nxhfcdcem27JgN1iEngjzJ+W+McMsJHgH8HRx+nl0Sc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ddTqYosvVcuiTCJHoiwZ7FpEGCp/I2AE0Q/RnCLUr+z7al2RrSOj2C1VR9jTUuniV
         +1CVdWmLpzpEtDrQhPyF7AwLHiNpWRDAiA1ih2cHShPinTbUL6Lf3mpGqPXbAXFaQ5
         cwr7t2hOoDcRWkzrCNwoiW2cv0pRlUETk6AqQJF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 133/313] EDAC/amd64: Decode syndrome before translating address
Date:   Thu,  3 Oct 2019 17:51:51 +0200
Message-Id: <20191003154545.993390858@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

[ Upstream commit 8a2eaab7daf03b23ac902481218034ae2fae5e16 ]

AMD Family 17h systems currently require address translation in order to
report the system address of a DRAM ECC error. This is currently done
before decoding the syndrome information. The syndrome information does
not depend on the address translation, so the proper EDAC csrow/channel
reporting can function without the address. However, the syndrome
information will not be decoded if the address translation fails.

Decode the syndrome information before doing the address translation.
The syndrome information is architecturally defined in MCA_SYND and can
be considered robust. The address translation is system-specific and may
fail on newer systems without proper updates to the translation
algorithm.

Fixes: 713ad54675fd ("EDAC, amd64: Define and register UMC error decode function")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/20190821235938.118710-6-Yazen.Ghannam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/amd64_edac.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index ffe56a8fe39da..608fdab566b32 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2550,13 +2550,6 @@ static void decode_umc_error(int node_id, struct mce *m)
 
 	err.channel = find_umc_channel(m);
 
-	if (umc_normaddr_to_sysaddr(m->addr, pvt->mc_node_id, err.channel, &sys_addr)) {
-		err.err_code = ERR_NORM_ADDR;
-		goto log_error;
-	}
-
-	error_address_to_page_and_offset(sys_addr, &err);
-
 	if (!(m->status & MCI_STATUS_SYNDV)) {
 		err.err_code = ERR_SYND;
 		goto log_error;
@@ -2573,6 +2566,13 @@ static void decode_umc_error(int node_id, struct mce *m)
 
 	err.csrow = m->synd & 0x7;
 
+	if (umc_normaddr_to_sysaddr(m->addr, pvt->mc_node_id, err.channel, &sys_addr)) {
+		err.err_code = ERR_NORM_ADDR;
+		goto log_error;
+	}
+
+	error_address_to_page_and_offset(sys_addr, &err);
+
 log_error:
 	__log_ecc_error(mci, &err, ecc_type);
 }
-- 
2.20.1



