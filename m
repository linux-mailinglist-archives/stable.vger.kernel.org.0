Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C1F1CAFC4
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgEHNUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:20:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728790AbgEHMlN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56F4F21835;
        Fri,  8 May 2020 12:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941672;
        bh=dtMqCeN0jf3ytObDrTDdY1U5ezSq4z//xU03AYErxMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asiy5aWeLzFW2DH09WlycEOSGUdMYplGUzmQubzaMldp5/jzLUY3PWGQjQFX2iA40
         OZuyd4Y9pyGIMVL6N3xENlPxkmCsshCGSQisPb8AaWTbrdaHQljfDLQXefP6WiHCKp
         uzKgEtXqMucz1Z9t13qCNPz/Cq3RUO6QO0meXSN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.4 126/312] mac80211: fix mgmt-tx abort cookie and leak
Date:   Fri,  8 May 2020 14:31:57 +0200
Message-Id: <20200508123133.362186114@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit e673a65952b4ab045a3e3eb200fdf408004fb4fd upstream.

If a mgmt-tx operation is aborted before it runs, the wrong
cookie is reported back to userspace, and the ack_skb gets
leaked since the frame is freed directly instead of freeing
it using ieee80211_free_txskb(). Fix that.

Fixes: 3b79af973cf4 ("mac80211: stop using pointers as userspace cookies")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/offchannel.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -308,11 +308,10 @@ void ieee80211_roc_notify_destroy(struct
 
 	/* was never transmitted */
 	if (roc->frame) {
-		cfg80211_mgmt_tx_status(&roc->sdata->wdev,
-					(unsigned long)roc->frame,
+		cfg80211_mgmt_tx_status(&roc->sdata->wdev, roc->mgmt_tx_cookie,
 					roc->frame->data, roc->frame->len,
 					false, GFP_KERNEL);
-		kfree_skb(roc->frame);
+		ieee80211_free_txskb(&roc->sdata->local->hw, roc->frame);
 	}
 
 	if (!roc->mgmt_tx_cookie)


