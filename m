Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCE8711B6C0
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387424AbfLKQCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:02:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731343AbfLKPNH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10DC9208C3;
        Wed, 11 Dec 2019 15:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077186;
        bh=NVUSMFBeU6giYFVWU6X0SZEzw/TcFc6R5zCxRAbfVsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z5iYJYvPwQlpEU/Z62N7o0+NM9FcWaWR2Yr6Y7DKfSHDsCp4ItFi1JRy7oSuLUeUA
         MxDiqU87Dz5HR8Dfe81BO6B2/Ttmrqq8sJ8KmNufJoY9SBAkQfh7WgPNHE0GP3L1ig
         EYgJSRfydqDk4o1ffCTSJIW7TpBwp7ks8/OgzcXo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sam Bobroff <sbobroff@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 070/134] powerpc/eeh: differentiate duplicate detection message
Date:   Wed, 11 Dec 2019 10:10:46 -0500
Message-Id: <20191211151150.19073-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Bobroff <sbobroff@linux.ibm.com>

[ Upstream commit de84ffc3ccbeec3678f95a3d898fc188efa0d9c5 ]

Currently when an EEH error is detected, the system log receives the
same (or almost the same) message twice:

  EEH: PHB#0 failure detected, location: N/A
  EEH: PHB#0 failure detected, location: N/A
or
  EEH: eeh_dev_check_failure: Frozen PHB#0-PE#0 detected
  EEH: Frozen PHB#0-PE#0 detected

This looks like a bug, but in fact the messages are from different
functions and mean slightly different things.  So keep both but change
one of the messages slightly, so that it's clear they are different:

  EEH: PHB#0 failure detected, location: N/A
  EEH: Recovering PHB#0, location: N/A
or
  EEH: eeh_dev_check_failure: Frozen PHB#0-PE#0 detected
  EEH: Recovering PHB#0-PE#0

Signed-off-by: Sam Bobroff <sbobroff@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/43817cb6e6631b0828b9a6e266f60d1f8ca8eb22.1571288375.git.sbobroff@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh_driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
index d9279d0ee9f54..c031be8d41ffd 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -897,12 +897,12 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
 
 	/* Log the event */
 	if (pe->type & EEH_PE_PHB) {
-		pr_err("EEH: PHB#%x failure detected, location: %s\n",
+		pr_err("EEH: Recovering PHB#%x, location: %s\n",
 			pe->phb->global_number, eeh_pe_loc_get(pe));
 	} else {
 		struct eeh_pe *phb_pe = eeh_phb_pe_get(pe->phb);
 
-		pr_err("EEH: Frozen PHB#%x-PE#%x detected\n",
+		pr_err("EEH: Recovering PHB#%x-PE#%x\n",
 		       pe->phb->global_number, pe->addr);
 		pr_err("EEH: PE location: %s, PHB location: %s\n",
 		       eeh_pe_loc_get(pe), eeh_pe_loc_get(phb_pe));
-- 
2.20.1

