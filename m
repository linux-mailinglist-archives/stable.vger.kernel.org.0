Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5948567F7EA
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 14:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbjA1NMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Jan 2023 08:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjA1NMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Jan 2023 08:12:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B3123D95
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 05:12:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55553B80968
        for <stable@vger.kernel.org>; Sat, 28 Jan 2023 13:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961FBC433EF;
        Sat, 28 Jan 2023 13:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674911558;
        bh=/ohKBidNsuuDmKNpOlG8qyueJ2tQ5zBmhKbLQN2fHs4=;
        h=Subject:To:Cc:From:Date:From;
        b=h22kd8NKfOIVxmiOTbg4xIGGrEHMNxlwmVp8sX4dMYSOWnTnmpdkNffLwXkpcMg+S
         da3vIMDX8ByStSzYYIoPKwTlh1WDbdALuYr3sBgciyl80WrvAU0uAAdeH7pUJ9Ccfg
         53h0Qg9TXUUkRWCLAI5f0P50wGuLjW6tk+3heg3o=
Subject: FAILED: patch "[PATCH] cifs: Fix oops due to uncleared server->smbd_conn in" failed to apply to 4.19-stable tree
To:     dhowells@redhat.com, longli@microsoft.com, lsahlber@redhat.com,
        pc@cjr.nz, piastryyy@gmail.com, stfrench@microsoft.com,
        tom@talpey.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 28 Jan 2023 14:12:34 +0100
Message-ID: <1674911554100156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

b7ab9161cf5d ("cifs: Fix oops due to uncleared server->smbd_conn in reconnect")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b7ab9161cf5ddc42a288edf9d1a61f3bdffe17c7 Mon Sep 17 00:00:00 2001
From: David Howells <dhowells@redhat.com>
Date: Wed, 25 Jan 2023 14:02:13 +0000
Subject: [PATCH] cifs: Fix oops due to uncleared server->smbd_conn in
 reconnect

In smbd_destroy(), clear the server->smbd_conn pointer after freeing the
smbd_connection struct that it points to so that reconnection doesn't get
confused.

Fixes: 8ef130f9ec27 ("CIFS: SMBD: Implement function to destroy a SMB Direct connection")
Cc: stable@vger.kernel.org
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Acked-by: Tom Talpey <tom@talpey.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Long Li <longli@microsoft.com>
Cc: Pavel Shilovsky <piastryyy@gmail.com>
Cc: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 90789aaa6567..8c816b25ce7c 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1405,6 +1405,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	destroy_workqueue(info->workqueue);
 	log_rdma_event(INFO,  "rdma session destroyed\n");
 	kfree(info);
+	server->smbd_conn = NULL;
 }
 
 /*

