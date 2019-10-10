Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAA5D25A9
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388193AbfJJIku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387576AbfJJIkt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:40:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA83420B7C;
        Thu, 10 Oct 2019 08:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696849;
        bh=U7gRGV/O4IvB29cLMdvtxm+jQ0J8p2tK9b/FYOCtQDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GpNh+JMBon3ubE7i29mMMoEqt2MoETxx49L12acv5kbLp9fg58ndv2OKJuJwQTh0X
         1sHZk/gPZ6DJnlBgSX/63X/V/UjTFbLuFPxmGmyj389RLFjwxNd4Yu3kcd1HHp5V1i
         K7Gh6V85sTXIx3XRZ3G/zELfHK6m/A9j8j5IrlKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Hill <aa1ronham@gmail.com>,
        Lukas Redlinger <rel+kernel@agilox.net>,
        Oleksii Shevchuk <alxchk@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.3 073/148] mac80211: keep BHs disabled while calling drv_tx_wake_queue()
Date:   Thu, 10 Oct 2019 10:35:34 +0200
Message-Id: <20191010083615.810908484@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit d8dec42b5c2d2b273bc30b0e073cfbe832d69902 upstream.

Drivers typically expect this, as it's the case for almost all cases
where this is called (i.e. from the TX path). Also, the code in mac80211
itself (if the driver calls ieee80211_tx_dequeue()) expects this as it
uses this_cpu_ptr() without additional protection.

This should fix various reports of the problem:
https://bugzilla.kernel.org/show_bug.cgi?id=204127
https://lore.kernel.org/linux-wireless/CAN5HydrWb3o_FE6A1XDnP1E+xS66d5kiEuhHfiGKkLNQokx13Q@mail.gmail.com/
https://lore.kernel.org/lkml/nycvar.YFH.7.76.1909111238470.473@cbobk.fhfr.pm/

Cc: stable@vger.kernel.org
Reported-and-tested-by: Jiri Kosina <jkosina@suse.cz>
Reported-by: Aaron Hill <aa1ronham@gmail.com>
Reported-by: Lukas Redlinger <rel+kernel@agilox.net>
Reported-by: Oleksii Shevchuk <alxchk@gmail.com>
Fixes: 21a5d4c3a45c ("mac80211: add stop/start logic for software TXQs")
Link: https://lore.kernel.org/r/1569928763-I3e8838c5ecad878e59d4a94eb069a90f6641461a@changeid
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/util.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -247,7 +247,8 @@ static void __ieee80211_wake_txqs(struct
 	struct sta_info *sta;
 	int i;
 
-	spin_lock_bh(&fq->lock);
+	local_bh_disable();
+	spin_lock(&fq->lock);
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP)
 		ps = &sdata->bss->ps;
@@ -273,9 +274,9 @@ static void __ieee80211_wake_txqs(struct
 						&txqi->flags))
 				continue;
 
-			spin_unlock_bh(&fq->lock);
+			spin_unlock(&fq->lock);
 			drv_wake_tx_queue(local, txqi);
-			spin_lock_bh(&fq->lock);
+			spin_lock(&fq->lock);
 		}
 	}
 
@@ -288,12 +289,14 @@ static void __ieee80211_wake_txqs(struct
 	    (ps && atomic_read(&ps->num_sta_ps)) || ac != vif->txq->ac)
 		goto out;
 
-	spin_unlock_bh(&fq->lock);
+	spin_unlock(&fq->lock);
 
 	drv_wake_tx_queue(local, txqi);
+	local_bh_enable();
 	return;
 out:
-	spin_unlock_bh(&fq->lock);
+	spin_unlock(&fq->lock);
+	local_bh_enable();
 }
 
 static void


