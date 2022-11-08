Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A29621560
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbiKHOLP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbiKHOLM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:11:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F6F7721C
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:10:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A61A615B5
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7D8C433D6;
        Tue,  8 Nov 2022 14:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916655;
        bh=vKsjsUd37Zi36AVnvxrSGEcd04fPDqeHOW1Qn+w+h8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IE3Mbzaby4qdjb49oYy5fP98th8ZVjlzulpnNi4WbpHULLHO6R3p7NpLcLdySrvPh
         ioqfZupEsojDLCFmmIpMKXAiXgkwxWYZUZ+eO7obN88TSr29iqiEzRnOPwJ+Cc76O8
         Sz838pzcd6Nr262DOdwvZSnDWAxNTNxtMF5tZ+rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dexuan Cui <decui@microsoft.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        =?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Dalleau?= 
        <frederic.dalleau@docker.com>, Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 062/197] vsock: fix possible infinite sleep in vsock_connectible_wait_data()
Date:   Tue,  8 Nov 2022 14:38:20 +0100
Message-Id: <20221108133357.659437140@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit 466a85336fee6e3b35eb97b8405a28302fd25809 ]

Currently vsock_connectible_has_data() may miss a wakeup operation
between vsock_connectible_has_data() == 0 and the prepare_to_wait().

Fix the race by adding the process to the wait queue before checking
vsock_connectible_has_data().

Fixes: b3f7fd54881b ("af_vsock: separate wait data loop")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reported-by: Frédéric Dalleau <frederic.dalleau@docker.com>
Tested-by: Frédéric Dalleau <frederic.dalleau@docker.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index b4ee163154a6..e5ab2418f9d6 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1894,8 +1894,11 @@ static int vsock_connectible_wait_data(struct sock *sk,
 	err = 0;
 	transport = vsk->transport;
 
-	while ((data = vsock_connectible_has_data(vsk)) == 0) {
+	while (1) {
 		prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
+		data = vsock_connectible_has_data(vsk);
+		if (data != 0)
+			break;
 
 		if (sk->sk_err != 0 ||
 		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
-- 
2.35.1



