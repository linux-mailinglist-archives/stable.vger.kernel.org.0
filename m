Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E451E2EC4
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgEZTbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389646AbgEZS6f (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:58:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ACBE2086A;
        Tue, 26 May 2020 18:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519514;
        bh=TBLo4dLq5VDRFNhsmD0LzmJsQnZuiQGTpDo2FwyX2f4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VcsXZpgfI49T2NUvNTlPkX8CpkXNyvhiApcseN6QV1NESGeSf+nndiCbR8xP3AJhV
         FcxEPQEsRBiA+hrc3M/mmXDjBD8yuU92R76UAW4KjRe7nJkkxjRFaDy0wpUT8kZobX
         Fp9cTWAD7ynhZZFRF+XdT2zqkRRvekN/yDd3FspI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.9 32/64] l2tp: remove useless duplicate session detection in l2tp_netlink
Date:   Tue, 26 May 2020 20:53:01 +0200
Message-Id: <20200526183923.094609162@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit af87ae465abdc070de0dc35d6c6a9e7a8cd82987 upstream.

There's no point in checking for duplicate sessions at the beginning of
l2tp_nl_cmd_session_create(); the ->session_create() callbacks already
return -EEXIST when the session already exists.

Furthermore, even if l2tp_session_find() returns NULL, a new session
might be created right after the test. So relying on ->session_create()
to avoid duplicate session is the only sane behaviour.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_netlink.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -513,11 +513,6 @@ static int l2tp_nl_cmd_session_create(st
 		goto out;
 	}
 	session_id = nla_get_u32(info->attrs[L2TP_ATTR_SESSION_ID]);
-	session = l2tp_session_find(net, tunnel, session_id);
-	if (session) {
-		ret = -EEXIST;
-		goto out;
-	}
 
 	if (!info->attrs[L2TP_ATTR_PEER_SESSION_ID]) {
 		ret = -EINVAL;


