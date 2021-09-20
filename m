Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31279411B27
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244596AbhITQ4F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:56:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244672AbhITQyD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:54:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8227E61371;
        Mon, 20 Sep 2021 16:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156624;
        bh=C4mfR34Kt8+8pPBTORIUmL3kQkS3THVY86RLORmnMTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vhzG8Urky3W0blV/0dI0ZBBttU0Z6p4iewD2mluHJLZykI8yhAhNi6aRVq9EzJGAV
         fIdobPBReQ/1lQpfaI2W3x9ptS4lsmfYMPx2moglgQponGFAiaiLd4pqf3oJx5ws3z
         8WDLT6oGi4Ah+tKru8a6pUw03cTwS+aTN0r9bPVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.9 011/175] ath9k: Clear key cache explicitly on disabling hardware
Date:   Mon, 20 Sep 2021 18:41:00 +0200
Message-Id: <20210920163918.438147356@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Malinen <jouni@codeaurora.org>

commit 73488cb2fa3bb1ef9f6cf0d757f76958bd4deaca upstream.

Now that ath/key.c may not be explicitly clearing keys from the key
cache, clear all key cache entries when disabling hardware to make sure
no keys are left behind beyond this point.

Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201214172118.18100-3-jouni@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -894,6 +894,11 @@ static void ath9k_stop(struct ieee80211_
 
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
+	/* Clear key cache entries explicitly to get rid of any potentially
+	 * remaining keys.
+	 */
+	ath9k_cmn_init_crypto(sc->sc_ah);
+
 	ath9k_ps_restore(sc);
 
 	sc->ps_idle = prev_idle;


