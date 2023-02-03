Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D720C6896DD
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbjBCKda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbjBCKcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:32:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371A2A2A7A
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:31:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9FA9B82A65
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0359DC433D2;
        Fri,  3 Feb 2023 10:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420262;
        bh=AmwcGoV8S7L3k3AVkPr9Ntqo/duMqIbcawy4sxKHzug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l9ma5fchtJLkwUFnUT+OF+Gtn2Bqgyu5lo6I1ZF+U2nXOuTjCoAW41SJZxRNTeLeY
         g36vw35H/Szm7XDKKriBHEgnTX81keeDa8PmSdh/W+n7XD5LwMNSUwb8tyoJcpyxYI
         OPONQXNpunJbRukjSbZxu55cm5rH3m5Pfv9aVVIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 134/134] Revert "xprtrdma: Fix regbuf data not freed in rpcrdma_req_create()"
Date:   Fri,  3 Feb 2023 11:13:59 +0100
Message-Id: <20230203101029.850099165@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit bcebcb11fcbc744de1add88601c51cca8b4e762c which is
commit 9181f40fb2952fd59ecb75e7158620c9c669eee3 upstream.

The backport to 5.4.y causes problems, as reported by Harshit, so revert
it for now and wait for a working backport to be added.

Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/4d2928e1-c836-b817-3dc2-3fe9adcaf2d6@oracle.com
Cc: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtrdma/verbs.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1037,7 +1037,6 @@ out4:
 	kfree(req->rl_sendbuf);
 out3:
 	kfree(req->rl_rdmabuf);
-	rpcrdma_regbuf_free(req->rl_sendbuf);
 out2:
 	kfree(req);
 out1:


