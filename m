Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E76D4F4091
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382588AbiDEMQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237533AbiDEKdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:33:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75603DEBAD;
        Tue,  5 Apr 2022 03:19:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBB8B617CE;
        Tue,  5 Apr 2022 10:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BF0C385A0;
        Tue,  5 Apr 2022 10:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153949;
        bh=lCSdk4p+UKFX1K5vODvPBm8UQRNJlya47e8kZdEbe0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vtxrCCm8ckFevYnCzlxz5LQ5p/cTk3c8qsPDXaW4r1uUP4bmvf3wW2HUKTKkNTItx
         scXwrzH+WXVwDuU1vpiUtVFQWap36bHuETYMngjffARxtl+oqFcWPO/tojQjqnTBys
         Vut9+Wq+mHfnle7VsXtryx0wRb9k74FPa1Yp9obw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 368/599] af_netlink: Fix shift out of bounds in group mask calculation
Date:   Tue,  5 Apr 2022 09:31:02 +0200
Message-Id: <20220405070309.781411076@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 0caf6d9922192dd1afa8dc2131abfb4df1443b9f ]

When a netlink message is received, netlink_recvmsg() fills in the address
of the sender. One of the fields is the 32-bit bitfield nl_groups, which
carries the multicast group on which the message was received. The least
significant bit corresponds to group 1, and therefore the highest group
that the field can represent is 32. Above that, the UB sanitizer flags the
out-of-bounds shift attempts.

Which bits end up being set in such case is implementation defined, but
it's either going to be a wrong non-zero value, or zero, which is at least
not misleading. Make the latter choice deterministic by always setting to 0
for higher-numbered multicast groups.

To get information about membership in groups >= 32, userspace is expected
to use nl_pktinfo control messages[0], which are enabled by NETLINK_PKTINFO
socket option.
[0] https://lwn.net/Articles/147608/

The way to trigger this issue is e.g. through monitoring the BRVLAN group:

	# bridge monitor vlan &
	# ip link add name br type bridge

Which produces the following citation:

	UBSAN: shift-out-of-bounds in net/netlink/af_netlink.c:162:19
	shift exponent 32 is too large for 32-bit type 'int'

Fixes: f7fa9b10edbb ("[NETLINK]: Support dynamic number of multicast groups per netlink family")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/2bef6aabf201d1fc16cca139a744700cff9dcb04.1647527635.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index e55af5c078ac..f37916156ca5 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -149,6 +149,8 @@ static const struct rhashtable_params netlink_rhashtable_params;
 
 static inline u32 netlink_group_mask(u32 group)
 {
+	if (group > 32)
+		return 0;
 	return group ? 1 << (group - 1) : 0;
 }
 
-- 
2.34.1



