Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5923463539A
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 09:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236767AbiKWI5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236780AbiKWI45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:56:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BEBFDDB0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:56:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 901C0B81EEE
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB90AC433D7;
        Wed, 23 Nov 2022 08:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193813;
        bh=Ae8EYFn2Me9WGxC8wMAvFS4+yGKTqzB+QiZmXtJq9vI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghNgm3QMg+7tgCuIiglj9nKmLho+Jumt9PhynvbR0T/8DVZrA6kAqPU19VO1KiJru
         UZpqGKoqgUEzPhXptYJgH4qmN8T1ujBbi505ipWQg107sBTXqJ0XJfOUcU0aQiwYM4
         66s0nNP98azHBFLxAFdyLBVqpkmROVtJHDeBz684=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+50f7e8d06c3768dd97f3@syzkaller.appspotmail.com,
        Dominique Martinet <asmadeus@codewreck.org>,
        Schspa Shi <schspa@gmail.com>
Subject: [PATCH 4.9 69/76] 9p: trans_fd/p9_conn_cancel: drop client lock earlier
Date:   Wed, 23 Nov 2022 09:51:08 +0100
Message-Id: <20221123084549.005072250@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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

From: Dominique Martinet <asmadeus@codewreck.org>

commit 52f1c45dde9136f964d63a77d19826c8a74e2c7f upstream.

syzbot reported a double-lock here and we no longer need this
lock after requests have been moved off to local list:
just drop the lock earlier.

Link: https://lkml.kernel.org/r/20220904064028.1305220-1-asmadeus@codewreck.org
Reported-by: syzbot+50f7e8d06c3768dd97f3@syzkaller.appspotmail.com
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Tested-by: Schspa Shi <schspa@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/trans_fd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -215,6 +215,8 @@ static void p9_conn_cancel(struct p9_con
 		list_move(&req->req_list, &cancel_list);
 	}
 
+	spin_unlock(&m->client->lock);
+
 	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
 		p9_debug(P9_DEBUG_ERROR, "call back req %p\n", req);
 		list_del(&req->req_list);
@@ -222,7 +224,6 @@ static void p9_conn_cancel(struct p9_con
 			req->t_err = err;
 		p9_client_cb(m->client, req, REQ_STATUS_ERROR);
 	}
-	spin_unlock(&m->client->lock);
 }
 
 static int


