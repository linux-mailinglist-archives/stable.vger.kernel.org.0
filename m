Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88B03F66A2
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239713AbhHXR0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:26:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240620AbhHXRWO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0264761882;
        Tue, 24 Aug 2021 17:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824616;
        bh=gQp5n812jLH3sfq+6yBJFf6d48l/2qD1Grf9TT4PUlE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QMwCAGPK3HFiq5v0o10vMb1xywCDyOR04AGwYBKzcq1U2MtvwPK4BB9Kyl/Nr/Hzt
         2KjARCQhUiCl6ootmJBmdi+6ri1+exHb+I3byZ+w9gIGD8a9d5QEK3K2cwcPW22IDa
         3WjEqP8XfRPwIpbadAFmaxY7t+8o4ZvpvsijNw+uCXTYRGsdUp9R4NqOAEouTJfst6
         7JpAWwsgJ9AH9PC0+71MHCYoQyWo1zi0TcDaUoIolnJ5nZI5o0u4spRUYRledkSDpM
         2rOI7nglYVRfRhTIzeAmX6DmiqqL0W7M1v3Fu4qZdx3FfJIJRl680OqjMIDeKt9psh
         F34+nkAG3rFfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 46/84] ath9k: Clear key cache explicitly on disabling hardware
Date:   Tue, 24 Aug 2021 13:02:12 -0400
Message-Id: <20210824170250.710392-47-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
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
index e929020d7c9c..4b0a3f042ca3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -896,6 +896,11 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
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

