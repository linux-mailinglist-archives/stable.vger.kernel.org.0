Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED4F44A0D4
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbhKIBFl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:05:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237836AbhKIBEU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:04:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7035D61989;
        Tue,  9 Nov 2021 01:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419690;
        bh=TOjlPrRJfj9axhzhp0RKU2dhlU5V9dASr+ThzNajcqA=;
        h=From:To:Cc:Subject:Date:From;
        b=GZtDjNuLYIZCeFDOMvhR+zDaOEd89Zvg1+3U3F1UkGwi70be5rk5wx46le9pfP3US
         LXLrtIc26wOfLC+UoQN5WeKJO8K/LFnBb5chA9uHC1wxxUBJnVH1l5MueTzYxkxEeb
         mqoBpnCW2voXMVBOcVP0xR69jFjE3lMFpi94lSf0bOIOm1s+40X+NpR50v5Cojox5z
         1PGhPyssyEdN1FC5xbK7/DDcOh6UMjWXzIB4dIReojP+7oFDzSTtiXxHX9UnZl3Nl5
         7LB6ZLjH2MUd3xFzSPHWmbOyl5Zod03xG6ayUYgxK3H8sJYWv9D/LO5vxhjIz2CWZV
         zHf2/vDDbPaUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charan Teja Reddy <charante@codeaurora.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>, sumit.semwal@linaro.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH AUTOSEL 5.14 001/138] dma-buf: WARN on dmabuf release with pending attachments
Date:   Mon,  8 Nov 2021 12:44:27 -0500
Message-Id: <20211108174644.1187889-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charan Teja Reddy <charante@codeaurora.org>

[ Upstream commit f492283b157053e9555787262f058ae33096f568 ]

It is expected from the clients to follow the below steps on an imported
dmabuf fd:
a) dmabuf = dma_buf_get(fd) // Get the dmabuf from fd
b) dma_buf_attach(dmabuf); // Clients attach to the dmabuf
   o Here the kernel does some slab allocations, say for
dma_buf_attachment and may be some other slab allocation in the
dmabuf->ops->attach().
c) Client may need to do dma_buf_map_attachment().
d) Accordingly dma_buf_unmap_attachment() should be called.
e) dma_buf_detach () // Clients detach to the dmabuf.
   o Here the slab allocations made in b) are freed.
f) dma_buf_put(dmabuf) // Can free the dmabuf if it is the last
reference.

Now say an erroneous client failed at step c) above thus it directly
called dma_buf_put(), step f) above. Considering that it may be the last
reference to the dmabuf, buffer will be freed with pending attachments
left to the dmabuf which can show up as the 'memory leak'. This should
at least be reported as the WARN().

Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1627043468-16381-1-git-send-email-charante@codeaurora.org
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-buf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 511fe0d217a08..733c8b1c8467c 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -79,6 +79,7 @@ static void dma_buf_release(struct dentry *dentry)
 	if (dmabuf->resv == (struct dma_resv *)&dmabuf[1])
 		dma_resv_fini(dmabuf->resv);
 
+	WARN_ON(!list_empty(&dmabuf->attachments));
 	module_put(dmabuf->owner);
 	kfree(dmabuf->name);
 	kfree(dmabuf);
-- 
2.33.0

