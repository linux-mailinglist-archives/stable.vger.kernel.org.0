Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33AF1C8F07
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgEGO25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:28:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728329AbgEGO2z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:28:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B38CF20857;
        Thu,  7 May 2020 14:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861735;
        bh=d77HrayXv/zUq1hAABKyDml8cu8MWX+x2DmXs/dulIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1nuMML2NUbxZkabrfk00d3qXuaOGmGtgSj05FNMxZFv20WlhcCMS3wF8uPDuJ5zCj
         V70uQMIBpL8+uUcEEVUX6PowbIjy811bBIeAbcsI9z3RlFETDJcuAdBHCGiwTM+F9W
         vCMzMXAT1RpAz1hTEom4dcnmHryreLYigti3ipA0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@intel.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Chenbo Feng <fengc@google.com>,
        Greg Hackmann <ghackmann@google.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        minchan@kernel.org, surenb@google.com, jenhaochen@google.com,
        Martin Liu <liumartin@google.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 19/35] dma-buf: Fix SET_NAME ioctl uapi
Date:   Thu,  7 May 2020 10:28:13 -0400
Message-Id: <20200507142830.26239-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142830.26239-1-sashal@kernel.org>
References: <20200507142830.26239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@intel.com>

[ Upstream commit a5bff92eaac45bdf6221badf9505c26792fdf99e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-buf.c    | 3 ++-
 include/uapi/linux/dma-buf.h | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 0fb0358f00736..adc88e1dc999a 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -388,7 +388,8 @@ static long dma_buf_ioctl(struct file *file,
 
 		return ret;
 
-	case DMA_BUF_SET_NAME:
+	case DMA_BUF_SET_NAME_A:
+	case DMA_BUF_SET_NAME_B:
 		return dma_buf_set_name(dmabuf, (const char __user *)arg);
 
 	default:
diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
index dbc7092e04b5a..7f30393b92c3b 100644
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
-- 
2.20.1

