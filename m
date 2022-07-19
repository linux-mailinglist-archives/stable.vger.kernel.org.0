Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C7E579BFD
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240439AbiGSMfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240727AbiGSMeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:34:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70F077485;
        Tue, 19 Jul 2022 05:13:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C281361632;
        Tue, 19 Jul 2022 12:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D752C341C6;
        Tue, 19 Jul 2022 12:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232750;
        bh=+9weaKiei4UsraWdur+ff2fnOPti+6SBDkR3LPIm2S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPv6z+jwJqQWOo6Az6sIo49djJKl5F5+FrFCXVK9MG0ua7zWK2mHBnTlmrZwHrATA
         tntTPQyeVBCm/Ik7V83hBcNEKlzBxXqUj/ASqYfc1ycQUHrGta95+PIpBmg3lKm74F
         37Q20S88sVL/+IPZTI4Xo9kChvPXCy5IM+5+B82U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/167] sysctl: Fix data races in proc_dointvec_minmax().
Date:   Tue, 19 Jul 2022 13:53:05 +0200
Message-Id: <20220719114701.722734928@linuxfoundation.org>
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

[ Upstream commit f613d86d014b6375a4085901de39406598121e35 ]

A sysctl variable is accessed concurrently, and there is always a chance
of data-race.  So, all readers and writers need some basic protection to
avoid load/store-tearing.

This patch changes proc_dointvec_minmax() to use READ_ONCE() and
WRITE_ONCE() internally to fix data-races on the sysctl side.  For now,
proc_dointvec_minmax() itself is tolerant to a data-race, but we still
need to add annotations on the other subsystem's side.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b152e0a30a2b..f5134435fb9c 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -988,7 +988,7 @@ static int do_proc_dointvec_minmax_conv(bool *negp, unsigned long *lvalp,
 		if ((param->min && *param->min > tmp) ||
 		    (param->max && *param->max < tmp))
 			return -EINVAL;
-		*valp = tmp;
+		WRITE_ONCE(*valp, tmp);
 	}
 
 	return 0;
-- 
2.35.1



