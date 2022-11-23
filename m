Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF44B635657
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237686AbiKWJ33 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237619AbiKWJ3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:29:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F620D100
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:27:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEBE661B40
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF30C433D6;
        Wed, 23 Nov 2022 09:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195638;
        bh=yYhp8Hn/124hrHXNT+nRAm36mEF9eGnbHttfrnpJ3Ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daVp4CrDMf41Og7Ok+WUia/lO9w0A/RKZROzQmiWsqzbZFcUBZLeCmXOXjCel8NMB
         XdMWpnY8VK3wJmYSm1kSkS8w58B9LV40biI3w6V3gvNfVFifsJolYvZFnXqEHX0PfE
         uc8E1PVnl9UkmGon29wmGJj8HPDd+2Qhkym9PWzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+50f7e8d06c3768dd97f3@syzkaller.appspotmail.com,
        Dominique Martinet <asmadeus@codewreck.org>,
        Schspa Shi <schspa@gmail.com>
Subject: [PATCH 5.10 142/149] 9p: trans_fd/p9_conn_cancel: drop client lock earlier
Date:   Wed, 23 Nov 2022 09:52:05 +0100
Message-Id: <20221123084603.032987856@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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
@@ -205,6 +205,8 @@ static void p9_conn_cancel(struct p9_con
 		list_move(&req->req_list, &cancel_list);
 	}
 
+	spin_unlock(&m->client->lock);
+
 	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
 		p9_debug(P9_DEBUG_ERROR, "call back req %p\n", req);
 		list_del(&req->req_list);
@@ -212,7 +214,6 @@ static void p9_conn_cancel(struct p9_con
 			req->t_err = err;
 		p9_client_cb(m->client, req, REQ_STATUS_ERROR);
 	}
-	spin_unlock(&m->client->lock);
 }
 
 static __poll_t


