Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E34D531BA8
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbiEWRfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240692AbiEWRdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:33:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4139A7CB36;
        Mon, 23 May 2022 10:27:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2F3860916;
        Mon, 23 May 2022 17:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA127C34115;
        Mon, 23 May 2022 17:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326873;
        bh=Kb3EsYIGclp3SjLyiWotONiDJkvSpTjwoijaEjgWOrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nGBXGB6pHFg0KSkFlZnqQCAcxHnMZmPTKGABd8JMJzlbVHGBWKq2im1X04S/dNgmj
         3JIqT7AjREAF8HjAmC7NE3KsDhSQmEsuQyVKBIcU8lZVgH9qdtqE6zVI7elH5D9The
         5p/eJqHY7GTfLccVRJOiXU4Th3623bZFEspD+9VE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 085/158] netfilter: flowtable: fix excessive hw offload attempts after failure
Date:   Mon, 23 May 2022 19:04:02 +0200
Message-Id: <20220523165845.201616537@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 396ef64113a8ba01c46315d67a99db8dde3eef51 ]

If a flow cannot be offloaded, the code currently repeatedly tries again as
quickly as possible, which can significantly increase system load.
Fix this by limiting flow timeout update and hardware offload retry to once
per second.

Fixes: c07531c01d82 ("netfilter: flowtable: Remove redundant hw refresh bit")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b90eca7a2f22..52e7f94d2450 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -329,8 +329,10 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 	u32 timeout;
 
 	timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
-	if (READ_ONCE(flow->timeout) != timeout)
+	if (timeout - READ_ONCE(flow->timeout) > HZ)
 		WRITE_ONCE(flow->timeout, timeout);
+	else
+		return;
 
 	if (likely(!nf_flowtable_hw_offload(flow_table)))
 		return;
-- 
2.35.1



