Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C88229B996
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802627AbgJ0Pue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801427AbgJ0PlR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:41:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ECB3223B0;
        Tue, 27 Oct 2020 15:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813276;
        bh=P05hMdmcCfZ6hsb/t3C3HolCK1kxPQigs2YlxUr23RU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daKtbnfEtE2cTF86u4YN0JSpg0O8tBvE/94Z03gI6rjs/LecAcgjULlwBaFaQDnqE
         OS24uF/VEOIqZeXmhxDfOex4O2c7vJ+7XdinuNflh5Wd92VUh+9qGce9ugIvD1rsGp
         xkecDmWucxjOV08T+G1xwQLlfdQdX01HuidlJejg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 497/757] thermal: core: Adding missing nlmsg_free() in thermal_genl_sampling_temp()
Date:   Tue, 27 Oct 2020 14:52:27 +0100
Message-Id: <20201027135513.775287511@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit 48b458591749d35c927351b4960b49e35af30fe6 ]

thermal_genl_sampling_temp() misses to call nlmsg_free() in an error path.

Jump to out_free to fix it.

Fixes: 1ce50e7d408ef2 ("thermal: core: genetlink support for events/cmd/sampling")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20200929082652.59876-1-jingxiangfeng@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_netlink.c b/drivers/thermal/thermal_netlink.c
index af7b2383e8f6b..019f4812def6c 100644
--- a/drivers/thermal/thermal_netlink.c
+++ b/drivers/thermal/thermal_netlink.c
@@ -78,7 +78,7 @@ int thermal_genl_sampling_temp(int id, int temp)
 	hdr = genlmsg_put(skb, 0, 0, &thermal_gnl_family, 0,
 			  THERMAL_GENL_SAMPLING_TEMP);
 	if (!hdr)
-		return -EMSGSIZE;
+		goto out_free;
 
 	if (nla_put_u32(skb, THERMAL_GENL_ATTR_TZ_ID, id))
 		goto out_cancel;
@@ -93,6 +93,7 @@ int thermal_genl_sampling_temp(int id, int temp)
 	return 0;
 out_cancel:
 	genlmsg_cancel(skb, hdr);
+out_free:
 	nlmsg_free(skb);
 
 	return -EMSGSIZE;
-- 
2.25.1



