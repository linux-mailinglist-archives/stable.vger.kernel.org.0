Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E8E3AF0A6
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhFUQvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:41158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232973AbhFUQtH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:49:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FBD261459;
        Mon, 21 Jun 2021 16:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293260;
        bh=Abcu7R72Y+ESvSiana/X/2E5PeEUfqnt9bI4nmFOqFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6OcJPoBfp/YR1+eiZ0l+f7+NJBhbgL42tYyrtypU168thtOndG4pKDWnu7cZwJGI
         YJa/sO29FLOzR3U8jjXlCXilbnJU6pdLmJW7u5AGkolEOAemlBnbWhpAHcLeIisFwd
         N6Ckeu82TDL3Zpe18O/AaEX7CKUSNrcC0OLs3a3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.12 157/178] mac80211: minstrel_ht: fix sample time check
Date:   Mon, 21 Jun 2021 18:16:11 +0200
Message-Id: <20210621154928.100445782@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

commit 1236af327af476731aa548dfcbbefb1a3ec6726a upstream.

We need to skip sampling if the next sample time is after jiffies, not before.
This patch fixes an issue where in some cases only very little sampling (or none
at all) is performed, leading to really bad data rates

Fixes: 80d55154b2f8 ("mac80211: minstrel_ht: significantly redesign the rate probing strategy")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20210617103854.61875-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rc80211_minstrel_ht.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -1516,7 +1516,7 @@ minstrel_ht_get_rate(void *priv, struct
 	    (info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO))
 		return;
 
-	if (time_is_before_jiffies(mi->sample_time))
+	if (time_is_after_jiffies(mi->sample_time))
 		return;
 
 	mi->sample_time = jiffies + MINSTREL_SAMPLE_INTERVAL;


