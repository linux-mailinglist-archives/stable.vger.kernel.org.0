Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD196B492F
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbjCJPK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:10:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233737AbjCJPKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:10:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A00F125DA0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:02:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 631F0B82337
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E94C433EF;
        Fri, 10 Mar 2023 15:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460536;
        bh=k5HQyqm0VGAfss/paDeflC6MNEUDpsDoCIgnT97MHH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MvC7oeYZjT1/5z0H1oaRJfAfwYUd0oPNnItpLTaVf7/0F5DaopJvGQpGxiLhRALXV
         6jiq+iJRv4qunaAB73TTND42Z0PE1xQrNcS2/RKVuIQpAaUT9UaHS9JetPTg60R+8P
         fcb+Qx0Jn3oO+9+3w6noVMo2WpQiZ4mq+iUHRXnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, KP Singh <kpsingh@kernel.org>,
        "Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 367/529] Documentation/hw-vuln: Document the interaction between IBRS and STIBP
Date:   Fri, 10 Mar 2023 14:38:30 +0100
Message-Id: <20230310133822.003718038@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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


