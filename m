Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2B674539
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404290AbfGYFkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404341AbfGYFkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:40:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40CBA22BEF;
        Thu, 25 Jul 2019 05:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033219;
        bh=sRjNnaSbB/ercgTaCTUQ2HMIydaVS1kizeSRouQ8XS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwwzbMlYPq1Pu4h1/z4U8qO1tDB5kRVqcpZW526txme3n8YuBw8pAB3yUCRX80heL
         jN/NMFGSStHie7wtWkJnGmT79yI+kYZqoy77catfSCOEkOWRzlts/TT0EKYXrZMmHm
         IsotgEzqsMAdhvbKx4wTKUE8J5GVLbIe5+nlM+Ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 134/271] iwlwifi: mvm: Drop large non sta frames
Date:   Wed, 24 Jul 2019 21:20:03 +0200
Message-Id: <20190724191706.707848147@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
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
index 2d21f0a1fa00..ffae299c3492 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -641,6 +641,9 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 
 	memcpy(&info, skb->cb, sizeof(info));
 
+	if (WARN_ON_ONCE(skb->len > IEEE80211_MAX_DATA_LEN + hdrlen))
+		return -1;
+
 	if (WARN_ON_ONCE(info.flags & IEEE80211_TX_CTL_AMPDU))
 		return -1;
 
-- 
2.20.1



