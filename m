Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5035F6649C0
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238165AbjAJSYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239439AbjAJSXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:23:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B53DB1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:21:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C610ECE18D4
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E5BC433D2;
        Tue, 10 Jan 2023 18:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374886;
        bh=sivQZ7fBkirVjV4uvmddVbqfmKT1DffMkbAStZfykFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmdubQpqFmxxecQa/MTYkbpsWL205GoUddep6qG0eKRerVAIP/bzcg5SK4QWxuMF7
         NL/7bLTGWgTXklvgSw6mbDNT2aQ7xkRAE4+0ef58PcM22vhsXab1znRfKHBX+HJd50
         fHvrJQOuz6akU1LKXJBIN2djq+HViUGMr0YiJaKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 140/159] thermal: int340x: Add missing attribute for data rate base
Date:   Tue, 10 Jan 2023 19:04:48 +0100
Message-Id: <20230110180022.884499846@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit b878d3ba9bb41cddb73ba4b56e5552f0a638daca upstream.

Commit 473be51142ad ("thermal: int340x: processor_thermal: Add RFIM
driver")' added rfi_restriction_data_rate_base string, mmio details and
documentation, but missed adding attribute to sysfs.

Add missing sysfs attribute.

Fixes: 473be51142ad ("thermal: int340x: processor_thermal: Add RFIM driver")
Cc: 5.11+ <stable@vger.kernel.org> # v5.11+
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
@@ -172,6 +172,7 @@ static const struct attribute_group fivr
 RFIM_SHOW(rfi_restriction_run_busy, 1)
 RFIM_SHOW(rfi_restriction_err_code, 1)
 RFIM_SHOW(rfi_restriction_data_rate, 1)
+RFIM_SHOW(rfi_restriction_data_rate_base, 1)
 RFIM_SHOW(ddr_data_rate_point_0, 1)
 RFIM_SHOW(ddr_data_rate_point_1, 1)
 RFIM_SHOW(ddr_data_rate_point_2, 1)
@@ -181,11 +182,13 @@ RFIM_SHOW(rfi_disable, 1)
 RFIM_STORE(rfi_restriction_run_busy, 1)
 RFIM_STORE(rfi_restriction_err_code, 1)
 RFIM_STORE(rfi_restriction_data_rate, 1)
+RFIM_STORE(rfi_restriction_data_rate_base, 1)
 RFIM_STORE(rfi_disable, 1)
 
 static DEVICE_ATTR_RW(rfi_restriction_run_busy);
 static DEVICE_ATTR_RW(rfi_restriction_err_code);
 static DEVICE_ATTR_RW(rfi_restriction_data_rate);
+static DEVICE_ATTR_RW(rfi_restriction_data_rate_base);
 static DEVICE_ATTR_RO(ddr_data_rate_point_0);
 static DEVICE_ATTR_RO(ddr_data_rate_point_1);
 static DEVICE_ATTR_RO(ddr_data_rate_point_2);
@@ -248,6 +251,7 @@ static struct attribute *dvfs_attrs[] =
 	&dev_attr_rfi_restriction_run_busy.attr,
 	&dev_attr_rfi_restriction_err_code.attr,
 	&dev_attr_rfi_restriction_data_rate.attr,
+	&dev_attr_rfi_restriction_data_rate_base.attr,
 	&dev_attr_ddr_data_rate_point_0.attr,
 	&dev_attr_ddr_data_rate_point_1.attr,
 	&dev_attr_ddr_data_rate_point_2.attr,


