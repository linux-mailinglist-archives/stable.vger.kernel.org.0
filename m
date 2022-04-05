Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E434F256F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiDEHt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbiDEHry (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF6793192;
        Tue,  5 Apr 2022 00:44:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0765661607;
        Tue,  5 Apr 2022 07:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFDEC340EE;
        Tue,  5 Apr 2022 07:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144678;
        bh=V+55jqt3IyHFsKthzO2N2W+UTW06gaSYVGI+xjHVEU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEnqYt1Ihr0CSSdX5epF7VmQSS6KU7mqMJ4dw6shfBoS9jGybKK5Sm+Rwpst/9KM5
         jO0sHPI8SpOx5wE5JILpbDAOWGJDvj/H0oqrnTFEPQ653JeVzpnZpMiQMXa97YVaTY
         6J87uwfQ6030KLwUrRzRwws/6xm9U6krvpngxBTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <Mario.Limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.17 0130/1126] Revert "ACPI: Pass the same capabilities to the _OSC regardless of the query flag"
Date:   Tue,  5 Apr 2022 09:14:37 +0200
Message-Id: <20220405070411.393115006@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 2ca8e6285250c07a2e5a22ecbfd59b5a4ef73484 upstream.

Revert commit 159d8c274fd9 ("ACPI: Pass the same capabilities to the
_OSC regardless of the query flag") which caused legitimate usage
scenarios (when the platform firmware does not want the OS to control
certain platform features controlled by the system bus scope _OSC) to
break and was misguided by some misleading language in the _OSC
definition in the ACPI specification (in particular, Section 6.2.11.1.3
"Sequence of _OSC Calls" that contradicts other perts of the _OSC
definition).

Link: https://lore.kernel.org/linux-acpi/CAJZ5v0iStA0JmO0H3z+VgQsVuQONVjKPpw0F5HKfiq=Gb6B5yw@mail.gmail.com
Reported-by: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/bus.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -332,21 +332,32 @@ static void acpi_bus_osc_negotiate_platf
 	if (ACPI_FAILURE(acpi_run_osc(handle, &context)))
 		return;
 
-	kfree(context.ret.pointer);
+	capbuf_ret = context.ret.pointer;
+	if (context.ret.length <= OSC_SUPPORT_DWORD) {
+		kfree(context.ret.pointer);
+		return;
+	}
 
-	/* Now run _OSC again with query flag clear */
+	/*
+	 * Now run _OSC again with query flag clear and with the caps
+	 * supported by both the OS and the platform.
+	 */
 	capbuf[OSC_QUERY_DWORD] = 0;
+	capbuf[OSC_SUPPORT_DWORD] = capbuf_ret[OSC_SUPPORT_DWORD];
+	kfree(context.ret.pointer);
 
 	if (ACPI_FAILURE(acpi_run_osc(handle, &context)))
 		return;
 
 	capbuf_ret = context.ret.pointer;
-	osc_sb_apei_support_acked =
-		capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_APEI_SUPPORT;
-	osc_pc_lpi_support_confirmed =
-		capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_PCLPI_SUPPORT;
-	osc_sb_native_usb4_support_confirmed =
-		capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_NATIVE_USB4_SUPPORT;
+	if (context.ret.length > OSC_SUPPORT_DWORD) {
+		osc_sb_apei_support_acked =
+			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_APEI_SUPPORT;
+		osc_pc_lpi_support_confirmed =
+			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_PCLPI_SUPPORT;
+		osc_sb_native_usb4_support_confirmed =
+			capbuf_ret[OSC_SUPPORT_DWORD] & OSC_SB_NATIVE_USB4_SUPPORT;
+	}
 
 	kfree(context.ret.pointer);
 }


