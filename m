Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261DD28B6CB
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388142AbgJLNhl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:37:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731011AbgJLNhP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:37:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D5D621D81;
        Mon, 12 Oct 2020 13:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509811;
        bh=Vg1T2YZp02cZX+Ff+PnbpejyRUOriqiX5Ovu8vTRhfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JpBSX2Gv2NoxjjOzj87X2zzAGFAOx+/nAGcUfzWEsVKu9kRPeoYLzmuQxVHT1rPJx
         diGcF6iNDmytdEpjwMbkomOJ/nbFrQ/c2IQumAWIpP9dY6GqQ3pTbKcenLvj44+Ray
         yhZQ4fXpQZA8X4GMNF3vIlY0zz0n+6fLQ4irKRMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.14 39/70] platform/x86: thinkpad_acpi: re-initialize ACPI buffer size when reuse
Date:   Mon, 12 Oct 2020 15:26:55 +0200
Message-Id: <20201012132632.060315100@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aaron Ma <aaron.ma@canonical.com>

commit 720ef73d1a239e33c3ad8fac356b9b1348e68aaf upstream.

Evaluating ACPI _BCL could fail, then ACPI buffer size will be set to 0.
When reuse this ACPI buffer, AE_BUFFER_OVERFLOW will be triggered.

Re-initialize buffer size will make ACPI evaluate successfully.

Fixes: 46445b6b896fd ("thinkpad-acpi: fix handle locate for video and query of _BCL")
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/thinkpad_acpi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6749,8 +6749,10 @@ static int __init tpacpi_query_bcl_level
 	list_for_each_entry(child, &device->children, node) {
 		acpi_status status = acpi_evaluate_object(child->handle, "_BCL",
 							  NULL, &buffer);
-		if (ACPI_FAILURE(status))
+		if (ACPI_FAILURE(status)) {
+			buffer.length = ACPI_ALLOCATE_BUFFER;
 			continue;
+		}
 
 		obj = (union acpi_object *)buffer.pointer;
 		if (!obj || (obj->type != ACPI_TYPE_PACKAGE)) {


