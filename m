Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D264EF039
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348631AbiDAOez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347377AbiDAOcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:32:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CADE36B5F;
        Fri,  1 Apr 2022 07:28:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23BDDB8240E;
        Fri,  1 Apr 2022 14:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CA4C340EE;
        Fri,  1 Apr 2022 14:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823311;
        bh=c8TjKPcrOluaxY+tbry9iwgrFV68Q5NpjoOYMtInmwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqZh6BUbvZ2LKV+wjfWfoxh2gm48W97CS8iT5af1wCn1Z8Hnm+VLW5Bka3X6kBvdx
         P7U+lt6Gkr/U8AR/tMnEA1CrznHoWfBEh5nIwElC9TdlPmDkAVKQToTww2IW/6qXBb
         A59TdTMT+MRa+sMdQAYM3kEDUPZXH62J5gYD3jxizebf/+x/qHJjkdW5MYVABoiyCL
         Qfews+SOZAw5Tbjnm8wNsNavjjJ0Hd2sAve4EyieLVJDqGMNjyOmBOsJmLPLJoBKP/
         7ID4u94rcYe9MQqkBFq5MtFUyYXCfat5QtXAtdpPxIvMh9JKYSSRErYTnZkpLYsYCq
         WroAbj9gFgFdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        pbonzini@redhat.com, shuah@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 052/149] kvm: selftests: aarch64: fix assert in gicv3_access_reg
Date:   Fri,  1 Apr 2022 10:23:59 -0400
Message-Id: <20220401142536.1948161-52-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
2.34.1

