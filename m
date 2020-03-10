Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECEA117FC5F
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730884AbgCJNGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:06:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728197AbgCJNGt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:06:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92A9420873;
        Tue, 10 Mar 2020 13:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845609;
        bh=iEGtXTNiqZ5sudgaIw3kA5MEwg/pCQ0S2xSXgV40sNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBw4x/URmtL8wx0WaxqAQkTkoJ4qyFJfAhW00cLfGR43hFTidx3G9iXZVCPH+Rt11
         RlVuUqpbkJAttFNtdLZZb4OO53RohaFccdf+JVnHoJLtnxkmfqlm4acHNveBZ0IwOj
         nW3FxGK2sUKqwhSn6p059b9i3QF+k956GX64doSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 036/126] ACPICA: Introduce ACPI_ACCESS_BYTE_WIDTH() macro
Date:   Tue, 10 Mar 2020 13:40:57 +0100
Message-Id: <20200310124206.687601253@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 1dade3a7048ccfc675650cd2cf13d578b095e5fb upstream.

Sometimes it is useful to find the access_width field value in bytes and
not in bits so add a helper that can be used for this purpose.

Suggested-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Cc: 4.16+ <stable@vger.kernel.org> # 4.16+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/acpi/actypes.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -556,11 +556,12 @@ typedef u64 acpi_integer;
 #define ACPI_MAKE_RSDP_SIG(dest)        (memcpy (ACPI_CAST_PTR (char, (dest)), ACPI_SIG_RSDP, 8))
 
 /*
- * Algorithm to obtain access bit width.
+ * Algorithm to obtain access bit or byte width.
  * Can be used with access_width of struct acpi_generic_address and access_size of
  * struct acpi_resource_generic_register.
  */
 #define ACPI_ACCESS_BIT_WIDTH(size)     (1 << ((size) + 2))
+#define ACPI_ACCESS_BYTE_WIDTH(size)    (1 << ((size) - 1))
 
 /*******************************************************************************
  *


