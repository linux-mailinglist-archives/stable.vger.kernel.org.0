Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05C03E5D9E
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241343AbhHJOWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:22:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240543AbhHJOSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A058610FD;
        Tue, 10 Aug 2021 14:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628605013;
        bh=cBAyOu+vxxDyr6zPBRNkl7ThswXP6jbsBSCyyefGmJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rcLA1wX6kHUTy6HGpSrAa3zzk2mI9MY43hIOGd8RgXuOimWWImxg5wJvSbqeQ+woC
         0H/4bSTDz7Czob4XxXKqrRDsV96ibOsVYt3KdKLd6Nqh0kAEaxaSDwHLzNO3+nbHtf
         SxhuxbhHH7GNuJTjpwFs+XcsDpGHFOqBg0gZyxzdlvAhh61wVBQsgBxpnooIlpUwf7
         WAW1QCO28K2umD8rPmDwbnksG2hOlBXaJahx/0zWEzYbeqoWsHygd1DXc7FDOs123E
         C1WPUWYnVc1QElbJmKWYMqr3qY4CajaJZcye2mVPIi/J+LW4OeHYIIGId4SC6xZ+In
         GhxiPNGCO/WfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Adrien Precigout <dev@asdrip.fr>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 4.14 09/10] Revert "ACPICA: Fix memory leak caused by _CID repair function"
Date:   Tue, 10 Aug 2021 10:16:40 -0400
Message-Id: <20210810141641.3118360-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141641.3118360-1-sashal@kernel.org>
References: <20210810141641.3118360-1-sashal@kernel.org>
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
index 78b802b5f7d3..06037e044694 100644
--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -409,13 +409,6 @@ acpi_ns_repair_CID(struct acpi_evaluate_info *info,
 
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

