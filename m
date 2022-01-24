Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0553E498E38
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355041AbiAXTjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353545AbiAXTe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:34:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED56C0219BF;
        Mon, 24 Jan 2022 11:16:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E62661320;
        Mon, 24 Jan 2022 19:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7A5C340E7;
        Mon, 24 Jan 2022 19:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051785;
        bh=q5W9hIOQRdyJnbVfoV96IYZAH+fk/4zycAksEdJnDqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tR4ELxWNivesxZkTHO80gxp9hF8HrtnhArNvK1C/L29WcQjMtJ7cTtMUUsixYw6VY
         x1lJ9Qd2t2GMYNTzvwFqchWFjHmOiuZdXu+VPS/45nC4h7yHTSQG/9E95q8PrdqunV
         uWSQLFH2j4nqh3OLRqAfaJYx9qZjPBS+30v5hBZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 087/239] netfilter: ipt_CLUSTERIP: fix refcount leak in clusterip_tg_check()
Date:   Mon, 24 Jan 2022 19:42:05 +0100
Message-Id: <20220124183945.883816661@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Xiong <xiongx18@fudan.edu.cn>

[ Upstream commit d94a69cb2cfa77294921aae9afcfb866e723a2da ]

The issue takes place in one error path of clusterip_tg_check(). When
memcmp() returns nonzero, the function simply returns the error code,
forgetting to decrease the reference count of a clusterip_config
object, which is bumped earlier by clusterip_config_find_get(). This
may incur reference count leak.

Fix this issue by decrementing the refcount of the object in specific
error path.

Fixes: 06aa151ad1fc74 ("netfilter: ipt_CLUSTERIP: check MAC address when duplicate config is set")
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 2fa1963259880..954c96f4ddd0f 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -509,8 +509,11 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
 			if (IS_ERR(config))
 				return PTR_ERR(config);
 		}
-	} else if (memcmp(&config->clustermac, &cipinfo->clustermac, ETH_ALEN))
+	} else if (memcmp(&config->clustermac, &cipinfo->clustermac, ETH_ALEN)) {
+		clusterip_config_entry_put(config);
+		clusterip_config_put(config);
 		return -EINVAL;
+	}
 
 	ret = nf_ct_netns_get(par->net, par->family);
 	if (ret < 0) {
-- 
2.34.1



