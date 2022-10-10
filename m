Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20AB55F99EA
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiJJHZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbiJJHZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:25:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CFB1F9ED;
        Mon, 10 Oct 2022 00:19:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88EE760E9B;
        Mon, 10 Oct 2022 07:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4E0C433D7;
        Mon, 10 Oct 2022 07:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385731;
        bh=uHkFqy/3KX5ATWrvmJSZU7yLAobRW9HH8hZoqhzThtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zHG3fYuww3zUvRsNCf9qrPasyVw4miQL6yNwX2LsJg279aPqOchw2bpgFdRri8uPj
         ojbNBD1XsqOH4ddGff5RoQ8d4TvKXb86orOv2MDZWgO3JNqJK5EA/QKV1DxSguhYQ4
         npRO1qU0Hxvh8ZjApTca94XBAk6zgVXJwBi/ffP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 23/37] net: atlantic: fix potential memory leak in aq_ndev_close()
Date:   Mon, 10 Oct 2022 09:05:42 +0200
Message-Id: <20221010070331.884476942@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070331.211113813@linuxfoundation.org>
References: <20221010070331.211113813@linuxfoundation.org>
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
index e22935ce9573..f069312463fb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -89,11 +89,8 @@ static int aq_ndev_close(struct net_device *ndev)
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



