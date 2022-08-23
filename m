Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6BE59D8E3
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346082AbiHWJmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352401AbiHWJlS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:41:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED0A9924B;
        Tue, 23 Aug 2022 01:42:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11F1561499;
        Tue, 23 Aug 2022 08:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AF6C433C1;
        Tue, 23 Aug 2022 08:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244124;
        bh=lRHVf0Ye2SVndBwkpQ79h5sgz/Nm8+YXIjTItiCh8lU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zyTn0kcT/8BNETApIVtwYL/25DPimcMpW1dNh3eEWuNLnO7hxWsuJZUXzHxHJuKSd
         0DQsrxZb/djgJNiLe0X2G5tOXxXwfNZU59I/BOIqOTJFz1G8jypO5bWoqhJv9zTJZU
         Bc8VoE/fzqVw5vxHnCqpEhJNj4Ek5D8or6kfUucw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Xianwei <zhang.xianwei8@zte.com.cn>,
        Yi Wang <wang.yi59@zte.com.cn>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.15 040/244] NFSv4.1: RECLAIM_COMPLETE must handle EACCES
Date:   Tue, 23 Aug 2022 10:23:19 +0200
Message-Id: <20220823080100.392951198@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Zhang Xianwei <zhang.xianwei8@zte.com.cn>

commit e35a5e782f67ed76a65ad0f23a484444a95f000f upstream.

A client should be able to handle getting an EACCES error while doing
a mount operation to reclaim state due to NFS4CLNT_RECLAIM_REBOOT
being set. If the server returns RPC_AUTH_BADCRED because authentication
failed when we execute "exportfs -au", then RECLAIM_COMPLETE will go a
wrong way. After mount succeeds, all OPEN call will fail due to an
NFS4ERR_GRACE error being returned. This patch is to fix it by resending
a RPC request.

Signed-off-by: Zhang Xianwei <zhang.xianwei8@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
Fixes: aa5190d0ed7d ("NFSv4: Kill nfs4_async_handle_error() abuses by NFSv4.1")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -9408,6 +9408,9 @@ static int nfs41_reclaim_complete_handle
 		rpc_delay(task, NFS4_POLL_RETRY_MAX);
 		fallthrough;
 	case -NFS4ERR_RETRY_UNCACHED_REP:
+	case -EACCES:
+		dprintk("%s: failed to reclaim complete error %d for server %s, retrying\n",
+			__func__, task->tk_status, clp->cl_hostname);
 		return -EAGAIN;
 	case -NFS4ERR_BADSESSION:
 	case -NFS4ERR_DEADSESSION:


