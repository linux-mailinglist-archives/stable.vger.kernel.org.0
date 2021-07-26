Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247F23D61FD
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbhGZPdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231820AbhGZPcL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22FB060F6E;
        Mon, 26 Jul 2021 16:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315928;
        bh=UjJdVjmfQ95kPg5jpNKBT4dkf+FJZ8lE0tZbVs6HlPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xw+q+C2Lou8Ob7zY+0RZfPAHkT7xqplc7QzmNt6xqZ+dzXoEKrO2cXcErg9cyziP3
         uTA+IBco//oxWYpIPnexctUiN82tohBe9vvoVX+WbFnh55OeL2mc/eRzgbh6MyOXcz
         7GC+fQr1/cdtQxABsmtqg91StkM4o4bhlRF30BkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Ekstrand <jason@jlekstrand.net>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 122/223] drm/ttm: Force re-init if ttm_global_init() fails
Date:   Mon, 26 Jul 2021 17:38:34 +0200
Message-Id: <20210726153850.265079510@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Ekstrand <jason@jlekstrand.net>

[ Upstream commit 235c3610d5f02ee91244239b43cd9ae8b4859dff ]

If we have a failure, decrement the reference count so that the next
call to ttm_global_init() will actually do something instead of assume
everything is all set up.

Signed-off-by: Jason Ekstrand <jason@jlekstrand.net>
Fixes: 62b53b37e4b1 ("drm/ttm: use a static ttm_bo_global instance")
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210720181357.2760720-5-jason@jlekstrand.net
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/ttm/ttm_device.c b/drivers/gpu/drm/ttm/ttm_device.c
index 3d9c62b93e29..ef6e0c042bb1 100644
--- a/drivers/gpu/drm/ttm/ttm_device.c
+++ b/drivers/gpu/drm/ttm/ttm_device.c
@@ -100,6 +100,8 @@ static int ttm_global_init(void)
 	debugfs_create_atomic_t("buffer_objects", 0444, ttm_debugfs_root,
 				&glob->bo_count);
 out:
+	if (ret)
+		--ttm_glob_use_count;
 	mutex_unlock(&ttm_global_mutex);
 	return ret;
 }
-- 
2.30.2



