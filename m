Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691A2504E54
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 11:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiDRJZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 05:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbiDRJZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 05:25:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331A215FD7
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 02:23:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C313A61182
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 09:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC607C385A1;
        Mon, 18 Apr 2022 09:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650273791;
        bh=xJsTfLiKeCM0/zx4NAKhVsztL5be2GliMqXG0F+oUhE=;
        h=Subject:To:Cc:From:Date:From;
        b=mQeth4VckgeusrEFCaY1Ghb2Pf9RmckQnMlLzN7R7am6q9K2CeG0gASkvYmVbXzNy
         /eG7lcpnKYUmtdAL7bU76Xzz0mzPFOpxZ4qcxWdmgVBr9BSRjOwVlk4D0fN11rZ/fU
         /ThzvXeUyaV0K5qj9PIYyhd1zN4MJXqFcswaj91o=
Subject: FAILED: patch "[PATCH] nl80211: correctly check NL80211_ATTR_REG_ALPHA2 size" failed to apply to 5.4-stable tree
To:     johannes.berg@intel.com, lee.jones@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Apr 2022 11:23:07 +0200
Message-ID: <165027378721588@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6624bb34b4eb19f715db9908cca00122748765d7 Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Mon, 11 Apr 2022 11:42:03 +0200
Subject: [PATCH] nl80211: correctly check NL80211_ATTR_REG_ALPHA2 size

We need this to be at least two bytes, so we can access
alpha2[0] and alpha2[1]. It may be three in case some
userspace used NUL-termination since it was NLA_STRING
(and we also push it out with NUL-termination).

Cc: stable@vger.kernel.org
Reported-by: Lee Jones <lee.jones@linaro.org>
Link: https://lore.kernel.org/r/20220411114201.fd4a31f06541.Ie7ff4be2cf348d8cc28ed0d626fc54becf7ea799@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ee1c2b6b6971..21e808fcb676 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -528,7 +528,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 				   .len = IEEE80211_MAX_MESH_ID_LEN },
 	[NL80211_ATTR_MPATH_NEXT_HOP] = NLA_POLICY_ETH_ADDR_COMPAT,
 
-	[NL80211_ATTR_REG_ALPHA2] = { .type = NLA_STRING, .len = 2 },
+	/* allow 3 for NUL-termination, we used to declare this NLA_STRING */
+	[NL80211_ATTR_REG_ALPHA2] = NLA_POLICY_RANGE(NLA_BINARY, 2, 3),
 	[NL80211_ATTR_REG_RULES] = { .type = NLA_NESTED },
 
 	[NL80211_ATTR_BSS_CTS_PROT] = { .type = NLA_U8 },

