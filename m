Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAEE210B93E
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbfK0UvV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:51:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:37976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730462AbfK0UvU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:51:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F6132184C;
        Wed, 27 Nov 2019 20:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887879;
        bh=Y4lAoQyQxZwgpe8S14AlWKNoT/13S/b0oclnwxddKWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vYqPotm8GTsuqhrJ7qaPf0UmjPoKpl5O2H5OXmYS5Z2xQJlN8D1K40oEgS+XGLX1G
         iKhgrBiKfeAu8w2/5ZeJI59Lg2j2YulA3/Y9KfGF7vdbmUy6GIEYziuMnTpPWMCVoT
         Z2O42BL3hVM0c9aojzB7vW5EKch0uEvjDvoLmISI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 129/211] openvswitch: fix linking without CONFIG_NF_CONNTRACK_LABELS
Date:   Wed, 27 Nov 2019 21:31:02 +0100
Message-Id: <20191127203106.276796645@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a277d516de5f498c91d91189717ef7e01102ad27 ]

When CONFIG_CC_OPTIMIZE_FOR_DEBUGGING is enabled, the compiler
fails to optimize out a dead code path, which leads to a link failure:

net/openvswitch/conntrack.o: In function `ovs_ct_set_labels':
conntrack.c:(.text+0x2e60): undefined reference to `nf_connlabels_replace'

In this configuration, we can take a shortcut, and completely
remove the contrack label code. This may also help the regular
optimization.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 0171b27a2b81b..48d81857961ca 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1083,7 +1083,8 @@ static int ovs_ct_commit(struct net *net, struct sw_flow_key *key,
 					 &info->labels.mask);
 		if (err)
 			return err;
-	} else if (labels_nonzero(&info->labels.mask)) {
+	} else if (IS_ENABLED(CONFIG_NF_CONNTRACK_LABELS) &&
+		   labels_nonzero(&info->labels.mask)) {
 		err = ovs_ct_set_labels(ct, key, &info->labels.value,
 					&info->labels.mask);
 		if (err)
-- 
2.20.1



