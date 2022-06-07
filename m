Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36776541978
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378434AbiFGVWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352155AbiFGVTO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:19:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCF6224470;
        Tue,  7 Jun 2022 11:59:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5922B8239A;
        Tue,  7 Jun 2022 18:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DD6C385A2;
        Tue,  7 Jun 2022 18:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628352;
        bh=oMvoq6PzZoULewxmpDNz8DT3BADsI6X0K8E2Um8Lppo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTdzhQQYOaFuSy2sSRjxUOS3rRDwOk4cfDG+lWbfhTzdVIc+Ngpp8F7WrTcDnGJhs
         UCpQdFj7R0qxxQ4Y5gsbXBkyWpejGUyf+Ukl30SMjz/yH8xYL70/U679wm0SMsY5Ty
         QZFjjThcFPeJxMqhdilrtSIKOJ/2mTB8/nG5NRsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH 5.18 299/879] mptcp: reset the packet scheduler on PRIO change
Date:   Tue,  7 Jun 2022 18:56:57 +0200
Message-Id: <20220607165011.526491992@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 0e203c324752e13d22624ab7ffafe934fa06ab50 ]

Similar to the previous patch, for priority changes
requested by the local PM.

Reported-and-suggested-by: Davide Caratti <dcaratti@redhat.com>
Fixes: 067065422fcd ("mptcp: add the outgoing MP_PRIO support")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index b5e8de6f7507..e3dcc5501579 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -727,6 +727,8 @@ static int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 		if (!addresses_equal(&local, addr, addr->port))
 			continue;
 
+		if (subflow->backup != bkup)
+			msk->last_snd = NULL;
 		subflow->backup = bkup;
 		subflow->send_mp_prio = 1;
 		subflow->request_bkup = bkup;
-- 
2.35.1



