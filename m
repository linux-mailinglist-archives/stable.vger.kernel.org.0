Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D9D6B4130
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjCJNu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjCJNuY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:50:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87A7104925
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87C38B822AD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D874BC433D2;
        Fri, 10 Mar 2023 13:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456220;
        bh=k5HQyqm0VGAfss/paDeflC6MNEUDpsDoCIgnT97MHH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UjcHJNrRXCNHteayECF/nHZ+Wmq1gbE43NDOcEMdnxkJUoLIeEBnIXdUdKBVcq+P0
         Gm9UpRg+zVsyZI79bfekrXkalqjhuPO2ia4t91BjFZxLx5f3GEzVIsraJLB0J9cpk8
         AK9sAZv6zsArDsxrLe1SWO9RA81qbLBgPGxxbn94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, KP Singh <kpsingh@kernel.org>,
        "Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 4.14 121/193] Documentation/hw-vuln: Document the interaction between IBRS and STIBP
Date:   Fri, 10 Mar 2023 14:38:23 +0100
Message-Id: <20230310133715.287488740@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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


