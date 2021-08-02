Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FBB3DD981
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbhHBOAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236279AbhHBN7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:59:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 863D06113B;
        Mon,  2 Aug 2021 13:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912531;
        bh=1HkeSCeLRg6gOHPEhMcea2MXL6I0yll1FZ3p332yxgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FnyvNkUMDyYMeRDXFyHoVXqbbTPsY/Jg6TaA9i0xDL5X1VHeAI8QxZSI/k9IJ3Wzl
         u356ZXKHjAWueu7FWvunhK7pdAqho8D4eKdiOF1/CGhcG8M5/VcYb0c6iFJgXtAJPQ
         /RA9OSdZTsDTGRdwSdCXT9/fVAAjaN17fpzuq6pY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nguyen Dinh Phi <phind.uet@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.13 034/104] cfg80211: Fix possible memory leak in function cfg80211_bss_update
Date:   Mon,  2 Aug 2021 15:44:31 +0200
Message-Id: <20210802134345.149149752@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
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
@@ -1744,16 +1744,14 @@ cfg80211_bss_update(struct cfg80211_regi
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
 


