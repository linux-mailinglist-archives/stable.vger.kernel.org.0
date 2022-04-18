Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22B45051A0
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239214AbiDRMgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239244AbiDRMfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:35:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8688620BDC;
        Mon, 18 Apr 2022 05:27:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A114660FB6;
        Mon, 18 Apr 2022 12:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40E2C385A1;
        Mon, 18 Apr 2022 12:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284842;
        bh=xoOqNW8QnXGo22oABOGmUCbKg4y5PZ8xL4qAa94Km+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIpWT/kiS0n65dfSvHSLfVej3QTKbAt1gPk5XdkSNX58pWjDOaslbKU2r6U0dzMlH
         yWpNiyZPrjOmDRAkq7su3dw6kWXEMFTjk4RG6RcGjk3goePAqtlD1NzoQHakGlFl5i
         WK+JUHwIXIJlMR695NLx/WZdYiazzJiHiRLis5Os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Woody Suwalski <wsuwalski@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 5.15 008/189] ACPI: processor: idle: fix lockup regression on 32-bit ThinkPad T40
Date:   Mon, 18 Apr 2022 14:10:28 +0200
Message-Id: <20220418121200.682225683@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Woody Suwalski <wsuwalski@gmail.com>

commit bfe55a1f7fd6bfede16078bf04c6250fbca11588 upstream.

Add and ACPI idle power level limit for 32-bit ThinkPad T40.

There is a regression on T40 introduced by commit d6b88ce2, starting
with kernel 5.16:

commit d6b88ce2eb9d2698eb24451eb92c0a1649b17bb1
Author: Richard Gong <richard.gong@amd.com>
Date:   Wed Sep 22 08:31:16 2021 -0500

  ACPI: processor idle: Allow playing dead in C3 state

The above patch is trying to enter C3 state during init, what is causing
a T40 system freeze. I have not found a similar issue on any other of my
32-bit machines.

The fix is to add another exception to the processor_power_dmi_table[] list.
As a result the dmesg shows as expected:

[2.155398] ACPI: IBM ThinkPad T40 detected - limiting to C2 max_cstate. Override with "processor.max_cstate=9"
[2.155404] ACPI: processor limited to max C-state 2

The fix is trivial and affects only vintage T40 systems.

Fixes: d6b88ce2eb9d ("CPI: processor idle: Allow playing dead in C3 state")
Signed-off-by: Woody Suwalski <wsuwalski@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Cc: 5.16+ <stable@vger.kernel.org> # 5.16+
[ rjw: New subject ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_idle.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -95,6 +95,11 @@ static const struct dmi_system_id proces
 	  DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"L8400B series Notebook PC")},
 	 (void *)1},
+	/* T40 can not handle C3 idle state */
+	{ set_max_cstate, "IBM ThinkPad T40", {
+	  DMI_MATCH(DMI_SYS_VENDOR, "IBM"),
+	  DMI_MATCH(DMI_PRODUCT_NAME, "23737CU")},
+	 (void *)2},
 	{},
 };
 


