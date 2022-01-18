Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0898C491A38
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351120AbiARC64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:58:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39032 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344713AbiARCqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:46:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E150612D4;
        Tue, 18 Jan 2022 02:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A776BC36AE3;
        Tue, 18 Jan 2022 02:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473989;
        bh=17uZWNwcuXXwaurrShXeLBZ0t+Jwvjam9BBI+xKfecg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Plj7oO/YiZdCmpmG1pMWuY7iiVz/6AnvvTcAcTymjxbDkXP0Sgm13ELsaIBPmCEym
         0qCBRhFSNfQurvcHyfOG8jU2zNk8aAtdq8b2JaL5H4uyez8O7gWl1/MqKNMdi37iMZ
         J1tS/zQ6JNH0IAFArc5qjIWfCymNE91WtoVzf7LNLVyg4Z2ErjXZHQPuky5gPqpVJb
         GOIoAg2T5q90S/w5ualn+MGZrRNyGbjRvqG8gC26xz+kfpqUY9u/Ufj+3duFOqm10g
         xuIygMHPoqL66zocExaHkdDcoKleEkqvDpspCr1X+B1ZwXlse/o5Ti3VfojXiGV1+E
         iUBMOAgdMC7eg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Langsdorf <mlangsdo@redhat.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.4 54/73] ACPICA: actypes.h: Expand the ACPI_ACCESS_ definitions
Date:   Mon, 17 Jan 2022 21:44:13 -0500
Message-Id: <20220118024432.1952028-54-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Langsdorf <mlangsdo@redhat.com>

[ Upstream commit f81bdeaf816142e0729eea0cc84c395ec9673151 ]

ACPICA commit bc02c76d518135531483dfc276ed28b7ee632ce1

The current ACPI_ACCESS_*_WIDTH defines do not provide a way to
test that size is small enough to not cause an overflow when
applied to a 32-bit integer.

Rather than adding more magic numbers, add ACPI_ACCESS_*_SHIFT,
ACPI_ACCESS_*_MAX, and ACPI_ACCESS_*_DEFAULT #defines and
redefine ACPI_ACCESS_*_WIDTH in terms of the new #defines.

This was inititally reported on Linux where a size of 102 in
ACPI_ACCESS_BIT_WIDTH caused an overflow error in the SPCR
initialization code.

Link: https://github.com/acpica/acpica/commit/bc02c76d
Signed-off-by: Mark Langsdorf <mlangsdo@redhat.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/acpi/actypes.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 9373662cdb44f..ff5fecff51167 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -536,8 +536,14 @@ typedef u64 acpi_integer;
  * Can be used with access_width of struct acpi_generic_address and access_size of
  * struct acpi_resource_generic_register.
  */
-#define ACPI_ACCESS_BIT_WIDTH(size)     (1 << ((size) + 2))
-#define ACPI_ACCESS_BYTE_WIDTH(size)    (1 << ((size) - 1))
+#define ACPI_ACCESS_BIT_SHIFT		2
+#define ACPI_ACCESS_BYTE_SHIFT		-1
+#define ACPI_ACCESS_BIT_MAX		(31 - ACPI_ACCESS_BIT_SHIFT)
+#define ACPI_ACCESS_BYTE_MAX		(31 - ACPI_ACCESS_BYTE_SHIFT)
+#define ACPI_ACCESS_BIT_DEFAULT		(8 - ACPI_ACCESS_BIT_SHIFT)
+#define ACPI_ACCESS_BYTE_DEFAULT	(8 - ACPI_ACCESS_BYTE_SHIFT)
+#define ACPI_ACCESS_BIT_WIDTH(size)	(1 << ((size) + ACPI_ACCESS_BIT_SHIFT))
+#define ACPI_ACCESS_BYTE_WIDTH(size)	(1 << ((size) + ACPI_ACCESS_BYTE_SHIFT))
 
 /*******************************************************************************
  *
-- 
2.34.1

