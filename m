Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E7E3E7F74
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbhHJRkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235139AbhHJRjW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:39:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14D2E61101;
        Tue, 10 Aug 2021 17:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617018;
        bh=Do6S9tWsL50rvbJAWA7Y25g1Mhue883Dv9sJ0GOnHvo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EUR3A/p0V2j/h9WyiynASq5uNIvq6hkLxWvrOdv15+735p7vzkyoemk5N/ZDmUQU3
         JrBryIsLjyZl+vXTY0cdTzyBz898v1V6a70E3HIdR7nF76uVUh8onsXN3CER1bIi01
         TVBqcLl600fFpuUBRBezJBnIQR/Dks82I52GL4o0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrien Precigout <dev@asdrip.fr>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 001/135] Revert "ACPICA: Fix memory leak caused by _CID repair function"
Date:   Tue, 10 Aug 2021 19:28:55 +0200
Message-Id: <20210810172955.711732308@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 6511a8b5b7a65037340cd8ee91a377811effbc83 upstream.

Revert commit c27bac0314131 ("ACPICA: Fix memory leak caused by _CID
repair function") which is reported to cause a boot issue on Acer
Swift 3 (SF314-51).

Reported-by: Adrien Precigout <dev@asdrip.fr>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpica/nsrepair2.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/acpi/acpica/nsrepair2.c
+++ b/drivers/acpi/acpica/nsrepair2.c
@@ -375,13 +375,6 @@ acpi_ns_repair_CID(struct acpi_evaluate_
 
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


