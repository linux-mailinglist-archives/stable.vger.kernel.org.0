Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCD52E3D48
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440235AbgL1ONl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:13:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:47560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440231AbgL1ONk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:13:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7997D207AB;
        Mon, 28 Dec 2020 14:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164805;
        bh=jqJfL+IA61ChRHh+GJgYt9xRBt9X2UOH7kO8EdhLkfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjEwCrUtR2B0xSN2L4E7jUysO+H5fFI36I/9f8y0V0gX6RwnuvTQP3Mrh4XP+UJvl
         AItK5b03I5S8YrB5JgRbTPMIuPM/um4Km3+Q7mZa8d1wmvNo7nSYFMrL+uvT69lfNL
         2YQp0SvTNS85WN377cum0U1gBtsPENOHmbTtXLkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 304/717] mt76: set fops_tx_stats.owner to THIS_MODULE
Date:   Mon, 28 Dec 2020 13:45:02 +0100
Message-Id: <20201228125035.591849201@linuxfoundation.org>
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

[ Upstream commit f9df085ce1be5c599e4df590ff7ba853786c6d95 ]

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
index d2ac7e5ee60a2..8f2ad32ade180 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/debugfs.c
@@ -233,6 +233,7 @@ static const struct file_operations fops_tx_stats = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
+	.owner = THIS_MODULE,
 };
 
 static int mt7915_read_temperature(struct seq_file *s, void *data)
-- 
2.27.0



