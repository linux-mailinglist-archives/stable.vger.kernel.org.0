Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29E74513B7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348523AbhKOTx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:53:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:44634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343706AbhKOTVi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B168163380;
        Mon, 15 Nov 2021 18:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001889;
        bh=cRVxZCPhGwa0VnlEXxf70JKCXbBBjfr5vdm258z9Ivg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLnpplQIDB5tBSKPxL/EvRhyZ8U069CKERU+QFtEgrnJD7vwtAvymuwSaXSml+sWo
         t3KENCCtNycCtWdQEusQKlO+y/3DxQFBwL73e8kSnBOF5MR1HNpXzPddKUKtnFgqUT
         ErnMyCdVXLiIZhUJNitA6xhBUVZhJrLgVZrU21BU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 360/917] mac80211: twt: dont use potentially unaligned pointer
Date:   Mon, 15 Nov 2021 17:57:35 +0100
Message-Id: <20211115165440.963540143@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7ff379ba2d4b7b205240e666601fe302207d73f8 ]

Since we're pointing into a frame, the pointer to the
twt_agrt->req_type struct member is potentially not
aligned properly. Open-code le16p_replace_bits() to
avoid passing an unaligned pointer.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: f5a4c24e689f ("mac80211: introduce individual TWT support in AP mode")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20210927115124.e1208694f37b.Ie3de9bcc5dde5a79e3ac81f3185beafe4d214e57@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/s1g.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/s1g.c b/net/mac80211/s1g.c
index 7e35ab5b61664..4141bc80cdfd6 100644
--- a/net/mac80211/s1g.c
+++ b/net/mac80211/s1g.c
@@ -104,9 +104,11 @@ ieee80211_s1g_rx_twt_setup(struct ieee80211_sub_if_data *sdata,
 
 	/* broadcast TWT not supported yet */
 	if (twt->control & IEEE80211_TWT_CONTROL_NEG_TYPE_BROADCAST) {
-		le16p_replace_bits(&twt_agrt->req_type,
-				   TWT_SETUP_CMD_REJECT,
-				   IEEE80211_TWT_REQTYPE_SETUP_CMD);
+		twt_agrt->req_type &=
+			~cpu_to_le16(IEEE80211_TWT_REQTYPE_SETUP_CMD);
+		twt_agrt->req_type |=
+			le16_encode_bits(TWT_SETUP_CMD_REJECT,
+					 IEEE80211_TWT_REQTYPE_SETUP_CMD);
 		goto out;
 	}
 
-- 
2.33.0



