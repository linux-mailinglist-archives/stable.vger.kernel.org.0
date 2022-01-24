Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B420499F8D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1841550AbiAXW7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588120AbiAXWbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:31:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4D0C02B86A;
        Mon, 24 Jan 2022 12:56:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95EE3B81057;
        Mon, 24 Jan 2022 20:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F31AC340E5;
        Mon, 24 Jan 2022 20:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057770;
        bh=N7iqN2dtcEyo4qkf5F6uhGxw3W2pDTN7WGAfMlTzNYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrqhCDvN3D6GkybQ/t4A0pjuPiwZNT4EQoSLlWhpdVesneLqn/fGx+uKxvTrX+wak
         b4osQ9NHnty/dpTYVGsN32BXVcgjT7s+XzkBFGzyI6cpdEdbDpE/eUIwDpQ2gWm4Yn
         7rbPu1Emv18NKdo3Hnoa+7vcKerJCyQ59CD4oHLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 5.16 0073/1039] dma_fence_array: Fix PENDING_ERROR leak in dma_fence_array_signaled()
Date:   Mon, 24 Jan 2022 19:31:02 +0100
Message-Id: <20220124184127.628739269@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit 95d35838880fb040ccb9fe4a48816bd0c8b62df5 upstream.

If a dma_fence_array is reported signaled by a call to
dma_fence_is_signaled(), it may leak the PENDING_ERROR status.

Fix this by clearing the PENDING_ERROR status if we return true in
dma_fence_array_signaled().

v2:
- Update Cc list, and add R-b.

Fixes: 1f70b8b812f3 ("dma-fence: Propagate errors to dma-fence-array container")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Christian König <christian.koenig@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211129152727.448908-1-thomas.hellstrom@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-fence-array.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/dma-buf/dma-fence-array.c
+++ b/drivers/dma-buf/dma-fence-array.c
@@ -104,7 +104,11 @@ static bool dma_fence_array_signaled(str
 {
 	struct dma_fence_array *array = to_dma_fence_array(fence);
 
-	return atomic_read(&array->num_pending) <= 0;
+	if (atomic_read(&array->num_pending) > 0)
+		return false;
+
+	dma_fence_array_clear_pending_error(array);
+	return true;
 }
 
 static void dma_fence_array_release(struct dma_fence *fence)


