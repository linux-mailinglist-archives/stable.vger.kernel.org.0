Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34EED35BFBE
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239087AbhDLJGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239173AbhDLJEG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:04:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D71F6127A;
        Mon, 12 Apr 2021 09:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218101;
        bh=pIEuZAiV99MWc4voYWz1ZTuI1rzlSLKpbzDsm62HSTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijOXshFChWnoEhsGIO8lweiv1cwC7TuLBnQW6NX4Sr393OnWl2WG+9lEyfliczw4b
         GpzO7GHw6Byr9WXH45rNGohxUXpFYSQIBtdEQmPg4eTZapu1Mvv0dh/vFByiHa8yYt
         GSvdlvf32GNrBtZEVwbY+zTQIKj3PeZvzC0pOECg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.11 071/210] nl80211: fix potential leak of ACL params
Date:   Mon, 12 Apr 2021 10:39:36 +0200
Message-Id: <20210412084018.380191265@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit abaf94ecc9c356d0b885a84edef4905cdd89cfdd upstream.

In case nl80211_parse_unsol_bcast_probe_resp() results in an
error, need to "goto out" instead of just returning to free
possibly allocated data.

Fixes: 7443dcd1f171 ("nl80211: Unsolicited broadcast probe response support")
Link: https://lore.kernel.org/r/20210408142833.d8bc2e2e454a.If290b1ba85789726a671ff0b237726d4851b5b0f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5,7 +5,7 @@
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright 2015-2017	Intel Deutschland GmbH
- * Copyright (C) 2018-2020 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 
 #include <linux/if.h>
@@ -5401,7 +5401,7 @@ static int nl80211_start_ap(struct sk_bu
 			rdev, info->attrs[NL80211_ATTR_UNSOL_BCAST_PROBE_RESP],
 			&params);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	nl80211_calculate_ap_params(&params);


