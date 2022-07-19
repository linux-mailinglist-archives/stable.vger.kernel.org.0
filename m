Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885D8579C25
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240712AbiGSMgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240706AbiGSMgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:36:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B964D7AC14;
        Tue, 19 Jul 2022 05:14:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56F7761772;
        Tue, 19 Jul 2022 12:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34269C341C6;
        Tue, 19 Jul 2022 12:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232805;
        bh=nZL5sHt4z6CkfvITyzjGV+EKz5h652UKzG19cc6+3GU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjcwpSkIy4ikk3UsvmxNjHXFy1AR+Xu91RQqtWGWKfM/FJuccMuRK2FK7UfqCEDuW
         5byMWaL7jisTcSC6oSQIrNgYlccokjpXFQCqGNyrdLdZFbRr15mT+1i3KSzmUtX3sq
         bbXanOYyfKgDMN/XATcDswqvgCV/guDAEH/QJFUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/167] sysctl: Fix data races in proc_dointvec().
Date:   Tue, 19 Jul 2022 13:53:03 +0200
Message-Id: <20220719114701.539279926@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
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
index 0586047f7323..11f0714273ab 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -566,14 +566,14 @@ static int do_proc_dointvec_conv(bool *negp, unsigned long *lvalp,
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



