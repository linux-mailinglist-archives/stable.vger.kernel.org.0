Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D813E5D4B
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242756AbhHJOSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:53856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242751AbhHJOQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:16:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1B7761100;
        Tue, 10 Aug 2021 14:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604980;
        bh=OrP3N2oIAEF39lwPt9uLzLIaN8jnmwa8q+zzqhPiHJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TX2JWEuUaWhQxsUJZZpVqlrgXtuJqpYWj4TlUNYnkOklunrMJYAlI4vSD5YaOqxWj
         wb2t1azLC1onDi4e2TGmQzesVmrTigqvCnp2wlFRULbFMlaYBNNgd3J1xl8Lg2LPCY
         XBx/jLs0ctYfZLlaWgx0jvBYX2H3tRUIbdobBWW7VJWTqfG3nyH8qPFDpYHqqf9Kr+
         bgHEsVblK54xmuJSFCsx4MwBdzIfq0Jt2v69o+RQ8G0ytPSKbh6hCRN62vl9JKFW5i
         AkVftNO0G/uwc1XzmbEghztQWas8oPJGnACsCKixjEVpCZE00QKC4f7sWfPfrJ37HN
         LjHI1+H024hSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Adrien Precigout <dev@asdrip.fr>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.4 11/13] Revert "ACPICA: Fix memory leak caused by _CID repair function"
Date:   Tue, 10 Aug 2021 10:16:03 -0400
Message-Id: <20210810141606.3117932-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141606.3117932-1-sashal@kernel.org>
References: <20210810141606.3117932-1-sashal@kernel.org>
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
index b7c408ce340c..663d85e0adba 100644
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

