Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39AD4F3294
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242132AbiDEIgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239203AbiDEITy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419EA7B54E;
        Tue,  5 Apr 2022 01:10:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57C1060B0B;
        Tue,  5 Apr 2022 08:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D832C385A2;
        Tue,  5 Apr 2022 08:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146227;
        bh=FG+J2l5vSMEjoMnkw7iQgBBSFO5qaxDzo5Wh5g7Ah6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJ3bKHuUzigIPDhNOK93cN5eoFkck/N1es4qJ4VNZYstfYyYc5uYNLn05vy6oYbhb
         R+ILLtdlYvvma253KoCOkXBY4lfBsSxEe6ruq3TqqC8I25QETI/kKKyIp2D637Hurh
         xDLiOWS+8LgTYBHBUL2cPeFVO5pfJ6XCroQhbiZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0689/1126] af_netlink: Fix shift out of bounds in group mask calculation
Date:   Tue,  5 Apr 2022 09:23:56 +0200
Message-Id: <20220405070427.838880213@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 7b344035bfe3..47a876ccd288 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -159,6 +159,8 @@ EXPORT_SYMBOL(do_trace_netlink_extack);
 
 static inline u32 netlink_group_mask(u32 group)
 {
+	if (group > 32)
+		return 0;
 	return group ? 1 << (group - 1) : 0;
 }
 
-- 
2.34.1



