Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5953E1C4406
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731534AbgEDSDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731527AbgEDSDb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:03:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6572B206B8;
        Mon,  4 May 2020 18:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615410;
        bh=5Ba3zmbe26PyiXUYcpJE1N44vRi1Et3FlZoBjwaufCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZS8JV2Mb+rFn1x8K1T2PZtixuNYfUcA1KnkAZ1wW6uPlWu4tzJfR9L9RDBSgoKps
         81O0Woq5tAqGO6h7HBCEaB3REdFjY3wPYe8UG/ZNAEUtiLkGk3BMus9upNqy4EzSQK
         kmxmVrE+EUCioZinZ/7wCy7G11to13ai4rVCJw+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 5.4 04/57] drm/qxl: qxl_release leak in qxl_draw_dirty_fb()
Date:   Mon,  4 May 2020 19:57:08 +0200
Message-Id: <20200504165457.017181982@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
References: <20200504165456.783676004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit 85e9b88af1e6164f19ec71381efd5e2bcfc17620 upstream.

ret should be changed to release allocated struct qxl_release

Cc: stable@vger.kernel.org
Fixes: 8002db6336dd ("qxl: convert qxl driver to proper use for reservations")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Link: http://patchwork.freedesktop.org/patch/msgid/22cfd55f-07c8-95d0-a2f7-191b7153c3d4@virtuozzo.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/qxl/qxl_draw.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/qxl/qxl_draw.c
+++ b/drivers/gpu/drm/qxl/qxl_draw.c
@@ -209,9 +209,10 @@ void qxl_draw_dirty_fb(struct qxl_device
 		goto out_release_backoff;
 
 	rects = drawable_set_clipping(qdev, num_clips, clips_bo);
-	if (!rects)
+	if (!rects) {
+		ret = -EINVAL;
 		goto out_release_backoff;
-
+	}
 	drawable = (struct qxl_drawable *)qxl_release_map(qdev, release);
 
 	drawable->clip.type = SPICE_CLIP_TYPE_RECTS;


