Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54D65944DB
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244170AbiHOV5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343873AbiHOVzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:55:31 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B9A109A36;
        Mon, 15 Aug 2022 12:33:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B9EE4CE12DC;
        Mon, 15 Aug 2022 19:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946E3C433C1;
        Mon, 15 Aug 2022 19:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592024;
        bh=fihsa39L0YZmsw9lbsImnQhoGQm4IP/0rXY4b4egfqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0QhmSmrWMnjW53wXexmtvW0eGPyCL/r1ILiiylHcYQcjOmqbIboNN/wUSthURK6iK
         9D8zIP1ocpHJ1Zznetk4YxTKvpCyKqZswh9x3J0Iq6p4n77Mha5g2DFlEdkt83ptLL
         KarJaB2A08j++flsL2GM5Uly6m+a1BdW0RZfpqvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianyu Li <tianyu.li@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0719/1095] mm/mempolicy: fix get_nodes out of bound access
Date:   Mon, 15 Aug 2022 20:01:58 +0200
Message-Id: <20220815180459.142421114@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index b27e8d71cda3..c1ccc89845f4 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1387,7 +1387,7 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 		unsigned long bits = min_t(unsigned long, maxnode, BITS_PER_LONG);
 		unsigned long t;
 
-		if (get_bitmap(&t, &nmask[maxnode / BITS_PER_LONG], bits))
+		if (get_bitmap(&t, &nmask[(maxnode - 1) / BITS_PER_LONG], bits))
 			return -EFAULT;
 
 		if (maxnode - bits >= MAX_NUMNODES) {
-- 
2.35.1



