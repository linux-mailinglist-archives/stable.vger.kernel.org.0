Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F339A68D859
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbjBGNIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbjBGNIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:08:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C213A866
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:08:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 023996143F
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07462C433D2;
        Tue,  7 Feb 2023 13:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775234;
        bh=aVeVN9zXt46j7A6KlhydEwhohHrf8YAsAgHUlnU+h0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7nrg02LG+QJNwmIUNxCZ+QPBUdHLw7/4qJO6W5h8qZN9JZQjV9Dm6uOs2f8WFMmD
         7EL/OQBW1Qjnfd9XohfJSbHZq360xnc2/zF6871IbvKB4OeA0+yZYw/GZ6MWxjWMZR
         jVZvGyM+lUdVqr+Nv446N9CQ3eGMP1ZwoIWqSPfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 152/208] parisc: Replace hardcoded value with PRIV_USER constant in ptrace.c
Date:   Tue,  7 Feb 2023 13:56:46 +0100
Message-Id: <20230207125641.344017904@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 3f0c17809a098d3f0c1ec83f1fb3ca61638d3dcd upstream.

Prefer usage of the PRIV_USER constant over the hard-coded value to set
the lowest 2 bits for the userspace privilege.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # 5.16+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/ptrace.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -166,7 +166,7 @@ long arch_ptrace(struct task_struct *chi
 		     addr >= sizeof(struct pt_regs))
 			break;
 		if (addr == PT_IAOQ0 || addr == PT_IAOQ1) {
-			data |= 3; /* ensure userspace privilege */
+			data |= PRIV_USER; /* ensure userspace privilege */
 		}
 		if ((addr >= PT_GR1 && addr <= PT_GR31) ||
 				addr == PT_IAOQ0 || addr == PT_IAOQ1 ||
@@ -285,7 +285,7 @@ long compat_arch_ptrace(struct task_stru
 			if (addr >= sizeof(struct pt_regs))
 				break;
 			if (addr == PT_IAOQ0+4 || addr == PT_IAOQ1+4) {
-				data |= 3; /* ensure userspace privilege */
+				data |= PRIV_USER; /* ensure userspace privilege */
 			}
 			if (addr >= PT_FR0 && addr <= PT_FR31 + 4) {
 				/* Special case, fp regs are 64 bits anyway */
@@ -483,7 +483,7 @@ static void set_reg(struct pt_regs *regs
 	case RI(iaoq[0]):
 	case RI(iaoq[1]):
 			/* set 2 lowest bits to ensure userspace privilege: */
-			regs->iaoq[num - RI(iaoq[0])] = val | 3;
+			regs->iaoq[num - RI(iaoq[0])] = val | PRIV_USER;
 			return;
 	case RI(sar):	regs->sar = val;
 			return;


