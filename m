Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E5C6E9E11
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 23:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbjDTVnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 17:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjDTVnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 17:43:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA207B3
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 14:43:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b8c875f2eb9so1973607276.0
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 14:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682027011; x=1684619011;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EPJuk2RlKQF5rplKbsjJK9PAjVUfFiyP3bT14lsF7K8=;
        b=fmPg674BTKUN2oub2+nb9wQQoygkYpn6h+vAxLJOP3QX27gct75QuGg2ougN0gC/OM
         GE30DrVbbbt17XVy68xXvBSNrb9hMtoT726Vu30eWQoCs7K24p1MX7wAs4S3tNehrv6e
         Qe4lX63kCJi1hKBG3MTAtuXyJD7qtJrt2uxJTZGV2Ap/eE491NvAtLfW4ridFAFmixjS
         LAbmKMoEruHCXk9nFoWIyBZPXLkjSw5gyx5WQchkdj/5mbrSUENlBar/s0gaWIVdryMo
         Dg32zaC1aBp1+DoZIuH2fWdy6NKicIVEAklhCwU9/dMYmoxP6aANfb/qnexN+uYM0llX
         NdNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682027011; x=1684619011;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EPJuk2RlKQF5rplKbsjJK9PAjVUfFiyP3bT14lsF7K8=;
        b=dmmX+zGqUkJtesgefDnIJFMWcGJA3nxNeRJ+4E9qpJcOj1juSqB/7SYeY9euH484QE
         6X1NbU3mmuiGQXKbrijrsTOUZMmRCKz8KCBJOFbCHNYFzABP/F2JaNjMouqpj8KBQTur
         xDEZL2PTHxpuyvfLeQXaI8MMRRO4/oAU68oMmnlXNLcwIOwpuC+HHTWlBqbCtgyDfCyC
         e8QlFrKWhrJf2S0rC+48uzzHPbZk19pVrJRPg7qsJoWpepb+HNMbN8onUOJOUe1g4R34
         9c/Ysy6g/v4BhcXKNQ6BFS+vJtNYaoueeLGkhWto7lqOp+i7G1jyLH+daj0inEdrix+R
         bCQw==
X-Gm-Message-State: AAQBX9fQ32bxa9vgYfMTbk+Esz4hCeuuTVPwzfKdaDqvPfaOAqS4WZTU
        NFiZBqS3oSOlKeGOGJZcK0HrJAQ=
X-Google-Smtp-Source: AKy350ZGowUjD2oNzGIQ3zGuwTVrIdWfjJeCh71ZWLiGoZvKEWoG8xY6aER2YSQZqr2VBs16IpEktxs=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2d3:205:651e:f743:4850:3ce])
 (user=pcc job=sendgmr) by 2002:a25:d246:0:b0:b98:6352:be22 with SMTP id
 j67-20020a25d246000000b00b986352be22mr220549ybg.8.1682027011012; Thu, 20 Apr
 2023 14:43:31 -0700 (PDT)
Date:   Thu, 20 Apr 2023 14:43:27 -0700
Message-Id: <20230420214327.2357985-1-pcc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Subject: [PATCH] arm64: mte: Do not set PG_mte_tagged if tags were not initialized
From:   Peter Collingbourne <pcc@google.com>
To:     catalin.marinas@arm.com
Cc:     Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, vincenzo.frascino@arm.com,
        will@kernel.org, eugenis@google.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The mte_sync_page_tags() function sets PG_mte_tagged if it initializes
page tags. Then we return to mte_sync_tags(), which sets PG_mte_tagged
again. At best, this is redundant. However, it is possible for
mte_sync_page_tags() to return without having initialized tags for the
page, i.e. in the case where check_swap is true (non-compound page),
is_swap_pte(old_pte) is false and pte_is_tagged is false. So at worst,
we set PG_mte_tagged on a page with uninitialized tags. This can happen
if, for example, page migration causes a PTE for an untagged page to
be replaced. If the userspace program subsequently uses mprotect() to
enable PROT_MTE for that page, the uninitialized tags will be exposed
to userspace.

Fix it by removing the redundant call to set_page_mte_tagged().

Fixes: e059853d14ca ("arm64: mte: Fix/clarify the PG_mte_tagged semantics")
Signed-off-by: Peter Collingbourne <pcc@google.com>
Cc: <stable@vger.kernel.org> # 6.1
Link: https://linux-review.googlesource.com/id/Ib02d004d435b2ed87603b858ef7480f7b1463052
---
 arch/arm64/kernel/mte.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index f5bcb0dc6267..7e89968bd282 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -66,13 +66,10 @@ void mte_sync_tags(pte_t old_pte, pte_t pte)
 		return;
 
 	/* if PG_mte_tagged is set, tags have already been initialised */
-	for (i = 0; i < nr_pages; i++, page++) {
-		if (!page_mte_tagged(page)) {
+	for (i = 0; i < nr_pages; i++, page++)
+		if (!page_mte_tagged(page))
 			mte_sync_page_tags(page, old_pte, check_swap,
 					   pte_is_tagged);
-			set_page_mte_tagged(page);
-		}
-	}
 
 	/* ensure the tags are visible before the PTE is set */
 	smp_wmb();
-- 
2.40.0.634.g4ca3ef3211-goog

