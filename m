Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71904990A8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347180AbiAXUCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:02:41 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56772 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347427AbiAXUAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:00:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E159D61028;
        Mon, 24 Jan 2022 20:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA22BC340E5;
        Mon, 24 Jan 2022 20:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054428;
        bh=l0GpjSvIxki+YLVBG10eC3DNjPlwaQrzUJ48btOsIBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F953C4IUAQVRynS524oIPrNVDYQzrydgNmibd/89IS/BpVR9UDOK9Ap/YlSRMdZ7e
         tm/oWipR/LDaM8/bFyqpmIQxdsbb8KfstikcpN2XFrqLAkavJ2EmIZnEAlTXvB81QD
         ldLe0OsEIsmKW9RBTUV01sJNRrEp2R1v0W6QR+PE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Langsdorf <mlangsdo@redhat.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 385/563] ACPICA: actypes.h: Expand the ACPI_ACCESS_ definitions
Date:   Mon, 24 Jan 2022 19:42:30 +0100
Message-Id: <20220124184037.743109630@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 647cb11d0a0a3..7334037624c5c 100644
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



