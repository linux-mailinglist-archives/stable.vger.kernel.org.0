Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E55347AED0
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238241AbhLTPED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237303AbhLTPCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:02:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4AFC08ED8C;
        Mon, 20 Dec 2021 06:51:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDB86B80EED;
        Mon, 20 Dec 2021 14:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D616C36AE7;
        Mon, 20 Dec 2021 14:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011889;
        bh=lQP/t8cEjkRjYcCnjSrNpxyxh+7/iO4jjLfrclS7w0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuaydNyh6ZE5YhuQjNrqx0zTRwt8tX+IMYUT3Hb0NRm8/3F4gUI5FRBEt8xBXhfAC
         fIuTyCCVL/n2QspEfkxm6xn1VdsbtxWK9bVOu0cmG69XOMITstsxtFFgrTPaiE6QU/
         HoR2bd/7wlvNxwjHADgBqFR5aU9HTjOUJIpY+5Lk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+59bdff68edce82e393b6@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 011/177] mac80211: validate extended element ID is present
Date:   Mon, 20 Dec 2021 15:32:41 +0100
Message-Id: <20211220143040.460577210@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
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
@@ -943,7 +943,12 @@ static void ieee80211_parse_extension_el
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


