Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE9D59D94C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241877AbiHWJlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243247AbiHWJj1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:39:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A46D696F6;
        Tue, 23 Aug 2022 01:41:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8747BB81C55;
        Tue, 23 Aug 2022 08:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E71C433C1;
        Tue, 23 Aug 2022 08:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244062;
        bh=LP5BzgqKsxL6/kCUIrjEs8eLaEKoR1gKWjg9bD0cpqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acqsz9Sv2/fHKYqRZEqMRygfgxuvmHz+v75Q47PsSU/vQRbtDvG2LthdbCGH9L3+W
         qoCuTDLAZJqS3nYIKM7d5qDrc3m2cALgy5gTC1Ve4VcYZi83Bet0YzUVahwURyMZYB
         fQJJ/0U6U/v/8dnBDeUF2AM3hlGaIU/aTC6vPkRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.15 031/244] apparmor: fix aa_label_asxprint return check
Date:   Tue, 23 Aug 2022 10:23:10 +0200
Message-Id: <20220823080100.097762623@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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
@@ -1745,7 +1745,7 @@ void aa_label_xaudit(struct audit_buffer
 	if (!use_label_hname(ns, label, flags) ||
 	    display_mode(ns, label, flags)) {
 		len  = aa_label_asxprint(&name, ns, label, flags, gfp);
-		if (len == -1) {
+		if (len < 0) {
 			AA_DEBUG("label print error");
 			return;
 		}
@@ -1773,7 +1773,7 @@ void aa_label_seq_xprint(struct seq_file
 		int len;
 
 		len = aa_label_asxprint(&str, ns, label, flags, gfp);
-		if (len == -1) {
+		if (len < 0) {
 			AA_DEBUG("label print error");
 			return;
 		}
@@ -1796,7 +1796,7 @@ void aa_label_xprintk(struct aa_ns *ns,
 		int len;
 
 		len = aa_label_asxprint(&str, ns, label, flags, gfp);
-		if (len == -1) {
+		if (len < 0) {
 			AA_DEBUG("label print error");
 			return;
 		}


