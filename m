Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69EB1E2C7F
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404429AbgEZTP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404399AbgEZTP0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:15:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 378B82053B;
        Tue, 26 May 2020 19:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520525;
        bh=85MRjDuphd+B7adNDduYkYSTVwOmbRTDqL773PNxNGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H9Qzdf0gEuQ97AXzgVXM0487uUj02dMRIQuT6dPEDqXEavXA3yfWtdIHQRB5LAkEt
         Jg0GKfXmdIu0R28gBBGlNZB0x/Ka/htSzfNqLYS/gyhByvdvbG+FeEuv/SGPCt+vvw
         dWkYS0tm3M2YGU2tBwVGeI0XNRiP/p5ndx41DyTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.6 074/126] apparmor: Fix use-after-free in aa_audit_rule_init
Date:   Tue, 26 May 2020 20:53:31 +0200
Message-Id: <20200526183944.435819124@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

commit c54d481d71c6849e044690d3960aaebc730224cc upstream.

In the implementation of aa_audit_rule_init(), when aa_label_parse()
fails the allocated memory for rule is released using
aa_audit_rule_free(). But after this release, the return statement
tries to access the label field of the rule which results in
use-after-free. Before releasing the rule, copy errNo and return it
after release.

Fixes: 52e8c38001d8 ("apparmor: Fix memory leak of rule on error exit path")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/apparmor/audit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/apparmor/audit.c
+++ b/security/apparmor/audit.c
@@ -197,8 +197,9 @@ int aa_audit_rule_init(u32 field, u32 op
 	rule->label = aa_label_parse(&root_ns->unconfined->label, rulestr,
 				     GFP_KERNEL, true, false);
 	if (IS_ERR(rule->label)) {
+		int err = PTR_ERR(rule->label);
 		aa_audit_rule_free(rule);
-		return PTR_ERR(rule->label);
+		return err;
 	}
 
 	*vrule = rule;


