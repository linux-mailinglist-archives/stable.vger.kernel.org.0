Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6416AF37D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbjCGTFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233639AbjCGTFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:05:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651D7BBB27
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:50:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C7029CE1C8B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EAEC433D2;
        Tue,  7 Mar 2023 18:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215018;
        bh=zVFlCUq2KS03cQbskNWRfL1KcKptZvzyvobziaxmBTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JrxDPoiy0XPAtP+lW1vFGfGBhGVUVIk4rzk9CAMoccFnYXcNM5wXPBIbdNye6U7Cy
         lD+XkozpE1LpNah5BVej7TZLjVqUpyVTAF9R+zE4pNRtV9e+JFeUyX5QepUoM2tdXY
         tSRNodbca4SiLrDhW2CHct5ed/iEtnOqje9Vidvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniil Tatianin <d-tatianin@yandex-team.ru>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/567] ACPICA: nsrepair: handle cases without a return value correctly
Date:   Tue,  7 Mar 2023 17:57:09 +0100
Message-Id: <20230307165909.911004241@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit ca843a4c79486e99a19b859ef0b9887854afe146 ]

Previously acpi_ns_simple_repair() would crash if expected_btypes
contained any combination of ACPI_RTYPE_NONE with a different type,
e.g | ACPI_RTYPE_INTEGER because of slightly incorrect logic in the
!return_object branch, which wouldn't return AE_AML_NO_RETURN_VALUE
for such cases.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Link: https://github.com/acpica/acpica/pull/811
Fixes: 61db45ca2163 ("ACPICA: Restore code that repairs NULL package elements in return values.")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/nsrepair.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpica/nsrepair.c b/drivers/acpi/acpica/nsrepair.c
index 499067daa22c6..1b8677f2ced37 100644
--- a/drivers/acpi/acpica/nsrepair.c
+++ b/drivers/acpi/acpica/nsrepair.c
@@ -181,8 +181,9 @@ acpi_ns_simple_repair(struct acpi_evaluate_info *info,
 	 * Try to fix if there was no return object. Warning if failed to fix.
 	 */
 	if (!return_object) {
-		if (expected_btypes && (!(expected_btypes & ACPI_RTYPE_NONE))) {
-			if (package_index != ACPI_NOT_PACKAGE_ELEMENT) {
+		if (expected_btypes) {
+			if (!(expected_btypes & ACPI_RTYPE_NONE) &&
+			    package_index != ACPI_NOT_PACKAGE_ELEMENT) {
 				ACPI_WARN_PREDEFINED((AE_INFO,
 						      info->full_pathname,
 						      ACPI_WARN_ALWAYS,
@@ -196,14 +197,15 @@ acpi_ns_simple_repair(struct acpi_evaluate_info *info,
 				if (ACPI_SUCCESS(status)) {
 					return (AE_OK);	/* Repair was successful */
 				}
-			} else {
+			}
+
+			if (expected_btypes != ACPI_RTYPE_NONE) {
 				ACPI_WARN_PREDEFINED((AE_INFO,
 						      info->full_pathname,
 						      ACPI_WARN_ALWAYS,
 						      "Missing expected return value"));
+				return (AE_AML_NO_RETURN_VALUE);
 			}
-
-			return (AE_AML_NO_RETURN_VALUE);
 		}
 	}
 
-- 
2.39.2



