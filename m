Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E963A62AA
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 13:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbhFNLDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 07:03:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233830AbhFNLAp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 07:00:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C49FA6162F;
        Mon, 14 Jun 2021 10:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667391;
        bh=yP091ATsF9sSYq3kWijW/heKOsq+HSjUAsAoy4i+UiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AkqhyDcN85NIjaoYR+1UMUHKqRjfRiFNK2H/eka4V1is9gESB8aGKWgTLc7Qu7ArU
         TdMu9N7oK33JNfELsRgBtB8mmgJOYGYpo1a766GnRGCTu3wRxQYqnB/+jCxAEWn1fb
         8aYDWGP/hUBQtho05eAp3rv4TXqKUrKeRpXWAxIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Hohe <sth.dev@tejp.de>,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 053/131] Revert "ACPI: sleep: Put the FACS table after using it"
Date:   Mon, 14 Jun 2021 12:26:54 +0200
Message-Id: <20210614102654.826578905@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102652.964395392@linuxfoundation.org>
References: <20210614102652.964395392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

commit f1ffa9d4cccc8fdf6c03fb1b3429154d22037988 upstream.

Commit 95722237cb2a ("ACPI: sleep: Put the FACS table after using it")
puts the FACS table during initialization.

But the hardware signature bits in the FACS table need to be accessed,
after every hibernation, to compare with the original hardware
signature.

So there is no reason to release the FACS table mapping after
initialization.

This reverts commit 95722237cb2ae4f7b73471058cdb19e8f4057c93.

An alternative solution is to use acpi_gbl_FACS variable instead, which
is mapped by the ACPICA core and never released.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=212277
Reported-by: Stephan Hohe <sth.dev@tejp.de>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Cc: 5.8+ <stable@vger.kernel.org> # 5.8+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/sleep.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -1290,10 +1290,8 @@ static void acpi_sleep_hibernate_setup(v
 		return;
 
 	acpi_get_table(ACPI_SIG_FACS, 1, (struct acpi_table_header **)&facs);
-	if (facs) {
+	if (facs)
 		s4_hardware_signature = facs->hardware_signature;
-		acpi_put_table((struct acpi_table_header *)facs);
-	}
 }
 #else /* !CONFIG_HIBERNATION */
 static inline void acpi_sleep_hibernate_setup(void) {}


