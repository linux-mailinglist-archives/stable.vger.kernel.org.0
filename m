Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1FD3DD917
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbhHBN5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235145AbhHBNze (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:55:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BBCC611C7;
        Mon,  2 Aug 2021 13:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912441;
        bh=jwiD68Kt9Ea8IEOA1Eb8yzP4bQY8DfSsIb0n8LdyZYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hp2/GSvmop3U66ngmZrHW54BEmjnaZ5YE+k1fMqVD5RMnSYSQuF/WRZBk5Z0XuJMX
         2+AX6rI6I/zsr8nN6B1BWgGFRBPsWlC9arOr8VPUaSiSJlcOBYEGYgA4IeUVsRQsok
         HVvPhYchVtXSXyvqITXD25gOmUveE+JjeS4NV0NA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nguyen Dinh Phi <phind.uet@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 27/67] cfg80211: Fix possible memory leak in function cfg80211_bss_update
Date:   Mon,  2 Aug 2021 15:44:50 +0200
Message-Id: <20210802134339.942278538@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nguyen Dinh Phi <phind.uet@gmail.com>

commit f9a5c358c8d26fed0cc45f2afc64633d4ba21dff upstream.

When we exceed the limit of BSS entries, this function will free the
new entry, however, at this time, it is the last door to access the
inputed ies, so these ies will be unreferenced objects and cause memory
leak.
Therefore we should free its ies before deallocating the new entry, beside
of dropping it from hidden_list.

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Link: https://lore.kernel.org/r/20210628132334.851095-1-phind.uet@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1746,16 +1746,14 @@ cfg80211_bss_update(struct cfg80211_regi
 			 * be grouped with this beacon for updates ...
 			 */
 			if (!cfg80211_combine_bsses(rdev, new)) {
-				kfree(new);
+				bss_ref_put(rdev, new);
 				goto drop;
 			}
 		}
 
 		if (rdev->bss_entries >= bss_entries_limit &&
 		    !cfg80211_bss_expire_oldest(rdev)) {
-			if (!list_empty(&new->hidden_list))
-				list_del(&new->hidden_list);
-			kfree(new);
+			bss_ref_put(rdev, new);
 			goto drop;
 		}
 


