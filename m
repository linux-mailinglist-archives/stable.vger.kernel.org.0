Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B384B4B84
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344327AbiBNKCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:02:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345210AbiBNKB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:01:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75ACC13E33;
        Mon, 14 Feb 2022 01:47:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12E0361252;
        Mon, 14 Feb 2022 09:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD902C340EF;
        Mon, 14 Feb 2022 09:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832053;
        bh=+NBcL0Eq3UCVybOvYfablR+3wu7sDTLFohP96udNTEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tIDt0FKh0O02NDla50BKPZEFj+3lGKZWuiL1LvRiiWDTBQnVW1B2uKjHjKmkcX+K+
         D2iqJi+VAI4/it2Z7C9W7N15ACv4l+wbEqFiqDTJs+lHRe3JDSE56kSjPTzi5aWRoX
         H2pH8uMcEnschqByGXt+J6afllAAvxGsY0qlbiJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/172] net/sunrpc: fix reference count leaks in rpc_sysfs_xprt_state_change
Date:   Mon, 14 Feb 2022 10:24:51 +0100
Message-Id: <20220214092507.542826837@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 776d794f28c95051bc70405a7b1fa40115658a18 ]

The refcount leak issues take place in an error handling path. When the
3rd argument buf doesn't match with "offline", "online" or "remove", the
function simply returns -EINVAL and forgets to decrease the reference
count of a rpc_xprt object and a rpc_xprt_switch object increased by
rpc_sysfs_xprt_kobj_get_xprt() and
rpc_sysfs_xprt_kobj_get_xprt_switch(), causing reference count leaks of
both unused objects.

Fix this issue by jumping to the error handling path labelled with
out_put when buf matches none of "offline", "online" or "remove".

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/sysfs.c b/net/sunrpc/sysfs.c
index 9a6f17e18f73b..379cf0e4d965b 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -291,8 +291,10 @@ static ssize_t rpc_sysfs_xprt_state_change(struct kobject *kobj,
 		online = 1;
 	else if (!strncmp(buf, "remove", 6))
 		remove = 1;
-	else
-		return -EINVAL;
+	else {
+		count = -EINVAL;
+		goto out_put;
+	}
 
 	if (wait_on_bit_lock(&xprt->state, XPRT_LOCKED, TASK_KILLABLE)) {
 		count = -EINTR;
-- 
2.34.1



