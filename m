Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3291643152
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbiLETNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiLETNg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:13:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56351F2F9
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:13:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FF4B61307
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537FCC433C1;
        Mon,  5 Dec 2022 19:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267614;
        bh=NWxlKCDh4Kcu5dEAqc4mfxwNtdQoeIPBJx17f/9MiFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gtVOgBuCQwORQsfS2r08zhdel/FSpMnvj2lLY5c6MpIz8tV+tG4DmGzJma20dvt3F
         IKJ1rNb7z5qhexpegx7+FhggESjYWOmim9Q/n5AM4HZW8ACTdl4Ve4RGYlN+Sa87LP
         JNKdT/xVqYJS8bZy+ZQCCAPs95B9kmMp68dVWqqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 13/62] net/qla3xxx: fix potential memleak in ql3xxx_send()
Date:   Mon,  5 Dec 2022 20:09:10 +0100
Message-Id: <20221205190758.592549922@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190758.073114639@linuxfoundation.org>
References: <20221205190758.073114639@linuxfoundation.org>
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

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 62a7311fb96c61d281da9852dbee4712fc8c3277 ]

The ql3xxx_send() returns NETDEV_TX_OK without freeing skb in error
handling case, add dev_kfree_skb_any() to fix it.

Fixes: bd36b0ac5d06 ("qla3xxx: Add support for Qlogic 4032 chip.")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1668675039-21138-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qla3xxx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index e62e3a9d5249..4ad4fb832a4a 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2472,6 +2472,7 @@ static netdev_tx_t ql3xxx_send(struct sk_buff *skb,
 					     skb_shinfo(skb)->nr_frags);
 	if (tx_cb->seg_count == -1) {
 		netdev_err(ndev, "%s: invalid segment count!\n", __func__);
+		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
 	}
 
-- 
2.35.1



