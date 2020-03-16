Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E773C1875A2
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 23:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732815AbgCPWbP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 18:31:15 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:49130 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732770AbgCPWbP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 18:31:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584397873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/+qrXyrX4BXE0wU00InkhyqrFJWb/9bTzqHRraJpPNU=;
        b=o/+ZbE/oXgAEoV1lk390C/Rp2/trpKBtXxPiNqfNrGVfUJnhRX/4T9TpPsgocKW/wBEpwj
        nvNSRozgOEO+B96FhYUnqREuThERe5+2gUYgf6dz+nDa8JhAhFf90ls7TENqXwqa0eG9oZ
        NaSIh1wMz3Ck7CSVZLRN6ULNbagtCrA=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.9 05/24] batman-adv: Use default throughput value on cfg80211 error
Date:   Mon, 16 Mar 2020 23:30:46 +0100
Message-Id: <20200316223105.6333-6-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200316223105.6333-1-sven@narfation.org>
References: <20200316223105.6333-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3f3f87325dcb3c201076c81490f4da91ad4c09fc upstream.

A wifi interface should never be handled like an ethernet devices. The
parser of the cfg80211 output must therefore skip the ethtool code when
cfg80211_get_station returned an error.

Fixes: f44a3ae9a281 ("batman-adv: refactor wifi interface detection")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Reviewed-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bat_v_elp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/bat_v_elp.c b/net/batman-adv/bat_v_elp.c
index 5d79004de25c..337cdcd3386f 100644
--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -100,8 +100,10 @@ static u32 batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh)
 				 */
 				return 0;
 			}
-			if (!ret)
-				return sinfo.expected_throughput / 100;
+			if (ret)
+				goto default_throughput;
+
+			return sinfo.expected_throughput / 100;
 		}
 
 		/* unsupported WiFi driver version */
-- 
2.20.1

