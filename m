Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4196DB86A0
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406213AbfISWPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404416AbfISWPt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:15:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D485321907;
        Thu, 19 Sep 2019 22:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931348;
        bh=9lb3SWxX/C1wWDSA+roIseZKqStn2Kk5e3tEe6Fhw1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ADRwd9C1vpXOa7k1UCKmDkxwmTlPRfXkBrFPgaecgtB/ZJSd55LIPhp/VSiQsl6dY
         IMvk4dDnHHzSuMV9R6AOZgmlqpQLeoee1DySw8B0Gf9DTcBCKelgxB5ITQNGEHCYOR
         TvFDhJHP4/AGAnSNa7PpX3t3Hfc/L0WrFZMVcfU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Masashi Honma <masashi.honma@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 14/59] nl80211: Fix possible Spectre-v1 for CQM RSSI thresholds
Date:   Fri, 20 Sep 2019 00:03:29 +0200
Message-Id: <20190919214759.601512597@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masashi Honma <masashi.honma@gmail.com>

commit 4b2c5a14cd8005a900075f7dfec87473c6ee66fb upstream.

commit 1222a1601488 ("nl80211: Fix possible Spectre-v1 for CQM
RSSI thresholds") was incomplete and requires one more fix to
prevent accessing to rssi_thresholds[n] because user can control
rssi_thresholds[i] values to make i reach to n. For example,
rssi_thresholds = {-400, -300, -200, -100} when last is -34.

Cc: stable@vger.kernel.org
Fixes: 1222a1601488 ("nl80211: Fix possible Spectre-v1 for CQM RSSI thresholds")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
Link: https://lore.kernel.org/r/20190908005653.17433-1-masashi.honma@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9753,9 +9753,11 @@ static int cfg80211_cqm_rssi_update(stru
 	hyst = wdev->cqm_config->rssi_hyst;
 	n = wdev->cqm_config->n_rssi_thresholds;
 
-	for (i = 0; i < n; i++)
+	for (i = 0; i < n; i++) {
+		i = array_index_nospec(i, n);
 		if (last < wdev->cqm_config->rssi_thresholds[i])
 			break;
+	}
 
 	low_index = i - 1;
 	if (low_index >= 0) {


