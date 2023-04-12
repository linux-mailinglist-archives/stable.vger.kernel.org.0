Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518A26DEE4A
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjDLIlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjDLIkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:40:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FA276B8
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:39:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 687F3627F2
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8313BC433EF;
        Wed, 12 Apr 2023 08:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288676;
        bh=AF9g+Tb2emYJDaDpciFvV+lM4Gyj5F6neLswzcnGvFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIO2wsk5ZqWG3ViAzFoBFZwbV7A8/jiTwyDBfylGC4XwDGzWPrjCBQwu7LFeQkYJ8
         X9QUjKqT5e1kjdB0KPpV9/TueoW+qAbHzyQ4ArKed2gkIs40jofCCrCIIeu3QIn15w
         pzKQTwX1t4Pv9Cp7z2gV2sSJDfscJMLt7i30WLY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marios Makassikis <mmakassikis@freebox.fr>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 69/93] ksmbd: do not call kvmalloc() with __GFP_NORETRY | __GFP_NO_WARN
Date:   Wed, 12 Apr 2023 10:34:10 +0200
Message-Id: <20230412082826.029542796@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
@@ -320,10 +320,7 @@ int ksmbd_conn_handler_loop(void *p)
 
 		/* 4 for rfc1002 length field */
 		size = pdu_size + 4;
-		conn->request_buf = kvmalloc(size,
-					     GFP_KERNEL |
-					     __GFP_NOWARN |
-					     __GFP_NORETRY);
+		conn->request_buf = kvmalloc(size, GFP_KERNEL);
 		if (!conn->request_buf)
 			break;
 


