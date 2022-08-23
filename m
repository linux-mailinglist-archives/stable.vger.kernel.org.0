Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4421A59E021
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358615AbiHWLw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358190AbiHWLtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:49:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E7C92F64;
        Tue, 23 Aug 2022 02:31:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00A03B81C85;
        Tue, 23 Aug 2022 09:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666F6C433D7;
        Tue, 23 Aug 2022 09:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247064;
        bh=tw20pXa+9aPH9hPJaqwcFL8AznpKL7tAVxhOZnoPxz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FCwfHYr0LPqXSnIH5GzSxnTDh+qXBvpnNpPkN8JekU/9isGVdPvqp4ECdQDloVsLM
         Gg0cE4G4ag/xblbpZlajl2DUMpJiULXQr2owDzvoCsfksIYiPe8Lxn7V/Xdu0VI2c9
         RNsvDwekCf4sQMM0wwE35PPc/U+44B4JDVVWSlxE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Aloni <dan.aloni@vastdata.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 308/389] sunrpc: fix expiry of auth creds
Date:   Tue, 23 Aug 2022 10:26:26 +0200
Message-Id: <20220823080128.444859208@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
@@ -494,7 +494,7 @@ rpcauth_prune_expired(struct list_head *
 		 * Enforce a 60 second garbage collection moratorium
 		 * Note that the cred_unused list must be time-ordered.
 		 */
-		if (!time_in_range(cred->cr_expire, expired, jiffies))
+		if (time_in_range(cred->cr_expire, expired, jiffies))
 			continue;
 		if (!rpcauth_unhash_cred(cred))
 			continue;


