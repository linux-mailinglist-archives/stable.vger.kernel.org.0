Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50FF14225
	for <lists+stable@lfdr.de>; Sun,  5 May 2019 21:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfEETpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 May 2019 15:45:01 -0400
Received: from mail1.windriver.com ([147.11.146.13]:33338 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfEETpB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 May 2019 15:45:01 -0400
Received: from ALA-HCB.corp.ad.wrs.com ([147.11.189.41])
        by mail1.windriver.com (8.15.2/8.15.1) with ESMTPS id x45JitCq003528
        (version=TLSv1 cipher=AES128-SHA bits=128 verify=FAIL);
        Sun, 5 May 2019 12:44:55 -0700 (PDT)
Received: from yow-pgortmak-d1.corp.ad.wrs.com (128.224.56.57) by
 ALA-HCB.corp.ad.wrs.com (147.11.189.41) with Microsoft SMTP Server id
 14.3.439.0; Sun, 5 May 2019 12:44:48 -0700
Received: by yow-pgortmak-d1.corp.ad.wrs.com (Postfix, from userid 1000)        id
 5DA002E04E4; Sun,  5 May 2019 15:44:48 -0400 (EDT)
Date:   Sun, 5 May 2019 15:44:48 -0400
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Erik Schmauss <erik.schmauss@intel.com>
Subject: Possible mis-backport of 4abb951b in 4.19.35 ("ACPICA: AML
 interpreter: add region addresses...")
Message-ID: <20190505194448.GA2649@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I noticed 4.19.35 got a backport of mainline 4abb951b, but it appears to
be a duplicate backport that landed in the wrong function.  We can see
this in the stable-queue repo:

stable-queue$ find . -name '*acpica-aml-interpreter-add-region-addr*' |grep 4.19
./releases/4.19.6/acpica-aml-interpreter-add-region-addresses-in-global-list-during-initialization.patch
./releases/4.19.3/revert-acpica-aml-interpreter-add-region-addresses-in.patch
./releases/4.19.35/acpica-aml-interpreter-add-region-addresses-in-global-list-during-initialization.patch
./releases/4.19.2/acpica-aml-interpreter-add-region-addresses-in-global-list-during-initialization.patch

So it was added to 4.19.2, reverted in .3, re-added in .6, and then
finally patched into a similar looking but wrong function in .35

If we diff the .6 and .35 versions, we see the function difference:

-@@ -417,6 +417,10 @@ acpi_ds_eval_region_operands(struct acpi
+@@ -523,6 +523,10 @@ acpi_ds_eval_table_region_operands(struc

I don't know what the history is/was around the 2/3/6 churn, but the
re-addition in 4.19.35 to a different function sure looks wrong.

The commit adds a call "status = acpi_ut_add_address_range(..." and if
we check mainline, there is only one in that file, but in 4.19.35+ there
now are two calls - since the two functions had similar context and
comments, it isn't hard to see how patch could/would apply it a 2nd time
in the wrong place.

I didn't check if any of the other currently maintained linux-stable
versions also had this possible issue.

Paul.
