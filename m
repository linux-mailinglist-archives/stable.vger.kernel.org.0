Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB2C65EC0B
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbjAENFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234053AbjAENFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:05:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3116F5B142
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:05:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1F1161A05
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFA5C433F2;
        Thu,  5 Jan 2023 13:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923920;
        bh=0EBGk+wpzcLEDTQ6rRsTphJYVqXss/I+7TPaKDlIWf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qef8LyCdC/gNZgwoLtN3p6K4yH0MnxG6ZsfWvsq61UHi7zkhl5ZCZM/uVyZUTWUoD
         J0T8tVGUra1Sr6H725FcItUAqrdEdg2wlITGmAOB9tE2YpPvlsmV2cVnwJQibGSJ6O
         fulpIcWjjeyhCGopUx5qjpyUtVsm1np0CwYBLUFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jun Nie <jun.nie@linaro.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+4caeae4c7103813598ae@syzkaller.appspotmail.com
Subject: [PATCH 4.9 176/251] net_sched: reject TCF_EM_SIMPLE case for complex ematch module
Date:   Thu,  5 Jan 2023 13:55:13 +0100
Message-Id: <20230105125342.850723394@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 9cd3fd2054c3b3055163accbf2f31a4426f10317 ]

When TCF_EM_SIMPLE was introduced, it is supposed to be convenient
for ematch implementation:

https://lore.kernel.org/all/20050105110048.GO26856@postel.suug.ch/

"You don't have to, providing a 32bit data chunk without TCF_EM_SIMPLE
set will simply result in allocating & copy. It's an optimization,
nothing more."

So if an ematch module provides ops->datalen that means it wants a
complex data structure (saved in its em->data) instead of a simple u32
value. We should simply reject such a combination, otherwise this u32
could be misinterpreted as a pointer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-and-tested-by: syzbot+4caeae4c7103813598ae@syzkaller.appspotmail.com
Reported-by: Jun Nie <jun.nie@linaro.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/ematch.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/ematch.c b/net/sched/ematch.c
index d4d6f9c91e8c..59340d633253 100644
--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -259,6 +259,8 @@ static int tcf_em_validate(struct tcf_proto *tp,
 			 * the value carried.
 			 */
 			if (em_hdr->flags & TCF_EM_SIMPLE) {
+				if (em->ops->datalen > 0)
+					goto errout;
 				if (data_len < sizeof(u32))
 					goto errout;
 				em->data = *(u32 *) data;
-- 
2.35.1



