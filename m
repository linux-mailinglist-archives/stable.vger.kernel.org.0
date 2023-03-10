Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1835F6B4777
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbjCJOux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbjCJOty (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:49:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE02125AC9
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:47:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 469B4618A6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05482C4339B;
        Fri, 10 Mar 2023 14:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459671;
        bh=HGxm2KsIGxWWV6Kb5hnz87IfWmMiVzUjpLjz+EfiUWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHCkHSn039ZAkTEjOjLccn1Fw2U+BzAo9jv/CW65bCnXquv5U3R6e0vWYdvucWh3d
         /aS2GeAq9HOYmAp9pfrcxFbDlYxIvvxx3zwztQ43fWsDSn3OHlNmROArvw4iNv6XkE
         6ZbIv+99GZ2KNoJDtne/rKhdUufhfkLWRTVeTVV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniil Tatianin <d-tatianin@yandex-team.ru>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/529] ACPICA: nsrepair: handle cases without a return value correctly
Date:   Fri, 10 Mar 2023 14:33:43 +0100
Message-Id: <20230310133808.692518730@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index 90db2d85e7f5c..f28d811a3724d 100644
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



