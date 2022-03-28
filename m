Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF25E4E932E
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240588AbiC1LU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240594AbiC1LUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:20:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9AB5575C;
        Mon, 28 Mar 2022 04:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7607AB80EAE;
        Mon, 28 Mar 2022 11:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6F5C340EC;
        Mon, 28 Mar 2022 11:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466314;
        bh=BvOMy4RbsI49sIO4SepK9xXqk0plSR56A0uhNkJ0EQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwCe6EgU45+1JX7qpJoARKq53o4vWR+PHI7ON/uvmYTyKLoj96NAR1SWNHAhuKeZM
         OXOB6TG+pVyDsksPnqT0OeCOTy4C/9lBsX0F1xjAb/fktreMlCFcylbDHzHJP+tu4M
         EtKxzYC1KQ1ftgBxby+yNE87gt/Du3nIT5MJRmUf5vUg5xy18jLS4n6q/pGBW+/K8O
         fHEu1+4tqdWkgkv5zi6lXVTs0xKHeIU7f056xer/gh8cP2ghZnPNMwRydd7us2oX5X
         bme6fdWx4Z3sHlj+ujxoKwbLzh0XWPFpKh7kKZkXw9i4fbzVk28K6BtasOx6pza7pF
         62D5RJx4fNlVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, wangzhou1@hisilicon.com,
        davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 03/43] crypto: hisilicon/qm - cleanup warning in qm_vf_read_qos
Date:   Mon, 28 Mar 2022 07:17:47 -0400
Message-Id: <20220328111828.1554086-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328111828.1554086-1-sashal@kernel.org>
References: <20220328111828.1554086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Ye <yekai13@huawei.com>

[ Upstream commit 05b3bade290d6c940701f97f3233c07cfe27205d ]

The kernel test rebot report this warning: Uninitialized variable: ret.
The code flow may return value of ret directly. This value is an
uninitialized variable, here is fix it.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index c5b84a5ea350..3b29c8993b8c 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4295,7 +4295,7 @@ static void qm_vf_get_qos(struct hisi_qm *qm, u32 fun_num)
 static int qm_vf_read_qos(struct hisi_qm *qm)
 {
 	int cnt = 0;
-	int ret;
+	int ret = -EINVAL;
 
 	/* reset mailbox qos val */
 	qm->mb_qos = 0;
-- 
2.34.1

