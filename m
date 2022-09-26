Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023495E9F71
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbiIZKZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235675AbiIZKYg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:24:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C294D27E;
        Mon, 26 Sep 2022 03:18:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8496EB80930;
        Mon, 26 Sep 2022 10:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA212C433D7;
        Mon, 26 Sep 2022 10:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187479;
        bh=0D4Q9fdkdNqRsgQXEkbD9sdW2pAZmHjPrqk4lVtgJjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1EK9UxRtX6jc8z3AGHBSe6U3/xnlnaQzFvUmbapWo8eWQ60DY7RF6xZr4HfSvCmf
         zqlCdQpcSi1h3oq8LAfKrGvcrbXssH1ZnzKHetWZtYYK4KrbSov2wI7HwKq6Zw0W1S
         QXjAeDvTwP74zfId+AX9nKvsce5LZc7YzzGPouyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Metzmacher <metze@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.19 09/58] cifs: dont send down the destination address to sendmsg for a SOCK_STREAM
Date:   Mon, 26 Sep 2022 12:11:28 +0200
Message-Id: <20220926100741.748856850@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
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
@@ -168,8 +168,8 @@ smb_send_kvec(struct TCP_Server_Info *se
 
 	*sent = 0;
 
-	smb_msg->msg_name = (struct sockaddr *) &server->dstaddr;
-	smb_msg->msg_namelen = sizeof(struct sockaddr);
+	smb_msg->msg_name = NULL;
+	smb_msg->msg_namelen = 0;
 	smb_msg->msg_control = NULL;
 	smb_msg->msg_controllen = 0;
 	if (server->noblocksnd)


