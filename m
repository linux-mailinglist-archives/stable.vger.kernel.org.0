Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B735B6DEF93
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbjDLIwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjDLIwD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:52:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A690793DD
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:51:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B5146315F
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D38AC433EF;
        Wed, 12 Apr 2023 08:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289498;
        bh=KniCw7X4s6beES+ACV7I6uEf+SnCJlfKPEwGe5iWZ3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1KYHcLEM/9I95e1L2HBqvrE6RkDR66xNflVJ50tqnGDCF6Ete8laqSeOtKAnSQ5Yn
         DyG2ySyHblJnof7U0Ul/FI12mF4GB9KFp1kqn2BaWAjpmUt4GlCjZqgxx6I5O6rcED
         lfbz4HsjBsvmtJxFEIRr1pdch1f5OfeXnTMXx0is=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marios Makassikis <mmakassikis@freebox.fr>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 093/173] ksmbd: do not call kvmalloc() with __GFP_NORETRY | __GFP_NO_WARN
Date:   Wed, 12 Apr 2023 10:33:39 +0200
Message-Id: <20230412082841.820299099@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
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
 


