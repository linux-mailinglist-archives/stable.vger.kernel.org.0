Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBE55F9949
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiJJHK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbiJJHJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:09:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2BF5BC19;
        Mon, 10 Oct 2022 00:06:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2A7760E7F;
        Mon, 10 Oct 2022 07:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FB3C433D6;
        Mon, 10 Oct 2022 07:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385571;
        bh=lGWll2ZLCWNFayanlIW957ru5Q6QTijFAVemujlKJ1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ax7uxa1Ar+A9pZzwS1lanUY3LirWvbiSeiAis2VIMaKSAKIWglfky+9hBXnriuO2m
         BVY7cxm8RVgCDCxK7dWQzvEJVeKwSAdOr2GygVnFKcrkKbS2DOuNmS7G9d0GidAaoT
         zyX5kQHEHiMBFruPxcdYypaX6ah4JV5NaFRvoK5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 27/48] net: atlantic: fix potential memory leak in aq_ndev_close()
Date:   Mon, 10 Oct 2022 09:05:25 +0200
Message-Id: <20221010070334.407887127@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
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

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit 65e5d27df61283e5390f04b09dc79cd832f95607 ]

If aq_nic_stop() fails, aq_ndev_close() returns err without calling
aq_nic_deinit() to release the relevant memory and resource, which
will lead to a memory leak.

We can fix it by deleting the if condition judgment and goto statement to
call aq_nic_deinit() directly after aq_nic_stop() to fix the memory leak.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 88595863d8bc..8a0af371e7dc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -94,11 +94,8 @@ static int aq_ndev_close(struct net_device *ndev)
 	int err = 0;
 
 	err = aq_nic_stop(aq_nic);
-	if (err < 0)
-		goto err_exit;
 	aq_nic_deinit(aq_nic, true);
 
-err_exit:
 	return err;
 }
 
-- 
2.35.1



