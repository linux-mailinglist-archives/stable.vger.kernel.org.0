Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1A8594CFE
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244500AbiHPAsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345200AbiHPAoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:44:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D5EAE21D;
        Mon, 15 Aug 2022 13:40:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E8E96122E;
        Mon, 15 Aug 2022 20:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B45C433D6;
        Mon, 15 Aug 2022 20:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596024;
        bh=Pyw799UMOd9W9JvMkl0+1zzeas8WDF0EpdwV1mZOenI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5SlELF3J/OHBzuVestKGu/k1J5+E2dnx9fIrXU1D/zpsRfw4u8zUWrLyYOYQV17E
         aw9a1MKD4e0sdyTX/9qCBC4DFLuMqhQuP4figYtxg6RXI6RHLYHP3XRCFOjbOFUjY0
         LbsYAy4Hj8cfXu8XsOjv4eaV1cpCAPqL1X1Pf+KM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Yury Norov <yury.norov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0950/1157] lib/bitmap: fix off-by-one in bitmap_to_arr64()
Date:   Mon, 15 Aug 2022 20:05:06 +0200
Message-Id: <20220815180517.578237375@linuxfoundation.org>
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

From: Alexander Lobakin <alexandr.lobakin@intel.com>

[ Upstream commit 428bc098635680a664779f26f24fe9197d186172 ]

GENMASK*() family takes the first and the last bits of the mask
*including* them. So, with the current code bitmap_to_arr64()
doesn't clear the tail properly:

nbits %  exp             mask                must be
1        GENMASK(1, 0)   0x3                 0x1
...
63       GENMASK(63, 0)  0xffffffffffffffff  0x7fffffffffffffff

This was found by making the function always available instead of
32-bit BE systems only (for reusing in some new functionality).
Turn the number of bits into the last bit set by subtracting 1.
@nbits is already checked to be positive beforehand.

Fixes: 0a97953fd221 ("lib: add bitmap_{from,to}_arr64")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index b18e31ea6e66..e903e13c62e1 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1564,7 +1564,7 @@ void bitmap_to_arr64(u64 *buf, const unsigned long *bitmap, unsigned int nbits)
 
 	/* Clear tail bits in the last element of array beyond nbits. */
 	if (nbits % 64)
-		buf[-1] &= GENMASK_ULL(nbits % 64, 0);
+		buf[-1] &= GENMASK_ULL((nbits - 1) % 64, 0);
 }
 EXPORT_SYMBOL(bitmap_to_arr64);
 #endif
-- 
2.35.1



