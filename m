Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FFC579BE4
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240419AbiGSMdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240478AbiGSMcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:32:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25ABC71BED;
        Tue, 19 Jul 2022 05:12:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59E80B81B29;
        Tue, 19 Jul 2022 12:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE7FC341C6;
        Tue, 19 Jul 2022 12:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232748;
        bh=vPnNpgGDRGI+DMe2OVtqxPOGDsBg1fdz9d8mtoBzC5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HrHiKtdplgnWLvllklZbbsUfqpmqlG/VtRwcgZvvYiVhGJrDNoZQ65zhS86DPZy3y
         7VaJXjcfv/0+Sc8gaYOQGx6EO0Wgcz6IsiPj9j8q0WKzYMmg3SUZjiatHlCGzFyhds
         WyMbVIEc0KWdntig3e/+2Ni/zow7r606weWElhu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/167] sysctl: Fix data races in proc_douintvec().
Date:   Tue, 19 Jul 2022 13:53:04 +0200
Message-Id: <20220719114701.622278611@linuxfoundation.org>
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

[ Upstream commit 4762b532ec9539755aab61445d5da6e1926ccb99 ]

A sysctl variable is accessed concurrently, and there is always a chance
of data-race.  So, all readers and writers need some basic protection to
avoid load/store-tearing.

This patch changes proc_douintvec() to use READ_ONCE() and WRITE_ONCE()
internally to fix data-races on the sysctl side.  For now, proc_douintvec()
itself is tolerant to a data-race, but we still need to add annotations on
the other subsystem's side.

Fixes: e7d316a02f68 ("sysctl: handle error writing UINT_MAX to u32 fields")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sysctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 11f0714273ab..b152e0a30a2b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -592,9 +592,9 @@ static int do_proc_douintvec_conv(unsigned long *lvalp,
 	if (write) {
 		if (*lvalp > UINT_MAX)
 			return -EINVAL;
-		*valp = *lvalp;
+		WRITE_ONCE(*valp, *lvalp);
 	} else {
-		unsigned int val = *valp;
+		unsigned int val = READ_ONCE(*valp);
 		*lvalp = (unsigned long)val;
 	}
 	return 0;
-- 
2.35.1



