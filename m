Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE5EA8FA1
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389160AbfIDSEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:04:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389143AbfIDSEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:04:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B19B208E4;
        Wed,  4 Sep 2019 18:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620291;
        bh=mIoMcKNn9GjbYIpVDxmecKlFNlK+wwsAh9RcwrBCiHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdMsrXgPiYHRQd8zjm6DsePaIgPFEK70tF7hmjq/369WYkoDnIJKSWBMOV9Mreij3
         kO87WSKYHpsVNk1rt4M99P0miQHYpORs9WAASUl+5mT/obmIskFwvT5HZ6GiHcz/01
         f1d4t3TXXJvNcCZl3Vvcyyh9I4NY5V//+L+Ein0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hodaszi <robert.hodaszi@digi.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 47/57] Revert "cfg80211: fix processing world regdomain when non modular"
Date:   Wed,  4 Sep 2019 19:54:15 +0200
Message-Id: <20190904175306.563531412@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175301.777414715@linuxfoundation.org>
References: <20190904175301.777414715@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hodaszi, Robert <Robert.Hodaszi@digi.com>

commit 0d31d4dbf38412f5b8b11b4511d07b840eebe8cb upstream.

This reverts commit 96cce12ff6e0 ("cfg80211: fix processing world
regdomain when non modular").

Re-triggering a reg_process_hint with the last request on all events,
can make the regulatory domain fail in case of multiple WiFi modules. On
slower boards (espacially with mdev), enumeration of the WiFi modules
can end up in an intersected regulatory domain, and user cannot set it
with 'iw reg set' anymore.

This is happening, because:
- 1st module enumerates, queues up a regulatory request
- request gets processed by __reg_process_hint_driver():
  - checks if previous was set by CORE -> yes
    - checks if regulator domain changed -> yes, from '00' to e.g. 'US'
      -> sends request to the 'crda'
- 2nd module enumerates, queues up a regulator request (which triggers
  the reg_todo() work)
- reg_todo() -> reg_process_pending_hints() sees, that the last request
  is not processed yet, so it tries to process it again.
  __reg_process_hint driver() will run again, and:
  - checks if the last request's initiator was the core -> no, it was
    the driver (1st WiFi module)
  - checks, if the previous initiator was the driver -> yes
    - checks if the regulator domain changed -> yes, it was '00' (set by
      core, and crda call did not return yet), and should be changed to 'US'

------> __reg_process_hint_driver calls an intersect

Besides, the reg_process_hint call with the last request is meaningless
since the crda call has a timeout work. If that timeout expires, the
first module's request will lost.

Cc: stable@vger.kernel.org
Fixes: 96cce12ff6e0 ("cfg80211: fix processing world regdomain when non modular")
Signed-off-by: Robert Hodaszi <robert.hodaszi@digi.com>
Link: https://lore.kernel.org/r/20190614131600.GA13897@a1-hr
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/reg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2252,7 +2252,7 @@ static void reg_process_pending_hints(vo
 
 	/* When last_request->processed becomes true this will be rescheduled */
 	if (lr && !lr->processed) {
-		reg_process_hint(lr);
+		pr_debug("Pending regulatory request, waiting for it to be processed...\n");
 		return;
 	}
 


