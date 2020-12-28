Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6452E40F5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440315AbgL1OOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:14:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440309AbgL1OOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:14:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9540720731;
        Mon, 28 Dec 2020 14:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164802;
        bh=fZ6Kn4rPUq9KtioS1e0jKBS0B5PWzIC6EwLWFf1z2Zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+AW7z/fSZiMKzFjOaKxGGH7rpjj0M+842MDO/+aNYJRF0d7UoIgjao8M/N6O/chT
         er+kkCdSfBnvo5CuW+XGgu8abDFKaPJ59fcSKllf2RZHE9BsiHQ0CYI/JkTCu+xRyH
         48QtyP0/TfejChmRHP38FuXOy1sQTkVOzZjz7Eqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 303/717] mt76: mt7915: set fops_sta_stats.owner to THIS_MODULE
Date:   Mon, 28 Dec 2020 13:45:01 +0100
Message-Id: <20201228125035.544901560@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 5efbe3b1b8992d5f837388091920945c23212159 ]

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: ec9742a8f38e ("mt76: mt7915: add .sta_add_debugfs support")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index 1049927faf246..d2ac7e5ee60a2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -460,6 +460,7 @@ static const struct file_operations fops_sta_stats = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
+	.owner = THIS_MODULE,
 };
 
 void mt7915_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-- 
2.27.0



