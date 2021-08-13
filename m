Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9E13EB827
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241256AbhHMPLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:11:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241154AbhHMPKx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C3F2610CC;
        Fri, 13 Aug 2021 15:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867426;
        bh=Bl7y6ROz+05kOEXoTQ+ExpZSHGOR0lZZTTArOuW9SP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A70nl1vsAUllCYH3p5uzbCfd8DJfJ3fPtOzEz/LIKmh8MGaW0erf0LBilwBfAMZjH
         QW7Eod7kyox7yoRlyRNYXoTa0JzUZ6wFNnnSnFbx5pGuxTpQ5UWXFaPVw7Sfnt1AW3
         nNeGw2BP+yCU+TMYapl64gHHGurl6lP2rVK8NeTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrien Precigout <dev@asdrip.fr>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 01/42] Revert "ACPICA: Fix memory leak caused by _CID repair function"
Date:   Fri, 13 Aug 2021 17:06:27 +0200
Message-Id: <20210813150525.148259640@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150525.098817398@linuxfoundation.org>
References: <20210813150525.098817398@linuxfoundation.org>
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
@@ -409,13 +409,6 @@ acpi_ns_repair_CID(struct acpi_evaluate_
 
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


