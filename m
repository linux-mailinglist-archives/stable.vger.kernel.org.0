Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889F2615932
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbiKBDGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiKBDGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:06:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E3B23E87
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:06:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8D5B617BC
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6B0C433D6;
        Wed,  2 Nov 2022 03:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358374;
        bh=FeJs2gKM++hqlwsNFAzSqDbMOqIeYuKBjUhJHrss8Pk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJ20gN4ZiCTOeskz7vIurwlnZisP6MuPYuE71Cud7+wmb3ILzicVzrsSf6nLVQstP
         WwpO2P7GLwFRhL9kOSDstcVa36B/cCcJksI8wauZsZ32WVBnGRIu/MdNKoQ1ZifIzn
         BJgY+v0HQx8xi5wgOTfooQOcss3L29GPVV7Qz9xE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/132] net-memcg: avoid stalls when under memory pressure
Date:   Wed,  2 Nov 2022 03:33:14 +0100
Message-Id: <20221102022101.937795582@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 720ca52bcef225b967a339e0fffb6d0c7e962240 ]

As Shakeel explains the commit under Fixes had the unintended
side-effect of no longer pre-loading the cached memory allowance.
Even tho we previously dropped the first packet received when
over memory limit - the consecutive ones would get thru by using
the cache. The charging was happening in batches of 128kB, so
we'd let in 128kB (truesize) worth of packets per one drop.

After the change we no longer force charge, there will be no
cache filling side effects. This causes significant drops and
connection stalls for workloads which use a lot of page cache,
since we can't reclaim page cache under GFP_NOWAIT.

Some of the latency can be recovered by improving SACK reneg
handling but nowhere near enough to get back to the pre-5.15
performance (the application I'm experimenting with still
sees 5-10x worst latency).

Apply the suggested workaround of using GFP_ATOMIC. We will now
be more permissive than previously as we'll drop _no_ packets
in softirq when under pressure. But I can't think of any good
and simple way to address that within networking.

Link: https://lore.kernel.org/all/20221012163300.795e7b86@kernel.org/
Suggested-by: Shakeel Butt <shakeelb@google.com>
Fixes: 4b1327be9fe5 ("net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()")
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Link: https://lore.kernel.org/r/20221021160304.1362511-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index cb1a1bb64ed8..e1a303e4f0f7 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2472,7 +2472,7 @@ static inline gfp_t gfp_any(void)
 
 static inline gfp_t gfp_memcg_charge(void)
 {
-	return in_softirq() ? GFP_NOWAIT : GFP_KERNEL;
+	return in_softirq() ? GFP_ATOMIC : GFP_KERNEL;
 }
 
 static inline long sock_rcvtimeo(const struct sock *sk, bool noblock)
-- 
2.35.1



