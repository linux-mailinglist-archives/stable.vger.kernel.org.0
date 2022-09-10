Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290165B49A4
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiIJVVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbiIJVUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:20:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8607F4C610;
        Sat, 10 Sep 2022 14:18:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D5CD60EC8;
        Sat, 10 Sep 2022 21:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7919C43140;
        Sat, 10 Sep 2022 21:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844702;
        bh=zGUf+dIncbfBmDbOFyCW2gzyXF8Db5DU0ihwD6D1D48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bb0jMHsSXwztoXhVvZAP77nVR3frfwChmpuqGn3kq7Ttw+mU6W/MHKtw4jOH34iJY
         /mhs9Bm1dTgqLNvm/QkWIiomPxVQbdleakpI8uQlJd0E9k4uJ13mHKxdeifeqCJYYM
         vceQEMxtZ2jXfwk/xYiJgWM5G2gYepWVrnVy9BaC8oUwdeSMecCXS9vn+0y66OLQmF
         NFlhfLIvhnsGLC7Kh/1Hwb23SZQeGqQ7vOC95V/Mvvw7yjjl+MgSpwLSbDV+chpXmc
         MmIKzlKbHIPO374awXpzBo3kjkVtd602ZMjFUYuR/sx7RRuooISmXjtfaCqfhJY2+U
         LIec+0qrgdfrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 16/21] nvmet-tcp: fix unhandled tcp states in nvmet_tcp_state_change()
Date:   Sat, 10 Sep 2022 17:17:47 -0400
Message-Id: <20220910211752.70291-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211752.70291-1-sashal@kernel.org>
References: <20220910211752.70291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 889c5433c94d2..fba5a77c58d6b 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1501,6 +1501,9 @@ static void nvmet_tcp_state_change(struct sock *sk)
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

