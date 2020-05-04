Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823C41C4393
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 19:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730852AbgEDR7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 13:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730846AbgEDR7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:59:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ABC92073E;
        Mon,  4 May 2020 17:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615179;
        bh=WqTx+QF6pJnF3cGIVyBhUyFzTKMpOvQY0boZGNlnp88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsuyYv/NJmli9syymhc+/CQL7p9xoKKktyptFHMpTH2+tevt0hKW5I2WWsOCmkief
         Fl2R0jTVHkwlSCdxjZn9Wq81T8gf3D/MF3zMGJ1eAX22LM+59485P1HBvNAK2yjI1p
         U5zH0nAyWCvwelFCLLQTTYMcnAysPuXyJgnJ1eho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 4.9 04/18] drm/qxl: qxl_release leak in qxl_hw_surface_alloc()
Date:   Mon,  4 May 2020 19:57:14 +0200
Message-Id: <20200504165442.950806007@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165442.028485341@linuxfoundation.org>
References: <20200504165442.028485341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit a65aa9c3676ffccb21361d52fcfedd5b5ff387d7 upstream.

Cc: stable@vger.kernel.org
Fixes: 8002db6336dd ("qxl: convert qxl driver to proper use for reservations")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Link: http://patchwork.freedesktop.org/patch/msgid/2e5a13ae-9ab2-5401-aa4d-03d5f5593423@virtuozzo.com
Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/qxl/qxl_cmd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/qxl/qxl_cmd.c
+++ b/drivers/gpu/drm/qxl/qxl_cmd.c
@@ -500,9 +500,10 @@ int qxl_hw_surface_alloc(struct qxl_devi
 		return ret;
 
 	ret = qxl_release_reserve_list(release, true);
-	if (ret)
+	if (ret) {
+		qxl_release_free(qdev, release);
 		return ret;
-
+	}
 	cmd = (struct qxl_surface_cmd *)qxl_release_map(qdev, release);
 	cmd->type = QXL_SURFACE_CMD_CREATE;
 	cmd->flags = QXL_SURF_FLAG_KEEP_DATA;


