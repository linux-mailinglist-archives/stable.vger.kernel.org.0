Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C17681049
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbjA3OCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236965AbjA3OB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4018C3B0E5
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:01:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D13DE61031
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E082CC433EF;
        Mon, 30 Jan 2023 14:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087300;
        bh=fnSG7f7DVdh4i6myr9patFjaMBCJ9BKiN2rZa66Ptn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvr2ezBvaViWxVTLBJ5PRALFdY48frfHjQ3P39t0FSiURpTVA9bE4Szmfja2oMaBG
         /AyBWwMuy7ATQ5T2b616xJdiHnNfaJEbfAgsvw2qd9zbGOIOJ/m422Eje/hZoDZCp9
         zujJ/Lb5hVENRt9eNI4gXJCq736M89pWbOJ5tzfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kan Liang <kan.liang@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/313] perf/x86/cstate: Add Meteor Lake support
Date:   Mon, 30 Jan 2023 14:49:57 +0100
Message-Id: <20230130134344.216747915@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 01f2ea5bcf89dbd7a6530dbce7f2fb4e327e7006 ]

Meteor Lake is Intel's successor to Raptor lake. From the perspective of
Intel cstate residency counters, there is nothing changed compared with
Raptor lake.

Share adl_cstates with Raptor lake.
Update the comments for Meteor Lake.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Link: https://lore.kernel.org/r/20230104201349.1451191-6-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/cstate.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/events/intel/cstate.c b/arch/x86/events/intel/cstate.c
index a2834bc93149..3019fb1926e3 100644
--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -41,6 +41,7 @@
  *	MSR_CORE_C1_RES: CORE C1 Residency Counter
  *			 perf code: 0x00
  *			 Available model: SLM,AMT,GLM,CNL,ICX,TNT,ADL,RPL
+ *					  MTL
  *			 Scope: Core (each processor core has a MSR)
  *	MSR_CORE_C3_RESIDENCY: CORE C3 Residency Counter
  *			       perf code: 0x01
@@ -51,50 +52,50 @@
  *			       perf code: 0x02
  *			       Available model: SLM,AMT,NHM,WSM,SNB,IVB,HSW,BDW,
  *						SKL,KNL,GLM,CNL,KBL,CML,ICL,ICX,
- *						TGL,TNT,RKL,ADL,RPL,SPR
+ *						TGL,TNT,RKL,ADL,RPL,SPR,MTL
  *			       Scope: Core
  *	MSR_CORE_C7_RESIDENCY: CORE C7 Residency Counter
  *			       perf code: 0x03
  *			       Available model: SNB,IVB,HSW,BDW,SKL,CNL,KBL,CML,
- *						ICL,TGL,RKL,ADL,RPL
+ *						ICL,TGL,RKL,ADL,RPL,MTL
  *			       Scope: Core
  *	MSR_PKG_C2_RESIDENCY:  Package C2 Residency Counter.
  *			       perf code: 0x00
  *			       Available model: SNB,IVB,HSW,BDW,SKL,KNL,GLM,CNL,
  *						KBL,CML,ICL,ICX,TGL,TNT,RKL,ADL,
- *						RPL,SPR
+ *						RPL,SPR,MTL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C3_RESIDENCY:  Package C3 Residency Counter.
  *			       perf code: 0x01
  *			       Available model: NHM,WSM,SNB,IVB,HSW,BDW,SKL,KNL,
  *						GLM,CNL,KBL,CML,ICL,TGL,TNT,RKL,
- *						ADL,RPL
+ *						ADL,RPL,MTL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C6_RESIDENCY:  Package C6 Residency Counter.
  *			       perf code: 0x02
  *			       Available model: SLM,AMT,NHM,WSM,SNB,IVB,HSW,BDW,
  *						SKL,KNL,GLM,CNL,KBL,CML,ICL,ICX,
- *						TGL,TNT,RKL,ADL,RPL,SPR
+ *						TGL,TNT,RKL,ADL,RPL,SPR,MTL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C7_RESIDENCY:  Package C7 Residency Counter.
  *			       perf code: 0x03
  *			       Available model: NHM,WSM,SNB,IVB,HSW,BDW,SKL,CNL,
- *						KBL,CML,ICL,TGL,RKL,ADL,RPL
+ *						KBL,CML,ICL,TGL,RKL,ADL,RPL,MTL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C8_RESIDENCY:  Package C8 Residency Counter.
  *			       perf code: 0x04
  *			       Available model: HSW ULT,KBL,CNL,CML,ICL,TGL,RKL,
- *						ADL,RPL
+ *						ADL,RPL,MTL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C9_RESIDENCY:  Package C9 Residency Counter.
  *			       perf code: 0x05
  *			       Available model: HSW ULT,KBL,CNL,CML,ICL,TGL,RKL,
- *						ADL,RPL
+ *						ADL,RPL,MTL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C10_RESIDENCY: Package C10 Residency Counter.
  *			       perf code: 0x06
  *			       Available model: HSW ULT,KBL,GLM,CNL,CML,ICL,TGL,
- *						TNT,RKL,ADL,RPL
+ *						TNT,RKL,ADL,RPL,MTL
  *			       Scope: Package (physical package)
  *
  */
@@ -686,6 +687,8 @@ static const struct x86_cpu_id intel_cstates_match[] __initconst = {
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,		&adl_cstates),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,	&adl_cstates),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,	&adl_cstates),
+	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE,		&adl_cstates),
+	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L,	&adl_cstates),
 	{ },
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_cstates_match);
-- 
2.39.0



