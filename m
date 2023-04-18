Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3156E647E
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbjDRMth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbjDRMth (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:49:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD3215469
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:49:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78FA5633F4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0A2C433EF;
        Tue, 18 Apr 2023 12:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822174;
        bh=YXI3cJJG1LAicBo7rXho6XhtvfBFTMq7jgmCQAZ4dCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCmSsmcS+T3XIAWOeUGZKQxQeTFvm7hD/4g3ly81tGVSoMVYDOdpPKaxr6zd/I+TP
         HV+f3K0h3dD6fkvQBYOYt8w5+/B4urG2ZYMwZjO5OA/1ysv9S7sYhMn0pZBSs4rQ9D
         ndLzyR07o7291y7FNr4SCrAyaGLrLlwr9oW5JEXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, YueHaibing <yuehaibing@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 051/139] tcp: restrict net.ipv4.tcp_app_win
Date:   Tue, 18 Apr 2023 14:21:56 +0200
Message-Id: <20230418120315.632449907@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
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
index 7fbd060d60470..afed49280b52e 100644
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
index 0d0cc4ef2b85a..40fe70fc2015d 100644
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
@@ -1198,6 +1199,8 @@ static struct ctl_table ipv4_net_table[] = {
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



