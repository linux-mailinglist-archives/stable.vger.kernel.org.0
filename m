Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B89255D491
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbiF0JlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 05:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbiF0JlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 05:41:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C236B6391
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 02:41:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3150861299
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 09:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21425C3411D;
        Mon, 27 Jun 2022 09:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656322875;
        bh=WCjE81LhW9g9DsRgsG79Ym2MKQZx2MOouHu1KcARM7U=;
        h=Subject:To:Cc:From:Date:From;
        b=Mc+dHtDnAdmumqrF++HEUxXr4C0+PZYg26csI0n+Y8ZslYih2XP7WWWC3sqyEM8zi
         mI21TYwOuMfYwxLB1iJE4rraUwRH3D8b+83iAq8QGNlimH8yAhBVija5UGUi1b83w3
         gJHFDax8cdNA7EzEYoBLGOUKzEkENnmxeULpHqLw=
Subject: FAILED: patch "[PATCH] cifs: update cifs_ses::ip_addr after failover" failed to apply to 4.9-stable tree
To:     pc@cjr.nz, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jun 2022 11:40:53 +0200
Message-ID: <165632285322787@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
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

