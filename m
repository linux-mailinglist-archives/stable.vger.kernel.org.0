Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3725947AD12
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:50:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236387AbhLTOtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:49:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54282 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237146AbhLTOrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:47:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E780CB80EF4;
        Mon, 20 Dec 2021 14:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E87C36AE8;
        Mon, 20 Dec 2021 14:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011627;
        bh=mtJeu+Rfiso5zgGHkS+BnDh4vCwUgRD9IQmhdh6BppE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOSMO7st8UrIUwHGpj9DMB1HGTSA5PzSJf+zlVS5DJCOOzqSOdAL1i4MiegUFiw8v
         hj25mkrcxS3/uaM4d5vtfMyPgZdwNjcJhghmeivq1YcagsWG2W2ltylB9m3nGW/ppx
         H01F+Bw2MwEzh1U0pMZV/lcLLGZ9KkcvEaSkvJdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+59bdff68edce82e393b6@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 06/99] mac80211: validate extended element ID is present
Date:   Mon, 20 Dec 2021 15:33:39 +0100
Message-Id: <20211220143029.561741348@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 768c0b19b50665e337c96858aa2b7928d6dcf756 upstream.

Before attempting to parse an extended element, verify that
the extended element ID is present.

Fixes: 41cbb0f5a295 ("mac80211: add support for HE")
Reported-by: syzbot+59bdff68edce82e393b6@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20211211201023.f30a1b128c07.I5cacc176da94ba316877c6e10fe3ceec8b4dbd7d@changeid
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/util.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -950,7 +950,12 @@ static void ieee80211_parse_extension_el
 					      struct ieee802_11_elems *elems)
 {
 	const void *data = elem->data + 1;
-	u8 len = elem->datalen - 1;
+	u8 len;
+
+	if (!elem->datalen)
+		return;
+
+	len = elem->datalen - 1;
 
 	switch (elem->data[0]) {
 	case WLAN_EID_EXT_HE_MU_EDCA:


