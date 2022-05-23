Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96252531704
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240424AbiEWRYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241782AbiEWRWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:22:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102717CB08;
        Mon, 23 May 2022 10:19:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90BB8B811FF;
        Mon, 23 May 2022 17:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10CFC385AA;
        Mon, 23 May 2022 17:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326368;
        bh=QQM2k9G4KGPPMRx/b75fnIz+rJxFZTX5YdrkkcEBeSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9FTREnp/Ri/3wfNHCNXLw81Hgjw1kdtb672iPByJKAIFtOgV6EBKnpYgr60W7Q9b
         b2tt1KFK84cJQ427Q8tVElZ7j+uVhfaywAELuvshWp273yPDTVxeMHuUuKD1vjaq+X
         xkovUkC1N+3wUrEdFC3KVqgypDeT8K2JUV2558zI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 5.15 060/132] dma-buf: fix use of DMA_BUF_SET_NAME_{A,B} in userspace
Date:   Mon, 23 May 2022 19:04:29 +0200
Message-Id: <20220523165833.209250206@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

commit 7c3e9fcad9c7d8bb5d69a576044fb16b1d2e8a01 upstream.

The typedefs u32 and u64 are not available in userspace. Thus user get
an error he try to use DMA_BUF_SET_NAME_A or DMA_BUF_SET_NAME_B:

    $ gcc -Wall   -c -MMD -c -o ioctls_list.o ioctls_list.c
    In file included from /usr/include/x86_64-linux-gnu/asm/ioctl.h:1,
                     from /usr/include/linux/ioctl.h:5,
                     from /usr/include/asm-generic/ioctls.h:5,
                     from ioctls_list.c:11:
    ioctls_list.c:463:29: error: ‘u32’ undeclared here (not in a function)
      463 |     { "DMA_BUF_SET_NAME_A", DMA_BUF_SET_NAME_A, -1, -1 }, // linux/dma-buf.h
          |                             ^~~~~~~~~~~~~~~~~~
    ioctls_list.c:464:29: error: ‘u64’ undeclared here (not in a function)
      464 |     { "DMA_BUF_SET_NAME_B", DMA_BUF_SET_NAME_B, -1, -1 }, // linux/dma-buf.h
          |                             ^~~~~~~~~~~~~~~~~~

The issue was initially reported here[1].

[1]: https://github.com/jerome-pouiller/ioctl/pull/14

Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Fixes: a5bff92eaac4 ("dma-buf: Fix SET_NAME ioctl uapi")
CC: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20220517072708.245265-1-Jerome.Pouiller@silabs.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/dma-buf.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/uapi/linux/dma-buf.h
+++ b/include/uapi/linux/dma-buf.h
@@ -92,7 +92,7 @@ struct dma_buf_sync {
  * between them in actual uapi, they're just different numbers.
  */
 #define DMA_BUF_SET_NAME	_IOW(DMA_BUF_BASE, 1, const char *)
-#define DMA_BUF_SET_NAME_A	_IOW(DMA_BUF_BASE, 1, u32)
-#define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, u64)
+#define DMA_BUF_SET_NAME_A	_IOW(DMA_BUF_BASE, 1, __u32)
+#define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, __u64)
 
 #endif


