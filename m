Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BCC1C43B1
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbgEDSAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731030AbgEDSAl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:00:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A69E5206B8;
        Mon,  4 May 2020 18:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615241;
        bh=wRkYzBLk0vUVQRuUS+lFzvR6kc1EqVlOI6UkZWW2SN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tNrjxHt3aOkSS6CqgXI4nyIAXhESpGjKI9IPNl4/RxV5lE2IwQiTCCArqXiWlZ6Cp
         7Fh2kJ76sxKG8XXszIFm/LeAxQdzVU+dggzojBMPzpav4xuGiwgQXqtiqeEhPD79UW
         aF4btDvkryIHPDvV8wNsEFz0nJGN0Y1vWUzvZWMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 4.14 03/26] drm/qxl: qxl_release leak in qxl_draw_dirty_fb()
Date:   Mon,  4 May 2020 19:57:17 +0200
Message-Id: <20200504165443.279359748@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165442.494398840@linuxfoundation.org>
References: <20200504165442.494398840@linuxfoundation.org>
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
@@ -348,9 +348,10 @@ void qxl_draw_dirty_fb(struct qxl_device
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


