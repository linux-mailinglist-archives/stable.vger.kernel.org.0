Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC09A59406D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241347AbiHOVIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346905AbiHOVG2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:06:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F28C388C;
        Mon, 15 Aug 2022 12:15:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9744E60F68;
        Mon, 15 Aug 2022 19:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F77C433D7;
        Mon, 15 Aug 2022 19:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590927;
        bh=HdZN3NTvMMQl8HTqsLSlcwZKLq5OqohzlyHzJ25xYXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZafUegXbXcBEt9lXLZXl1D5MLNYD38NpFiYL8QZduzYMQIHWXVPfwmu2A2DYfgsLE
         HpsJfxrfzYyONj7NmPohNoXRcvMdO6+jkP6STxB8XNwdKQ5osSECN3ak9hzmYjk8KB
         Lu4zYjRh2bE/ibHc9TDQgvCWAiQuqt/cvHj3kTqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0415/1095] net: sched: provide shim definitions for taprio_offload_{get,free}
Date:   Mon, 15 Aug 2022 19:56:54 +0200
Message-Id: <20220815180446.866780758@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit d7be266adbfd3aca6965ea6a0c36b2c3d8fc9fc8 ]

All callers of taprio_offload_get() and taprio_offload_free() prior to
the blamed commit are conditionally compiled based on CONFIG_NET_SCH_TAPRIO.

felix_vsc9959.c is different; it provides vsc9959_qos_port_tas_set()
even when taprio is compiled out.

Provide shim definitions for the functions exported by taprio so that
felix_vsc9959.c is able to compile. vsc9959_qos_port_tas_set() in that
case is dead code anyway, and ocelot_port->taprio remains NULL, which is
fine for the rest of the logic.

Fixes: 1c9017e44af2 ("net: dsa: felix: keep reference on entire tc-taprio config")
Reported-by: Colin Foster <colin.foster@in-advantage.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Colin Foster <colin.foster@in-advantage.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://lore.kernel.org/r/20220704190241.1288847-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_sched.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 44a35531952e..3372a1f67cf4 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -173,11 +173,28 @@ struct tc_taprio_qopt_offload {
 	struct tc_taprio_sched_entry entries[];
 };
 
+#if IS_ENABLED(CONFIG_NET_SCH_TAPRIO)
+
 /* Reference counting */
 struct tc_taprio_qopt_offload *taprio_offload_get(struct tc_taprio_qopt_offload
 						  *offload);
 void taprio_offload_free(struct tc_taprio_qopt_offload *offload);
 
+#else
+
+/* Reference counting */
+static inline struct tc_taprio_qopt_offload *
+taprio_offload_get(struct tc_taprio_qopt_offload *offload)
+{
+	return NULL;
+}
+
+static inline void taprio_offload_free(struct tc_taprio_qopt_offload *offload)
+{
+}
+
+#endif
+
 /* Ensure skb_mstamp_ns, which might have been populated with the txtime, is
  * not mistaken for a software timestamp, because this will otherwise prevent
  * the dispatch of hardware timestamps to the socket.
-- 
2.35.1



