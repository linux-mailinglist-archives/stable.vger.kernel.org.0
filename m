Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20832604700
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiJSN03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbiJSN0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:26:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8DD1D3A5D;
        Wed, 19 Oct 2022 06:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 279F3B8238F;
        Wed, 19 Oct 2022 08:51:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A43FC433D6;
        Wed, 19 Oct 2022 08:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169458;
        bh=Fe2eaMVMJuai5RAeCwO60IBS5K+pDaQ07JaRfMxVcPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWNHdvlMI1Za/eZHibwmFmFfUgdZT/gN+Q0Rsz05135v/FdQfAC5saDVgXfByQXpX
         IIfP/9/3ckys/RZpxhVKRbRCQ45bz032P1IBQhGV6nVR58dM8TMux9Fy+Shqn67k5L
         V/EXe4LIJ7JxKbZN8r7TGS3Wd67XOjx0ufrRvHCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 285/862] wifi: mt76: connac: fix possible unaligned access in mt76_connac_mcu_add_nested_tlv
Date:   Wed, 19 Oct 2022 10:26:12 +0200
Message-Id: <20221019083302.600692455@linuxfoundation.org>
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
index 9b17bd97ec09..13d4722e4186 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -260,8 +260,10 @@ mt76_connac_mcu_add_nested_tlv(struct sk_buff *skb, int tag, int len,
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



