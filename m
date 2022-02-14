Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6F34B49D2
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344537AbiBNKJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:09:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345245AbiBNKIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:08:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CF275C37;
        Mon, 14 Feb 2022 01:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E82D2B80DC8;
        Mon, 14 Feb 2022 09:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFE1C340F1;
        Mon, 14 Feb 2022 09:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832211;
        bh=DrjitRWyezSPq3nPLzHzoi5LlKZRoVPa3+u+GnJEjtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKbfPUTAPssvH8gtSAyUTsaSHa9+fshNk/vu37WSifzFYQFK99CvgiNefXtUBLOjE
         Zw/TB+wLXGth7jOIf6Kk215ifJs3O78RrhQq1WGVpaT9etlJQiRv4oXUnLGfzTy9W8
         zB6drm/3hGqzI/KqpHxvCSp1rE4JFaKdWvh31JiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Mathias Krause <minipli@grsecurity.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/172] misc: fastrpc: avoid double fput() on failed usercopy
Date:   Mon, 14 Feb 2022 10:25:55 +0100
Message-Id: <20220214092509.760885873@linuxfoundation.org>
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
index f3002653bd010..86d8fb8c0148b 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1286,7 +1286,14 @@ static int fastrpc_dmabuf_alloc(struct fastrpc_user *fl, char __user *argp)
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



