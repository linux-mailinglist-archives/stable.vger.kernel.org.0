Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AC65486CD
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383850AbiFMO1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383714AbiFMOXs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:23:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E5D2E6B6;
        Mon, 13 Jun 2022 04:45:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 043CBB80EA7;
        Mon, 13 Jun 2022 11:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4966BC34114;
        Mon, 13 Jun 2022 11:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120700;
        bh=TQN8FbRvwhf8aOUwKo9Yzwo79hck/ToTXTcmi0hEbn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACTgMdL3K9Dovk/3m5OuXYAuyK0+SIEuscP/2tJqd053OjkGnOAe2z/6NcK+3yTC0
         XmLNxjHolyuU9Dj75FlgHMr/qnJhj/w4YnBMjQ5r/6koPNtIu89XUVaBfswsJn6Mmg
         qX0YAQddMwsOTbps4Q5co6opY2gviI6jhE82hank=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e820fdc8ce362f2dea51@syzkaller.appspotmail.com,
        Jon Maloy <jmaloy@redhat.com>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 126/298] tipc: check attribute length for bearer name
Date:   Mon, 13 Jun 2022 12:10:20 +0200
Message-Id: <20220613094928.763999926@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

[ Upstream commit 7f36f798f89bf32c0164049cb0e3fd1af613d0bb ]

syzbot reported uninit-value:
=====================================================
BUG: KMSAN: uninit-value in string_nocheck lib/vsprintf.c:644 [inline]
BUG: KMSAN: uninit-value in string+0x4f9/0x6f0 lib/vsprintf.c:725
 string_nocheck lib/vsprintf.c:644 [inline]
 string+0x4f9/0x6f0 lib/vsprintf.c:725
 vsnprintf+0x2222/0x3650 lib/vsprintf.c:2806
 vprintk_store+0x537/0x2150 kernel/printk/printk.c:2158
 vprintk_emit+0x28b/0xab0 kernel/printk/printk.c:2256
 vprintk_default+0x86/0xa0 kernel/printk/printk.c:2283
 vprintk+0x15f/0x180 kernel/printk/printk_safe.c:50
 _printk+0x18d/0x1cf kernel/printk/printk.c:2293
 tipc_enable_bearer net/tipc/bearer.c:371 [inline]
 __tipc_nl_bearer_enable+0x2022/0x22a0 net/tipc/bearer.c:1033
 tipc_nl_bearer_enable+0x6c/0xb0 net/tipc/bearer.c:1042
 genl_family_rcv_msg_doit net/netlink/genetlink.c:731 [inline]

- Do sanity check the attribute length for TIPC_NLA_BEARER_NAME.
- Do not use 'illegal name' in printing message.

Reported-by: syzbot+e820fdc8ce362f2dea51@syzkaller.appspotmail.com
Fixes: cb30a63384bc ("tipc: refactor function tipc_enable_bearer()")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Link: https://lore.kernel.org/r/20220602063053.5892-1-hoang.h.le@dektech.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bearer.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index a2f9c9640716..91d9c815a406 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -259,9 +259,8 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 	u32 i;
 
 	if (!bearer_name_validate(name, &b_names)) {
-		errstr = "illegal name";
 		NL_SET_ERR_MSG(extack, "Illegal name");
-		goto rejected;
+		return res;
 	}
 
 	if (prio > TIPC_MAX_LINK_PRI && prio != TIPC_MEDIA_LINK_PRI) {
-- 
2.35.1



