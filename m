Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01BBE55C2C2
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbiF0JlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 05:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbiF0JlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 05:41:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6384C636C
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 02:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F24C461299
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 09:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AB6C3411D;
        Mon, 27 Jun 2022 09:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656322866;
        bh=/giJYTux71P/Iy+rk4TR59KLqe4lioKi7zO+mQs62ns=;
        h=Subject:To:Cc:From:Date:From;
        b=jRMSvyH2/RMyVF63IfBldZEmbPxxwcag6M436xtFgd8CFs95PMn33u+qRCC2SNe/t
         N+74qnTJtkQ5HtVxmCuUgEJITadhS/wjlHFU+GZ+AdJxW1ktwTalAn9JYfMQDU5L22
         4rSYP2f5vzyt0c8AOeKZ1M5e4rmb1xky8Grs4Vi0=
Subject: FAILED: patch "[PATCH] cifs: update cifs_ses::ip_addr after failover" failed to apply to 5.10-stable tree
To:     pc@cjr.nz, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jun 2022 11:40:52 +0200
Message-ID: <1656322852176163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From af3a6d1018f02c6dc8388f1f3785a559c7ab5961 Mon Sep 17 00:00:00 2001
From: Paulo Alcantara <pc@cjr.nz>
Date: Fri, 24 Jun 2022 15:01:43 -0300
Subject: [PATCH] cifs: update cifs_ses::ip_addr after failover

cifs_ses::ip_addr wasn't being updated in cifs_session_setup() when
reconnecting SMB sessions thus returning wrong value in
/proc/fs/cifs/DebugData.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: stable@kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8d56325915d0..fa29c9aae24b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4025,10 +4025,16 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		   struct nls_table *nls_info)
 {
 	int rc = -ENOSYS;
+	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&server->dstaddr;
+	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
 	bool is_binding = false;
 
-
 	spin_lock(&cifs_tcp_ses_lock);
+	if (server->dstaddr.ss_family == AF_INET6)
+		scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI6", &addr6->sin6_addr);
+	else
+		scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI4", &addr->sin_addr);
+
 	if (ses->ses_status != SES_GOOD &&
 	    ses->ses_status != SES_NEW &&
 	    ses->ses_status != SES_NEED_RECON) {

