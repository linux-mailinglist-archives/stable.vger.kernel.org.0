Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA96681311
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237601AbjA3O2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237653AbjA3O1o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:27:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282BAEF8B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:26:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A42E60CEE
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13ADC433EF;
        Mon, 30 Jan 2023 14:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088766;
        bh=C4+1NCGshatBTcXabSWAElGtsT0hVdZRKnXYKE57Q4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrInmdvDy8AYrCysTuQldpp3Ea04D1eQstW5tr5xFgBZCii2mHOwEfXHYHpnj06PJ
         fI8SZNzinbco+S4tAhDjCMIEOZ5rKNpRw3twjp/NEpjgOfC1pvk5G9yUwvVEZ8g8x2
         c+EDiE13JzXMFV9lIjjsB7+RAAgPWC3pFt6NO3S8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/143] sctp: fail if no bound addresses can be used for a given scope
Date:   Mon, 30 Jan 2023 14:53:06 +0100
Message-Id: <20230130134312.163295634@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

[ Upstream commit 458e279f861d3f61796894cd158b780765a1569f ]

Currently, if you bind the socket to something like:
        servaddr.sin6_family = AF_INET6;
        servaddr.sin6_port = htons(0);
        servaddr.sin6_scope_id = 0;
        inet_pton(AF_INET6, "::1", &servaddr.sin6_addr);

And then request a connect to:
        connaddr.sin6_family = AF_INET6;
        connaddr.sin6_port = htons(20000);
        connaddr.sin6_scope_id = if_nametoindex("lo");
        inet_pton(AF_INET6, "fe88::1", &connaddr.sin6_addr);

What the stack does is:
 - bind the socket
 - create a new asoc
 - to handle the connect
   - copy the addresses that can be used for the given scope
   - try to connect

But the copy returns 0 addresses, and the effect is that it ends up
trying to connect as if the socket wasn't bound, which is not the
desired behavior. This unexpected behavior also allows KASLR leaks
through SCTP diag interface.

The fix here then is, if when trying to copy the addresses that can
be used for the scope used in connect() it returns 0 addresses, bail
out. This is what TCP does with a similar reproducer.

Reported-by: Pietro Borrello <borrello@diag.uniroma1.it>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/9fcd182f1099f86c6661f3717f63712ddd1c676c.1674496737.git.marcelo.leitner@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/bind_addr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index 59e653b528b1..6b95d3ba8fe1 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -73,6 +73,12 @@ int sctp_bind_addr_copy(struct net *net, struct sctp_bind_addr *dest,
 		}
 	}
 
+	/* If somehow no addresses were found that can be used with this
+	 * scope, it's an error.
+	 */
+	if (list_empty(&dest->address_list))
+		error = -ENETUNREACH;
+
 out:
 	if (error)
 		sctp_bind_addr_clean(dest);
-- 
2.39.0



