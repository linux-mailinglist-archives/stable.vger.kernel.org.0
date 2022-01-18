Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5944E491629
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343502AbiARCdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:33:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40746 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344241AbiARC3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:29:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E8ACB81238;
        Tue, 18 Jan 2022 02:29:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D5EC36AE3;
        Tue, 18 Jan 2022 02:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472962;
        bh=hY4UWMyFSq0Q4bgph2NQBK7SyoqPgPe9sNmHDQXYo1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGy8GpeHvxWv3uoV99vqp+GdiXcBW1b++/lv2N0HW+0nhNWYRSbFZRSS4WP85Qe27
         bfPCpW2bYhBRqs/J/OGPqoei6xDo96hJyFUFpHbmVoqxEJ4j2rIwj0iDKXnqkA6pQI
         KSRU5jnDwAfuSyTNEfdyrAaoQYVQwdcDibzxjjPlDsx70ZRjNEOJl3T1YpfnpeCWdN
         oZIaDyoj752+t042MgPfdMSAW+wwtDynciDsYkkFMsOY3Rbg2CqBzGMA3qTSU4MtXx
         K8I3vPP8AvtAnal4asrA83FI1VSvtHVll2y3elKEPN8ajdOX0GncL2QkZ98MAfdNdI
         Ct1mChzBO90VA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Langsdorf <mlangsdo@redhat.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org, devel@acpica.org
Subject: [PATCH AUTOSEL 5.16 179/217] ACPICA: actypes.h: Expand the ACPI_ACCESS_ definitions
Date:   Mon, 17 Jan 2022 21:19:02 -0500
Message-Id: <20220118021940.1942199-179-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index ff8b3c913f217..248242dca28d3 100644
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

