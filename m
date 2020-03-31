Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBCF1991E2
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731317AbgCaJIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:08:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731314AbgCaJIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:08:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C58EF20675;
        Tue, 31 Mar 2020 09:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645690;
        bh=+1xLu4UM8eC0DtDYdw0C89iwUWF2tSN4pL1u48vjWDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCIcDXXMaeHxhTFL6TW6le+adUKW6OKRuC5p6Y2gS1EGMbShDw0wcuFmhu7QPcn5t
         3gkyeKQpdw1gm4WX308FKVaexH8jUmYI67uzipsUTrPYm0Py/yWv/PtX1DSZkjvUoY
         yw+ikrXbMuF6rh794GCO82We2K7FEckknxOEq3N8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.5 133/170] ieee80211: fix HE SPR size calculation
Date:   Tue, 31 Mar 2020 10:59:07 +0200
Message-Id: <20200331085437.747111522@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 575a97acc3b7446094b0dcaf6285c7c6934c2477 upstream.

The he_sr_control field is just a u8, so le32_to_cpu()
shouldn't be applied to it; this was evidently copied
from ieee80211_he_oper_size(). Fix it, and also adjust
the type of the local variable.

Fixes: ef11a931bd1c ("mac80211: HE: add Spatial Reuse element parsing support")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20200325090918.dfe483b49e06.Ia53622f23b2610a2ae6ea39a199866196fe946c1@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/ieee80211.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2102,14 +2102,14 @@ ieee80211_he_spr_size(const u8 *he_spr_i
 {
 	struct ieee80211_he_spr *he_spr = (void *)he_spr_ie;
 	u8 spr_len = sizeof(struct ieee80211_he_spr);
-	u32 he_spr_params;
+	u8 he_spr_params;
 
 	/* Make sure the input is not NULL */
 	if (!he_spr_ie)
 		return 0;
 
 	/* Calc required length */
-	he_spr_params = le32_to_cpu(he_spr->he_sr_control);
+	he_spr_params = he_spr->he_sr_control;
 	if (he_spr_params & IEEE80211_HE_SPR_NON_SRG_OFFSET_PRESENT)
 		spr_len++;
 	if (he_spr_params & IEEE80211_HE_SPR_SRG_INFORMATION_PRESENT)


