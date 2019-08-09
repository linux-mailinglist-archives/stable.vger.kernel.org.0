Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E363487BF7
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 15:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407211AbfHINrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 09:47:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406644AbfHINrL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 09:47:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 196DA2171F;
        Fri,  9 Aug 2019 13:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565358430;
        bh=ekEil7OIvosv3Ar8RW497EvnfJe5r+WgJEwJe01LqaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6pQJqfiGicSKR9bhh410BeHkkyDV1eJ143XNcfFC4scFlqMM+rmCIKU+DcrAM9Gf
         +H4VLnUg1xjBSmp1ix3aeIlfVgLDJK9DgZzbVGtRH3778SbGTiyNwlsFzeRVJwDVWr
         hrG2NGZFINXUlAy6iLbwXL482sGDl5j5CoP/WJWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taras Kondratiuk <takondra@cisco.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 21/32] tipc: compat: allow tipc commands without arguments
Date:   Fri,  9 Aug 2019 15:45:24 +0200
Message-Id: <20190809133923.628513265@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809133922.945349906@linuxfoundation.org>
References: <20190809133922.945349906@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taras Kondratiuk <takondra@cisco.com>

[ Upstream commit 4da5f0018eef4c0de31675b670c80e82e13e99d1 ]

Commit 2753ca5d9009 ("tipc: fix uninit-value in tipc_nl_compat_doit")
broke older tipc tools that use compat interface (e.g. tipc-config from
tipcutils package):

% tipc-config -p
operation not supported

The commit started to reject TIPC netlink compat messages that do not
have attributes. It is too restrictive because some of such messages are
valid (they don't need any arguments):

% grep 'tx none' include/uapi/linux/tipc_config.h
#define  TIPC_CMD_NOOP              0x0000    /* tx none, rx none */
#define  TIPC_CMD_GET_MEDIA_NAMES   0x0002    /* tx none, rx media_name(s) */
#define  TIPC_CMD_GET_BEARER_NAMES  0x0003    /* tx none, rx bearer_name(s) */
#define  TIPC_CMD_SHOW_PORTS        0x0006    /* tx none, rx ultra_string */
#define  TIPC_CMD_GET_REMOTE_MNG    0x4003    /* tx none, rx unsigned */
#define  TIPC_CMD_GET_MAX_PORTS     0x4004    /* tx none, rx unsigned */
#define  TIPC_CMD_GET_NETID         0x400B    /* tx none, rx unsigned */
#define  TIPC_CMD_NOT_NET_ADMIN     0xC001    /* tx none, rx none */

This patch relaxes the original fix and rejects messages without
arguments only if such arguments are expected by a command (reg_type is
non zero).

Fixes: 2753ca5d9009 ("tipc: fix uninit-value in tipc_nl_compat_doit")
Cc: stable@vger.kernel.org
Signed-off-by: Taras Kondratiuk <takondra@cisco.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/netlink_compat.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -55,6 +55,7 @@ struct tipc_nl_compat_msg {
 	int rep_type;
 	int rep_size;
 	int req_type;
+	int req_size;
 	struct net *net;
 	struct sk_buff *rep;
 	struct tlv_desc *req;
@@ -252,7 +253,8 @@ static int tipc_nl_compat_dumpit(struct
 	int err;
 	struct sk_buff *arg;
 
-	if (msg->req_type && !TLV_CHECK_TYPE(msg->req, msg->req_type))
+	if (msg->req_type && (!msg->req_size ||
+			      !TLV_CHECK_TYPE(msg->req, msg->req_type)))
 		return -EINVAL;
 
 	msg->rep = tipc_tlv_alloc(msg->rep_size);
@@ -345,7 +347,8 @@ static int tipc_nl_compat_doit(struct ti
 {
 	int err;
 
-	if (msg->req_type && !TLV_CHECK_TYPE(msg->req, msg->req_type))
+	if (msg->req_type && (!msg->req_size ||
+			      !TLV_CHECK_TYPE(msg->req, msg->req_type)))
 		return -EINVAL;
 
 	err = __tipc_nl_compat_doit(cmd, msg);
@@ -1267,8 +1270,8 @@ static int tipc_nl_compat_recv(struct sk
 		goto send;
 	}
 
-	len = nlmsg_attrlen(req_nlh, GENL_HDRLEN + TIPC_GENL_HDRLEN);
-	if (!len || !TLV_OK(msg.req, len)) {
+	msg.req_size = nlmsg_attrlen(req_nlh, GENL_HDRLEN + TIPC_GENL_HDRLEN);
+	if (msg.req_size && !TLV_OK(msg.req, msg.req_size)) {
 		msg.rep = tipc_get_err_tlv(TIPC_CFG_NOT_SUPPORTED);
 		err = -EOPNOTSUPP;
 		goto send;


