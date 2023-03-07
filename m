Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E2B6AEB8B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbjCGRpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbjCGRpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:45:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A78974BB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:40:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1A2B614B5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E79C433EF;
        Tue,  7 Mar 2023 17:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210821;
        bh=Gt5RttRD2uzBUsNCm618cpLLtdUwX0697o/p2YGOFh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvLyS+cOYvxLJJE2a79o8apj1lNc6BgM7G4yCQoXpTO1K/g/7DTxa7grPPP4QNxDn
         J+Ldvj14eQEHchwFxoogX3mVe4UnL5p82S2Uq4BIIfG9ExfRa7pXQCaApDM6Wexf1l
         ta66nnS9NMABwKKhYOHBuPs8ZHMrDIu9a0hMh0f4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0665/1001] can: isotp: check CAN address family in isotp_bind()
Date:   Tue,  7 Mar 2023 17:57:17 +0100
Message-Id: <20230307170050.470556034@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit c6adf659a8ba85913e16a571d5a9bcd17d3d1234 ]

Add missing check to block non-AF_CAN binds.

Syzbot created some code which matched the right sockaddr struct size
but used AF_XDP (0x2C) instead of AF_CAN (0x1D) in the address family
field:

bind$xdp(r2, &(0x7f0000000540)={0x2c, 0x0, r4, 0x0, r2}, 0x10)
                                ^^^^
This has no funtional impact but the userspace should be notified about
the wrong address family field content.

Link: https://syzkaller.appspot.com/text?tag=CrashLog&x=11ff9d8c480000
Reported-by: syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230104201844.13168-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index fc81d77724a13..9bc344851704e 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1220,6 +1220,9 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	if (len < ISOTP_MIN_NAMELEN)
 		return -EINVAL;
 
+	if (addr->can_family != AF_CAN)
+		return -EINVAL;
+
 	/* sanitize tx CAN identifier */
 	if (tx_id & CAN_EFF_FLAG)
 		tx_id &= (CAN_EFF_FLAG | CAN_EFF_MASK);
-- 
2.39.2



