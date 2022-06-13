Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65CE548B19
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379893AbiFMN7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381638AbiFMN5D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:57:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89ED219F;
        Mon, 13 Jun 2022 04:37:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 680A561325;
        Mon, 13 Jun 2022 11:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD1DC3411C;
        Mon, 13 Jun 2022 11:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120237;
        bh=5fgkOH7xDgS6Kb/TqVo4BBb+cplA2IpxfR8lxDeJRPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WzD1y9UCd9pNyw4XnqcFYeYZV4qlfWZW5z0m35eri8rcJNMgpPwh2iZeQ+vXheK1O
         Iwl69qBjoQS4XrVpnpRbm7b9fbm4VTPnX9P5n+e09K56EUagF7eqWxfQT0JnKpPwxi
         23+WjLNzx6zocGUuZ0ntL5fY8osac8rHyJQ1QCKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.18 300/339] cifs: populate empty hostnames for extra channels
Date:   Mon, 13 Jun 2022 12:12:05 +0200
Message-Id: <20220613094935.862451941@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

commit 4c14d7043fede258957d7b01da0cad2d9fe3a205 upstream.

Currently, the secondary channels of a multichannel session
also get hostname populated based on the info in primary channel.
However, this will end up with a wrong resolution of hostname to
IP address during reconnect.

This change fixes this by not populating hostname info for all
secondary channels.

Fixes: 5112d80c162f ("cifs: populate server_hostname for extra channels")
Cc: stable@vger.kernel.org
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    4 ++++
 fs/cifs/sess.c    |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -97,6 +97,10 @@ static int reconn_set_ipaddr_from_hostna
 	if (!server->hostname)
 		return -EINVAL;
 
+	/* if server hostname isn't populated, there's nothing to do here */
+	if (server->hostname[0] == '\0')
+		return 0;
+
 	len = strlen(server->hostname) + 3;
 
 	unc = kmalloc(len, GFP_KERNEL);
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -274,7 +274,10 @@ cifs_ses_add_channel(struct cifs_sb_info
 	/* Auth */
 	ctx.domainauto = ses->domainAuto;
 	ctx.domainname = ses->domainName;
-	ctx.server_hostname = ses->server->hostname;
+
+	/* no hostname for extra channels */
+	ctx.server_hostname = "";
+
 	ctx.username = ses->user_name;
 	ctx.password = ses->password;
 	ctx.sectype = ses->sectype;


