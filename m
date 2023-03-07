Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440376AEE48
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbjCGSLA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbjCGSKZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:10:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4096CA42F1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:05:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8DFF5CE1C79
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB87C433EF;
        Tue,  7 Mar 2023 18:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212312;
        bh=2A80Z58Hp2NSVCCFodeok3KSXLHNndCp9od2ZunT07U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kb0m9+QVsugnzcMVjoadcACIIHvrZuKp8wzjhvOnbsOCa8v8/pmUJWSivUSNgwFMv
         YsAZmaL4k7S42GtcngBLS3t/zaIBvpKpwiUTXtbNFFLeGiSFsZgKGbv5Ic6spA23tZ
         no5CyA6ATnryjN/QKcheYtbY+kffm5q9MjQgbmCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 115/885] wifi: mt76: mt7915: fix unintended sign extension of mt7915_hw_queue_read()
Date:   Tue,  7 Mar 2023 17:50:49 +0100
Message-Id: <20230307170006.878516966@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit edb0406bda4629ef496f52eb11cbea7e92ed301b ]

In the expression "map[i].qid << 24" starts as u8, but is promoted to
"signed int", then sign-extended to type "unsigned long", which is not
intended. Cast to u32 to avoid the sign extension.

Fixes: 776ec4e77aa6 ("mt76: mt7915: rework debugfs queue info")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 6ef3431cad648..2975128a78c90 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -759,7 +759,7 @@ mt7915_hw_queue_read(struct seq_file *s, u32 size,
 		if (val & BIT(map[i].index))
 			continue;
 
-		ctrl = BIT(31) | (map[i].pid << 10) | (map[i].qid << 24);
+		ctrl = BIT(31) | (map[i].pid << 10) | ((u32)map[i].qid << 24);
 		mt76_wr(dev, MT_FL_Q0_CTRL, ctrl);
 
 		head = mt76_get_field(dev, MT_FL_Q2_CTRL,
-- 
2.39.2



