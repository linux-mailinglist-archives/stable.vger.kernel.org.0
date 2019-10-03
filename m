Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79595CA171
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 17:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbfJCPz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbfJCPz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:55:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3EBF20700;
        Thu,  3 Oct 2019 15:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118156;
        bh=2E95dSBRWtQr6Z6UBdjENXXfyVla9zDM7EnJmd5Yigg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2LXLEGIG/oQ2VAxJS6dCtpbtPSmABeRp3rPUFxMuA8mau9Wr6OSRTCbHdssVjYKRd
         OqJ+YX/YW45prge4iVbzqy0QPCOxKO1C0Zz97527RVGw3DWZIVAWA0rTOI5BmIBShV
         Pjz5tkImJn1I4iTyBRxWJFgGc4fzIFu9i3Adeb2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 11/99] mac80211: Print text for disassociation reason
Date:   Thu,  3 Oct 2019 17:52:34 +0200
Message-Id: <20191003154258.281012302@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>

[ Upstream commit 68506e9af132a6b5735c1dd4b11240da0cf5eeae ]

When disassociation happens only numeric reason is printed
in ieee80211_rx_mgmt_disassoc(). Add text variant, too.

Signed-off-by: Arkadiusz Miśkiewicz <arekm@maven.pl>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ae5387b93df37..3daf3ae4003be 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2857,8 +2857,9 @@ static void ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
-	sdata_info(sdata, "disassociated from %pM (Reason: %u)\n",
-		   mgmt->sa, reason_code);
+	sdata_info(sdata, "disassociated from %pM (Reason: %u=%s)\n",
+		   mgmt->sa, reason_code,
+		   ieee80211_get_reason_code_string(reason_code));
 
 	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
-- 
2.20.1



