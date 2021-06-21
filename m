Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E673AEE1A
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhFUQZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:25:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231869AbhFUQYI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:24:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F85161361;
        Mon, 21 Jun 2021 16:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292458;
        bh=bvVWjjst/6gC7bJkUleLE7w8/ink/O+2lWVwNgYKnJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LWkb3FZbE7C5JDEhUChXJu80Yi9qoXTTgRHc6b/eLp9SgK89HrLK2JAN0QjkawJOm
         VltiNVB/dJjcRj6zI88l2E6tPYorK+tn3SRy2CeU9Pe4XITjb3Ge7/fejQC8EdfzrB
         YkgbbxKAcAwnWsa+K5PODs7Abl4AUqFeN8fPtf9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 71/90] cfg80211: avoid double free of PMSR request
Date:   Mon, 21 Jun 2021 18:15:46 +0200
Message-Id: <20210621154906.557071252@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

commit 0288e5e16a2e18f0b7e61a2b70d9037fc6e4abeb upstream.

If cfg80211_pmsr_process_abort() moves all the PMSR requests that
need to be freed into a local list before aborting and freeing them.
As a result, it is possible that cfg80211_pmsr_complete() will run in
parallel and free the same PMSR request.

Fix it by freeing the request in cfg80211_pmsr_complete() only if it
is still in the original pmsr list.

Cc: stable@vger.kernel.org
Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator API")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210618133832.1fbef57e269a.I00294bebdb0680b892f8d1d5c871fd9dbe785a5e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/pmsr.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/net/wireless/pmsr.c
+++ b/net/wireless/pmsr.c
@@ -293,6 +293,7 @@ void cfg80211_pmsr_complete(struct wirel
 			    gfp_t gfp)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct cfg80211_pmsr_request *tmp, *prev, *to_free = NULL;
 	struct sk_buff *msg;
 	void *hdr;
 
@@ -323,9 +324,20 @@ free_msg:
 	nlmsg_free(msg);
 free_request:
 	spin_lock_bh(&wdev->pmsr_lock);
-	list_del(&req->list);
+	/*
+	 * cfg80211_pmsr_process_abort() may have already moved this request
+	 * to the free list, and will free it later. In this case, don't free
+	 * it here.
+	 */
+	list_for_each_entry_safe(tmp, prev, &wdev->pmsr_list, list) {
+		if (tmp == req) {
+			list_del(&req->list);
+			to_free = req;
+			break;
+		}
+	}
 	spin_unlock_bh(&wdev->pmsr_lock);
-	kfree(req);
+	kfree(to_free);
 }
 EXPORT_SYMBOL_GPL(cfg80211_pmsr_complete);
 


