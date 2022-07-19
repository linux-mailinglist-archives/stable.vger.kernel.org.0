Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82872579E29
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242310AbiGSM6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235856AbiGSM6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:58:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4285D596;
        Tue, 19 Jul 2022 05:23:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86BB0618C1;
        Tue, 19 Jul 2022 12:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F36C341C6;
        Tue, 19 Jul 2022 12:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233399;
        bh=XECchj46DqH3hUhk2VLoi/eh4vI39pKf+B4T1uialzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idz6KXx1WsT8V1z7oAlpo3HGG92f7YCpt1INlLY3VSqq7a/0VGswBg27UnMeABFU7
         mkrobYMSRcOIuomxEm+RCPHI5PGEAv9TWXlYsRyONOClL8j/JIBMDzi+wJdVqa0w5h
         Jxmd0lX0l90Qf2biSkI3P6EbWLKTwbPl6/Ol3RZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 109/231] sysctl: Fix data-races in proc_dou8vec_minmax().
Date:   Tue, 19 Jul 2022 13:53:14 +0200
Message-Id: <20220719114723.766278861@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
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

[ Upstream commit 7dee5d7747a69aa2be41f04c6a7ecfe3ac8cdf18 ]

A sysctl variable is accessed concurrently, and there is always a chance
of data-race.  So, all readers and writers need some basic protection to
avoid load/store-tearing.

This patch changes proc_dou8vec_minmax() to use READ_ONCE() and
WRITE_ONCE() internally to fix data-races on the sysctl side.  For now,
proc_dou8vec_minmax() itself is tolerant to a data-race, but we still
need to add annotations on the other subsystem's side.

Fixes: cb9444130662 ("sysctl: add proc_dou8vec_minmax()")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sysctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 878b1122cb89..54ec36e69907 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1079,13 +1079,13 @@ int proc_dou8vec_minmax(struct ctl_table *table, int write,
 
 	tmp.maxlen = sizeof(val);
 	tmp.data = &val;
-	val = *data;
+	val = READ_ONCE(*data);
 	res = do_proc_douintvec(&tmp, write, buffer, lenp, ppos,
 				do_proc_douintvec_minmax_conv, &param);
 	if (res)
 		return res;
 	if (write)
-		*data = val;
+		WRITE_ONCE(*data, val);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(proc_dou8vec_minmax);
-- 
2.35.1



