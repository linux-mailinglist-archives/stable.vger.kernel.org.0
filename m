Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4FF4E7725
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376519AbiCYP1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376711AbiCYPXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:23:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362C4E43B2;
        Fri, 25 Mar 2022 08:16:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D0E760DE3;
        Fri, 25 Mar 2022 15:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C1CC340E9;
        Fri, 25 Mar 2022 15:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221377;
        bh=tHJ0fvPCozzdBu+3vz3vvpVBOjJkkaJqoVH44eGv5JY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vFdZcKcpWS1lKs/1FI8mflxjTez0uViY37HXiuYfKdQxrZE5xLpCxJrzDKfGe8ZmH
         V8yC82zw9Wn3tIfWWRe4YEzit1gZtK9mJGcKs/NlBjKPp9dBczkZEJxnlLbd8hrlj0
         O63uxVSjTzAEreqlA2uzB7zXBRDMowhdNBaRqRas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        =?UTF-8?q?=E8=B5=B5=E5=AD=90=E8=BD=A9?= <beraphin@gmail.com>,
        Stoyan Manolov <smanolov@suse.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 05/37] llc: fix netdevice reference leaks in llc_ui_bind()
Date:   Fri, 25 Mar 2022 16:14:06 +0100
Message-Id: <20220325150420.090118002@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150419.931802116@linuxfoundation.org>
References: <20220325150419.931802116@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 764f4eb6846f5475f1244767d24d25dd86528a4a upstream.

Whenever llc_ui_bind() and/or llc_ui_autobind()
took a reference on a netdevice but subsequently fail,
they must properly release their reference
or risk the infamous message from unregister_netdevice()
at device dismantle.

unregister_netdevice: waiting for eth0 to become free. Usage count = 3

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: 赵子轩 <beraphin@gmail.com>
Reported-by: Stoyan Manolov <smanolov@suse.de>
Link: https://lore.kernel.org/r/20220323004147.1990845-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/llc/af_llc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -310,6 +310,10 @@ static int llc_ui_autobind(struct socket
 	sock_reset_flag(sk, SOCK_ZAPPED);
 	rc = 0;
 out:
+	if (rc) {
+		dev_put(llc->dev);
+		llc->dev = NULL;
+	}
 	return rc;
 }
 
@@ -407,6 +411,10 @@ static int llc_ui_bind(struct socket *so
 out_put:
 	llc_sap_put(sap);
 out:
+	if (rc) {
+		dev_put(llc->dev);
+		llc->dev = NULL;
+	}
 	release_sock(sk);
 	return rc;
 }


