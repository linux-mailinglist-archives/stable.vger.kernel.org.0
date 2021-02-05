Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C748B311102
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbhBERjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:39:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:54086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233441AbhBEP51 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:57:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 894B565078;
        Fri,  5 Feb 2021 14:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534397;
        bh=xgyzvnoPklt8bKJGV32B0uJ0AGIcvYnScLfe+eHno1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZR+JuCRTX2FKiIE5s9LZJP4ITitfiATeaBOrriEDnVxQHkxpxubZYEQTYwxb+UVw
         InJZPTO3ZiUMIvHsyhbeNWFr/+ochnSLEJiq7avUxWkxNQGYWhFlCYihEHNiaEfNHO
         NZKL+nCoJLtFzgW5rzFiH4V6lRhixhDvI/mghzUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 22/32] mac80211: fix fast-rx encryption check
Date:   Fri,  5 Feb 2021 15:07:37 +0100
Message-Id: <20210205140653.293052129@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 622d3b4e39381262da7b18ca1ed1311df227de86 ]

When using WEP, the default unicast key needs to be selected, instead of
the STA PTK.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20201218184718.93650-5-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3ab85e1e38d82..1a15e7bae106a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4080,6 +4080,8 @@ void ieee80211_check_fast_rx(struct sta_info *sta)
 
 	rcu_read_lock();
 	key = rcu_dereference(sta->ptk[sta->ptk_idx]);
+	if (!key)
+		key = rcu_dereference(sdata->default_unicast_key);
 	if (key) {
 		switch (key->conf.cipher) {
 		case WLAN_CIPHER_SUITE_TKIP:
-- 
2.27.0



