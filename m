Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A06579AD2
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbiGSMU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239273AbiGSMSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:18:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788714D4F7;
        Tue, 19 Jul 2022 05:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42AE7B81B36;
        Tue, 19 Jul 2022 12:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D05C341C6;
        Tue, 19 Jul 2022 12:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232394;
        bh=a/sAmAYMs3H7B9lRQaCSEPbIAzVS79fHzsO5WLh7RgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LMDclzabAErfBHTFnyLW9wel+GeOlXLzpMijluw+Asp04xaXLxDpaFTHve/yQC5ks
         YutpP7CpcRBgEPmC3jX6y+TARd62CHQY3i/B9CiZ5xnpBEbbNIxxlEzMtkKq+6l1W2
         zvcyqypDWZfGQMg7uqnN2vOdAusEmhyudhadsif8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/112] sysctl: Fix data races in proc_dointvec().
Date:   Tue, 19 Jul 2022 13:53:35 +0200
Message-Id: <20220719114630.454008327@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 1f1be04b4d48a2475ea1aab46a99221bfc5c0968 ]

A sysctl variable is accessed concurrently, and there is always a chance
of data-race.  So, all readers and writers need some basic protection to
avoid load/store-tearing.

This patch changes proc_dointvec() to use READ_ONCE() and WRITE_ONCE()
internally to fix data-races on the sysctl side.  For now, proc_dointvec()
itself is tolerant to a data-race, but we still need to add annotations on
the other subsystem's side.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sysctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8832440a4938..81657b13bd53 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -557,14 +557,14 @@ static int do_proc_dointvec_conv(bool *negp, unsigned long *lvalp,
 		if (*negp) {
 			if (*lvalp > (unsigned long) INT_MAX + 1)
 				return -EINVAL;
-			*valp = -*lvalp;
+			WRITE_ONCE(*valp, -*lvalp);
 		} else {
 			if (*lvalp > (unsigned long) INT_MAX)
 				return -EINVAL;
-			*valp = *lvalp;
+			WRITE_ONCE(*valp, *lvalp);
 		}
 	} else {
-		int val = *valp;
+		int val = READ_ONCE(*valp);
 		if (val < 0) {
 			*negp = true;
 			*lvalp = -(unsigned long)val;
-- 
2.35.1



