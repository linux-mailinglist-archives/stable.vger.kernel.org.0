Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB412C05DC
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgKWMZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:25:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729917AbgKWMZB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:25:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7457F20728;
        Mon, 23 Nov 2020 12:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134301;
        bh=HoIxnDrBm+fJ0iCjA74t68UzK62ny8/iYmYyqlIrhVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kk3Jyw2GplEfc0yBPCJGGMc0WRqAOJEiyoMtgKik8ZMeNu0TVG/5nELvlJr1wcRnu
         YcuD5eGJECmxgVL3NJU/dGkYRNZXXGa+AFG1xl3cXNoSIxACSy3mi0w27NiguDst7U
         9JmR97kbPldt3Vxs8vG4bnN/QJP6idTwSZwPQoLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 04/47] devlink: Add missing genlmsg_cancel() in devlink_nl_sb_port_pool_fill()
Date:   Mon, 23 Nov 2020 13:21:50 +0100
Message-Id: <20201123121805.760726665@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121805.530891002@linuxfoundation.org>
References: <20201123121805.530891002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 849920c703392957f94023f77ec89ca6cf119d43 ]

If sb_occ_port_pool_get() failed in devlink_nl_sb_port_pool_fill(),
msg should be canceled by genlmsg_cancel().

Fixes: df38dafd2559 ("devlink: implement shared buffer occupancy monitoring interface")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Link: https://lore.kernel.org/r/20201113111622.11040-1-wanghai38@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/devlink.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -986,7 +986,7 @@ static int devlink_nl_sb_port_pool_fill(
 		err = ops->sb_occ_port_pool_get(devlink_port, devlink_sb->index,
 						pool_index, &cur, &max);
 		if (err && err != -EOPNOTSUPP)
-			return err;
+			goto sb_occ_get_failure;
 		if (!err) {
 			if (nla_put_u32(msg, DEVLINK_ATTR_SB_OCC_CUR, cur))
 				goto nla_put_failure;
@@ -999,8 +999,10 @@ static int devlink_nl_sb_port_pool_fill(
 	return 0;
 
 nla_put_failure:
+	err = -EMSGSIZE;
+sb_occ_get_failure:
 	genlmsg_cancel(msg, hdr);
-	return -EMSGSIZE;
+	return err;
 }
 
 static int devlink_nl_cmd_sb_port_pool_get_doit(struct sk_buff *skb,


