Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCEEB498E49
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355163AbiAXTkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:40:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58070 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354158AbiAXTgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:36:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0C12B810AF;
        Mon, 24 Jan 2022 19:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AD4C340E5;
        Mon, 24 Jan 2022 19:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052965;
        bh=17uZWNwcuXXwaurrShXeLBZ0t+Jwvjam9BBI+xKfecg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsCObvFyeFtQSKB2P5j/QDzrQ/02w3AEol8NWkA8I7OsyHK5OVMAi/cPFWxzg8+1q
         FlYyp+zpZ4+Jop5nyfK70XRunHYXwyqeLvdW7pLX//Rh29FPha0e1L4pGQoS+a704R
         U3q/b2ZYB/x9KhMpEmqt0Qr6aw3Qk9HP4grLMVaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Langsdorf <mlangsdo@redhat.com>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 204/320] ACPICA: actypes.h: Expand the ACPI_ACCESS_ definitions
Date:   Mon, 24 Jan 2022 19:43:08 +0100
Message-Id: <20220124184000.573255237@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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



