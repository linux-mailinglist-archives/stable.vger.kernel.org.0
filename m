Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B091595166
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbiHPE5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbiHPE4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:56:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E661FBBA50;
        Mon, 15 Aug 2022 13:51:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7675ECE12C3;
        Mon, 15 Aug 2022 20:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF23C433C1;
        Mon, 15 Aug 2022 20:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596653;
        bh=l8T1bFz4R/GbxK6CIV6og1RrUXHJ5KWwpqh2rejeafg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bm9+/Ju4fZvC5fz+pMF9jK7Bnew+MGUtQ9WCBr6B7GH5ryD5LVDJNlO7XoELXSHUM
         x1yAM84xPU4rAUsSfIrbhwn49anzX+/zVDoMG8ndKZou+lPsCGEMfKtEVYm5FcUj3m
         wtYDIeR0gsMRGM9vfoaN7RfCqD28lZQWB1ZRPyqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+90d912872157e63589e4@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.19 1147/1157] wifi: cfg80211: handle IBSS in channel switch
Date:   Mon, 15 Aug 2022 20:08:23 +0200
Message-Id: <20220815180526.397830233@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 77e7b6ba78edf817bddfa97fadb15a971992b1ee upstream.

Prior to commit 7b0a0e3c3a88 ("wifi: cfg80211: do some
rework towards MLO link APIs") the interface type didn't
really matter here, but now we need to handle all of the
possible cases. Add IBSS ("ADHOC") and handle it.

Fixes: 7b0a0e3c3a88 ("wifi: cfg80211: do some rework towards MLO link APIs")
Reported-by: syzbot+90d912872157e63589e4@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18294,6 +18294,9 @@ void cfg80211_ch_switch_notify(struct ne
 	case NL80211_IFTYPE_P2P_GO:
 		wdev->links[link_id].ap.chandef = *chandef;
 		break;
+	case NL80211_IFTYPE_ADHOC:
+		wdev->u.ibss.chandef = *chandef;
+		break;
 	default:
 		WARN_ON(1);
 		break;


