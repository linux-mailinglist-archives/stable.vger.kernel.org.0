Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8707F402
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406835AbfHBKCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 06:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404213AbfHBJn0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:43:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEB4220B7C;
        Fri,  2 Aug 2019 09:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739005;
        bh=ZuvzeOkifbdFscsE+cpqtwRqHwkkieq9DjYijZJAm2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6l+sG0pv/xJIfAiUTBK4RNM0ikSmzKtFAy3C1TBPaefahRJviX3ZZBO0wn25ktxc
         7j67pzePCXLtRnFPh0Kf2w5nSDBDgsxAzos8OSKJu+pI/QT+kZoOV56IqfRlvcNCqc
         AC6qSCtNun7Vvk9iLvXxPD6pgW1lQvJurDNjmAvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 065/223] iwlwifi: mvm: Drop large non sta frames
Date:   Fri,  2 Aug 2019 11:34:50 +0200
Message-Id: <20190802092243.047447500@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ac70499ee97231a418dc1a4d6c9dc102e8f64631 ]

In some buggy scenarios we could possible attempt to transmit frames larger
than maximum MSDU size. Since our devices don't know how to handle this,
it may result in asserts, hangs etc.
This can happen, for example, when we receive a large multicast frame
and try to transmit it back to the air in AP mode.
Since in a legal scenario this should never happen, drop such frames and
warn about it.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index bd7ff562d82d..1aa74b87599f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -551,6 +551,9 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 
 	memcpy(&info, skb->cb, sizeof(info));
 
+	if (WARN_ON_ONCE(skb->len > IEEE80211_MAX_DATA_LEN + hdrlen))
+		return -1;
+
 	if (WARN_ON_ONCE(info.flags & IEEE80211_TX_CTL_AMPDU))
 		return -1;
 
-- 
2.20.1



