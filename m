Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31C1531B77
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239184AbiEWREV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239199AbiEWREJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:04:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFECE54FBB;
        Mon, 23 May 2022 10:04:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61C4D614BF;
        Mon, 23 May 2022 17:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C89C385A9;
        Mon, 23 May 2022 17:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325447;
        bh=uIm61Ja8CySFdnlS4xGVURLTLLzoNaoSoJAbJKty5Ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z++1lF1JMerbS+fYCGBpWQgag9tOUvdkx0gqg50cjDeCdVV5K7JTFKHG9dBzX8Oj3
         0bbAWlavRomEnxADcuXCdYZmRSKf5xMDlsMJCMpti2BQqCNXZy6KyQKwOkDwW2cy1C
         gImvhMSwRqhPkcJEFeFBnz+1xsZJBTTC9t97Jxas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 15/25] net/qla3xxx: Fix a test in ql_reset_work()
Date:   Mon, 23 May 2022 19:03:33 +0200
Message-Id: <20220523165747.368958980@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165743.398280407@linuxfoundation.org>
References: <20220523165743.398280407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 5361448e45fac6fb96738df748229432a62d78b6 ]

test_bit() tests if one bit is set or not.
Here the logic seems to check of bit QL_RESET_PER_SCSI (i.e. 4) OR bit
QL_RESET_START (i.e. 3) is set.

In fact, it checks if bit 7 (4 | 3 = 7) is set, that is to say
QL_ADAPTER_UP.

This looks harmless, because this bit is likely be set, and when the
ql_reset_work() delayed work is scheduled in ql3xxx_isr() (the only place
that schedule this work), QL_RESET_START or QL_RESET_PER_SCSI is set.

This has been spotted by smatch.

Fixes: 5a4faa873782 ("[PATCH] qla3xxx NIC driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/80e73e33f390001d9c0140ffa9baddf6466a41a2.1652637337.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qla3xxx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 147effc16316..e62e3a9d5249 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -3625,7 +3625,8 @@ static void ql_reset_work(struct work_struct *work)
 		qdev->mem_map_registers;
 	unsigned long hw_flags;
 
-	if (test_bit((QL_RESET_PER_SCSI | QL_RESET_START), &qdev->flags)) {
+	if (test_bit(QL_RESET_PER_SCSI, &qdev->flags) ||
+	    test_bit(QL_RESET_START, &qdev->flags)) {
 		clear_bit(QL_LINK_MASTER, &qdev->flags);
 
 		/*
-- 
2.35.1



