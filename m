Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9BE5B7F55
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 05:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiIND0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 23:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiIND0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 23:26:34 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E8A2496F;
        Tue, 13 Sep 2022 20:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=6l3abcKl3JgyU3M7jMOHoKTZZmCGJ25op7rHPAhG9Ew=; b=P/PGB5PwaPeG6Flx3Ywyt/FBKz
        6ypVqIjhPYxk6l1IdNINCdJ2wagTUH89mfPdxAXpLV1c7UAUL2ND+ig5q3grTw7W1Afw43y11YztZ
        SZZ+OVzwzHrF4HwALt7Rjs8Xbxsq2yi+MoVD1zd5VF4anlTUVgT8U9naVqkeDwK53nyqqToqOmtA9
        SYZNOb9IRSS0mklbrCC//3LAeBc4IBVkS2+9QxsILZzvL8hzJUKgo4xDOvR9xdp+/mtvuNyv+3nNe
        czlNZY9yNs6KQZIH0qSUCQT6mTHnE+grdeJeZYdZ+ukbWkKbtqlI/CsajHCKr97GB6P549OhHPU6Z
        L2J2XlgF5eXqaVr2FjBf3JmvG/aHzniXibocp8VefV4g1vTMDzvY6ex9hy6CgPYV4nFY5wDG2MIyL
        I5JOBCnVWdR+Uw5P85CDSuB2xKcbTs4sIifjqx76+2enPwWabXHv7CAkpGGU7KjA5TlsBo2CA2eWB
        Id2bGhek/tYVBzxe9THpIh/S;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oYJ2j-000Hzg-GB; Wed, 14 Sep 2022 03:26:29 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>, stable@vger.kernel.org,
        Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 1/2] cifs: don't send down the destination address to sendmsg for a SOCK_STREAM
Date:   Wed, 14 Sep 2022 05:25:46 +0200
Message-Id: <1f0efc3630e3e91d47f4b886c4ef75264aaaa42c.1663125352.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1663125352.git.metze@samba.org>
References: <cover.1663125352.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is ignored anyway by the tcp layer.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/transport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index c2fe035e573b..a43c87c1d343 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -194,8 +194,8 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 
 	*sent = 0;
 
-	smb_msg->msg_name = (struct sockaddr *) &server->dstaddr;
-	smb_msg->msg_namelen = sizeof(struct sockaddr);
+	smb_msg->msg_name = NULL;
+	smb_msg->msg_namelen = 0;
 	smb_msg->msg_control = NULL;
 	smb_msg->msg_controllen = 0;
 	if (server->noblocksnd)
-- 
2.34.1

