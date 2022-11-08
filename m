Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F198A6212FD
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbiKHNpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234527AbiKHNpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:45:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C59FE5984F
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:45:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 299D761596
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5C6C433D6;
        Tue,  8 Nov 2022 13:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915105;
        bh=k9sgmI9B9bqMpNa7A4RyVrrVWN++hPhtwEOf4iOMqbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NWffO8JzfA5S/oKnSAhXyGiPCf89cfIML+DiCSZ/UBwr0cXmU3S67p6f+ug8KBl+K
         i2bYSWznPE/oyqpRk1oCzepnYGFYA+2yuDWjZfTi8AHGAXlzzYfL9+/DUM0I1OyAqz
         0JFk37S+tuae4/WuTBGx9Sb5DTinsj7WFw/nmlXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/48] ipvs: use explicitly signed chars
Date:   Tue,  8 Nov 2022 14:38:57 +0100
Message-Id: <20221108133329.948886865@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit 5c26159c97b324dc5174a5713eafb8c855cf8106 ]

The `char` type with no explicit sign is sometimes signed and sometimes
unsigned. This code will break on platforms such as arm, where char is
unsigned. So mark it here as explicitly signed, so that the
todrop_counter decrement and subsequent comparison is correct.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 95c35aa639ec..5ebc7998529a 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1230,8 +1230,8 @@ static inline int todrop_entry(struct ip_vs_conn *cp)
 	 * The drop rate array needs tuning for real environments.
 	 * Called from timer bh only => no locking
 	 */
-	static const char todrop_rate[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
-	static char todrop_counter[9] = {0};
+	static const signed char todrop_rate[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
+	static signed char todrop_counter[9] = {0};
 	int i;
 
 	/* if the conn entry hasn't lasted for 60 seconds, don't drop it.
-- 
2.35.1



