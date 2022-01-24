Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEEC49A94F
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322441AbiAYDVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355551AbiAXUWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:22:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89917C0417CE;
        Mon, 24 Jan 2022 11:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51E28B81215;
        Mon, 24 Jan 2022 19:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CE8C340E5;
        Mon, 24 Jan 2022 19:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053209;
        bh=/CkJZbBS/noqHTVzt9gb1OaMJAK407vUfQxtvkkrFfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2LiZgTyZEXUnOWd2dJuGh+dWOk+/XFW2H4Rcno9IhEuXu4fRrmSginiCXvN9aJS51
         TQUJ9jxSzQBnCWVUBoZ1ae9PohqAh1Xv1gTgdnvRIfOTf14qXFqU8NYKJTZ5sfTFME
         mhcTRd7c9ro1rZogPO+1GkUXQE7KOc0pXv5Q0O94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 278/320] Documentation: ACPI: Fix data node reference documentation
Date:   Mon, 24 Jan 2022 19:44:22 +0100
Message-Id: <20220124184003.431781304@linuxfoundation.org>
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


