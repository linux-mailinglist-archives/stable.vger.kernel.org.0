Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8DD366B93
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240370AbhDUNDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240398AbhDUND3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 09:03:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BDCC61452;
        Wed, 21 Apr 2021 13:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619010175;
        bh=MLuGesSrOTYIWT5l3OCC2yQe2aTTLKl7J3riXeovMOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OVbU1R4CqJpueh9jKM089gpqd9uzlVnQbvxj9TeXICxvo3PZMrIEvHAAYbiyjbEyw
         cw6ue1kjUoyNh3KZ0iQH1z6R+6jsMeOQOlxzJ1TwMrhRSINn+Ri+IJ2d++x/xubEiC
         m+KuiBzY5UlhZwHszu096MtD+BQ2HMtP37ySNwzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Qiushi Wu <wu000273@umn.edu>,
        "4 . 10+" <stable@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 040/190] Revert "ACPI: CPPC: Fix reference count leak in acpi_cppc_processor_probe()"
Date:   Wed, 21 Apr 2021 14:58:35 +0200
Message-Id: <20210421130105.1226686-41-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 4d8be4bc94f74bb7d096e1c2e44457b530d5a170.

Commits from @umn.edu addresses have been found to be submitted in "bad
faith" to try to test the kernel community's ability to review "known
malicious" changes.  The result of these submissions can be found in a
paper published at the 42nd IEEE Symposium on Security and Privacy
entitled, "Open Source Insecurity: Stealthily Introducing
Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
of Minnesota) and Kangjie Lu (University of Minnesota).

Because of this, all submissions from this group must be reverted from
the kernel tree and will need to be re-reviewed again to determine if
they actually are a valid fix.  Until that work is complete, remove this
change to ensure that no problems are being introduced into the
codebase.

Cc: Qiushi Wu <wu000273@umn.edu>
Cc: 4.10+ <stable@vger.kernel.org> # 4.10+
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 69057fcd2c04..42650b34e45e 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -830,7 +830,6 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 			"acpi_cppc");
 	if (ret) {
 		per_cpu(cpc_desc_ptr, pr->id) = NULL;
-		kobject_put(&cpc_ptr->kobj);
 		goto out_free;
 	}
 
-- 
2.31.1

