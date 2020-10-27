Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763B929BD59
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799561AbgJ0Pm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800851AbgJ0Pg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:36:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2BCF22264;
        Tue, 27 Oct 2020 15:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813017;
        bh=l7550WL8V7HrHeDV9MOX337k1Jz9qcvopLUQ/QNR858=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=14B0cFA1eIPRWVbVCBk9QVtcqi9SCLWMnYqyqXR6zegLSrm25X4A1VXLamaxF9sol
         XTefYrl9Bp6WFM12dRqJ4E+cIvNMPn5n9TEdcsyAT+qqBmq3A46jjduSPpeYIIT+mw
         OWlUmyxNiMLNR1t06xiLmv0IMP3JBCuq5piarOhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 379/757] staging: wfx: fix BA sessions for older firmwares
Date:   Tue, 27 Oct 2020 14:50:29 +0100
Message-Id: <20201027135508.330298911@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit 4fd1241778b08129f196605c62636a4d6d71c2c7 ]

Firmwares with API < 3.6 do not forward DELBA requests. Thus, when a
Block Ack session is restarted, the reordering buffer is not flushed and
the received sequence number is not contiguous. Therefore, mac80211
starts to wait some missing frames that it will never receive.

This patch disables the reordering buffer for old firmware. It is
harmless when the network is unencrypted. When the network is encrypted,
the non-contiguous frames will be thrown away by the TKIP/CCMP replay
protection. So, the user will observe some packet loss with UDP and
performance drop with TCP.

Fixes: e5da5fbd7741 ("staging: wfx: fix CCMP/TKIP replay protection")
Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20201007101943.749898-4-Jerome.Pouiller@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/data_rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/wfx/data_rx.c b/drivers/staging/wfx/data_rx.c
index 6fb0788807426..33b715b7b94bb 100644
--- a/drivers/staging/wfx/data_rx.c
+++ b/drivers/staging/wfx/data_rx.c
@@ -17,6 +17,9 @@ static void wfx_rx_handle_ba(struct wfx_vif *wvif, struct ieee80211_mgmt *mgmt)
 {
 	int params, tid;
 
+	if (wfx_api_older_than(wvif->wdev, 3, 6))
+		return;
+
 	switch (mgmt->u.action.u.addba_req.action_code) {
 	case WLAN_ACTION_ADDBA_REQ:
 		params = le16_to_cpu(mgmt->u.action.u.addba_req.capab);
-- 
2.25.1



