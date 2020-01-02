Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97B0F12EBEF
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgABWNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:13:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727750AbgABWNk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:13:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F319022525;
        Thu,  2 Jan 2020 22:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003220;
        bh=3Qa0uTkqnfY4GO23SXOVCD7Sy8mhDYu9wApa37BJccE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dmDxazMwNhzkoJIXtPVDdelKgk/VP/VXqi8MyK0uUZpo9HcJJBLZX8aLO4W5myF5j
         fz+jcmMyIqjJVQvWw6nt6a139h/j/O1DGREuKtKYWu1A5Ay4J2Ekwo5N9YNJlkIPVn
         mWS/35kx+eCaF/HQVueaEcODV5A8dGMcf/MOBTxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Bobroff <sbobroff@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/191] powerpc/eeh: differentiate duplicate detection message
Date:   Thu,  2 Jan 2020 23:05:52 +0100
Message-Id: <20200102215837.427405144@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d9279d0ee9f5..c031be8d41ff 100644
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



