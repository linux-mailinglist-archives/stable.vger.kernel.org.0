Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00EC44ABCA8
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386999AbiBGLia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385680AbiBGLcG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:32:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DC9C0401D2;
        Mon,  7 Feb 2022 03:31:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD8A8B811A6;
        Mon,  7 Feb 2022 11:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3824C004E1;
        Mon,  7 Feb 2022 11:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233508;
        bh=n9ts40NzW/gNgiYJSJZjAg4qmKmz5RkYXFbhssIVcNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQ96lTIDG8I5CUJToi1mE5Axn7Ph7YUezwQzkwh/7KoY/14LOKfhFXYPx1S0PkAcF
         WFeAesJCmUVZvXkrCZrFKiUphOWJVXkCY1bdcrV+HplUyOfX6EZQtW7F2Yjbari5zf
         IS23lqYytpfCwmZoYdbTFrrAJpn7Fd6KclrIts4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordy Zomer <jordy@pwning.systems>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 5.16 035/126] dma-buf: heaps: Fix potential spectre v1 gadget
Date:   Mon,  7 Feb 2022 12:06:06 +0100
Message-Id: <20220207103805.354301991@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jordy Zomer <jordy@pwning.systems>

commit 92c4cfaee6872038563c5b6f2e8e613f9d84d47d upstream.

It appears like nr could be a Spectre v1 gadget as it's supplied by a
user and used as an array index. Prevent the contents
of kernel memory from being leaked to userspace via speculative
execution by using array_index_nospec.

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
Fixes: c02a81fba74f ("dma-buf: Add dma-buf heaps framework")
Cc: <stable@vger.kernel.org> # v5.6+
Acked-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
 [sumits: added fixes and cc: stable tags]
Link: https://patchwork.freedesktop.org/patch/msgid/20220129150604.3461652-1-jordy@pwning.systems
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-heap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -14,6 +14,7 @@
 #include <linux/xarray.h>
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <linux/nospec.h>
 #include <linux/uaccess.h>
 #include <linux/syscalls.h>
 #include <linux/dma-heap.h>
@@ -135,6 +136,7 @@ static long dma_heap_ioctl(struct file *
 	if (nr >= ARRAY_SIZE(dma_heap_ioctl_cmds))
 		return -EINVAL;
 
+	nr = array_index_nospec(nr, ARRAY_SIZE(dma_heap_ioctl_cmds));
 	/* Get the kernel ioctl cmd that matches */
 	kcmd = dma_heap_ioctl_cmds[nr];
 


