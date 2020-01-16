Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD4413E062
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgAPQnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:43:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgAPQnQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:43:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE2852073A;
        Thu, 16 Jan 2020 16:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579192996;
        bh=RYT3Thh3tiOU++abROfc/4w/PvMGTw8L9nEx8FuHJ18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WgbuheOAl6EwsEFOsNe8giSV0N+x7+a+uR/xUlnkvfk6LtvuptLQZrjVjH+Y/2rxG
         27f3aMVKoXr/vxt4JyyD/9Y+kHvxAeht7aNXOmpofN7Fv2FJj2cV6QNdqAruMDdngd
         tMbs6WB9cCGLEFBn9RvfKlgZX2XNMG+4/IfIDsm4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Iago Toral Quiroga <itoral@igalia.com>,
        Eric Anholt <eric@anholt.net>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 003/205] drm/v3d: don't leak bin job if v3d_job_init fails.
Date:   Thu, 16 Jan 2020 11:39:38 -0500
Message-Id: <20200116164300.6705-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iago Toral Quiroga <itoral@igalia.com>

[ Upstream commit 0d352a3a8a1f26168d09f7073e61bb4b328e3bb9 ]

If the initialization of the job fails we need to kfree() it
before returning.

Signed-off-by: Iago Toral Quiroga <itoral@igalia.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20190916071125.5255-1-itoral@igalia.com
Fixes: a783a09ee76d ("drm/v3d: Refactor job management.")
Reviewed-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_gem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
index 19c092d75266..6316bf3646af 100644
--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -565,6 +565,7 @@ v3d_submit_cl_ioctl(struct drm_device *dev, void *data,
 		ret = v3d_job_init(v3d, file_priv, &bin->base,
 				   v3d_job_free, args->in_sync_bcl);
 		if (ret) {
+			kfree(bin);
 			v3d_job_put(&render->base);
 			kfree(bin);
 			return ret;
-- 
2.20.1

