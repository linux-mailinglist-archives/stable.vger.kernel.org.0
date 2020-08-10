Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F742240A30
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgHJPYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:24:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728371AbgHJPYt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:24:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D05121775;
        Mon, 10 Aug 2020 15:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073088;
        bh=Ug02kqfPGJ0/IdfnyY4yzw4nqwciixxjTmDNOcu3TVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHYfNHj9w9o/iFAS0/uYGC10j7tW4T+cswi0DpDMxcSpNXq8dy7ZXjG68zSHorNca
         o8MqI/xd23a82ENa12DEiCTTS8UijYr0PV40DTjkbXHu5GIqg8tz08Bj440RFAYx7Q
         5ILgvZfCXSyl2h4ojhs7fNQIs4Qrm2AmjC4/zkrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 62/79] devlink: ignore -EOPNOTSUPP errors on dumpit
Date:   Mon, 10 Aug 2020 17:21:21 +0200
Message-Id: <20200810151815.301734997@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 82274d075536322368ce710b211c41c37c4740b9 ]

Number of .dumpit functions try to ignore -EOPNOTSUPP errors.
Recent change missed that, and started reporting all errors
but -EMSGSIZE back from dumps. This leads to situation like
this:

$ devlink dev info
devlink answers: Operation not supported

Dump should not report an error just because the last device
to be queried could not provide an answer.

To fix this and avoid similar confusion make sure we clear
err properly, and not leave it set to an error if we don't
terminate the iteration.

Fixes: c62c2cfb801b ("net: devlink: don't ignore errors during dumpit")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/devlink.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1065,7 +1065,9 @@ static int devlink_nl_cmd_sb_pool_get_du
 						   devlink_sb,
 						   NETLINK_CB(cb->skb).portid,
 						   cb->nlh->nlmsg_seq);
-			if (err && err != -EOPNOTSUPP) {
+			if (err == -EOPNOTSUPP) {
+				err = 0;
+			} else if (err) {
 				mutex_unlock(&devlink->lock);
 				goto out;
 			}
@@ -1266,7 +1268,9 @@ static int devlink_nl_cmd_sb_port_pool_g
 							devlink, devlink_sb,
 							NETLINK_CB(cb->skb).portid,
 							cb->nlh->nlmsg_seq);
-			if (err && err != -EOPNOTSUPP) {
+			if (err == -EOPNOTSUPP) {
+				err = 0;
+			} else if (err) {
 				mutex_unlock(&devlink->lock);
 				goto out;
 			}
@@ -1498,7 +1502,9 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpi
 							   devlink_sb,
 							   NETLINK_CB(cb->skb).portid,
 							   cb->nlh->nlmsg_seq);
-			if (err && err != -EOPNOTSUPP) {
+			if (err == -EOPNOTSUPP) {
+				err = 0;
+			} else if (err) {
 				mutex_unlock(&devlink->lock);
 				goto out;
 			}
@@ -3299,7 +3305,9 @@ static int devlink_nl_cmd_param_get_dump
 						    NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
 						    NLM_F_MULTI);
-			if (err && err != -EOPNOTSUPP) {
+			if (err == -EOPNOTSUPP) {
+				err = 0;
+			} else if (err) {
 				mutex_unlock(&devlink->lock);
 				goto out;
 			}
@@ -3569,7 +3577,9 @@ static int devlink_nl_cmd_port_param_get
 						NETLINK_CB(cb->skb).portid,
 						cb->nlh->nlmsg_seq,
 						NLM_F_MULTI);
-				if (err && err != -EOPNOTSUPP) {
+				if (err == -EOPNOTSUPP) {
+					err = 0;
+				} else if (err) {
 					mutex_unlock(&devlink->lock);
 					goto out;
 				}
@@ -4479,7 +4489,9 @@ static int devlink_nl_cmd_info_get_dumpi
 					   cb->nlh->nlmsg_seq, NLM_F_MULTI,
 					   cb->extack);
 		mutex_unlock(&devlink->lock);
-		if (err && err != -EOPNOTSUPP)
+		if (err == -EOPNOTSUPP)
+			err = 0;
+		else if (err)
 			break;
 		idx++;
 	}


