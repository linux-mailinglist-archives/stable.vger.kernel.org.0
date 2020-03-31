Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99FF91990EA
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731046AbgCaJPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:15:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgCaJPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:15:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C763208E0;
        Tue, 31 Mar 2020 09:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646146;
        bh=t4fDSHC9Vo7tWKfxMQCIigCearlKnvxQUe+quo/ArlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/XcJu3Ij+9nvcXUwJ/bwMITFwXXQldQA1j6vyBX8QkZyXlOhj4l1jsyHEMtUAYUn
         x9uLSjsWkQsLJncqkEBB2daZqHXc5x92whvuuj1so/ii45PdpYM3Z/VklA3DqpmFwk
         Fn4ebYBtGk09YzdZ49/DmIDMl7Awwrirop0M4HBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 097/155] nl80211: fix NL80211_ATTR_CHANNEL_WIDTH attribute type
Date:   Tue, 31 Mar 2020 10:58:57 +0200
Message-Id: <20200331085429.444477280@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
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
@@ -16407,7 +16407,7 @@ void cfg80211_sta_opmode_change_notify(s
 		goto nla_put_failure;
 
 	if ((sta_opmode->changed & STA_OPMODE_MAX_BW_CHANGED) &&
-	    nla_put_u8(msg, NL80211_ATTR_CHANNEL_WIDTH, sta_opmode->bw))
+	    nla_put_u32(msg, NL80211_ATTR_CHANNEL_WIDTH, sta_opmode->bw))
 		goto nla_put_failure;
 
 	if ((sta_opmode->changed & STA_OPMODE_N_SS_CHANGED) &&


