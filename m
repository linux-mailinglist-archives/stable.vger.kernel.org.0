Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273EE499218
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381001AbiAXURZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:17:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37400 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354908AbiAXUNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:13:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DCF061371;
        Mon, 24 Jan 2022 20:13:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62ACCC340E5;
        Mon, 24 Jan 2022 20:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055184;
        bh=N7iqN2dtcEyo4qkf5F6uhGxw3W2pDTN7WGAfMlTzNYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iULFF34YQwaikxFUcgZWyy9upVa3ofcLkCM8+0bq4ureXg4fyCXamg+COgOz4Gdpo
         x+dr54QSUuwGlaU87vWDX6iV3qJv7/5m38u5RLQh4z9Wrb6Qj2sxkRrsFyoqKsLMya
         D1p6EH04a2ZYlao0OiNOTwEbQBfkUjeVH7Z4O8Tg=
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
Subject: [PATCH 5.15 068/846] dma_fence_array: Fix PENDING_ERROR leak in dma_fence_array_signaled()
Date:   Mon, 24 Jan 2022 19:33:05 +0100
Message-Id: <20220124184103.321401854@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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


