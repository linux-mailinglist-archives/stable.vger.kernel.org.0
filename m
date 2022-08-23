Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5D959D43D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241965AbiHWILz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241986AbiHWIKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:10:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90C5DFB;
        Tue, 23 Aug 2022 01:06:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2E52B81C19;
        Tue, 23 Aug 2022 08:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D3AC433D6;
        Tue, 23 Aug 2022 08:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242006;
        bh=A7ts6CbMVjgBAKQlRCgmW3ymHvurmus5NqdLHCsbjTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O+Hlh3vUM7vYcVX4iD+lPPsjcWlhemHzbwp24IaW/TT/a9+FHDppq8BEHTpZfzCtG
         K1o9lrrBHmNimn2SXO2KU7VgmXFOesktdlrax/KHPjMMQcSL8OgQi7wSQ2VqQcY18P
         9KoryVs5Ci/0yYSjotTiUoY1ACIAef9308hS+DhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.19 044/365] apparmor: fix aa_label_asxprint return check
Date:   Tue, 23 Aug 2022 09:59:05 +0200
Message-Id: <20220823080120.013258481@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit 3e2a3a0830a2090e766d0d887d52c67de2a6f323 upstream.

Clang static analysis reports this issue
label.c:1802:3: warning: 2nd function call argument
  is an uninitialized value
  pr_info("%s", str);
  ^~~~~~~~~~~~~~~~~~

str is set from a successful call to aa_label_asxprint(&str, ...)
On failure a negative value is returned, not a -1.  So change
the check.

Fixes: f1bd904175e8 ("apparmor: add the base fns() for domain labels")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/label.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1744,7 +1744,7 @@ void aa_label_xaudit(struct audit_buffer
 	if (!use_label_hname(ns, label, flags) ||
 	    display_mode(ns, label, flags)) {
 		len  = aa_label_asxprint(&name, ns, label, flags, gfp);
-		if (len == -1) {
+		if (len < 0) {
 			AA_DEBUG("label print error");
 			return;
 		}
@@ -1772,7 +1772,7 @@ void aa_label_seq_xprint(struct seq_file
 		int len;
 
 		len = aa_label_asxprint(&str, ns, label, flags, gfp);
-		if (len == -1) {
+		if (len < 0) {
 			AA_DEBUG("label print error");
 			return;
 		}
@@ -1795,7 +1795,7 @@ void aa_label_xprintk(struct aa_ns *ns,
 		int len;
 
 		len = aa_label_asxprint(&str, ns, label, flags, gfp);
-		if (len == -1) {
+		if (len < 0) {
 			AA_DEBUG("label print error");
 			return;
 		}


