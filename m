Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2245A10BD89
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbfK0U43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:56:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:47342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731059AbfK0U43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:56:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 860AF2068E;
        Wed, 27 Nov 2019 20:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888188;
        bh=Sf3cIY4FBXZRehIUMul+h13jBBMHJUAoQ3mb0dOaB0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+bmam0a9iKthI+JGrSHl5mKGmoyjDq8p9KuIsRyK0RAJH29Lqw50h9LnyBdon5Mg
         nENcmZDZ8Q/o37i5TY+ziQid3d/TaQpuDevqpUF1mYFcU3mNaU5YgmXPYbxxETIxWb
         mjFZAFhD0uwysZT9DNwk89EbaHkfO81mIS88yVYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 037/306] mt76: do not store aggregation sequence number for null-data frames
Date:   Wed, 27 Nov 2019 21:28:07 +0100
Message-Id: <20191127203117.566587432@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 5155938d8a0fe0e0251435cae02539e81fb8e407 ]

Fixes a rare corner case where a BlockAckReq might get the wrong
sequence number.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 20447fdce4c33..227e5ebfe3dc2 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -148,7 +148,8 @@ mt76_check_agg_ssn(struct mt76_txq *mtxq, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 
-	if (!ieee80211_is_data_qos(hdr->frame_control))
+	if (!ieee80211_is_data_qos(hdr->frame_control) ||
+	    !ieee80211_is_data_present(hdr->frame_control))
 		return;
 
 	mtxq->agg_ssn = le16_to_cpu(hdr->seq_ctrl) + 0x10;
-- 
2.20.1



