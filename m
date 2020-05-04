Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415371C43EC
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731376AbgEDSCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731372AbgEDSCp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:02:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C16020721;
        Mon,  4 May 2020 18:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615364;
        bh=N4i6e4VsODP2CW1mwqCEy5GnptRmE9Pa1G3YDTPyGAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EwlF4hdQ2WhT+nZuqQc7NYW+8JqniJEeuMwf5SKAgaJUIwtgwn8UdxTLhiHJK0GXo
         uC8vXdwSIhqBVjLcv5s8OKbbILyEP3auDAnUzeN9IKmzI/V7sYrF8pYnIkdxxzfBTw
         sBjwTOHN8/CNy/TUIIoIIWhbI+KQLKsXGOBehyOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>,
        Chenbo Feng <fengc@google.com>,
        Greg Hackmann <ghackmann@google.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        minchan@kernel.org, surenb@google.com, jenhaochen@google.com,
        Martin Liu <liumartin@google.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 5.4 01/57] dma-buf: Fix SET_NAME ioctl uapi
Date:   Mon,  4 May 2020 19:57:05 +0200
Message-Id: <20200504165456.862815638@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
References: <20200504165456.783676004@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@intel.com>

commit a5bff92eaac45bdf6221badf9505c26792fdf99e upstream.

The uapi is the same on 32 and 64 bit, but the number isn't. Everyone
who botched this please re-read:

https://www.kernel.org/doc/html/v5.4-preprc-cpu/ioctl/botching-up-ioctls.html

Also, the type argument for the ioctl macros is for the type the void
__user *arg pointer points at, which in this case would be the
variable-sized char[] of a 0 terminated string. So this was botched in
more than just the usual ways.

Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Chenbo Feng <fengc@google.com>
Cc: Greg Hackmann <ghackmann@google.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-media@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: minchan@kernel.org
Cc: surenb@google.com
Cc: jenhaochen@google.com
Cc: Martin Liu <liumartin@google.com>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Tested-by: Martin Liu <liumartin@google.com>
Reviewed-by: Martin Liu <liumartin@google.com>
Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
  [sumits: updated some checkpatch fixes, corrected author email]
Link: https://patchwork.freedesktop.org/patch/msgid/20200407133002.3486387-1-daniel.vetter@ffwll.ch
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma-buf/dma-buf.c    |    3 ++-
 include/uapi/linux/dma-buf.h |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -388,7 +388,8 @@ static long dma_buf_ioctl(struct file *f
 
 		return ret;
 
-	case DMA_BUF_SET_NAME:
+	case DMA_BUF_SET_NAME_A:
+	case DMA_BUF_SET_NAME_B:
 		return dma_buf_set_name(dmabuf, (const char __user *)arg);
 
 	default:
--- a/include/uapi/linux/dma-buf.h
+++ b/include/uapi/linux/dma-buf.h
@@ -39,6 +39,12 @@ struct dma_buf_sync {
 
 #define DMA_BUF_BASE		'b'
 #define DMA_BUF_IOCTL_SYNC	_IOW(DMA_BUF_BASE, 0, struct dma_buf_sync)
+
+/* 32/64bitness of this uapi was botched in android, there's no difference
+ * between them in actual uapi, they're just different numbers.
+ */
 #define DMA_BUF_SET_NAME	_IOW(DMA_BUF_BASE, 1, const char *)
+#define DMA_BUF_SET_NAME_A	_IOW(DMA_BUF_BASE, 1, u32)
+#define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, u64)
 
 #endif


