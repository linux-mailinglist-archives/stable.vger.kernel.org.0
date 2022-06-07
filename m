Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4A65417C6
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378125AbiFGVGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378680AbiFGVE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:04:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03386B2EB6;
        Tue,  7 Jun 2022 11:49:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD7CDB8220B;
        Tue,  7 Jun 2022 18:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33693C385A2;
        Tue,  7 Jun 2022 18:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627746;
        bh=/bRe3fMWLujieOuRXkmsKWSwKCr2pPGcp3HWPp9ylT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q22QvVumIZnpU+l0S6I6WXn1Z5nFUlssDzzNtVsAQN9/DCwPcwP4CSQmJoLPgTy4Q
         ySCGc0f93EpIoIgc11EKWRC99oAWQjdkk++N46JebvzLwy/QOP8w2vQaT/3khayDSG
         j89qAHj5A7Q3XiHKty4R2F9XMEONT6WOaNe9Qfho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 079/879] rcu: Make TASKS_RUDE_RCU select IRQ_WORK
Date:   Tue,  7 Jun 2022 18:53:17 +0200
Message-Id: <20220607165004.983480542@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index bf8e341e75b4..f559870fbf8b 100644
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



