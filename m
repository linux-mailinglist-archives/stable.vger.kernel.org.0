Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2691048917D
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240815AbiAJHcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240243AbiAJHaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:30:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D383C0258C7;
        Sun,  9 Jan 2022 23:27:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48A53B81208;
        Mon, 10 Jan 2022 07:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB73C36AED;
        Mon, 10 Jan 2022 07:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799676;
        bh=4kDfAj20Zo9hGT42g+YkMgq6vh22o5XuKgrXlcf2I8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uP1iFwXoAlaF9yFE21jGXrP6llTbtFQWvJw3aFgtY3R1ONf5jm2G5eQdveozCBYp8
         G37Spt0k/2uyQLLCH2/B7E1RnqijqgJX3rDkQHiIOmHT0wNyIGUaghqnuK5yhyi6YM
         Z4AxbJU6sBU5a+ZIckwgqBIcDs7lt/SMxXxq0Fig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 10/34] mac80211: initialize variable have_higher_than_11mbit
Date:   Mon, 10 Jan 2022 08:23:05 +0100
Message-Id: <20220110071815.998641859@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
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
@@ -4953,7 +4953,7 @@ static int ieee80211_prep_connection(str
 	 */
 	if (new_sta) {
 		u32 rates = 0, basic_rates = 0;
-		bool have_higher_than_11mbit;
+		bool have_higher_than_11mbit = false;
 		int min_rate = INT_MAX, min_rate_index = -1;
 		const struct cfg80211_bss_ies *ies;
 		int shift = ieee80211_vif_get_shift(&sdata->vif);


