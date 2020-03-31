Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D07B198FDE
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbgCaJHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:07:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731181AbgCaJHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:07:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D341D20675;
        Tue, 31 Mar 2020 09:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645621;
        bh=qQwBDFzSp4aOGOwQwSFV8JxU0PnUe5HGBU7fJ4SIY5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=or2KBLcn1wUikRUey5gq36nLtUDWlwwTnSEE5uHvcK+LX5c83pyikTRsQRE+G38Ru
         EYRYSlamnAxKfr8lbsaYRlGcE2FZaS9Ds2CPT33q1oQLX9KbQ/miERJSJ0ZPrOBNdm
         n2iRQViA9V773NlfoADuUP6R4aNX9OrFZ8CpLIaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.5 108/170] nl80211: fix NL80211_ATTR_CHANNEL_WIDTH attribute type
Date:   Tue, 31 Mar 2020 10:58:42 +0200
Message-Id: <20200331085435.660024649@linuxfoundation.org>
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

commit 0016d3201753b59f3ae84b868fe66c86ad256f19 upstream.

The new opmode notification used this attribute with a u8, when
it's documented as a u32 and indeed used in userspace as such,
it just happens to work on little-endian systems since userspace
isn't doing any strict size validation, and the u8 goes into the
lower byte. Fix this.

Cc: stable@vger.kernel.org
Fixes: 466b9936bf93 ("cfg80211: Add support to notify station's opmode change to userspace")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20200325090531.be124f0a11c7.Iedbf4e197a85471ebd729b186d5365c0343bf7a8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -16416,7 +16416,7 @@ void cfg80211_sta_opmode_change_notify(s
 		goto nla_put_failure;
 
 	if ((sta_opmode->changed & STA_OPMODE_MAX_BW_CHANGED) &&
-	    nla_put_u8(msg, NL80211_ATTR_CHANNEL_WIDTH, sta_opmode->bw))
+	    nla_put_u32(msg, NL80211_ATTR_CHANNEL_WIDTH, sta_opmode->bw))
 		goto nla_put_failure;
 
 	if ((sta_opmode->changed & STA_OPMODE_N_SS_CHANGED) &&


