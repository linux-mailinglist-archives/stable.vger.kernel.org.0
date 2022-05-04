Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03A451A905
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356527AbiEDRNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355826AbiEDRKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:10:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348314A91F;
        Wed,  4 May 2022 09:57:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8014B8279A;
        Wed,  4 May 2022 16:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9C7C385AF;
        Wed,  4 May 2022 16:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683441;
        bh=e+oxjEJlR1PMHd11JKjXVmZGlgC98O91GpA6vAZb0A4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nS7JrE10OrN6b+JGFmFPVN2BqUK+PrZknazplH50d2INDz1NSc9MX3AEblp2DE75I
         SJvhOHuncXCIT5e7BzIYk/zebDtsEuyVxFALt77O+BklSwVEE6xsOYoljFecfCjhpL
         uW9rHzd4keEztQ3F0/EnCqn8PyDJoXbxliOJSvvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Xu <yinxu@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 109/225] sctp: check asoc strreset_chunk in sctp_generate_reconf_event
Date:   Wed,  4 May 2022 18:45:47 +0200
Message-Id: <20220504153120.352753278@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 165e3e17fe8fe6a8aab319bc6e631a2e23b9a857 ]

A null pointer reference issue can be triggered when the response of a
stream reconf request arrives after the timer is triggered, such as:

  send Incoming SSN Reset Request --->
  CPU0:
   reconf timer is triggered,
   go to the handler code before hold sk lock
                            <--- reply with Outgoing SSN Reset Request
  CPU1:
   process Outgoing SSN Reset Request,
   and set asoc->strreset_chunk to NULL
  CPU0:
   continue the handler code, hold sk lock,
   and try to hold asoc->strreset_chunk, crash!

In Ying Xu's testing, the call trace is:

  [ ] BUG: kernel NULL pointer dereference, address: 0000000000000010
  [ ] RIP: 0010:sctp_chunk_hold+0xe/0x40 [sctp]
  [ ] Call Trace:
  [ ]  <IRQ>
  [ ]  sctp_sf_send_reconf+0x2c/0x100 [sctp]
  [ ]  sctp_do_sm+0xa4/0x220 [sctp]
  [ ]  sctp_generate_reconf_event+0xbd/0xe0 [sctp]
  [ ]  call_timer_fn+0x26/0x130

This patch is to fix it by returning from the timer handler if asoc
strreset_chunk is already set to NULL.

Fixes: 7b9438de0cd4 ("sctp: add stream reconf timer")
Reported-by: Ying Xu <yinxu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_sideeffect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index b3815b568e8e..463c4a58d2c3 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -458,6 +458,10 @@ void sctp_generate_reconf_event(struct timer_list *t)
 		goto out_unlock;
 	}
 
+	/* This happens when the response arrives after the timer is triggered. */
+	if (!asoc->strreset_chunk)
+		goto out_unlock;
+
 	error = sctp_do_sm(net, SCTP_EVENT_T_TIMEOUT,
 			   SCTP_ST_TIMEOUT(SCTP_EVENT_TIMEOUT_RECONF),
 			   asoc->state, asoc->ep, asoc,
-- 
2.35.1



