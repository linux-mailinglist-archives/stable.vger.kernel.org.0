Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691585408C8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352042AbiFGSCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349301AbiFGR7I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:59:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E321208B5;
        Tue,  7 Jun 2022 10:41:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97A21614BC;
        Tue,  7 Jun 2022 17:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5444C385A5;
        Tue,  7 Jun 2022 17:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623701;
        bh=lf/6Y4rbIRE2r8y1XIjTcfxBGOF6A6YKLaXjA0DcB9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sqY43FLI3nHfW7lp2brAJXxkdGR8NWT4Mq/ctmH1X/UqPF9qB89hxO0S7fz9l1Jj7
         n6IJPcww2TsO22ZO9KDsm22SoMjkuQs5MwIRTzKnqJtcYOXZ61IjKEZNGoiawZlkTZ
         9BmwJlR/her7HcaJLLofaIMjV1XWDL71Mf9s009o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/667] rcu: Make TASKS_RUDE_RCU select IRQ_WORK
Date:   Tue,  7 Jun 2022 18:55:25 +0200
Message-Id: <20220607164936.613469572@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Paul E. McKenney <paulmck@kernel.org>

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



