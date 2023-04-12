Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0226DEEC9
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjDLIpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjDLIor (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:44:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16651869A
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:44:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B48DF6308F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A39C4339B;
        Wed, 12 Apr 2023 08:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289048;
        bh=KniCw7X4s6beES+ACV7I6uEf+SnCJlfKPEwGe5iWZ3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gnKotxFWonxaS3qFzNfhSQjKOF0ZZKWB4dFQ17amrOsXIeF77hABK0+uCRu8WSoya
         m42Pro8LyCqT8IzA7y5xUxmEqJw2oTtnHd7yGcLsq/LOOuHXoLNfzy+OupuFFDkvPq
         pHWUldDyTIbSXQaSBO5XeVjVKU/Ytsv3HS4/XQoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marios Makassikis <mmakassikis@freebox.fr>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 086/164] ksmbd: do not call kvmalloc() with __GFP_NORETRY | __GFP_NO_WARN
Date:   Wed, 12 Apr 2023 10:33:28 +0200
Message-Id: <20230412082840.379841322@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marios Makassikis <mmakassikis@freebox.fr>

commit e416ea62a9166e6075a07a970cc5bf79255d2700 upstream.

Commit 83dcedd5540d ("ksmbd: fix infinite loop in ksmbd_conn_handler_loop()"),
changes GFP modifiers passed to kvmalloc(). This cause xfstests generic/551
test to fail. We limit pdu length size according to connection status and
maximum number of connections. In the rest, memory allocation of request
is limited by credit management. so these flags are no longer needed.

Fixes: 83dcedd5540d ("ksmbd: fix infinite loop in ksmbd_conn_handler_loop()")
Cc: stable@vger.kernel.org
Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -326,10 +326,7 @@ int ksmbd_conn_handler_loop(void *p)
 
 		/* 4 for rfc1002 length field */
 		size = pdu_size + 4;
-		conn->request_buf = kvmalloc(size,
-					     GFP_KERNEL |
-					     __GFP_NOWARN |
-					     __GFP_NORETRY);
+		conn->request_buf = kvmalloc(size, GFP_KERNEL);
 		if (!conn->request_buf)
 			break;
 


