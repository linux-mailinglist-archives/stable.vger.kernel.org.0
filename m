Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D985A9143
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390485AbfIDSO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:14:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390784AbfIDSO0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:14:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1C2022CF7;
        Wed,  4 Sep 2019 18:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620865;
        bh=XWQBgoLY4BuOh4fxWyMIoplPF5D+67TJ2badyDWx9f4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9+njK2HsHgWznjKqHbbvc4UZRp/vjqJIQItNcTILZeYH8iAqxwVIHuW3uVIqHbc8
         xjRyKB/bWUm5mPT7v+9PHCsS3Q4hGEkjWcU0LogiS8hEyVJkfDo88gH8+yrRWw0ycN
         x948ljxfO8rrUBunwmziExtwDz89cy1MRdu7h3iE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hodaszi <robert.hodaszi@digi.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.2 124/143] Revert "cfg80211: fix processing world regdomain when non modular"
Date:   Wed,  4 Sep 2019 19:54:27 +0200
Message-Id: <20190904175319.259723212@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
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
@@ -2788,7 +2788,7 @@ static void reg_process_pending_hints(vo
 
 	/* When last_request->processed becomes true this will be rescheduled */
 	if (lr && !lr->processed) {
-		reg_process_hint(lr);
+		pr_debug("Pending regulatory request, waiting for it to be processed...\n");
 		return;
 	}
 


