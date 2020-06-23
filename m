Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC127205D0A
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387917AbgFWUIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387792AbgFWUIE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:08:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 140B32078A;
        Tue, 23 Jun 2020 20:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942884;
        bh=kFvlRI1DJkWhOtlwTbd/fwD/9DKWV8ga+NNawGwowEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pu8YF57zBaqG87NsaG7DzuiHOU1r6bSe28BW/3bxbSa4ksOZcNxtb7ziD/6bPivAN
         FG1XF+3Y6c4trqZshtTmH2VA83RSQS19SOqThrk/pxJjW3giX60lmkC+es9IDQ/B+h
         u8ng5s//4VAYbwB/qDYI8Klo8fpwsiyQ38IkSJf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 142/477] staging: wfx: fix double init of tx_policy_upload_work
Date:   Tue, 23 Jun 2020 21:52:19 +0200
Message-Id: <20200623195414.319333698@linuxfoundation.org>
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

[ Upstream commit 6ae0878b4800c7042d35c0fb4c6baabb62621ecc ]

The work_struct tx_policy_upload_work was initialized twice.

Fixes: 99879121bfbb ("staging: wfx: fix the cache of rate policies on interface reset")
Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20200427134031.323403-12-Jerome.Pouiller@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/sta.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wfx/sta.c b/drivers/staging/wfx/sta.c
index 969d7a4a7fbd9..b4cd7cb1ce569 100644
--- a/drivers/staging/wfx/sta.c
+++ b/drivers/staging/wfx/sta.c
@@ -1049,7 +1049,6 @@ int wfx_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	init_completion(&wvif->scan_complete);
 	INIT_WORK(&wvif->scan_work, wfx_hw_scan_work);
 
-	INIT_WORK(&wvif->tx_policy_upload_work, wfx_tx_policy_upload_work);
 	mutex_unlock(&wdev->conf_mutex);
 
 	hif_set_macaddr(wvif, vif->addr);
-- 
2.25.1



