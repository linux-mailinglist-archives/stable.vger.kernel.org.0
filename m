Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6E66E63F3
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbjDRMow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjDRMot (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:44:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7156C15637
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:44:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D77863374
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2338AC433D2;
        Tue, 18 Apr 2023 12:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821886;
        bh=ZlO6oyoBVDjCG5jtQnEfb6K3J648VHTb+OoCehevMjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1800eukZkd7aAJD/y8bji6sgw0Rn4s5scbJ8ciBLLw7p2+FurO+vjx0EhiQMupN0
         6OODFIfH2MOWroEhU0BsL/beoqaiDnfX8Dt2dUY1Kxkvi0uhlc1fzkPHtVQkXck5fU
         F0rFinIJzaFpG56Z+bvsd16mU1rcsJznYaNIEWSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, YueHaibing <yuehaibing@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/134] tcp: restrict net.ipv4.tcp_app_win
Date:   Tue, 18 Apr 2023 14:21:45 +0200
Message-Id: <20230418120314.647489018@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit dc5110c2d959c1707e12df5f792f41d90614adaa ]

UBSAN: shift-out-of-bounds in net/ipv4/tcp_input.c:555:23
shift exponent 255 is too large for 32-bit type 'int'
CPU: 1 PID: 7907 Comm: ssh Not tainted 6.3.0-rc4-00161-g62bad54b26db-dirty #206
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x136/0x150
 __ubsan_handle_shift_out_of_bounds+0x21f/0x5a0
 tcp_init_transfer.cold+0x3a/0xb9
 tcp_finish_connect+0x1d0/0x620
 tcp_rcv_state_process+0xd78/0x4d60
 tcp_v4_do_rcv+0x33d/0x9d0
 __release_sock+0x133/0x3b0
 release_sock+0x58/0x1b0

'maxwin' is int, shifting int for 32 or more bits is undefined behaviour.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ip-sysctl.rst | 2 ++
 net/ipv4/sysctl_net_ipv4.c             | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index e7b3fa7bb3f73..4ecb549fd052e 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -337,6 +337,8 @@ tcp_app_win - INTEGER
 	Reserve max(window/2^tcp_app_win, mss) of window for application
 	buffer. Value 0 is special, it means that nothing is reserved.
 
+	Possible values are [0, 31], inclusive.
+
 	Default: 31
 
 tcp_autocorking - BOOLEAN
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 9b8a6db7a66b3..39dbeb6071965 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -25,6 +25,7 @@ static int ip_local_port_range_min[] = { 1, 1 };
 static int ip_local_port_range_max[] = { 65535, 65535 };
 static int tcp_adv_win_scale_min = -31;
 static int tcp_adv_win_scale_max = 31;
+static int tcp_app_win_max = 31;
 static int tcp_min_snd_mss_min = TCP_MIN_SND_MSS;
 static int tcp_min_snd_mss_max = 65535;
 static int ip_privileged_port_min;
@@ -1171,6 +1172,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &tcp_app_win_max,
 	},
 	{
 		.procname	= "tcp_adv_win_scale",
-- 
2.39.2



