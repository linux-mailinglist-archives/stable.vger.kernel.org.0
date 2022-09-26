Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38AE85E9EC4
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbiIZKN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbiIZKNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:13:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40126E3B;
        Mon, 26 Sep 2022 03:13:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCF0F60AF0;
        Mon, 26 Sep 2022 10:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7064C433D6;
        Mon, 26 Sep 2022 10:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187223;
        bh=wYYg+ZsRnP0jNGIZ0QVKY3zQv/ltH8dLHcgdLcIHnVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPlzx+RSClNETtC1O3LMXyoRsmL4FHF9xTGZiMHTHKJusxWShCRHDxHTCtW9phOHS
         ARN+j7WCKa9tcHj2wvl1f+hkaGzs5wigWU62ulmwj/6vJ9bvfE43kk0xszhc5qNjLf
         ytK1ChkoefwwlMy0+r+3oqkRXFQmEgVElTQ3YLCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.9 02/30] cifs: dont send down the destination address to sendmsg for a SOCK_STREAM
Date:   Mon, 26 Sep 2022 12:11:33 +0200
Message-Id: <20220926100736.249258635@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100736.153157100@linuxfoundation.org>
References: <20220926100736.153157100@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Metzmacher <metze@samba.org>

commit 17d3df38dc5f4cec9b0ac6eb79c1859b6e2693a4 upstream.

This is ignored anyway by the tcp layer.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: stable@vger.kernel.org
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/transport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -140,8 +140,8 @@ smb_send_kvec(struct TCP_Server_Info *se
 
 	*sent = 0;
 
-	smb_msg->msg_name = (struct sockaddr *) &server->dstaddr;
-	smb_msg->msg_namelen = sizeof(struct sockaddr);
+	smb_msg->msg_name = NULL;
+	smb_msg->msg_namelen = 0;
 	smb_msg->msg_control = NULL;
 	smb_msg->msg_controllen = 0;
 	if (server->noblocksnd)


