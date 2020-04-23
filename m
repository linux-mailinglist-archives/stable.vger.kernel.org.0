Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F361B69C4
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgDWX0K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:26:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48126 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbgDWXG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:26 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvH-0004ZK-Td; Fri, 24 Apr 2020 00:06:23 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvH-00E6eP-Fe; Fri, 24 Apr 2020 00:06:23 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Nicolai Stange" <nstange@suse.de>,
        "Kalle Valo" <kvalo@codeaurora.org>
Date:   Fri, 24 Apr 2020 00:03:51 +0100
Message-ID: <lsq.1587683028.253321576@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 004/245] libertas: make lbs_ibss_join_existing()
 return error code on rates overflow
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Stange <nstange@suse.de>

commit 1754c4f60aaf1e17d886afefee97e94d7f27b4cb upstream.

Commit e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss
descriptor") introduced a bounds check on the number of supplied rates to
lbs_ibss_join_existing() and made it to return on overflow.

However, the aforementioned commit doesn't set the return value accordingly
and thus, lbs_ibss_join_existing() would return with zero even though it
failed.

Make lbs_ibss_join_existing return -EINVAL in case the bounds check on the
number of supplied rates fails.

Fixes: e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss descriptor")
Signed-off-by: Nicolai Stange <nstange@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/libertas/cfg.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -1856,6 +1856,7 @@ static int lbs_ibss_join_existing(struct
 		if (rates_max > MAX_RATES) {
 			lbs_deb_join("invalid rates");
 			rcu_read_unlock();
+			ret = -EINVAL;
 			goto out;
 		}
 		rates = cmd.bss.rates;

