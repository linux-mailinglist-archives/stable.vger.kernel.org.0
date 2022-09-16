Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F605BAA5B
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbiIPK1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbiIPKZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:25:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2C9ABF2B;
        Fri, 16 Sep 2022 03:16:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 966A762A42;
        Fri, 16 Sep 2022 10:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4D4C433D6;
        Fri, 16 Sep 2022 10:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323311;
        bh=h2JJsDOxp0+rL1U/L7fiyquP3/111TM89S4s473Qksc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFTGLlUnRQapBVKXKSvPek96QqWqTva3E99QR9U+TaS1yl3pjOeDDoWZj62HCsPUI
         V+YRr58i1G/A+8Ci0/9p0+dQ1WJk2136UnkPc2T+62s1ilJPyLUxJZeVhcpe0J/2qw
         IByaUKoRYS6nri7TpwYSQs/OHqvUbrshOhoIC9VI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 26/38] nvmet-tcp: fix unhandled tcp states in nvmet_tcp_state_change()
Date:   Fri, 16 Sep 2022 12:09:00 +0200
Message-Id: <20220916100449.564230192@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 478814a5584197fa1fb18377653626e3416e7cd6 ]

TCP_FIN_WAIT2 and TCP_LAST_ACK were not handled, the connection is closing
so we can ignore them and avoid printing the "unhandled state"
warning message.

[ 1298.852386] nvmet_tcp: queue 2 unhandled state 5
[ 1298.879112] nvmet_tcp: queue 7 unhandled state 5
[ 1298.884253] nvmet_tcp: queue 8 unhandled state 5
[ 1298.889475] nvmet_tcp: queue 9 unhandled state 5

v2: Do not call nvmet_tcp_schedule_release_queue(), just ignore
the fin_wait2 and last_ack states.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index dc3b4dc8fe08b..a3694a32f6d52 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1506,6 +1506,9 @@ static void nvmet_tcp_state_change(struct sock *sk)
 		goto done;
 
 	switch (sk->sk_state) {
+	case TCP_FIN_WAIT2:
+	case TCP_LAST_ACK:
+		break;
 	case TCP_FIN_WAIT1:
 	case TCP_CLOSE_WAIT:
 	case TCP_CLOSE:
-- 
2.35.1



