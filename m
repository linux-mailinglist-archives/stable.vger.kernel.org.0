Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1641824086A
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbgHJPUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728077AbgHJPUy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:20:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B22112075F;
        Mon, 10 Aug 2020 15:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597072853;
        bh=Itc7IHb08ZGOHTDJBJwZojMpWgF91q1faBxQtgBUtgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lP3M946vgvk1y79SpAgUrfpclJ8nZr/cJ643P00S5W1U1X9icqqZsBOC86eqlJU0Q
         6J+kneaqAj2W9XPhngXwR6qYpBMVWH3W7g8RG+rTpEsuFwAxiPOBLKf+rT3Ui3BN5O
         zeLgLQX5EuBQxX2EXC8SN2sdb3Tl14EqRWf0K/rI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julia Lawall <julia.lawall@inria.fr>,
        YueHaibing <yuehaibing@huawei.com>, jeyu@kernel.org,
        cocci@systeme.lip6.fr, Matthias Maennich <maennich@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.8 21/38] scripts: add dummy report mode to add_namespace.cocci
Date:   Mon, 10 Aug 2020 17:19:11 +0200
Message-Id: <20200810151804.940355810@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151803.920113428@linuxfoundation.org>
References: <20200810151803.920113428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Maennich <maennich@google.com>

commit 55c7549819e438f40a3ef1d8ac5c38b73390bcb7 upstream.

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
Reported-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Julia Lawall <julia.lawall@inria.fr>
Link: https://lore.kernel.org/r/20200604164145.173925-1-maennich@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/coccinelle/misc/add_namespace.cocci |    8 +++++++-
 scripts/nsdeps                              |    2 +-
 2 files changed, 8 insertions(+), 2 deletions(-)

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
--- a/scripts/nsdeps
+++ b/scripts/nsdeps
@@ -29,7 +29,7 @@ fi
 
 generate_deps_for_ns() {
 	$SPATCH --very-quiet --in-place --sp-file \
-		$srctree/scripts/coccinelle/misc/add_namespace.cocci -D ns=$1 $2
+		$srctree/scripts/coccinelle/misc/add_namespace.cocci -D nsdeps -D ns=$1 $2
 }
 
 generate_deps() {


