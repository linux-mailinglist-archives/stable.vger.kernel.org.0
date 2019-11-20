Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2130103F96
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbfKTPpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:45:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52688 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729338AbfKTPkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:17 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004ag-FY; Wed, 20 Nov 2019 15:40:12 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004Ii-10; Wed, 20 Nov 2019 15:40:12 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Robert Hodaszi" <robert.hodaszi@digi.com>,
        "Hodaszi, Robert" <Robert.Hodaszi@digi.com>,
        "Johannes Berg" <johannes.berg@intel.com>
Date:   Wed, 20 Nov 2019 15:37:51 +0000
Message-ID: <lsq.1574264230.641188431@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 41/83] Revert "cfg80211: fix processing world
 regdomain when non modular"
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Hodaszi, Robert" <Robert.Hodaszi@digi.com>

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

Fixes: 96cce12ff6e0 ("cfg80211: fix processing world regdomain when non modular")
Signed-off-by: Robert Hodaszi <robert.hodaszi@digi.com>
Link: https://lore.kernel.org/r/20190614131600.GA13897@a1-hr
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1913,7 +1913,7 @@ static void reg_process_pending_hints(vo
 
 	/* When last_request->processed becomes true this will be rescheduled */
 	if (lr && !lr->processed) {
-		reg_process_hint(lr);
+		pr_debug("Pending regulatory request, waiting for it to be processed...\n");
 		return;
 	}
 

