Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36665EA4FB
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238853AbiIZL4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238908AbiIZLyF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:54:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5FE4CA39;
        Mon, 26 Sep 2022 03:49:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43DA5B80926;
        Mon, 26 Sep 2022 10:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8851DC433C1;
        Mon, 26 Sep 2022 10:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189393;
        bh=2TbbozwGCYo4oYPb7D3d7IgWjrP1CmeCObRzTOyfZ4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mbrlzphjn5gvXCs0SOxGln3zYx8ldSJLeYP61OnlvfN6COvRsx3paTF01iA8WMIdx
         ZBPVe8P3d9FsTIdiwwlpt/CbUoVmv12lrfDf+hc2zPA+3gbzw0Zc5N/JFnJb6l7xwH
         4f59KpQnQr+NvTL2vnZUSh1YV+1DKVa2f+evmstQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roberto Ricci <rroberto2r@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 132/207] ipv6: Fix crash when IPv6 is administratively disabled
Date:   Mon, 26 Sep 2022 12:12:01 +0200
Message-Id: <20220926100812.431984472@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 76dd07281338da6951fdab3432ced843fa87839c ]

The global 'raw_v6_hashinfo' variable can be accessed even when IPv6 is
administratively disabled via the 'ipv6.disable=1' kernel command line
option, leading to a crash [1].

Fix by restoring the original behavior and always initializing the
variable, regardless of IPv6 support being administratively disabled or
not.

[1]
 BUG: unable to handle page fault for address: ffffffffffffffc8
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 173e18067 P4D 173e18067 PUD 173e1a067 PMD 0
 Oops: 0000 [#1] PREEMPT SMP KASAN
 CPU: 3 PID: 271 Comm: ss Not tainted 6.0.0-rc4-custom-00136-g0727a9a5fbc1 #1396
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.fc36 04/01/2014
 RIP: 0010:raw_diag_dump+0x310/0x7f0
 [...]
 Call Trace:
  <TASK>
  __inet_diag_dump+0x10f/0x2e0
  netlink_dump+0x575/0xfd0
  __netlink_dump_start+0x67b/0x940
  inet_diag_handler_cmd+0x273/0x2d0
  sock_diag_rcv_msg+0x317/0x440
  netlink_rcv_skb+0x15e/0x430
  sock_diag_rcv+0x2b/0x40
  netlink_unicast+0x53b/0x800
  netlink_sendmsg+0x945/0xe60
  ____sys_sendmsg+0x747/0x960
  ___sys_sendmsg+0x13a/0x1e0
  __sys_sendmsg+0x118/0x1e0
  do_syscall_64+0x34/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 0daf07e52709 ("raw: convert raw sockets to RCU")
Reported-by: Roberto Ricci <rroberto2r@gmail.com>
Tested-by: Roberto Ricci <rroberto2r@gmail.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20220916084821.229287-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/af_inet6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 9f6f4a41245d..1012012a061f 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -1069,13 +1069,13 @@ static int __init inet6_init(void)
 	for (r = &inetsw6[0]; r < &inetsw6[SOCK_MAX]; ++r)
 		INIT_LIST_HEAD(r);
 
+	raw_hashinfo_init(&raw_v6_hashinfo);
+
 	if (disable_ipv6_mod) {
 		pr_info("Loaded, but administratively disabled, reboot required to enable\n");
 		goto out;
 	}
 
-	raw_hashinfo_init(&raw_v6_hashinfo);
-
 	err = proto_register(&tcpv6_prot, 1);
 	if (err)
 		goto out;
-- 
2.35.1



