Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F786BB26A
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbjCOMgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbjCOMfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:35:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EFD24BF0
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:34:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3898861D13
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE13C433EF;
        Wed, 15 Mar 2023 12:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883619;
        bh=M+jEZo/G0TdDBpQSFA7NpqpK31M80bqJFkKMAZKjnno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MdnVvSyzSNK4QZdA7cTKnVg9EoEOX+ZeKo4GFHvK+l3qE6ervnwTuZ/GaD1zDLwkH
         6wxE1tkJUBXiDLWHWh1iWrqEZDkEKRQWg/ym63dtE0MCJm3LO23SNdrppUB7Uj1W+x
         EDHWcC3E7atINUSa0khBPYxi2BeoaRTID7ekGSwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaurav Jain <gaurav.jain@nxp.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/143] tls: rx: fix return value for async crypto
Date:   Wed, 15 Mar 2023 13:12:33 +0100
Message-Id: <20230315115742.569483149@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 4d42cd6bc2ac1b9be50ade13771daec90c9d18b1 ]

Gaurav reports that TLS Rx is broken with async crypto
accelerators. The commit under fixes missed updating
the retval byte counting logic when updating how records
are stored. Even tho both before and after the change
'decrypted' was updated inside the main loop, it was
completely overwritten when processing the async
completions. Now that the rx_list only holds
non-zero-copy records we need to add, not overwrite.

Reported-and-bisected-by: Gaurav Jain <gaurav.jain@nxp.com>
Fixes: cbbdee9918a2 ("tls: rx: async: don't put async zc on the list")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217064
Tested-by: Gaurav Jain <gaurav.jain@nxp.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230227181201.1793772-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 38dcd9b401027..992092aeebad9 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2114,7 +2114,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		else
 			err = process_rx_list(ctx, msg, &control, 0,
 					      async_copy_bytes, is_peek);
-		decrypted = max(err, 0);
+		decrypted += max(err, 0);
 	}
 
 	copied += decrypted;
-- 
2.39.2



