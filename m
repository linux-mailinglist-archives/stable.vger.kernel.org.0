Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2933F64A3
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbhHXRGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:06:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238734AbhHXRDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:03:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0680B613AD;
        Tue, 24 Aug 2021 16:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824352;
        bh=glfijK9RYgrdyWE3nv5SRvg/QmtOBe5WB3JrgVvs2LY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EjbnLZ7hqzqy1GvKOmrVXzfab/GUX34TbuxbKivioj3wUPMGoG5z1Aa3/hlPNl4N9
         X0QJx65yeohjbJ6f1Psun6m9uscCwgR2ikWrkv73tVhqUx9YXtWB2rDbrfHAs3b3cx
         EXwt6qxxL2Vnxjsn432hBzPUWfCL4RU4nVF4HgTDc315TU1U7tWzu7QPPPlE+g2zQs
         cTPK/icGK09j7T16IQ16u6CsGuRErexZJ9/S0iR5jUr7+w9R07qicjYCWf7ZJ3paST
         rjNN0Al3hgY7HW7gWMNVfXE2UiAvBEyoFRPwJ0p5gLbgE/LxUE4RlKZhV1P71IUivu
         FuQeJ49waP5Yg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.10 02/98] ath9k: Clear key cache explicitly on disabling hardware
Date:   Tue, 24 Aug 2021 12:57:32 -0400
Message-Id: <20210824165908.709932-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
Cc: Pali Rohár <pali@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ac805f56627a..7d933fd8e5bb 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -899,6 +899,11 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	spin_unlock_bh(&sc->sc_pcu_lock);
 
+	/* Clear key cache entries explicitly to get rid of any potentially
+	 * remaining keys.
+	 */
+	ath9k_cmn_init_crypto(sc->sc_ah);
+
 	ath9k_ps_restore(sc);
 
 	sc->ps_idle = prev_idle;
-- 
2.30.2

