Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F4E594B75
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351760AbiHPASX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354942AbiHPAQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:16:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B4B15C909;
        Mon, 15 Aug 2022 13:30:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9762961089;
        Mon, 15 Aug 2022 20:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFCFC433D6;
        Mon, 15 Aug 2022 20:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595448;
        bh=IWPQb8ie+Po/Tj9QdZjmmgG64zCz88pHqWsrx6zftGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=waluQLjDTyhhF6AdyO+KAJYM7oHz0chJ2zV4VAvDiJJxABEMo7hWBR6kgrzxXlN4h
         0z87HnS4EaBvvHoH4/HI+M5M2QopytjVogzF8F+NgTQq+/n/djWzQ8whGZKEa5ZmiU
         j48VV1njxGG3OTeQlWLUvGG8IQ7Cc9hTl39fyF6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianyu Li <tianyu.li@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0768/1157] mm/mempolicy: fix get_nodes out of bound access
Date:   Mon, 15 Aug 2022 20:02:04 +0200
Message-Id: <20220815180510.211406156@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Tianyu Li <tianyu.li@arm.com>

[ Upstream commit 000eca5d044d1ee23b4ca311793cf3fc528da6c6 ]

When user specified more nodes than supported, get_nodes will access nmask
array out of bounds.

Link: https://lkml.kernel.org/r/20220601093211.2970565-1-tianyu.li@arm.com
Fixes: e130242dc351 ("mm: simplify compat numa syscalls")
Signed-off-by: Tianyu Li <tianyu.li@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mempolicy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 9689919a2829..f4cd963550c1 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1388,7 +1388,7 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 		unsigned long bits = min_t(unsigned long, maxnode, BITS_PER_LONG);
 		unsigned long t;
 
-		if (get_bitmap(&t, &nmask[maxnode / BITS_PER_LONG], bits))
+		if (get_bitmap(&t, &nmask[(maxnode - 1) / BITS_PER_LONG], bits))
 			return -EFAULT;
 
 		if (maxnode - bits >= MAX_NUMNODES) {
-- 
2.35.1



