Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2BF5010A5
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344479AbiDNONS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347752AbiDNN7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:59:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF5EBCB71;
        Thu, 14 Apr 2022 06:52:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 794DB61E33;
        Thu, 14 Apr 2022 13:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A2DEC385A5;
        Thu, 14 Apr 2022 13:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944348;
        bh=IrHkgNkTjMspQ/PfQua7POCpkCgUgP/xW+Bu2KBXnK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vcsLJACfltArfJfkuh+OLl98yxSAjLsKdNSTkAZNlb22a6SZU/JsLj7e9e9GbcvJ0
         ZgBURMIid11mWkUmnhVXy1uPhg4CVnAj/W4QLk/yIRZq5ufFohhTUruDoLhYkylf3U
         nAfV+d1jC4GUkv8WgVkWLifrJIGfSFTZ2tBkARic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 475/475] ACPI: processor idle: Check for architectural support for LPI
Date:   Thu, 14 Apr 2022 15:14:20 +0200
Message-Id: <20220414110908.349507329@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit eb087f305919ee8169ad65665610313e74260463 upstream.

When `osc_pc_lpi_support_confirmed` is set through `_OSC` and `_LPI` is
populated then the cpuidle driver assumes that LPI is fully functional.

However currently the kernel only provides architectural support for LPI
on ARM.  This leads to high power consumption on X86 platforms that
otherwise try to enable LPI.

So probe whether or not LPI support is implemented before enabling LPI in
the kernel.  This is done by overloading `acpi_processor_ffh_lpi_probe` to
check whether it returns `-EOPNOTSUPP`. It also means that all future
implementations of `acpi_processor_ffh_lpi_probe` will need to follow
these semantics as well.

Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_idle.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1201,6 +1201,11 @@ static int flatten_lpi_states(struct acp
 	return 0;
 }
 
+int __weak acpi_processor_ffh_lpi_probe(unsigned int cpu)
+{
+	return -EOPNOTSUPP;
+}
+
 static int acpi_processor_get_lpi_info(struct acpi_processor *pr)
 {
 	int ret, i;
@@ -1209,6 +1214,11 @@ static int acpi_processor_get_lpi_info(s
 	struct acpi_device *d = NULL;
 	struct acpi_lpi_states_array info[2], *tmp, *prev, *curr;
 
+	/* make sure our architecture has support */
+	ret = acpi_processor_ffh_lpi_probe(pr->id);
+	if (ret == -EOPNOTSUPP)
+		return ret;
+
 	if (!osc_pc_lpi_support_confirmed)
 		return -EOPNOTSUPP;
 
@@ -1260,11 +1270,6 @@ static int acpi_processor_get_lpi_info(s
 	return 0;
 }
 
-int __weak acpi_processor_ffh_lpi_probe(unsigned int cpu)
-{
-	return -ENODEV;
-}
-
 int __weak acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
 {
 	return -ENODEV;


