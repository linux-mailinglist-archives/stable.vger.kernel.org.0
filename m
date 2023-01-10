Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6804664848
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238745AbjAJSKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239032AbjAJSJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:09:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DA98D5C1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:07:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08D2F6186E
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:07:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC21C433EF;
        Tue, 10 Jan 2023 18:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374052;
        bh=goc9zy/4l8vkIUno5Az/ePvO0Gv498KEOUcal1w97gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0G+PFmlVVKcq3XO4+4eGpkIh4P6UB8LgM0fNSvYZIdtm62ffAybv3jObCalYnhrFl
         cW6zzepbwGd+NqzDePeNH+IG4Gh+FNPeP4PjWnGhEOzV6J3qPppBnahG95Mmgtq3oA
         FqaSGlSQW+ntkTkrT9nI1cEoL2yYzyTottoxvWjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 003/148] cifs: fix interface count calculation during refresh
Date:   Tue, 10 Jan 2023 19:01:47 +0100
Message-Id: <20230110180017.273086938@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit cc7d79d4fad6a4eab3f88c4bb237de72be4478f1 upstream.

The last fix to iface_count did fix the overcounting issue.
However, during each refresh, we could end up undercounting
the iface_count, if a match was found.

Fixing this by doing increments and decrements instead of
setting it to 0 before each parsing of server interfaces.

Fixes: 096bbeec7bd6 ("smb3: interface count displayed incorrectly")
Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -530,7 +530,6 @@ parse_server_interfaces(struct network_i
 	p = buf;
 
 	spin_lock(&ses->iface_lock);
-	ses->iface_count = 0;
 	/*
 	 * Go through iface_list and do kref_put to remove
 	 * any unused ifaces. ifaces in use will be removed
@@ -540,6 +539,7 @@ parse_server_interfaces(struct network_i
 				 iface_head) {
 		iface->is_active = 0;
 		kref_put(&iface->refcount, release_iface);
+		ses->iface_count--;
 	}
 	spin_unlock(&ses->iface_lock);
 
@@ -617,6 +617,7 @@ parse_server_interfaces(struct network_i
 				/* just get a ref so that it doesn't get picked/freed */
 				iface->is_active = 1;
 				kref_get(&iface->refcount);
+				ses->iface_count++;
 				spin_unlock(&ses->iface_lock);
 				goto next_iface;
 			} else if (ret < 0) {


