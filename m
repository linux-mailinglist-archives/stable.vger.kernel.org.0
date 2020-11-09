Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2302ABB14
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732681AbgKINYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:24:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732846AbgKINTe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:19:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F129B2083B;
        Mon,  9 Nov 2020 13:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927973;
        bh=Y6uXY5C00WL5m4QLuoLJfu/7E8rvKuQY0cP45TjdG80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbfEvkazZ0ITKWZYbo8FzPft6de1kTZ/RSwt1ooaQhTmzQ2TxhohvHsexuL0EWhG/
         SADMAdzHXFq4FAGb7aeElhRZgab6/Lf3/JwIFHKd0OLSh010m3y4R9ij7OqJUfA3J6
         tRF6M5rqvthq60Eg0yYiMkjiqChfAo0AmhBj1R90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 084/133] drm/v3d: Fix double free in v3d_submit_cl_ioctl()
Date:   Mon,  9 Nov 2020 13:55:46 +0100
Message-Id: <20201109125034.760072033@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 897dbea6b716c0f2c5bcd4ba1eb4d809caba290c ]

Originally this error path used to leak "bin" but then we accidentally
applied two separate commits to fix it and ended up with a double free.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20201026094905.GA1634423@mwanda
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_gem.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
index 915f8bfdb58ca..182c586525eb8 100644
--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -568,7 +568,6 @@ v3d_submit_cl_ioctl(struct drm_device *dev, void *data,
 		ret = v3d_job_init(v3d, file_priv, &bin->base,
 				   v3d_job_free, args->in_sync_bcl);
 		if (ret) {
-			kfree(bin);
 			v3d_job_put(&render->base);
 			kfree(bin);
 			return ret;
-- 
2.27.0



