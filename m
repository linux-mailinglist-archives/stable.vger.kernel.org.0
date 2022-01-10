Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B084890E9
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239772AbiAJH0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:26:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35638 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239273AbiAJHZY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:25:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64C2E611BC;
        Mon, 10 Jan 2022 07:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47931C36AED;
        Mon, 10 Jan 2022 07:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799523;
        bh=7fe28n9qt6453jcIrqeOZVXWam3/hE5nOqhxsljTte8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYBXbTdCAPB96nzna8GU5JB7PFPWxTNS0JMIDBvAhMC/USO1TdBVQIL8uNDff/KN8
         RE1jveJD1hqQFUd9XUQRZ5Bln5nfyaIyDkcY5SMZSI3GF8DvSwdiq1YwL60IvWcFMU
         gf9WP+leXGqIw9y+EwqaGRpt8dsKHZVizvajIzDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.9 06/21] mac80211: initialize variable have_higher_than_11mbit
Date:   Mon, 10 Jan 2022 08:22:53 +0100
Message-Id: <20220110071813.022371698@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071812.806606886@linuxfoundation.org>
References: <20220110071812.806606886@linuxfoundation.org>
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
@@ -4450,7 +4450,7 @@ static int ieee80211_prep_connection(str
 
 	if (new_sta) {
 		u32 rates = 0, basic_rates = 0;
-		bool have_higher_than_11mbit;
+		bool have_higher_than_11mbit = false;
 		int min_rate = INT_MAX, min_rate_index = -1;
 		struct ieee80211_chanctx_conf *chanctx_conf;
 		const struct cfg80211_bss_ies *ies;


