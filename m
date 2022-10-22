Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B5060873F
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbiJVH6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232236AbiJVH4s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:56:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF9B13A588;
        Sat, 22 Oct 2022 00:48:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CE46B82E1C;
        Sat, 22 Oct 2022 07:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEB6C433D6;
        Sat, 22 Oct 2022 07:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424703;
        bh=uKCPqX8as8dkL2IZatNJrSMA6N4n2ERN4NedPly5oI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLj/n9x+1oXu3a0Y04YtrIcDspxFKhopJfhpAo6Ch4Rk8AWovujNElDmJ4HaxzpAT
         d6WxaYg5cLRfKtv4XxAeqO1PM/+ebMpMqjtKrAPY0WuyYhEmtp1NpHb/KadacCaFMK
         VmVQPnXfBUNoYeJ+K8O2zT0igvz6sVHsL8Ii0SFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 245/717] wifi: mt76: connac: fix possible unaligned access in mt76_connac_mcu_add_nested_tlv
Date:   Sat, 22 Oct 2022 09:22:04 +0200
Message-Id: <20221022072458.267489976@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 0a4860f627f1f2b2b777f54f993de1638a79da9f ]

Fix possible unaligned pointer in mt76_connac_mcu_add_nested_tlv
routine.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 25702d9c55dc5 ("mt76: connac: rely on le16_add_cpu in mt76_connac_mcu_add_nested_tlv")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 7eb23805aa94..d10b441eac4f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -258,8 +258,10 @@ mt76_connac_mcu_add_nested_tlv(struct sk_buff *skb, int tag, int len,
 	ntlv = le16_to_cpu(ntlv_hdr->tlv_num);
 	ntlv_hdr->tlv_num = cpu_to_le16(ntlv + 1);
 
-	if (sta_hdr)
-		le16_add_cpu(&sta_hdr->len, len);
+	if (sta_hdr) {
+		len += le16_to_cpu(sta_hdr->len);
+		sta_hdr->len = cpu_to_le16(len);
+	}
 
 	return ptlv;
 }
-- 
2.35.1



