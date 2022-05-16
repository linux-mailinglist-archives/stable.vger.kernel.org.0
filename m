Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F98752909F
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238143AbiEPUKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351017AbiEPUB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA92F4756B;
        Mon, 16 May 2022 12:56:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5752D60FEB;
        Mon, 16 May 2022 19:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FEDC385AA;
        Mon, 16 May 2022 19:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730985;
        bh=wvVEqKubDLAU8d+EGjBw6OMLzgm5quhGvEY1JhEPk9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pfIgqcMEXwU0Ul1lQVRkAN6711bp26H8ebBq9xwvb6EYwxVnu7GkDDsyfIGbk0PUb
         pgtz2xqLqajRu923KKbo5ox6ZR9z5A4TqtZL293089F2Y/ZL5/t11w+i9Hwd9eu14z
         j90gVVvz0Vkoqui9t3tqS85GEzuwK8Xf53a8kO6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 067/114] tcp: drop the hash_32() part from the index calculation
Date:   Mon, 16 May 2022 21:36:41 +0200
Message-Id: <20220516193627.416052786@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit e8161345ddbb66e449abde10d2fdce93f867eba9 ]

In commit 190cc82489f4 ("tcp: change source port randomizarion at
connect() time"), the table_perturb[] array was introduced and an
index was taken from the port_offset via hash_32(). But it turns
out that hash_32() performs a multiplication while the input here
comes from the output of SipHash in secure_seq, that is well
distributed enough to avoid the need for yet another hash.

Suggested-by: Amit Klein <aksecurity@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_hashtables.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index cc5f66328b47..a5d57fa679ca 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -778,7 +778,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 
 	net_get_random_once(table_perturb,
 			    INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
-	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
+	index = port_offset & (INET_TABLE_PERTURB_SIZE - 1);
 
 	offset = READ_ONCE(table_perturb[index]) + (port_offset >> 32);
 	offset %= remaining;
-- 
2.35.1



