Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC044BE927
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245119AbiBUKFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:05:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352990AbiBUJ5A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90C3B45530;
        Mon, 21 Feb 2022 01:24:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E753B80EB1;
        Mon, 21 Feb 2022 09:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CBF1C340E9;
        Mon, 21 Feb 2022 09:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435489;
        bh=yZXY8AcCl5920w1ObP5o3jbBfBFqVp7ha7l5VdB4S+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxrmUK7U45Tt1b3cVEeECAMObbtsizKGwJ+Uk7cwp1mfo0Tz5VynRcaCu0A/h46sx
         gTXtGwMVMbArR9bBTezdekLHb2Dg21cJ3pfuhF4ZRs5Scia+5zKKYC3YV5iNOlnSFw
         AoIjH7XY+j0nLTRo5gbobOYFWPJpaeM8CKEoIf/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Woody Suwalski <wsuwalski@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.16 149/227] ACPI: processor: idle: fix lockup regression on 32-bit ThinkPad T40
Date:   Mon, 21 Feb 2022 09:49:28 +0100
Message-Id: <20220221084939.789054473@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 


