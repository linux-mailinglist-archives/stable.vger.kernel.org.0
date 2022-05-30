Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16087538188
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240747AbiE3OUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241134AbiE3ORQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D6A111B95;
        Mon, 30 May 2022 06:44:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4359B80DBF;
        Mon, 30 May 2022 13:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C3A7C3411C;
        Mon, 30 May 2022 13:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918278;
        bh=RY/E0ku8qZesPos9VEKshGB+FIyj0M7JUps9BW7CIh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2F/zFsi6K/DEAqZxWtMgcT57W0YSm1JVeguYvTBPw613hogId9RIVgma9QJa+f/t
         aKAiAtTte5U0HXeSfJCPVtO1BtOr27wjDwkln1A7idMB7P1D1cGgZQnENw4XLiRQo1
         GnSy+IbjPRSEoILb7J2AFdwRqkIIulpQcxTGn1w4PDD+RYqM1jGt1Ddnc64isJCEqK
         9CgRi8Ew5XvKoL9fKYzUtgDipL+OqibgR6lRgjk93rU5awN1DRuGY28KsjsJhuswFH
         7bILh7eK7fnarayzzSa3BoQLlg6zhiDixM6NFwInrOYNzY0LZ2USCmpOFK9SRxXntV
         LnU8GZvPfMXJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Sasha Levin <sashal@kernel.org>, frederic@kernel.org,
        quic_neeraju@quicinc.com, josh@joshtriplett.org,
        rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 14/76] rcu: Make TASKS_RUDE_RCU select IRQ_WORK
Date:   Mon, 30 May 2022 09:43:04 -0400
Message-Id: <20220530134406.1934928-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
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
index b71e21f73c40..cd6e11403f1b 100644
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

