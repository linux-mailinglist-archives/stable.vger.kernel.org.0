Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE94491A75
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352383AbiARC7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:59:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42052 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345833AbiARCsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:48:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5846D61294;
        Tue, 18 Jan 2022 02:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E85C36AF6;
        Tue, 18 Jan 2022 02:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474118;
        bh=FNVb3dcHIBLomxyIdcLDZf6bDvbLp1BTjjK8xjoWU5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m23FwRri3RvkE986WqbOH4boIY34Pyuwn1TDkQAbf+CMHB8Jfgpig+oomcKmXO6Sa
         e7MTtdi/9Qtas3aYix1/edgf/XoesFjBdqKDYJ6RQi1w9eh/nlb+Rf/eowxQg80/0Y
         UxAYdthg1u8rAntZSbRkefXl0/uVr37/JmE/2g2NFN9c0DfNeAwmi2B0+AbNjMvfeT
         GsLgwIzlB/cqP0/ahVccd2LEotupAsWmBXaJ1v+QatX80sBvchqBBiYnYPWcSfjsIC
         dZ5iZ8c0Y7DoXycUz8KrjyaYKQwrE9ZsREFFPVD617F1sD4nxmu34kUimZx9WcGj1W
         t53QJHTggdsWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Langsdorf <mlangsdo@redhat.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 4.19 42/59] ACPICA: actypes.h: Expand the ACPI_ACCESS_ definitions
Date:   Mon, 17 Jan 2022 21:46:43 -0500
Message-Id: <20220118024701.1952911-42-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024701.1952911-1-sashal@kernel.org>
References: <20220118024701.1952911-1-sashal@kernel.org>
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
index 2939a6cd7fecb..9fc1dfc7f4c32 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -532,8 +532,14 @@ typedef u64 acpi_integer;
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

