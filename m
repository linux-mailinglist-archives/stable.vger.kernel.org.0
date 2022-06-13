Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0988B5497AA
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240152AbiFMNld (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379136AbiFMNjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD85A3DA52;
        Mon, 13 Jun 2022 04:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58FBD61046;
        Mon, 13 Jun 2022 11:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DEEC34114;
        Mon, 13 Jun 2022 11:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119732;
        bh=2hyf1cQmfW94cWq/If7w064AVZti1g8GtemsxPSoOSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCpJvRD56ke+Lvt3g7BYtIn00YIRrtbHZG8CMn0AKl9dQ2WceJaO8P5Z4aMNCEyaB
         Mes6h6vghuwG81OmikHGzt184vIgr+/bHK9yaA/deWYkUmH8l08uUFT+4DIE2I4n8x
         ZUU54HBHf81S18YXMlK6YDh9LE55Li/d+PSRSxmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Liang <liali@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 120/339] bonding: show NS IPv6 targets in proc master info
Date:   Mon, 13 Jun 2022 12:09:05 +0200
Message-Id: <20220613094930.148189277@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 4a1f14df55d1e9ecdfa797a87a80131207cbd66f ]

When adding bond new parameter ns_targets. I forgot to print this
in bond master proc info. After updating, the bond master info will look
like:

ARP IP target/s (n.n.n.n form): 192.168.1.254
NS IPv6 target/s (XX::XX form): 2022::1, 2022::2

Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Reported-by: Li Liang <liali@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20220530062639.37179-1-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_procfs.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index cfe37be42be4..43be458422b3 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -129,6 +129,21 @@ static void bond_info_show_master(struct seq_file *seq)
 			printed = 1;
 		}
 		seq_printf(seq, "\n");
+
+#if IS_ENABLED(CONFIG_IPV6)
+		printed = 0;
+		seq_printf(seq, "NS IPv6 target/s (xx::xx form):");
+
+		for (i = 0; (i < BOND_MAX_NS_TARGETS); i++) {
+			if (ipv6_addr_any(&bond->params.ns_targets[i]))
+				break;
+			if (printed)
+				seq_printf(seq, ",");
+			seq_printf(seq, " %pI6c", &bond->params.ns_targets[i]);
+			printed = 1;
+		}
+		seq_printf(seq, "\n");
+#endif
 	}
 
 	if (BOND_MODE(bond) == BOND_MODE_8023AD) {
-- 
2.35.1



