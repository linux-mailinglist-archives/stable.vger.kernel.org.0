Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664CB595157
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiHPE4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbiHPEz6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:55:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB95FE0A8;
        Mon, 15 Aug 2022 13:51:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 324F3B811AE;
        Mon, 15 Aug 2022 20:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75983C433D7;
        Mon, 15 Aug 2022 20:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596656;
        bh=J0ycxpS4pz0mQ35m3dePt8F7dDXGXxiCq9z7Kw0TkRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0woAm0BEy5+QQty13ps1WbC9cur/8ma0l+e4Xu82FFzDiFzjBgWQCKm0HwuvJJfI
         1CDHl1jNOgxqKTpIPsG8CISwS+XM4s+lCNCuqYzqr/9zQlJorVRyPvHZa42zg8izn4
         HQSI7pkw8hBw9lAG+7bu3ztuxmK083kdrPyGRYRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b4e9aa0f32ffd9902442@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.19 1148/1157] wifi: nl80211: hold wdev mutex for tid config
Date:   Mon, 15 Aug 2022 20:08:24 +0200
Message-Id: <20220815180526.445027831@linuxfoundation.org>
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

commit 206bbcf76121664e95a42e1c014c3fe168d07a3d upstream.

We need wdev_chandef() in this code, which now requires
the wdev mutex due to the per-link nature. Hold it here
to make sure we can access the link.

Reported-by: syzbot+b4e9aa0f32ffd9902442@syzkaller.appspotmail.com
Fixes: 7b0a0e3c3a88 ("wifi: cfg80211: do some rework towards MLO link APIs")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -15285,6 +15285,8 @@ static int nl80211_set_tid_config(struct
 	if (info->attrs[NL80211_ATTR_MAC])
 		tid_config->peer = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
+	wdev_lock(dev->ieee80211_ptr);
+
 	nla_for_each_nested(tid, info->attrs[NL80211_ATTR_TID_CONFIG],
 			    rem_conf) {
 		ret = nla_parse_nested(attrs, NL80211_TID_CONFIG_ATTR_MAX,
@@ -15306,6 +15308,7 @@ static int nl80211_set_tid_config(struct
 
 bad_tid_conf:
 	kfree(tid_config);
+	wdev_unlock(dev->ieee80211_ptr);
 	return ret;
 }
 


