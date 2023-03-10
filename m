Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87F66B45EB
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbjCJOin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjCJOi0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:38:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64691144B8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:38:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5497D61380
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47767C4339C;
        Fri, 10 Mar 2023 14:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459085;
        bh=k5HQyqm0VGAfss/paDeflC6MNEUDpsDoCIgnT97MHH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fymx+XQASd6bnzmVMSeEFEhSb04h3ov7FR0f3767RMook8qIxdTI9a8/sKxSQ1FMI
         ZpGfMM/3Cgh/tujxbn/h27Bz7EzXONtHRKXvxUP5FYXXk2LES417aysIywfxPCmdWR
         PDfvHpfn12n8G4K9tJsYZh5sm9V4+mKUDC8L8irg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, KP Singh <kpsingh@kernel.org>,
        "Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.4 243/357] Documentation/hw-vuln: Document the interaction between IBRS and STIBP
Date:   Fri, 10 Mar 2023 14:38:52 +0100
Message-Id: <20230310133745.468321134@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: KP Singh <kpsingh@kernel.org>

commit e02b50ca442e88122e1302d4dbc1b71a4808c13f upstream.

Explain why STIBP is needed with legacy IBRS as currently implemented
(KERNEL_IBRS) and why STIBP is not needed when enhanced IBRS is enabled.

Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
Signed-off-by: KP Singh <kpsingh@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230227060541.1939092-2-kpsingh@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/hw-vuln/spectre.rst |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -479,8 +479,16 @@ Spectre variant 2
    On Intel Skylake-era systems the mitigation covers most, but not all,
    cases. See :ref:`[3] <spec_ref3>` for more details.
 
-   On CPUs with hardware mitigation for Spectre variant 2 (e.g. Enhanced
-   IBRS on x86), retpoline is automatically disabled at run time.
+   On CPUs with hardware mitigation for Spectre variant 2 (e.g. IBRS
+   or enhanced IBRS on x86), retpoline is automatically disabled at run time.
+
+   Systems which support enhanced IBRS (eIBRS) enable IBRS protection once at
+   boot, by setting the IBRS bit, and they're automatically protected against
+   Spectre v2 variant attacks, including cross-thread branch target injections
+   on SMT systems (STIBP). In other words, eIBRS enables STIBP too.
+
+   Legacy IBRS systems clear the IBRS bit on exit to userspace and
+   therefore explicitly enable STIBP for that
 
    The retpoline mitigation is turned on by default on vulnerable
    CPUs. It can be forced on or off by the administrator
@@ -504,9 +512,12 @@ Spectre variant 2
    For Spectre variant 2 mitigation, individual user programs
    can be compiled with return trampolines for indirect branches.
    This protects them from consuming poisoned entries in the branch
-   target buffer left by malicious software.  Alternatively, the
-   programs can disable their indirect branch speculation via prctl()
-   (See :ref:`Documentation/userspace-api/spec_ctrl.rst <set_spec_ctrl>`).
+   target buffer left by malicious software.
+
+   On legacy IBRS systems, at return to userspace, implicit STIBP is disabled
+   because the kernel clears the IBRS bit. In this case, the userspace programs
+   can disable indirect branch speculation via prctl() (See
+   :ref:`Documentation/userspace-api/spec_ctrl.rst <set_spec_ctrl>`).
    On x86, this will turn on STIBP to guard against attacks from the
    sibling thread when the user program is running, and use IBPB to
    flush the branch target buffer when switching to/from the program.


