Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64F666C4AB
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbjAPP5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbjAPP5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:57:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A74F1CAE7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:56:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3380B81052
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7AEC433EF;
        Mon, 16 Jan 2023 15:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884610;
        bh=R6oZbqNU/2ppKcaBnPmrVX8xGwVcBk6i1S/XMl4WZlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwNen6fl37xVoIDIdsYAzpoIEjKWg15YRraUi/y5H0rFYlt1wmHYKjZBIxuE5BVjE
         jS9KvwY05ciV3S0Oh2RqBfl2cYlGJ5S4/hfLDX+VTGklfmoid07+gRJBS7T2aM4jaG
         idk/272EaAHxb/4ZdRjocIpePnr6TooBbe+xKyEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 041/183] cifs: do not query ifaces on smb1 mounts
Date:   Mon, 16 Jan 2023 16:49:24 +0100
Message-Id: <20230116154805.126104685@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Paulo Alcantara <pc@cjr.nz>

commit 22aeb01db7080e18c6aeb4361cc2556c9887099a upstream.

Users have reported the following error on every 600 seconds
(SMB_INTERFACE_POLL_INTERVAL) when mounting SMB1 shares:

	CIFS: VFS: \\srv\share error -5 on ioctl to get interface list

It's supported only by SMB2+, so do not query network interfaces on
SMB1 mounts.

Fixes: 6e1c1c08cdf3 ("cifs: periodically query network interfaces from server")
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2609,11 +2609,14 @@ cifs_get_tcon(struct cifs_ses *ses, stru
 	INIT_LIST_HEAD(&tcon->pending_opens);
 	tcon->status = TID_GOOD;
 
-	/* schedule query interfaces poll */
 	INIT_DELAYED_WORK(&tcon->query_interfaces,
 			  smb2_query_server_interfaces);
-	queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
-			   (SMB_INTERFACE_POLL_INTERVAL * HZ));
+	if (ses->server->dialect >= SMB30_PROT_ID &&
+	    (ses->server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
+		/* schedule query interfaces poll */
+		queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
+				   (SMB_INTERFACE_POLL_INTERVAL * HZ));
+	}
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_add(&tcon->tcon_list, &ses->tcon_list);


