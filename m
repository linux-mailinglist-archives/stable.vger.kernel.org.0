Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 018AF37C0FE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhELOz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231867AbhELOzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:55:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A91A461425;
        Wed, 12 May 2021 14:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831234;
        bh=Yj+n6HTrbEIbSLsN+7fP3a6ulZraPgYJox0mi+iJUDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NlPA4JpqPg8Z8TpVTSbF6lVJfP1H2mJVXorQWLbu9BbGj+0LXkLCYIk3wLlHIfd2n
         NAmCRt10pKnb1jRTuzyIQ6Ce+1NQU8LAkkEoYFhATCzwcnnOwvZQWxgk7E/dN7uS+c
         jBp9XzLbNurvSNa3ev6WIN1QdZcAnneEsxJ/ALuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 037/244] cfg80211: scan: drop entry from hidden_list on overflow
Date:   Wed, 12 May 2021 16:46:48 +0200
Message-Id: <20210512144744.241185695@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 010bfbe768f7ecc876ffba92db30432de4997e2a upstream.

If we overflow the maximum number of BSS entries and free the
new entry, drop it from any hidden_list that it may have been
added to in the code above or in cfg80211_combine_bsses().

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20210416094212.5de7d1676ad7.Ied283b0bc5f504845e7d6ab90626bdfa68bb3dc0@changeid
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1257,6 +1257,8 @@ cfg80211_bss_update(struct cfg80211_regi
 
 		if (rdev->bss_entries >= bss_entries_limit &&
 		    !cfg80211_bss_expire_oldest(rdev)) {
+			if (!list_empty(&new->hidden_list))
+				list_del(&new->hidden_list);
 			kfree(new);
 			goto drop;
 		}


