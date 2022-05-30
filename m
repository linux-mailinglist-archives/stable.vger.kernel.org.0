Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190F7537FC2
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbiE3ODk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239268AbiE3OAs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:00:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFB7C0E18;
        Mon, 30 May 2022 06:39:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E642860F3B;
        Mon, 30 May 2022 13:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D18AC385B8;
        Mon, 30 May 2022 13:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917961;
        bh=Es8gs4AferonvUyU7vO7rV3pF3BZ22ZnnU8qmdPDgWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNoTYDqWeu9diTzu222B7lMq5CiQe2GkpN9rzlOrjBJRy2vOU+/pERZXRMfphmbag
         rEx/u0KzZ4exwqVhB5LAgfvn94UZt6/q3FczaDhKxbA13fd9yqAQHFekzOHLx9F6WL
         n1E81ye7ELy5FdGurJqdjp9NF5mQNRzCUE6n9+DWAYANr35zL0Pq0UtokOmAyFb+/j
         C8qT3rQz4rIPi/kbgODdx1xBwql+3YHONOqDXSsUfFvTwg4Ug58BgblVnYbWYZbWSR
         P5digIhvu4mKVeXCUZdj9dDbCekKrlXKZKAScvjLocBBNEX4vkILr5heCnzQH2iH9P
         ycW9xqehft3xA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Sasha Levin <sashal@kernel.org>, frederic@kernel.org,
        quic_neeraju@quicinc.com, josh@joshtriplett.org,
        rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 018/109] rcu: Make TASKS_RUDE_RCU select IRQ_WORK
Date:   Mon, 30 May 2022 09:36:54 -0400
Message-Id: <20220530133825.1933431-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "Paul E. McKenney" <paulmck@kernel.org>

[ Upstream commit 46e861be589881e0905b9ade3d8439883858721c ]

The TASKS_RUDE_RCU does not select IRQ_WORK, which can result in build
failures for kernels that do not otherwise select IRQ_WORK.  This commit
therefore causes the TASKS_RUDE_RCU Kconfig option to select IRQ_WORK.

Reported-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/rcu/Kconfig b/kernel/rcu/Kconfig
index 3128b7cf8e1f..f73cf17fcee9 100644
--- a/kernel/rcu/Kconfig
+++ b/kernel/rcu/Kconfig
@@ -86,6 +86,7 @@ config TASKS_RCU
 
 config TASKS_RUDE_RCU
 	def_bool 0
+	select IRQ_WORK
 	help
 	  This option enables a task-based RCU implementation that uses
 	  only context switch (including preemption) and user-mode
-- 
2.35.1

