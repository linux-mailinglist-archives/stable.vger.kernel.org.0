Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1375579C1F
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239250AbiGSMgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240305AbiGSMfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:35:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCDD7AB11;
        Tue, 19 Jul 2022 05:14:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70CC3B81B32;
        Tue, 19 Jul 2022 12:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF17DC341C6;
        Tue, 19 Jul 2022 12:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232834;
        bh=PH0I0FrJz8Iu1ZppSIcZbT/GPSH/t/4UMdyeC++/lI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOqY+hTCPcb6HijPlHfB8Kyyzzu5ONRhA68ctXJiHrG83iVG06TiMbcVLxGfMFLDz
         F57PEERp5B3RPwipsO1Mkp0X4EIwBrjFEy7+ezuwMbFbApI0rprRgy2rco9yXwOvIC
         Zrgs1lvtqGqtCdHtYAcRa8K/A3XeWaUbNw7Txpyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/167] sysctl: Fix data-races in proc_dou8vec_minmax().
Date:   Tue, 19 Jul 2022 13:53:34 +0200
Message-Id: <20220719114704.502067143@linuxfoundation.org>
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
index 5be8108a9a45..357900d0cef9 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1138,13 +1138,13 @@ int proc_dou8vec_minmax(struct ctl_table *table, int write,
 
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



