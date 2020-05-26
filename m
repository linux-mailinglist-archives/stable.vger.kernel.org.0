Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F681E2EFC
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389791AbgEZS4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389789AbgEZS4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:56:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC32820870;
        Tue, 26 May 2020 18:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519380;
        bh=/Gw1qP01JOnZ5X12K7E0+YS8po1KWPSRMJgK+BuvE0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bR2treJU2PgmnknWsu9myNrfzwIdNLV2gL5AkjCfP5NjDjUi0Qxhps7Ug+lyX7hSF
         YOfEfcGG5Spg+KoFnmUfw45CK9Sy9LZhsYLKMqwi0dcL0tlG+VVLtsm9p/dgrxbKwN
         JJA8zjbUjCPJnuuw16uRlhxEisBs2ZHj5+Vmrf68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, greg@kroah.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Subject: [PATCH 4.4 44/65] l2tp: remove useless duplicate session detection in l2tp_netlink
Date:   Tue, 26 May 2020 20:53:03 +0200
Message-Id: <20200526183921.196186290@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
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
@@ -505,11 +505,6 @@ static int l2tp_nl_cmd_session_create(st
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


