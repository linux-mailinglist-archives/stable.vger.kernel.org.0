Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903F154898B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356414AbiFMM6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354745AbiFMMzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:55:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AC111807;
        Mon, 13 Jun 2022 04:16:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 858D5B80EA8;
        Mon, 13 Jun 2022 11:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6491C34114;
        Mon, 13 Jun 2022 11:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118995;
        bh=6ZdnYJ8rf0Ij1VeTv832SGgZbKN5b0dfE5OP1OorB9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsmL0VzDMra+asSGoSJtcMoJXskk7dMmnVTmGdC2wTnd1tU0+yXb45jHRmTBqlc5m
         uGXSfJGGuCF7mpXkXJPQUp0/tDA9cVptxK+upmcwYvoxJs/93nG64jGfRMfhpfSQus
         vO0tuXmJoysnxp6hra8haQI+TvWCQFiuKX7qSqt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/247] s390/mcck: isolate SIE instruction when setting CIF_MCCK_GUEST flag
Date:   Mon, 13 Jun 2022 12:10:04 +0200
Message-Id: <20220613094926.049928025@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 29ccaa4b35ea874ddd50518e5c2c746b9238a792 ]

Commit d768bd892fc8 ("s390: add options to change branch prediction
behaviour for the kernel") introduced .Lsie_exit label - supposedly
to fence off SIE instruction. However, the corresponding address
range length .Lsie_crit_mcck_length was not updated, which led to
BPON code potentionally marked with CIF_MCCK_GUEST flag.

Both .Lsie_exit and .Lsie_crit_mcck_length were removed with commit
0b0ed657fe00 ("s390: remove critical section cleanup from entry.S"),
but the issue persisted - currently BPOFF and BPENTER macros might
get wrongly considered by the machine check handler as a guest.

Fixes: d768bd892fc8 ("s390: add options to change branch prediction behaviour for the kernel")
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/entry.S | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 4c9b967290ae..d530eb4dc413 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -248,6 +248,10 @@ ENTRY(sie64a)
 	BPEXIT	__SF_SIE_FLAGS(%r15),(_TIF_ISOLATE_BP|_TIF_ISOLATE_BP_GUEST)
 .Lsie_entry:
 	sie	0(%r14)
+# Let the next instruction be NOP to avoid triggering a machine check
+# and handling it in a guest as result of the instruction execution.
+	nopr	7
+.Lsie_leave:
 	BPOFF
 	BPENTER	__SF_SIE_FLAGS(%r15),(_TIF_ISOLATE_BP|_TIF_ISOLATE_BP_GUEST)
 .Lsie_skip:
@@ -536,7 +540,7 @@ ENTRY(mcck_int_handler)
 	jno	.Lmcck_panic
 #if IS_ENABLED(CONFIG_KVM)
 	OUTSIDE	%r9,.Lsie_gmap,.Lsie_done,6f
-	OUTSIDE	%r9,.Lsie_entry,.Lsie_skip,4f
+	OUTSIDE	%r9,.Lsie_entry,.Lsie_leave,4f
 	oi	__LC_CPU_FLAGS+7, _CIF_MCCK_GUEST
 	j	5f
 4:	CHKSTG	.Lmcck_panic
-- 
2.35.1



