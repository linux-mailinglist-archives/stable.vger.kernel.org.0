Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54A8579BFF
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237680AbiGSMfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240879AbiGSMe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:34:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97C052E54;
        Tue, 19 Jul 2022 05:13:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B152FB81B29;
        Tue, 19 Jul 2022 12:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20602C341C6;
        Tue, 19 Jul 2022 12:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232759;
        bh=YOsoEXANQfVJmAisooZnQToiVBtWY4IDvfItt/4IiOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKjsg8G/6l9ZuE8bLDgtUrhCBvWKYWvRpLQ/gQIUYcSs+PYQHhzvsW+R6RM5ISVuP
         VT/aNdgh3kpXez2XLexOFTpBTZXC3myw4L4ZAH1EwSueh0L4C/LlDSy8nLX4pR/25b
         ROwcME0zLeG36AVnrPitNY+CLjS5CqPSyv2trlsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/167] sysctl: Fix data races in proc_dointvec_jiffies().
Date:   Tue, 19 Jul 2022 13:53:08 +0200
Message-Id: <20220719114702.012706315@linuxfoundation.org>
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

[ Upstream commit e877820877663fbae8cb9582ea597a7230b94df3 ]

A sysctl variable is accessed concurrently, and there is always a chance
of data-race.  So, all readers and writers need some basic protection to
avoid load/store-tearing.

This patch changes proc_dointvec_jiffies() to use READ_ONCE() and
WRITE_ONCE() internally to fix data-races on the sysctl side.  For now,
proc_dointvec_jiffies() itself is tolerant to a data-race, but we still
need to add annotations on the other subsystem's side.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sysctl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9a68da5e1551..5be8108a9a45 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1364,9 +1364,12 @@ static int do_proc_dointvec_jiffies_conv(bool *negp, unsigned long *lvalp,
 	if (write) {
 		if (*lvalp > INT_MAX / HZ)
 			return 1;
-		*valp = *negp ? -(*lvalp*HZ) : (*lvalp*HZ);
+		if (*negp)
+			WRITE_ONCE(*valp, -*lvalp * HZ);
+		else
+			WRITE_ONCE(*valp, *lvalp * HZ);
 	} else {
-		int val = *valp;
+		int val = READ_ONCE(*valp);
 		unsigned long lval;
 		if (val < 0) {
 			*negp = true;
-- 
2.35.1



