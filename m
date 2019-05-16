Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB7A620BFF
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfEPQAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:00:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42996 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727068AbfEPP6r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:47 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImJ-0006zN-Dr; Thu, 16 May 2019 16:58:43 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImF-0001TC-An; Thu, 16 May 2019 16:58:39 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Andi Kleen" <ak@linux.intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.575614928@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 85/86] x86/cpu/bugs: Use __initconst for 'const' init
 data
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Kleen <ak@linux.intel.com>

commit 1de7edbb59c8f1b46071f66c5c97b8a59569eb51 upstream.

Some of the recently added const tables use __initdata which causes section
attribute conflicts.

Use __initconst instead.

Fixes: fa1202ef2243 ("x86/speculation: Add command line control")
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190330004743.29541-9-andi@firstfloor.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/bugs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -383,7 +383,7 @@ static const struct {
 	const char			*option;
 	enum spectre_v2_user_cmd	cmd;
 	bool				secure;
-} v2_user_options[] __initdata = {
+} v2_user_options[] __initconst = {
 	{ "auto",		SPECTRE_V2_USER_CMD_AUTO,		false },
 	{ "off",		SPECTRE_V2_USER_CMD_NONE,		false },
 	{ "on",			SPECTRE_V2_USER_CMD_FORCE,		true  },
@@ -519,7 +519,7 @@ static const struct {
 	const char *option;
 	enum spectre_v2_mitigation_cmd cmd;
 	bool secure;
-} mitigation_options[] __initdata = {
+} mitigation_options[] __initconst = {
 	{ "off",		SPECTRE_V2_CMD_NONE,		  false },
 	{ "on",			SPECTRE_V2_CMD_FORCE,		  true  },
 	{ "retpoline",		SPECTRE_V2_CMD_RETPOLINE,	  false },
@@ -796,7 +796,7 @@ static const char * const ssb_strings[]
 static const struct {
 	const char *option;
 	enum ssb_mitigation_cmd cmd;
-} ssb_mitigation_options[]  __initdata = {
+} ssb_mitigation_options[]  __initconst = {
 	{ "auto",	SPEC_STORE_BYPASS_CMD_AUTO },    /* Platform decides */
 	{ "on",		SPEC_STORE_BYPASS_CMD_ON },      /* Disable Speculative Store Bypass */
 	{ "off",	SPEC_STORE_BYPASS_CMD_NONE },    /* Don't touch Speculative Store Bypass */

