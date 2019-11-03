Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C3DED413
	for <lists+stable@lfdr.de>; Sun,  3 Nov 2019 19:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfKCSAg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Nov 2019 13:00:36 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:47779 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726502AbfKCSAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Nov 2019 13:00:36 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D05B321B2B;
        Sun,  3 Nov 2019 13:00:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 03 Nov 2019 13:00:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=o+NfkE
        Q/mnU8PRXIwoCPTaoX1YVSPPSJzTuW6jwyYTI=; b=dQF4KDyXg8cbUudrz2eSuf
        oVOPy0m6XawO9oMcz7baq5coyFtjqUW1dKmxVmMZ0HNEfYM4y7laBARpx4oue+v1
        0vqitk2B93kBJtVAJLeYOQp1ocDnM9yWmbQK8TP9c4i7fWQ/UGmIYOVA5x/eQlCk
        LmeF80YXWcxI1p/TAchgWvT7tcanqPjpq4MOkf33AGWHcTrrqabEvVHgvlHt11Pg
        McEV+rkw/XXiAow5eMmtlkab/mYQFadc7umtkvXCjfl2qRVdo7UEQY2mXr6ah8/z
        CnfeiDNr61G7Y1M964NXdMyEvvf2zB3TFOJTR9OHp2aaxPgpyNdwAnSqd41oD7lg
        ==
X-ME-Sender: <xms:wxW_XWgxPyuSBygKzVSLQ8guBFBsiY0749tY2cJNFHnxx_IJzUaT8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduuddguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:wxW_XQXpGND7BIggLRA1EE7OZJBwzHx6gOI5_vGXMt91mOYdn8A89w>
    <xmx:wxW_XVWEB4maBjhmFfJpIcgBOiH-Mge8P8JKNEgaFoVV-F7Nd-XbSw>
    <xmx:wxW_XQjVo1wC0JJoChseCnULHtq6PBRmdgg74gPbxZVo9Y2daV99Rg>
    <xmx:wxW_XeS7q18qj5Bjl5INmblypW7ikd8ZQBBCtC_6d7jax1RQZxMJww>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 12B8280059;
        Sun,  3 Nov 2019 13:00:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] nl80211: fix validation of mesh path nexthop" failed to apply to 4.19-stable tree
To:     markus.theil@tu-ilmenau.de, johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Nov 2019 19:00:32 +0100
Message-ID: <1572804032120223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1fab1b89e2e8f01204a9c05a39fd0b6411a48593 Mon Sep 17 00:00:00 2001
From: Markus Theil <markus.theil@tu-ilmenau.de>
Date: Tue, 29 Oct 2019 10:30:03 +0100
Subject: [PATCH] nl80211: fix validation of mesh path nexthop

Mesh path nexthop should be a ethernet address, but current validation
checks against 4 byte integers.

Cc: stable@vger.kernel.org
Fixes: 2ec600d672e74 ("nl80211/cfg80211: support for mesh, sta dumping")
Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
Link: https://lore.kernel.org/r/20191029093003.10355-1-markus.theil@tu-ilmenau.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4453dd375de9..7b72286922f7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -393,7 +393,7 @@ const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_MNTR_FLAGS] = { /* NLA_NESTED can't be empty */ },
 	[NL80211_ATTR_MESH_ID] = { .type = NLA_BINARY,
 				   .len = IEEE80211_MAX_MESH_ID_LEN },
-	[NL80211_ATTR_MPATH_NEXT_HOP] = { .type = NLA_U32 },
+	[NL80211_ATTR_MPATH_NEXT_HOP] = NLA_POLICY_ETH_ADDR_COMPAT,
 
 	[NL80211_ATTR_REG_ALPHA2] = { .type = NLA_STRING, .len = 2 },
 	[NL80211_ATTR_REG_RULES] = { .type = NLA_NESTED },

