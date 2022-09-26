Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946515EA2F5
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234453AbiIZLQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237608AbiIZLQV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:16:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC7A65641;
        Mon, 26 Sep 2022 03:37:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E0B1B80757;
        Mon, 26 Sep 2022 10:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF019C4347C;
        Mon, 26 Sep 2022 10:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188543;
        bh=QlhGB4CupNlE5Ql5M5U7uGoDAhrr38NVyD/sKJ3vxrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OTqUW0xgtIm3jM7kL/NXfEx9TLdrPi8LE21EENjC5/HNoCeSAMzoHFxTVvMkOZQgF
         S73XdDV+WViYb1MXEEh34Rt+GeLzapVe72RyXMruAWJWFSifLsQuzh64yXHIRu1Yb5
         +awvAdgJ1ZJHckM0DTirD2MIIL1SNnOeZWNRvFDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.15 042/148] wifi: mt76: fix reading current per-tid starting sequence number for aggregation
Date:   Mon, 26 Sep 2022 12:11:16 +0200
Message-Id: <20220926100757.596969888@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit c3a510e2b53785df31d882a773c4c0780b4c825f upstream.

The code was accidentally shifting register values down by tid % 32 instead of
(tid * field_size) % 32.

Cc: stable@vger.kernel.org
Fixes: a28bef561a5c ("mt76: mt7615: re-enable offloading of sequence number assignment")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220826182329.18155-1-nbd@nbd.name
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1038,7 +1038,7 @@ u32 mt7615_mac_get_sta_tid_sn(struct mt7
 	offset %= 32;
 
 	val = mt76_rr(dev, addr);
-	val >>= (tid % 32);
+	val >>= offset;
 
 	if (offset > 20) {
 		addr += 4;


