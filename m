Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01877548BAF
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383700AbiFMObz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385185AbiFMOam (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:30:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8105EA8883;
        Mon, 13 Jun 2022 04:48:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BAFB61425;
        Mon, 13 Jun 2022 11:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69475C36AFE;
        Mon, 13 Jun 2022 11:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120883;
        bh=8WDX0SJNxmGVXLnNponzLp/iej1hKhI3AdDQ6gZ4IIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBlvOEDfekBFE1umYdQJzJyKWtKKxkvl/egOHPMYOSoSEy+oW2sBrUsVmreaN/a2S
         +ax2grJ7j0gCjWNhqBGqaZAI3EH0iU8s3Hw950I49tvnZVSW4JLrwRySzRntyASYFA
         bzBltWVqpEAueyzkMQ7Tf59Phh0UPWaSwXVft1a0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 170/298] amt: fix wrong type string definition
Date:   Mon, 13 Jun 2022 12:11:04 +0200
Message-Id: <20220613094930.087900844@linuxfoundation.org>
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

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit d7970039d87c926bb648982e920cb9851c19f3e1 ]

amt message type definition starts from 1, not 0.
But type_str[] starts from 0.
So, it prints wrong type information.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index e239c0262d56..83e5fe784f5c 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -51,6 +51,7 @@ static char *status_str[] = {
 };
 
 static char *type_str[] = {
+	"", /* Type 0 is not defined */
 	"AMT_MSG_DISCOVERY",
 	"AMT_MSG_ADVERTISEMENT",
 	"AMT_MSG_REQUEST",
-- 
2.35.1



