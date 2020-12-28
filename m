Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C068B2E37B7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgL1M7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:59:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728584AbgL1M7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:59:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB06522D00;
        Mon, 28 Dec 2020 12:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160333;
        bh=LMZyDnsGvgQkL+DovBkrlqbPZ8PfoOXGkxyBxKN6irk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYSngHYZ6nq1nwWn2II8CnQxlizm44wkC3pwvp4m5LiTHDQ3mTAmTQ2onqprQAZK2
         yiJBcxNe02uyWSIqDsyRkyEcf2nR7PLR6kww5iHueneUoI0sYqfHbRySqLHB7Bu6ut
         6Nr3MrPxhhw5KgitB8TZxHkNwGoeGdxklF//kCR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 016/175] net: bridge: vlan: fix error return code in __vlan_add()
Date:   Mon, 28 Dec 2020 13:47:49 +0100
Message-Id: <20201228124854.046832651@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit ee4f52a8de2c6f78b01f10b4c330867d88c1653a ]

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: f8ed289fab84 ("bridge: vlan: use br_vlan_(get|put)_master to deal with refcounts")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Link: https://lore.kernel.org/r/1607071737-33875-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_vlan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -238,8 +238,10 @@ static int __vlan_add(struct net_bridge_
 		}
 
 		masterv = br_vlan_get_master(br, v->vid);
-		if (!masterv)
+		if (!masterv) {
+			err = -ENOMEM;
 			goto out_filt;
+		}
 		v->brvlan = masterv;
 		v->stats = masterv->stats;
 	}


