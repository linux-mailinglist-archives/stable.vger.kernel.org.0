Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FAC59D60B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347742AbiHWJGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348118AbiHWJFs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:05:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD05E85F9E;
        Tue, 23 Aug 2022 01:29:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1932161257;
        Tue, 23 Aug 2022 08:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F624C433D7;
        Tue, 23 Aug 2022 08:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243307;
        bh=/0xUtoBD7lVWZLLkImr4H5x1++n8+L53UF+qUa8F/D0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OnipR9Gdr1LQKXmpZpu90OVVNu0W75NDjtCAw4pHyy1FDVRjaKKIJH5w9ZOB5F1l7
         JIy4Gbx8R7DEQLda8pB4hF7gijDTKDn8TN8YSmgmfIrUGfG86AlFHXbxKpyWlo0DmF
         XByY9sUvBzVSR0CMBcOjJGRkzPw2LdQ14mVwZqr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.19 205/365] net/sunrpc: fix potential memory leaks in rpc_sysfs_xprt_state_change()
Date:   Tue, 23 Aug 2022 10:01:46 +0200
Message-Id: <20220823080126.779775500@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Xin Xiong <xiongx18@fudan.edu.cn>

commit bfc48f1b0505ffcb03a6d749139b7577d6b81ae0 upstream.

The issue happens on some error handling paths. When the function
fails to grab the object `xprt`, it simply returns 0, forgetting to
decrease the reference count of another object `xps`, which is
increased by rpc_sysfs_xprt_kobj_get_xprt_switch(), causing refcount
leaks. Also, the function forgets to check whether `xps` is valid
before using it, which may result in NULL-dereferencing issues.

Fix it by adding proper error handling code when either `xprt` or
`xps` is NULL.

Fixes: 5b7eb78486cd ("SUNRPC: take a xprt offline using sysfs")
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/sysfs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -291,8 +291,10 @@ static ssize_t rpc_sysfs_xprt_state_chan
 	int offline = 0, online = 0, remove = 0;
 	struct rpc_xprt_switch *xps = rpc_sysfs_xprt_kobj_get_xprt_switch(kobj);
 
-	if (!xprt)
-		return 0;
+	if (!xprt || !xps) {
+		count = 0;
+		goto out_put;
+	}
 
 	if (!strncmp(buf, "offline", 7))
 		offline = 1;


