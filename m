Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35FB0579DCB
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238118AbiGSMzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242378AbiGSMy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:54:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D527F95C29;
        Tue, 19 Jul 2022 05:21:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F9B1618CF;
        Tue, 19 Jul 2022 12:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB66C341C6;
        Tue, 19 Jul 2022 12:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233289;
        bh=o/pgdEkrFtiMa7YeRpjlaMVNtc81Z+tPm/oq+KKV+C8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GeDrsh6uA5oyvepKMs0VpuW54a33FWL+Fv++SHueIMa9xMvSD0iC+xmpROFLnJ6r+
         R1Qo1wR3ZZVNUJGqhJ8sZWuBvl4T4Xu796jPe/Cz9QSViTp1fS7dpnyZpxlPT6XmII
         h+L+3p9izIdsaTqk00WHk0eMvJ43n/JrQqdCzxrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 072/231] sysctl: Fix data races in proc_douintvec_minmax().
Date:   Tue, 19 Jul 2022 13:52:37 +0200
Message-Id: <20220719114720.759821586@linuxfoundation.org>
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

[ Upstream commit 2d3b559df3ed39258737789aae2ae7973d205bc1 ]

A sysctl variable is accessed concurrently, and there is always a chance
of data-race.  So, all readers and writers need some basic protection to
avoid load/store-tearing.

This patch changes proc_douintvec_minmax() to use READ_ONCE() and
WRITE_ONCE() internally to fix data-races on the sysctl side.  For now,
proc_douintvec_minmax() itself is tolerant to a data-race, but we still
need to add annotations on the other subsystem's side.

Fixes: 61d9b56a8920 ("sysctl: add unsigned int range support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 22ebf3f5eefe..a769f64a78ed 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -995,7 +995,7 @@ static int do_proc_douintvec_minmax_conv(unsigned long *lvalp,
 		    (param->max && *param->max < tmp))
 			return -ERANGE;
 
-		*valp = tmp;
+		WRITE_ONCE(*valp, tmp);
 	}
 
 	return 0;
-- 
2.35.1



