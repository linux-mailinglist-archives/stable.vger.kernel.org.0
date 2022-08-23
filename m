Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8598059DEA9
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352284AbiHWMGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359410AbiHWMDu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:03:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A209CDABB8;
        Tue, 23 Aug 2022 02:37:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8299613CA;
        Tue, 23 Aug 2022 09:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7DFC433D6;
        Tue, 23 Aug 2022 09:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247435;
        bh=qbghJcHm0gVRjNPJv+owcXxInm53demoP6ZbyBNgN08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DoG/ccEIzpgpjQ+uQ5JBjVcidzNxbZfHiw675DfgPvujLiOQo8HS6z0QWjHPXaCfA
         8M7Mj8vK99Q/kY/fOtrXP6Gtg0ohgTfx/mUNEaLH917j/aC0cqeJ2/ytUt/w8nmG1/
         xygImtOKucm4DfN6ZDAbWba+xS4Oma5U8TDoLuXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Aloni <dan.aloni@vastdata.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 034/158] sunrpc: fix expiry of auth creds
Date:   Tue, 23 Aug 2022 10:26:06 +0200
Message-Id: <20220823080047.454420066@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Aloni <dan.aloni@vastdata.com>

commit f1bafa7375c01ff71fb7cb97c06caadfcfe815f3 upstream.

Before this commit, with a large enough LRU of expired items (100), the
loop skipped all the expired items and was entirely ineffectual in
trimming the LRU list.

Fixes: 95cd623250ad ('SUNRPC: Clean up the AUTH cache code')
Signed-off-by: Dan Aloni <dan.aloni@vastdata.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -445,7 +445,7 @@ rpcauth_prune_expired(struct list_head *
 		 * Enforce a 60 second garbage collection moratorium
 		 * Note that the cred_unused list must be time-ordered.
 		 */
-		if (!time_in_range(cred->cr_expire, expired, jiffies))
+		if (time_in_range(cred->cr_expire, expired, jiffies))
 			continue;
 		if (!rpcauth_unhash_cred(cred))
 			continue;


