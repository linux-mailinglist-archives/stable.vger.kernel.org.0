Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4746866C852
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbjAPQiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233501AbjAPQh0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:37:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61727265BB
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:26:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE581B81077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D23FC433D2;
        Mon, 16 Jan 2023 16:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886382;
        bh=I6sMuE1ogJuYiIWpdS4InycTJH1lueI8UdpaR2yGMUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MuFw0+7nkean6nqrTfwDGRvLBtb/lxreT+JdKxG4wwgIxoHP7ROPYZNRl6BIQl/zZ
         HJJuSPSqTOvon9LNgiP0xZ/HGH4ZBAWCP8vVP8CqENR+qNlmhyBSsLXOLktkq4HGDo
         /8A/OYeePIl/LBoidlpf89oe5cz/L8byWe6ec4Pk=
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
Subject: [PATCH 5.4 382/658] net_sched: reject TCF_EM_SIMPLE case for complex ematch module
Date:   Mon, 16 Jan 2023 16:47:50 +0100
Message-Id: <20230116154927.020574043@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index dd3b8c11a2e0..43bfb33629e9 100644
--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -255,6 +255,8 @@ static int tcf_em_validate(struct tcf_proto *tp,
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



