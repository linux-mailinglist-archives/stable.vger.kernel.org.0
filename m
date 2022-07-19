Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73704579AE6
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbiGSMVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239447AbiGSMSy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:18:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D51157E03;
        Tue, 19 Jul 2022 05:06:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13BD76175D;
        Tue, 19 Jul 2022 12:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6909C341CA;
        Tue, 19 Jul 2022 12:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232409;
        bh=9x6wjyw3uowRy38Uv06KV/a6m80Ia3Ch4Tpqz7nyfXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+wdDx0SZdbUm1j8DeKvMHoyMvG24b1fomsAe4UY4zZtB1wbchoe7oFoQM9ZBAkVj
         IPl9FAA2r9bOw4lY6LtUgYsYjESnHc6uganA/T34Pk8wC+OcC71BlYhkKuDLsSkjPX
         jClVlmr6K5p5+0xhsJrgxsbSVmifnGZ0Xf3LWXs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/112] sysctl: Fix data races in proc_doulongvec_minmax().
Date:   Tue, 19 Jul 2022 13:53:39 +0200
Message-Id: <20220719114630.922469359@linuxfoundation.org>
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

[ Upstream commit c31bcc8fb89fc2812663900589c6325ba35d9a65 ]

A sysctl variable is accessed concurrently, and there is always a chance
of data-race.  So, all readers and writers need some basic protection to
avoid load/store-tearing.

This patch changes proc_doulongvec_minmax() to use READ_ONCE() and
WRITE_ONCE() internally to fix data-races on the sysctl side.  For now,
proc_doulongvec_minmax() itself is tolerant to a data-race, but we still
need to add annotations on the other subsystem's side.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sysctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index df6090ba1d0b..e7409788db64 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1193,9 +1193,9 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table,
 				err = -EINVAL;
 				break;
 			}
-			*i = val;
+			WRITE_ONCE(*i, val);
 		} else {
-			val = convdiv * (*i) / convmul;
+			val = convdiv * READ_ONCE(*i) / convmul;
 			if (!first)
 				proc_put_char(&buffer, &left, '\t');
 			proc_put_long(&buffer, &left, val, false);
-- 
2.35.1



