Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A1A603DBC
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbiJSJGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbiJSJFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:05:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DB1B3B2A;
        Wed, 19 Oct 2022 01:59:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6645617D6;
        Wed, 19 Oct 2022 08:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58DBC433C1;
        Wed, 19 Oct 2022 08:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169445;
        bh=Y3IO5HhywAPti2cGUGNnM3/p1KnERdnF6bkopTa9wOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2Zv6NvtFEpY1eNkxKljG9SlgliWB9yxGjt6EsfH3Wd4dYfaP2t+wHqYjnD/BKZDW
         90CjziSs3m0/lrGeOar7jnsadsev6IRwWw8ug5iIK9S+M4sY3sA7Y4BbGJr02O+NlN
         w/ke77ouZe6MiyyXuotnv3HT4ehE7xe52+G6+Nts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 280/862] wifi: mt76: mt7915: fix an uninitialized variable bug
Date:   Wed, 19 Oct 2022 10:26:07 +0200
Message-Id: <20221019083302.394228816@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b5ee771c84082b4e54cc39d9d9a2dd239e4f6b86 ]

Smatch complains that:

    drivers/net/wireless/mediatek/mt76/mt7915/mac.c:428 mt7915_mac_fill_rx()
    error: uninitialized symbol 'msta'.

It looks like this was supposed to be initialized to NULL.

Fixes: 0880d40871d1 ("mt76: connac: move mt76_connac2_reverse_frag0_hdr_trans in mt76-connac module")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 60ae834d95a6..4ddcd3afa428 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -232,7 +232,7 @@ mt7915_mac_fill_rx(struct mt7915_dev *dev, struct sk_buff *skb)
 	bool unicast, insert_ccmp_hdr = false;
 	u8 remove_pad, amsdu_info;
 	u8 mode = 0, qos_ctl = 0;
-	struct mt7915_sta *msta;
+	struct mt7915_sta *msta = NULL;
 	bool hdr_trans;
 	u16 hdr_gap;
 	u16 seq_ctrl = 0;
-- 
2.35.1



