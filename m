Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A7C66C9D9
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233870AbjAPQ4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbjAPQ42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:56:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FEF22A27
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:39:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5B626105A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD15CC433D2;
        Mon, 16 Jan 2023 16:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887172;
        bh=TB4pMOsvkElmztXWLqzpVbRGOtMAmIqxdnvoHCCv+4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FaLcFALYeAd4vVW8Brw3vvum4h4sjMEA+8rfy7rZlcSx/pVdIQfs1e3bxuzj/WTED
         lY7Z1n6MRyqrmiuaQlwnxvgMnalUJO1fNb/I3EVw7/ZUUtKu11Nrblmqx3x40yc7Vv
         a2fQK3iBIjxwA1zyTXzV6tZ1oWenthbpcMCReCbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/521] timerqueue: Use rb_entry_safe() in timerqueue_getnext()
Date:   Mon, 16 Jan 2023 16:45:11 +0100
Message-Id: <20230116154849.436008643@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Barnabás Pőcze <pobrn@protonmail.com>

[ Upstream commit 2f117484329b233455ee278f2d9b0a4356835060 ]

When `timerqueue_getnext()` is called on an empty timer queue, it will
use `rb_entry()` on a NULL pointer, which is invalid. Fix that by using
`rb_entry_safe()` which handles NULL pointers.

This has not caused any issues so far because the offset of the `rb_node`
member in `timerqueue_node` is 0, so `rb_entry()` is essentially a no-op.

Fixes: 511885d7061e ("lib/timerqueue: Rely on rbtree semantics for next timer")
Signed-off-by: Barnabás Pőcze <pobrn@protonmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20221114195421.342929-1-pobrn@protonmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/timerqueue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/timerqueue.h b/include/linux/timerqueue.h
index aff122f1062a..e1a843cb16d4 100644
--- a/include/linux/timerqueue.h
+++ b/include/linux/timerqueue.h
@@ -35,7 +35,7 @@ struct timerqueue_node *timerqueue_getnext(struct timerqueue_head *head)
 {
 	struct rb_node *leftmost = rb_first_cached(&head->rb_root);
 
-	return rb_entry(leftmost, struct timerqueue_node, node);
+	return rb_entry_safe(leftmost, struct timerqueue_node, node);
 }
 
 static inline void timerqueue_init(struct timerqueue_node *node)
-- 
2.35.1



