Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6841B0BA0
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728949AbgDTM5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728613AbgDTMok (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:44:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 273F5206E9;
        Mon, 20 Apr 2020 12:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386679;
        bh=MdoRFjsV1Lh+ptXgT+zMxl1iZK4FAh48GuDQIzManUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAsdbUOTKzziI/JQjAvQ2gWlZGofav8aBTq1JkMoeL1QAD5uPMOqECU8q5HSCG504
         pa7hkeM97VNr/HpwqdByDDFmOacfXGZnI4Lz2Dqiul7q2DxFB0/wwOrPtdcRzhezxL
         Ye8OEAmPnISAxaoTJxjhlLIGndCYptIB+W+lx7d0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.6 52/71] nl80211: fix NL80211_ATTR_FTM_RESPONDER policy
Date:   Mon, 20 Apr 2020 14:39:06 +0200
Message-Id: <20200420121519.625075840@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121508.491252919@linuxfoundation.org>
References: <20200420121508.491252919@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 0e012b4e4b5ec8e064be3502382579dd0bb43269 upstream.

The nested policy here should be established using the
NLA_POLICY_NESTED() macro so the length is properly
filled in.

Cc: stable@vger.kernel.org
Fixes: 81e54d08d9d8 ("cfg80211: support FTM responder configuration/statistics")
Link: https://lore.kernel.org/r/20200412004029.9d0722bb56c8.Ie690bfcc4a1a61ff8d8ca7e475d59fcaa52fb2da@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -619,10 +619,8 @@ const struct nla_policy nl80211_policy[N
 	[NL80211_ATTR_HE_CAPABILITY] = { .type = NLA_BINARY,
 					 .len = NL80211_HE_MAX_CAPABILITY_LEN },
 
-	[NL80211_ATTR_FTM_RESPONDER] = {
-		.type = NLA_NESTED,
-		.validation_data = nl80211_ftm_responder_policy,
-	},
+	[NL80211_ATTR_FTM_RESPONDER] =
+		NLA_POLICY_NESTED(nl80211_ftm_responder_policy),
 	[NL80211_ATTR_TIMEOUT] = NLA_POLICY_MIN(NLA_U32, 1),
 	[NL80211_ATTR_PEER_MEASUREMENTS] =
 		NLA_POLICY_NESTED(nl80211_pmsr_attr_policy),


