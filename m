Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B95E499F9B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1841783AbiAXXAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382505AbiAXWdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:33:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9C3C0E532B;
        Mon, 24 Jan 2022 12:57:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38244B8105C;
        Mon, 24 Jan 2022 20:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17E2C340E5;
        Mon, 24 Jan 2022 20:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057866;
        bh=tctGHt42q3Mwwq0FN9H+8T4NxW6LUpLsKjo4CgiWmo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P0cHeLOL9nKLMxNEc4ENDo1QUO1Kbp7rzOke5h0MGj8hxmvDwp/lyrGjJQtAU5cfi
         FAxoEQCS8bnZng2JtNABD0FiD7nRqt1yrnRygR/44+jQvnNjnw5+Ob+JalZLCqzzvC
         Pt1zUu5/30hSJbJ7EOjaOn34s1OX6pCijZqqikZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0104/1039] drm/virtio: fix another potential integer overflow on shift of a int
Date:   Mon, 24 Jan 2022 19:31:33 +0100
Message-Id: <20220124184128.650978883@linuxfoundation.org>
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

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 74c1bda2f3fa79a93e1c910008649b49b02dc09d ]

The left shift of unsigned int 32 bit integer constant 1 is evaluated
using 32 bit arithmetic and then assigned to a signed 64 bit integer.
In the case where value is 32 or more this can lead to an overflow
(value can be in range 0..MAX_CAPSET_ID (63). Fix this by shifting
the value 1ULL instead.

Addresses-Coverity: ("Uninitentional integer overflow")
Fixes: 4fb530e5caf7 ("drm/virtio: implement context init: support init ioctl")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210930102748.16922-1-colin.king@canonical.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/virtio/virtgpu_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index 5e8103a197a96..c708bab555c6b 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -774,7 +774,7 @@ static int virtio_gpu_context_init_ioctl(struct drm_device *dev,
 				goto out_unlock;
 			}
 
-			if ((vgdev->capset_id_mask & (1 << value)) == 0) {
+			if ((vgdev->capset_id_mask & (1ULL << value)) == 0) {
 				ret = -EINVAL;
 				goto out_unlock;
 			}
-- 
2.34.1



