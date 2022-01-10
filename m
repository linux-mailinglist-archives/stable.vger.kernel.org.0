Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C0848910A
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239329AbiAJH2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:28:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57198 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239737AbiAJH0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:26:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39F46B81204;
        Mon, 10 Jan 2022 07:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E82CC36AED;
        Mon, 10 Jan 2022 07:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799596;
        bh=bj/NDmeVO0AXpsSp1ao1GxNohak9ggaCwQhdSZUvDvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ye05X2LxLPiyGc0+Sh0vvADVXMm4EGC69NXnBE/E4DvgVkJRzvMewCPu05K2/bTlC
         ZaLVHkgO9oF1YFqTu2mY2+Ynw0V/rjL0g5K/8AlIAtjaN9CsKgyu7zUu/ukit9ErFu
         yKb1levBqxvfQRfwW3QJVd2aUAHBR+H5iJ5WWFoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 07/22] mac80211: initialize variable have_higher_than_11mbit
Date:   Mon, 10 Jan 2022 08:23:00 +0100
Message-Id: <20220110071814.509909543@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071814.261471354@linuxfoundation.org>
References: <20220110071814.261471354@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit 68a18ad71378a56858141c4449e02a30c829763e upstream.

Clang static analysis reports this warnings

mlme.c:5332:7: warning: Branch condition evaluates to a
  garbage value
    have_higher_than_11mbit)
    ^~~~~~~~~~~~~~~~~~~~~~~

have_higher_than_11mbit is only set to true some of the time in
ieee80211_get_rates() but is checked all of the time.  So
have_higher_than_11mbit needs to be initialized to false.

Fixes: 5d6a1b069b7f ("mac80211: set basic rates earlier")
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20211223162848.3243702-1-trix@redhat.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4501,7 +4501,7 @@ static int ieee80211_prep_connection(str
 	 */
 	if (new_sta) {
 		u32 rates = 0, basic_rates = 0;
-		bool have_higher_than_11mbit;
+		bool have_higher_than_11mbit = false;
 		int min_rate = INT_MAX, min_rate_index = -1;
 		const struct cfg80211_bss_ies *ies;
 		int shift = ieee80211_vif_get_shift(&sdata->vif);


