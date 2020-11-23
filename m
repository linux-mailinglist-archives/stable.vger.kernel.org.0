Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869882C0779
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732665AbgKWMl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:41:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:54392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732661AbgKWMlZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:41:25 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5202E2065E;
        Mon, 23 Nov 2020 12:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135284;
        bh=FlixPoLxVNA3RfFFiFKfQxi5RJJZmEs2ImbBmMhLEUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FaA+8dAiSLehoV1L/pe3F9qq4iKcnOYap3D9jsn2gaKMdWRexWmA4/WvfxCFRf8C+
         Fo8O5SALqGxMe17bEj291JTfIfpHpIbGbseHAJFJBEge6yJuLAsDBEL+5IIrU9/U/W
         yXPFmchjKW488+4pOD/u+sSsp3R9HoI753xO5OtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 004/252] devlink: Add missing genlmsg_cancel() in devlink_nl_sb_port_pool_fill()
Date:   Mon, 23 Nov 2020 13:19:14 +0100
Message-Id: <20201123121835.799443774@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
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
@@ -1311,7 +1311,7 @@ static int devlink_nl_sb_port_pool_fill(
 		err = ops->sb_occ_port_pool_get(devlink_port, devlink_sb->index,
 						pool_index, &cur, &max);
 		if (err && err != -EOPNOTSUPP)
-			return err;
+			goto sb_occ_get_failure;
 		if (!err) {
 			if (nla_put_u32(msg, DEVLINK_ATTR_SB_OCC_CUR, cur))
 				goto nla_put_failure;
@@ -1324,8 +1324,10 @@ static int devlink_nl_sb_port_pool_fill(
 	return 0;
 
 nla_put_failure:
+	err = -EMSGSIZE;
+sb_occ_get_failure:
 	genlmsg_cancel(msg, hdr);
-	return -EMSGSIZE;
+	return err;
 }
 
 static int devlink_nl_cmd_sb_port_pool_get_doit(struct sk_buff *skb,


