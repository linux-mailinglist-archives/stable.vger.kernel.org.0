Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A886042AE
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbiJSLIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbiJSLI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:08:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE54017C542;
        Wed, 19 Oct 2022 03:37:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C3B57CE21AC;
        Wed, 19 Oct 2022 09:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5FAC433D7;
        Wed, 19 Oct 2022 09:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170619;
        bh=f33ezdzKDOq2FUj87Tg0YqhnSXpQQOcpgP0oUn0mnp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=USL62FonUgQmdZ69OG47s1aus2MzQ5qAcrlcFpK1fuUpPAa6YHh62k6S4o3pofQWE
         m8pdrobiLZ5sxEricJFzou0ujHpFYzgl16UEHYARvXUnQXtSmup4VI8oth7lt9e/nH
         5Jj6smG2KOGp54Oq8TRIQO/+dmqnGVDr0QAE6DJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com,
        Kees Cook <keescook@chromium.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 724/862] net: sched: cls_u32: Avoid memcpy() false-positive warning
Date:   Wed, 19 Oct 2022 10:33:31 +0200
Message-Id: <20221019083321.919155785@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 7cba18332e3635aaae60e4e7d4e52849de50d91b ]

To work around a misbehavior of the compiler's ability to see into
composite flexible array structs (as detailed in the coming memcpy()
hardening series[1]), use unsafe_memcpy(), as the sizing,
bounds-checking, and allocation are all very tightly coupled here.
This silences the false-positive reported by syzbot:

  memcpy: detected field-spanning write (size 80) of single field "&n->sel" at net/sched/cls_u32.c:1043 (size 16)

[1] https://lore.kernel.org/linux-hardening/20220901065914.1417829-2-keescook@chromium.org

Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Reported-by: syzbot+a2c4601efc75848ba321@syzkaller.appspotmail.com
Link: https://lore.kernel.org/lkml/000000000000a96c0b05e97f0444@google.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20220927153700.3071688-1-keescook@chromium.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_u32.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4d27300c287c..5f33472aad36 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1040,7 +1040,11 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 	}
 #endif
 
-	memcpy(&n->sel, s, sel_size);
+	unsafe_memcpy(&n->sel, s, sel_size,
+		      /* A composite flex-array structure destination,
+		       * which was correctly sized with struct_size(),
+		       * bounds-checked against nla_len(), and allocated
+		       * above. */);
 	RCU_INIT_POINTER(n->ht_up, ht);
 	n->handle = handle;
 	n->fshift = s->hmask ? ffs(ntohl(s->hmask)) - 1 : 0;
-- 
2.35.1



