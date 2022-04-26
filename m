Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B0650F837
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346674AbiDZJIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345944AbiDZJG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F4F13566A;
        Tue, 26 Apr 2022 01:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D1DE60C42;
        Tue, 26 Apr 2022 08:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CB2C385A0;
        Tue, 26 Apr 2022 08:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962867;
        bh=QGISIWt0xAu7CrLpvK0e1CfLL9c0uHmU/rChXAc3JGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EmbJx3ArBMhbtv8GYHAe+SpRR3D4cYaq+8qE90oKNMxrsq1PbbY5aclUDtB/zZP/W
         0ZgDq5VvNTPI03G33Os/vdi9chXUgr95p75XrrQm2GCnEYf340x2b8iCf6BVG3SAu0
         jZ8QCpwgSBaGjpWRF+wTPw9uwl9GtITLkYWzjza8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.17 116/146] cifs: use correct lock type in cifs_reconnect()
Date:   Tue, 26 Apr 2022 10:21:51 +0200
Message-Id: <20220426081753.317688313@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit cd70a3e8988a999c42d307d2616a5e7b6a33c7c8 upstream.

TCP_Server_Info::origin_fullpath and TCP_Server_Info::leaf_fullpath
are protected by refpath_lock mutex and not cifs_tcp_ses_lock
spinlock.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Cc: stable@vger.kernel.org
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -534,12 +534,19 @@ int cifs_reconnect(struct TCP_Server_Inf
 {
 	/* If tcp session is not an dfs connection, then reconnect to last target server */
 	spin_lock(&cifs_tcp_ses_lock);
-	if (!server->is_dfs_conn || !server->origin_fullpath || !server->leaf_fullpath) {
+	if (!server->is_dfs_conn) {
 		spin_unlock(&cifs_tcp_ses_lock);
 		return __cifs_reconnect(server, mark_smb_session);
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 
+	mutex_lock(&server->refpath_lock);
+	if (!server->origin_fullpath || !server->leaf_fullpath) {
+		mutex_unlock(&server->refpath_lock);
+		return __cifs_reconnect(server, mark_smb_session);
+	}
+	mutex_unlock(&server->refpath_lock);
+
 	return reconnect_dfs_server(server);
 }
 #else


