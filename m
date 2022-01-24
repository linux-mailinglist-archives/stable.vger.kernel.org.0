Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEBD49969E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345549AbiAXVFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:05:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47186 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391084AbiAXUqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:46:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9510DB812A4;
        Mon, 24 Jan 2022 20:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9761C340E5;
        Mon, 24 Jan 2022 20:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057213;
        bh=/CkJZbBS/noqHTVzt9gb1OaMJAK407vUfQxtvkkrFfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfwMs2jyL1H7yxkWFiogEhGmI6bFvi4chSMeM3WiB7BDIT/2BWoOm0+e/di7vabBE
         TBamEpfM5SoZPvQ7+tsTITRzlelkME2fPxM3y43cjs8DZL0eYUsozakPnDPUFFVx3a
         5LzidQX+yv7Gxv/8jVC23rBKsrDz1CfdHu+8F/24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 738/846] Documentation: ACPI: Fix data node reference documentation
Date:   Mon, 24 Jan 2022 19:44:15 +0100
Message-Id: <20220124184126.451066352@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit a11174952205d082f1658fab4314f0caf706e0a8 upstream.

The data node reference documentation was missing a package that must
contain the property values, instead property name and multiple values
being present in a single package. This is not aligned with the _DSD
spec.

Fix it by adding the package for the values.

Also add the missing "reg" properties to two numbered nodes.

Fixes: b10134a3643d ("ACPI: property: Document hierarchical data extension references")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/firmware-guide/acpi/dsd/data-node-references.rst |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/Documentation/firmware-guide/acpi/dsd/data-node-references.rst
+++ b/Documentation/firmware-guide/acpi/dsd/data-node-references.rst
@@ -5,7 +5,7 @@
 Referencing hierarchical data nodes
 ===================================
 
-:Copyright: |copy| 2018 Intel Corporation
+:Copyright: |copy| 2018, 2021 Intel Corporation
 :Author: Sakari Ailus <sakari.ailus@linux.intel.com>
 
 ACPI in general allows referring to device objects in the tree only.
@@ -52,12 +52,14 @@ the ANOD object which is also the final
 	    Name (NOD0, Package() {
 		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
 		Package () {
+		    Package () { "reg", 0 },
 		    Package () { "random-property", 3 },
 		}
 	    })
 	    Name (NOD1, Package() {
 		ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
 		Package () {
+		    Package () { "reg", 1 },
 		    Package () { "anothernode", "ANOD" },
 		}
 	    })
@@ -74,7 +76,11 @@ the ANOD object which is also the final
 	    Name (_DSD, Package () {
 		ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
 		Package () {
-		    Package () { "reference", ^DEV0, "node@1", "anothernode" },
+		    Package () {
+			"reference", Package () {
+			    ^DEV0, "node@1", "anothernode"
+			}
+		    },
 		}
 	    })
 	}


