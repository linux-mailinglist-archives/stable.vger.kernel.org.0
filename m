Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6803E5D79
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241094AbhHJOUE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243149AbhHJOSE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:18:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45D276024A;
        Tue, 10 Aug 2021 14:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604999;
        bh=h1B/iAWbC/Ujk+7bkx1aAwKMlZWFcRfIRTS2gNnUtS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4xpER+4hYUJ1Df47aStV1t9cjeyYEy3UHAHU3vOP/pOSfH0/ilmgLfgVaJM8I92k
         sBg2CnPFGVoYJLSUJ3RnupBZxXfPD1ypgfAHMbpmbHPm1oMC4Zy4GwGYKNS0iIvqz1
         9g3xPJwA8wRj1X6hI4SSisbL8EHriRxNpjNxJZp/2I9nREWAux4hNDZwNp/MD3SbLp
         vOSD6McDfcCQc19gLEKjWJz5NpR6cFn2FpDUcdltipDBaPpELm3npo+ccvBOpQY7lr
         dB2OiqLUHFNasRo4lMKk0DhDPaGCQ9sO69604XIWPpFuSKqXkAxgUhD4zDIiG10FxU
         zxrPE5OxrlEUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Adrien Precigout <dev@asdrip.fr>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 4.19 10/11] Revert "ACPICA: Fix memory leak caused by _CID repair function"
Date:   Tue, 10 Aug 2021 10:16:23 -0400
Message-Id: <20210810141625.3118097-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141625.3118097-1-sashal@kernel.org>
References: <20210810141625.3118097-1-sashal@kernel.org>
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
index 4c8ce483805d..a3bd6280882c 100644
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

