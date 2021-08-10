Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD953E5D15
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242804AbhHJORA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242401AbhHJOQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:16:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB21160F02;
        Tue, 10 Aug 2021 14:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604959;
        bh=/oB2UE8jOnRL1guBpCaQUOs0Yy9zo16YZNOX1+5BSEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NA4xJCVMYC/3GrfMWnrqLVUrs+v91ZEkuIlkdbv7qS4PXo9s8bwQQ+AGmcd+eCFCk
         8pg7eIF8PSMvM8N9g3zCpz7lz2Ul9lFj2RP1TVswmGgIL4SavSPJZJjV9VU3C1OUS4
         VSj1/aSjaIUfcXyxncU4n2/bu/oVr9CNcagH/kkDHBPhYPPhJR8CkcJkrTXojHMdKR
         tbPeEsrahS91+IeWP75DlyeaMzLV8dhv/ZyTLMv+hIhw3MHdnq5nJCiW8v8uwKJ424
         9tZ4PGn6FxPrL+ROJdqZ2pzUeZOAKoMXPcZrKxT8NEzPgAhLz9WasNMsv9TT4Pg1H+
         /Kx7TWYTYO6Zw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Adrien Precigout <dev@asdrip.fr>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.10 16/20] Revert "ACPICA: Fix memory leak caused by _CID repair function"
Date:   Tue, 10 Aug 2021 10:15:34 -0400
Message-Id: <20210810141538.3117707-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141538.3117707-1-sashal@kernel.org>
References: <20210810141538.3117707-1-sashal@kernel.org>
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
index 8768594c79e5..125143c41bb8 100644
--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -375,13 +375,6 @@ acpi_ns_repair_CID(struct acpi_evaluate_info *info,
 
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

