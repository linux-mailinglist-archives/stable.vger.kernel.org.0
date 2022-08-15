Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036E859492E
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354347AbiHOXrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354974AbiHOXqz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:46:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F211633359;
        Mon, 15 Aug 2022 13:15:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC68760B6E;
        Mon, 15 Aug 2022 20:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C887FC433C1;
        Mon, 15 Aug 2022 20:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594504;
        bh=YYAdXWhzBkm3cA5wJVhZB1fpWiSlTa5n7rfsMHhFYgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oN46WV+Jr1ndpSQgRDN0KjHQ1d66gQgGRsbK/FE4kMAb0tvfFjp0Dpf6JQDylQkFP
         zEc4+TF1Ugmzt1LjB6+3841ALQs1PSDy8QO997TtvBn991fA35Z5oZpWLVhvy36xJq
         R8e18m+4fr+js87zIEY02MbiVAwkymqIuxhifoME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0468/1157] mt76: mt7915: fix endianness in mt7915_rf_regval_get
Date:   Mon, 15 Aug 2022 19:57:04 +0200
Message-Id: <20220815180458.317372376@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 63907290faa916ffab1c8455141c79ca8e3a79bb ]

Fix the following sparse warning in mt7915_rf_regval_get routine:
drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c:979:16: warning: cast to restricted __le32

Fixes: 0a17329ae9c1f ("mt76: mt7915: add debugfs knob for RF registers read/write")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index cab6e02e1f8c..d0c719ecacd0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -976,7 +976,7 @@ mt7915_rf_regval_get(void *data, u64 *val)
 	if (ret)
 		return ret;
 
-	*val = le32_to_cpu(regval);
+	*val = regval;
 
 	return 0;
 }
-- 
2.35.1



