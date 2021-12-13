Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152E74729E3
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbhLMK0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236001AbhLMKYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:24:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2018C018B45;
        Mon, 13 Dec 2021 01:59:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EF012CE0F47;
        Mon, 13 Dec 2021 09:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C34AC34606;
        Mon, 13 Dec 2021 09:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389577;
        bh=e8DXmCHcGLP+yxHi53UPPXtXQysZ18VV6Gd1PtdYaVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6Kk5CLIvG3zarHkuLI2XEsNQQEyJMRUKH4GVihyYGJJ9CCEvvjliXL8fS9DpjcgQ
         3BRU/qXr0KS4Kkdm6Z7aeHtSbIdFV4pdg6jo32jM0RZNi5pLG0Jhd5qyi/J3HaYVRT
         n9gT1IA9uABpHDudQScZmAkcswPJypPzcKXbZa7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Subject: [PATCH 5.15 092/171] drm/syncobj: Deal with signalled fences in drm_syncobj_find_fence.
Date:   Mon, 13 Dec 2021 10:30:07 +0100
Message-Id: <20211213092948.145837133@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

commit b19926d4f3a660a8b76e5d989ffd1168e619a5c4 upstream.

dma_fence_chain_find_seqno only ever returns the top fence in the
chain or an unsignalled fence. Hence if we request a seqno that
is already signalled it returns a NULL fence. Some callers are
not prepared to handle this, like the syncobj transfer functions
for example.

This behavior is "new" with timeline syncobj and it looks like
not all callers were updated. To fix this behavior make sure
that a successful drm_sync_find_fence always returns a non-NULL
fence.

v2: Move the fix to drm_syncobj_find_fence from the transfer
    functions.

Fixes: ea569910cbab ("drm/syncobj: add transition iotcls between binary and timeline v2")
Cc: stable@vger.kernel.org
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reviewed-by: Christian König <christian.koenig@amd.com>
Acked-by: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211208023935.17018-1-bas@basnieuwenhuizen.nl
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_syncobj.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -404,8 +404,17 @@ int drm_syncobj_find_fence(struct drm_fi
 
 	if (*fence) {
 		ret = dma_fence_chain_find_seqno(fence, point);
-		if (!ret)
+		if (!ret) {
+			/* If the requested seqno is already signaled
+			 * drm_syncobj_find_fence may return a NULL
+			 * fence. To make sure the recipient gets
+			 * signalled, use a new fence instead.
+			 */
+			if (!*fence)
+				*fence = dma_fence_get_stub();
+
 			goto out;
+		}
 		dma_fence_put(*fence);
 	} else {
 		ret = -EINVAL;


