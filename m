Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2A75BAA20
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiIPKIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiIPKI1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:08:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E98AB4F3;
        Fri, 16 Sep 2022 03:08:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 951AB629EB;
        Fri, 16 Sep 2022 10:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839ECC433D7;
        Fri, 16 Sep 2022 10:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663322889;
        bh=Yy+QJ8tlNvHmBxspzZ1dLNGVkG6l9ASkDRXsHYTOjAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofdZBg1hzTfI0zUtHVsBPs0Y8vzsuYheTeMBJApRVR/b4ehPdjUJdCy1+ahkzkxVs
         1RxL6dD0uU/Ivlkh0/BQKQeGWUrnliL0J7jBB1IxCDlQ1/6meWs2IEnL8sZPMrwcQs
         bouNlYNr+PWkXQF7GiJgbSM3CUkqLF5M3d3npOnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Qiong <liqiong@nfschina.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 5/7] ieee802154: cc2520: add rc code in cc2520_tx()
Date:   Fri, 16 Sep 2022 12:07:57 +0200
Message-Id: <20220916100441.804893552@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100441.528608977@linuxfoundation.org>
References: <20220916100441.528608977@linuxfoundation.org>
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

From: Li Qiong <liqiong@nfschina.com>

[ Upstream commit ffd7bdddaab193c38416fd5dd416d065517d266e ]

The rc code is 0 at the error path "status & CC2520_STATUS_TX_UNDERFLOW".
Assign rc code with '-EINVAL' at this error path to fix it.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
Link: https://lore.kernel.org/r/20220829071259.18330-1-liqiong@nfschina.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ieee802154/cc2520.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
index d50add705a79a..436cf2007138a 100644
--- a/drivers/net/ieee802154/cc2520.c
+++ b/drivers/net/ieee802154/cc2520.c
@@ -512,6 +512,7 @@ cc2520_tx(struct ieee802154_hw *hw, struct sk_buff *skb)
 		goto err_tx;
 
 	if (status & CC2520_STATUS_TX_UNDERFLOW) {
+		rc = -EINVAL;
 		dev_err(&priv->spi->dev, "cc2520 tx underflow exception\n");
 		goto err_tx;
 	}
-- 
2.35.1



