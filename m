Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A30A9177F36
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731764AbgCCRtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:49:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731761AbgCCRtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:49:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF1C620870;
        Tue,  3 Mar 2020 17:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257757;
        bh=qRDi6QwEwHsC3lpbLViTlE0Qt/GgT4AnIBIpzw7niqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPzBS0MKkLoi2QLjEd3xguMPFmZ/DLlEBBWtZ/NFbovb5i2ITC12hlL2df6uxPmC6
         qYU5824MKydYi0V0CgbgYyLrl6fEiWZNXAhVH6j7fTVJFbwCDWT6I4oumF1kSruaON
         Jm2tk87ObcK4ghz9DxxT3ItY3Xv6FBdexE5nVMOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.5 118/176] nl80211: fix potential leak in AP start
Date:   Tue,  3 Mar 2020 18:43:02 +0100
Message-Id: <20200303174318.461858278@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 9951ebfcdf2b97dbb28a5d930458424341e61aa2 upstream.

If nl80211_parse_he_obss_pd() fails, we leak the previously
allocated ACL memory. Free it in this case.

Fixes: 796e90f42b7e ("cfg80211: add support for parsing OBBS_PD attributes")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20200221104142.835aba4cdd14.I1923b55ba9989c57e13978f91f40bfdc45e60cbd@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4800,8 +4800,7 @@ static int nl80211_start_ap(struct sk_bu
 		err = nl80211_parse_he_obss_pd(
 					info->attrs[NL80211_ATTR_HE_OBSS_PD],
 					&params.he_obss_pd);
-		if (err)
-			return err;
+		goto out;
 	}
 
 	nl80211_calculate_ap_params(&params);
@@ -4823,6 +4822,7 @@ static int nl80211_start_ap(struct sk_bu
 	}
 	wdev_unlock(wdev);
 
+out:
 	kfree(params.acl);
 
 	return err;


