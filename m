Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7AC205D08
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388197AbgFWUID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388692AbgFWUIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:08:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 807D82078A;
        Tue, 23 Jun 2020 20:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942882;
        bh=DTy5+KKhOvDumFrETKDqUe+uDSaHlmNX0AfYy8W082g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PMYt6AJ42zM2JpTyawxZcEReUmhOsavpRByhKIsZb07QR9ldwhsQygPik90d/5rFS
         P1ObgPkPNSr2gTN89Q2956uccGUP81S9r9ToSnxLKKzv9VvsSkgN8ZORK49sAWYbBj
         v7AgDhRIMUfFE3/UWTUJJ/EznivZUKKAiUGawRPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 141/477] staging: wfx: fix overflow in frame counters
Date:   Tue, 23 Jun 2020 21:52:18 +0200
Message-Id: <20200623195414.272118318@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit 87066173e34b0ca5d041d5519e6bb030b1958184 ]

It has been reported that trying to send small packets of data could
produce a "inconsistent notification" warning.

It seems that in some circumstances, the number of frame queued in the
driver could greatly increase and exceed UCHAR_MAX. So the field
"buffered" from struct sta_priv can overflow.

Just increase the size of "bueffered" to fix the problem.

Fixes: 7d2d2bfdeb82 ("staging: wfx: relocate "buffered" information to sta_priv")
Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20200427134031.323403-10-Jerome.Pouiller@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/sta.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wfx/sta.h b/drivers/staging/wfx/sta.h
index cf99a8a74a81b..ace845f9ed140 100644
--- a/drivers/staging/wfx/sta.h
+++ b/drivers/staging/wfx/sta.h
@@ -37,7 +37,7 @@ struct wfx_grp_addr_table {
 struct wfx_sta_priv {
 	int link_id;
 	int vif_id;
-	u8 buffered[IEEE80211_NUM_TIDS];
+	int buffered[IEEE80211_NUM_TIDS];
 	// Ensure atomicity of "buffered" and calls to ieee80211_sta_set_buffered()
 	spinlock_t lock;
 };
-- 
2.25.1



