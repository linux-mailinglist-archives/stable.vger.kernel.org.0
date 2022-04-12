Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D5A4FD564
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353529AbiDLHqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357106AbiDLHjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DC060E9;
        Tue, 12 Apr 2022 00:12:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B35E9B81A8F;
        Tue, 12 Apr 2022 07:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA4CC385A6;
        Tue, 12 Apr 2022 07:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747529;
        bh=qLmXZONcjAfLhV8Fgzrg3A5r3faqxtmtZPA9U6hBnwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7Z+sPsiwR7nxvtj+MAvAm0ar8ORz3M3FwsFM/jDwMOyEdnErt+G8RaAXoSyN7+VS
         X88w6CQB6j3cWLy8E2NaWJlS1D5ctRJTihQGWWvLufXXScGEBz8Tjr9a+NmwqeLIQi
         8CnImrzVllEwj3K+oAYtYPacLr3P2Jcnebj+wFGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 061/343] kvm: selftests: aarch64: fix assert in gicv3_access_reg
Date:   Tue, 12 Apr 2022 08:27:59 +0200
Message-Id: <20220412062952.863589103@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Ricardo Koller <ricarkol@google.com>

[ Upstream commit cc94d47ce16d4147d546e47c8248e8bd12ba5fe5 ]

The val argument in gicv3_access_reg can have any value when used for a
read, not necessarily 0.  Fix the assert by checking val only for
writes.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220127030858.3269036-2-ricarkol@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
index 00f613c0583c..e4945fe66620 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
@@ -159,7 +159,7 @@ static void gicv3_access_reg(uint32_t intid, uint64_t offset,
 	uint32_t cpu_or_dist;
 
 	GUEST_ASSERT(bits_per_field <= reg_bits);
-	GUEST_ASSERT(*val < (1U << bits_per_field));
+	GUEST_ASSERT(!write || *val < (1U << bits_per_field));
 	/* Some registers like IROUTER are 64 bit long. Those are currently not
 	 * supported by readl nor writel, so just asserting here until then.
 	 */
-- 
2.35.1



