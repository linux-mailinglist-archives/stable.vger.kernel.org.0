Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4A41EE8C0
	for <lists+stable@lfdr.de>; Thu,  4 Jun 2020 18:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgFDQmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jun 2020 12:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729115AbgFDQmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jun 2020 12:42:14 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F64C08C5C0
        for <stable@vger.kernel.org>; Thu,  4 Jun 2020 09:42:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f16so8605959ybp.5
        for <stable@vger.kernel.org>; Thu, 04 Jun 2020 09:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=pofY5UnHBtE2yEYmKDPS6cR9bq/E80+ZeaPnrnMNK98=;
        b=ub4mWTHgAmvJMZjGWw+3krHG/dMMay/tEALCX2G/rPbqjl75Y1uFKqie5t1rgrrhON
         mSo60E/ut95d77LLkZkje/FzRws70wUBRcAvqqI6aATgZOEQANEMIjEbyhsrSIwC/se1
         +gGkOGCIm1IyRrH4kWj4cbjTNvz6C+D4ft584XFWfpJ7iRrH7vNHTY3oULr4Z6pRVU6G
         BavBT5hfTMSMPCNrPtuEOHmz9ygqHX4Urzmv6tacLepDNsToQeLuvQr0aZV2GY+d7uvc
         FqYz0BricpkB/+MN9552QQhFDDWbsbpx/QxKWrc7keuS8FBrMpqkSeSwwHcn2IhJ2wAB
         UILw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=pofY5UnHBtE2yEYmKDPS6cR9bq/E80+ZeaPnrnMNK98=;
        b=rg21S3oghtQxjBrrUJWgpqSzt3lFWikffwqoVQ7OzwkIQZ4EvIbhJYdgTEQCxj61mC
         qFxjvgklIN/Az5R+eGmtffHWumxqcu9IVcdHfd6Md80ZYaFBBGF5eFkU1b2kQo1x+rkU
         nqUnmuP9JFOjX2hdwv0vmA+ibPVq6BxuGa4yCM8H4Q0nZeVx5bIC/YEdUim7OS8EK90U
         IIrIBn2buCPY+ooO9fS4dmKi5OLdCr1SY9tVu4XEma3KXjmAaYmN2g+F1fFiL5RQg1SU
         BaP8rPaPcJjVdapK0uDJexfDeI9XlnCd5RThVe0X8N/7tMhrIgCfmuiiQchmtQr1ueNE
         7pGQ==
X-Gm-Message-State: AOAM530zQrqUA6VSOLpd11QchlsAsnBwxvFlhcoKkMrRMdO4LD/WH3b7
        CxPS5O1L7MmYVF6/BwlxBSDtOkRx9bAHGw==
X-Google-Smtp-Source: ABdhPJzuB/YAm+byvdwGw2WfFvD+78kMp/xSR/rtbn2s7vqMXsI0/43mdS+H2sOvX7lbvdCDP2L90nRRZYLC1A==
X-Received: by 2002:a25:5804:: with SMTP id m4mr9094629ybb.488.1591288932392;
 Thu, 04 Jun 2020 09:42:12 -0700 (PDT)
Date:   Thu,  4 Jun 2020 18:41:45 +0200
Message-Id: <20200604164145.173925-1-maennich@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH] scripts: add dummy report mode to add_namespace.cocci
From:   Matthias Maennich <maennich@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, maennich@google.com,
        Julia Lawall <julia.lawall@inria.fr>,
        YueHaibing <yuehaibing@huawei.com>, jeyu@kernel.org,
        cocci@systeme.lip6.fr, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When running `make coccicheck` in report mode using the
add_namespace.cocci file, it will fail for files that contain
MODULE_LICENSE. Those match the replacement precondition, but spatch
errors out as virtual.ns is not set.

In order to fix that, add the virtual rule nsdeps and only do search and
replace if that rule has been explicitly requested.

In order to make spatch happy in report mode, we also need a dummy rule,
as otherwise it errors out with "No rules apply". Using a script:python
rule appears unrelated and odd, but this is the shortest I could come up
with.

Adjust scripts/nsdeps accordingly to set the nsdeps rule when run trough
`make nsdeps`.

Suggested-by: Julia Lawall <julia.lawall@inria.fr>
Fixes: c7c4e29fb5a4 ("scripts: add_namespace: Fix coccicheck failed")
Cc: YueHaibing <yuehaibing@huawei.com>
Cc: jeyu@kernel.org
Cc: cocci@systeme.lip6.fr
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Maennich <maennich@google.com>
---
 scripts/coccinelle/misc/add_namespace.cocci | 8 +++++++-
 scripts/nsdeps                              | 2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/scripts/coccinelle/misc/add_namespace.cocci b/scripts/coccinelle/misc/add_namespace.cocci
index 99e93a6c2e24..cbf1614163cb 100644
--- a/scripts/coccinelle/misc/add_namespace.cocci
+++ b/scripts/coccinelle/misc/add_namespace.cocci
@@ -6,6 +6,7 @@
 /// add a missing namespace tag to a module source file.
 ///
 
+virtual nsdeps
 virtual report
 
 @has_ns_import@
@@ -16,10 +17,15 @@ MODULE_IMPORT_NS(ns);
 
 // Add missing imports, but only adjacent to a MODULE_LICENSE statement.
 // That ensures we are adding it only to the main module source file.
-@do_import depends on !has_ns_import@
+@do_import depends on !has_ns_import && nsdeps@
 declarer name MODULE_LICENSE;
 expression license;
 identifier virtual.ns;
 @@
 MODULE_LICENSE(license);
 + MODULE_IMPORT_NS(ns);
+
+// Dummy rule for report mode that would otherwise be empty and make spatch
+// fail ("No rules apply.")
+@script:python depends on report@
+@@
diff --git a/scripts/nsdeps b/scripts/nsdeps
index 03a8e7cbe6c7..dab4c1a0e27d 100644
--- a/scripts/nsdeps
+++ b/scripts/nsdeps
@@ -29,7 +29,7 @@ fi
 
 generate_deps_for_ns() {
 	$SPATCH --very-quiet --in-place --sp-file \
-		$srctree/scripts/coccinelle/misc/add_namespace.cocci -D ns=$1 $2
+		$srctree/scripts/coccinelle/misc/add_namespace.cocci -D nsdeps -D ns=$1 $2
 }
 
 generate_deps() {
-- 
2.27.0.rc2.251.g90737beb825-goog

