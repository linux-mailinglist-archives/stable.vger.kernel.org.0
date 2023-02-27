Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEC26A3B26
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 07:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjB0GGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 01:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjB0GGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 01:06:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644DBE07A;
        Sun, 26 Feb 2023 22:06:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F4DCB80CA9;
        Mon, 27 Feb 2023 06:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE05C433A0;
        Mon, 27 Feb 2023 06:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677477954;
        bh=4C1+pvBIASG8iiG2GF0aay0fnKavFG+MLuc1joZcqJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NBrJCXUqgCf09EB5BvwGub/rHwbP+qS/KsQMfoKVAY6BOsh/xJK/x3pnCGYgmvqW5
         J4xHtWgvcxkua5CWg0lCPIuAHedO0RPFyd3TDHBFciORg2iNu2XrDdX2wadlEjaNMQ
         pYL/WS7hWKsUojenUJOHLzVSzueBYOA8vUGDG4ep/ye3cCNKsF8n18QkTJ7d0dE52U
         KjU+Zyqf54PAsUFWdh0neztl4So/qAR7bAWzKojzzI5eUIJVV38VBHjI5P0jquNAB7
         AXKGr//PXDfKgPZpgNlB2+fDnNlUBj6PA0hHUhmcy6jMffdw0f0SiCDTnS/pyMAskR
         pRpplp8d8rmjw==
From:   KP Singh <kpsingh@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     pjt@google.com, evn@google.com, jpoimboe@kernel.org,
        tglx@linutronix.de, x86@kernel.org, hpa@zytor.com,
        peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
        kim.phillips@amd.com, alexandre.chartre@oracle.com,
        daniel.sneddon@linux.intel.com, corbet@lwn.net, bp@suse.de,
        linyujun809@huawei.com, kpsingh@kernel.org, jmattson@google.com,
        mingo@redhat.com, seanjc@google.com, andrew.cooper3@citrix.com,
        stable@vger.kernel.org
Subject: [PATCH v3 2/2] Documentation/hw-vuln: Document the interaction between IBRS and STIBP
Date:   Mon, 27 Feb 2023 07:05:41 +0100
Message-Id: <20230227060541.1939092-2-kpsingh@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
In-Reply-To: <20230227060541.1939092-1-kpsingh@kernel.org>
References: <20230227060541.1939092-1-kpsingh@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Explain why STIBP is needed with legacy IBRS as currently implemented
(KERNEL_IBRS) and why STIBP is not needed when enhanced IBRS is enabled.

Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
Cc: stable@vger.kernel.org
Signed-off-by: KP Singh <kpsingh@kernel.org>
---
 Documentation/admin-guide/hw-vuln/spectre.rst | 21 ++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/spectre.rst b/Documentation/admin-guide/hw-vuln/spectre.rst
index 3fe6511c5405..4d186f599d90 100644
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
-- 
2.39.2.637.g21b0678d19-goog

