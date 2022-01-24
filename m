Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81EA49936A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385614AbiAXUdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:33:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33514 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382135AbiAXUZP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:25:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F354CB811FB;
        Mon, 24 Jan 2022 20:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28472C340E5;
        Mon, 24 Jan 2022 20:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055912;
        bh=v3CmNcQuVcLWxRTsj4bwVZeaXhS0Z8OOc7cj1SIMdtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/OroVOPtNvXPY/5tTh0E+jigHIWLisjzgUdyalt3PUSyU5N8lWnJqrM+DaLdmEP4
         QHE7VBwxEj3fM65nxKjA11j9XtcqecfR1xLEADzeiXJMYR2sB00f6Qv1uLMzHNihoJ
         wwpr/UuNQx6g8YQjoWXAktJz3bFimtz0VvWHEmbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 308/846] netfilter: ipt_CLUSTERIP: fix refcount leak in clusterip_tg_check()
Date:   Mon, 24 Jan 2022 19:37:05 +0100
Message-Id: <20220124184111.534886909@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 8fd1aba8af31c..b518f20c9a244 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -520,8 +520,11 @@ static int clusterip_tg_check(const struct xt_tgchk_param *par)
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



