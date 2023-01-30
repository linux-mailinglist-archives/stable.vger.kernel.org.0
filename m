Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505AC68108B
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236947AbjA3OE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236762AbjA3OET (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:04:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7242C6A69
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:04:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D77C6102D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00639C433EF;
        Mon, 30 Jan 2023 14:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087457;
        bh=py5Id8UF3tih0zkrTCVFvCxcpXEDE+FhXYVN0vEAASc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ful1tj+TcZDgxT2ftpFUlpcxSpIkv366yeQI56yu88Sy4e+3o5qYOVpkxdwaxWhDg
         67pULYz+1YOun7KwNqXM0CgzajP1pyIoAPKKwh02uzQcdG72MRGRobwjboHyxgfV3G
         uxrurgZS52+G4g+VWSZPp6JbgR1EwwlI7C/1v3nA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Tom Talpey <tom@talpey.com>,
        David Howells <dhowells@redhat.com>,
        Long Li <longli@microsoft.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 215/313] cifs: Fix oops due to uncleared server->smbd_conn in reconnect
Date:   Mon, 30 Jan 2023 14:50:50 +0100
Message-Id: <20230130134346.713955296@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit b7ab9161cf5ddc42a288edf9d1a61f3bdffe17c7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smbdirect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1405,6 +1405,7 @@ void smbd_destroy(struct TCP_Server_Info
 	destroy_workqueue(info->workqueue);
 	log_rdma_event(INFO,  "rdma session destroyed\n");
 	kfree(info);
+	server->smbd_conn = NULL;
 }
 
 /*


