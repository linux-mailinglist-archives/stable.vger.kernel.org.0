Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083833E5CDA
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242439AbhHJOP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242372AbhHJOPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:15:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A6E360F41;
        Tue, 10 Aug 2021 14:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604927;
        bh=T/67Tow/psOEgY9EDGLlWov3WbyBqHix91AGPcj2dNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PH6xDufp55Gwp7EEkWCWVXQOVsSeRGDa24KTz82AUTLNDzFJQNRLDE2juG/2CJFCl
         eWeX86xTDllsk/GZdLJFJVW2I5bfxRSU2DQBgHa+NwLkAZm4Cv+DNu0YBLcecTyosB
         ca12Qj4P/fNbKWl02ahdThKlHSff/x4s+MzMR53PbZmIs94mo7L4EZmZbzNl8MYNkE
         l+5dJjK03vCywq66kGy/o6UQvL7xtYifqmdjhLeaVHB0h2jzK2Y7u78UR2+HpwTc8b
         gOXumnQupdR49t7A2pXDcF2e49mpa2/XmsCa5AOKEJIs0V7p5mPLiap8yOf4ID0OiP
         flJ47wQoOVgoA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Adrien Precigout <dev@asdrip.fr>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.13 16/24] Revert "ACPICA: Fix memory leak caused by _CID repair function"
Date:   Tue, 10 Aug 2021 10:14:57 -0400
Message-Id: <20210810141505.3117318-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141505.3117318-1-sashal@kernel.org>
References: <20210810141505.3117318-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 6511a8b5b7a65037340cd8ee91a377811effbc83 ]

Revert commit c27bac0314131 ("ACPICA: Fix memory leak caused by _CID
repair function") which is reported to cause a boot issue on Acer
Swift 3 (SF314-51).

Reported-by: Adrien Precigout <dev@asdrip.fr>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/nsrepair2.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/acpi/acpica/nsrepair2.c b/drivers/acpi/acpica/nsrepair2.c
index 38e10ab976e6..14b71b41e845 100644
--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -379,13 +379,6 @@ acpi_ns_repair_CID(struct acpi_evaluate_info *info,
 
 			(*element_ptr)->common.reference_count =
 			    original_ref_count;
-
-			/*
-			 * The original_element holds a reference from the package object
-			 * that represents _HID. Since a new element was created by _HID,
-			 * remove the reference from the _CID package.
-			 */
-			acpi_ut_remove_reference(original_element);
 		}
 
 		element_ptr++;
-- 
2.30.2

