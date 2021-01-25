Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12240304A85
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731181AbhAZFFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730064AbhAYSyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:54:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D59D622B3F;
        Mon, 25 Jan 2021 18:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600869;
        bh=KycreZXd9pJDnFwXysRyrRxccjmWMf4awmvLPU+dn6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQXw0vI1e/jUmB/IO9jEIuHbkBQ2wqLCvP8eStgNYQ0MRan5s9XcKhUWI2NtGkmSx
         g+z95bV9QSEeDlWUoI3A0/TV3fViXvzCx1MOa/yLWs4C1fPkcM+Or9Vef0EH24i5Q7
         Ro7O3wXe15NdY6xVi4NP6JKLCl1aRL9g++JTU6ZA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 182/199] net: core: devlink: use right genl user_ptr when handling port param get/set
Date:   Mon, 25 Jan 2021 19:40:04 +0100
Message-Id: <20210125183223.863131875@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

commit 7e238de8283acd32c26c2bc2a50672d0ea862ff7 upstream.

Fix incorrect user_ptr dereferencing when handling port param get/set:

    idx [0] stores the 'struct devlink' pointer;
    idx [1] stores the 'struct devlink_port' pointer;

Fixes: 637989b5d77e ("devlink: Always use user_ptr[0] for devlink and simplify post_doit")
CC: Parav Pandit <parav@mellanox.com>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
Link: https://lore.kernel.org/r/20210119085333.16833-1-vadym.kochan@plvision.eu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/devlink.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4134,7 +4134,7 @@ out:
 static int devlink_nl_cmd_port_param_get_doit(struct sk_buff *skb,
 					      struct genl_info *info)
 {
-	struct devlink_port *devlink_port = info->user_ptr[0];
+	struct devlink_port *devlink_port = info->user_ptr[1];
 	struct devlink_param_item *param_item;
 	struct sk_buff *msg;
 	int err;
@@ -4163,7 +4163,7 @@ static int devlink_nl_cmd_port_param_get
 static int devlink_nl_cmd_port_param_set_doit(struct sk_buff *skb,
 					      struct genl_info *info)
 {
-	struct devlink_port *devlink_port = info->user_ptr[0];
+	struct devlink_port *devlink_port = info->user_ptr[1];
 
 	return __devlink_nl_cmd_param_set_doit(devlink_port->devlink,
 					       devlink_port->index,


