Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374364B4A21
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348172AbiBNKeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:34:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348221AbiBNKeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:34:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2898C35;
        Mon, 14 Feb 2022 02:00:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 526CE60B31;
        Mon, 14 Feb 2022 10:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9E4C340E9;
        Mon, 14 Feb 2022 10:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832852;
        bh=jfzU5AWgx9K/8cbFWPb2BdzFgFXH/WxAhtisdz6hsjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qUob6VHXs1PgOwrDOG9sNh2Jr7Ad7gwpUgtOK2ftA9+cjVjfoAvRJ7QCp+YvyiFF7
         OQL554AJ5JhXxa9dHlQDG0N43QFGyCbrUsxPK3RqQ5FYPwbVEWWnVb2vWdnNtlLAfj
         9I6mvW12mq/07YcdybLUOmKhtz9eWrxHtq0NgW3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Mathias Krause <minipli@grsecurity.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 114/203] misc: fastrpc: avoid double fput() on failed usercopy
Date:   Mon, 14 Feb 2022 10:25:58 +0100
Message-Id: <20220214092514.126632526@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
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

From: Mathias Krause <minipli@grsecurity.net>

[ Upstream commit 46963e2e0629cb31c96b1d47ddd89dc3d8990b34 ]

If the copy back to userland fails for the FASTRPC_IOCTL_ALLOC_DMA_BUFF
ioctl(), we shouldn't assume that 'buf->dmabuf' is still valid. In fact,
dma_buf_fd() called fd_install() before, i.e. "consumed" one reference,
leaving us with none.

Calling dma_buf_put() will therefore put a reference we no longer own,
leading to a valid file descritor table entry for an already released
'file' object which is a straight use-after-free.

Simply avoid calling dma_buf_put() and rely on the process exit code to
do the necessary cleanup, if needed, i.e. if the file descriptor is
still valid.

Fixes: 6cffd79504ce ("misc: fastrpc: Add support for dmabuf exporter")
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Link: https://lore.kernel.org/r/20220127130218.809261-1-minipli@grsecurity.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/fastrpc.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 4ccbf43e6bfa9..aa1682b94a23b 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1288,7 +1288,14 @@ static int fastrpc_dmabuf_alloc(struct fastrpc_user *fl, char __user *argp)
 	}
 
 	if (copy_to_user(argp, &bp, sizeof(bp))) {
-		dma_buf_put(buf->dmabuf);
+		/*
+		 * The usercopy failed, but we can't do much about it, as
+		 * dma_buf_fd() already called fd_install() and made the
+		 * file descriptor accessible for the current process. It
+		 * might already be closed and dmabuf no longer valid when
+		 * we reach this point. Therefore "leak" the fd and rely on
+		 * the process exit path to do any required cleanup.
+		 */
 		return -EFAULT;
 	}
 
-- 
2.34.1



