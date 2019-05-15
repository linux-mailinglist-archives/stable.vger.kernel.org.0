Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFD51F26C
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbfEOLML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729716AbfEOLMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:12:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 074952166E;
        Wed, 15 May 2019 11:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918729;
        bh=B7kKelVcZ26aftuVABM5ZbQ9DN2Zj+hKM8yNq3a3RRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5nMIk4gDhmdBlrz9IRpbnhKrJGELbcbH7lhy3kY4tGJJLYD734oRuOcpv7IsB7xQ
         JvQ/uUUSHKIR276RD7wJEYo35/l7BswXRRwov1qNtQUnvwBR55gJOQKbyu2JWlfLCx
         1jLfHJXbYK6tw1e7kZ77Rb+nMVJpS6zLfrGg2THM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 242/266] x86/cpu/bugs: Use __initconst for const init data
Date:   Wed, 15 May 2019 12:55:49 +0200
Message-Id: <20190515090731.191538406@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -315,7 +315,7 @@ static const struct {
 	const char			*option;
 	enum spectre_v2_user_cmd	cmd;
 	bool				secure;
-} v2_user_options[] __initdata = {
+} v2_user_options[] __initconst = {
 	{ "auto",		SPECTRE_V2_USER_CMD_AUTO,		false },
 	{ "off",		SPECTRE_V2_USER_CMD_NONE,		false },
 	{ "on",			SPECTRE_V2_USER_CMD_FORCE,		true  },
@@ -451,7 +451,7 @@ static const struct {
 	const char *option;
 	enum spectre_v2_mitigation_cmd cmd;
 	bool secure;
-} mitigation_options[] __initdata = {
+} mitigation_options[] __initconst = {
 	{ "off",		SPECTRE_V2_CMD_NONE,		  false },
 	{ "on",			SPECTRE_V2_CMD_FORCE,		  true  },
 	{ "retpoline",		SPECTRE_V2_CMD_RETPOLINE,	  false },
@@ -723,7 +723,7 @@ static const char * const ssb_strings[]
 static const struct {
 	const char *option;
 	enum ssb_mitigation_cmd cmd;
-} ssb_mitigation_options[]  __initdata = {
+} ssb_mitigation_options[]  __initconst = {
 	{ "auto",	SPEC_STORE_BYPASS_CMD_AUTO },    /* Platform decides */
 	{ "on",		SPEC_STORE_BYPASS_CMD_ON },      /* Disable Speculative Store Bypass */
 	{ "off",	SPEC_STORE_BYPASS_CMD_NONE },    /* Don't touch Speculative Store Bypass */


