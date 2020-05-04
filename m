Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED821C4376
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 19:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730206AbgEDR6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 13:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730118AbgEDR6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 13:58:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0794C20721;
        Mon,  4 May 2020 17:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615116;
        bh=WqTx+QF6pJnF3cGIVyBhUyFzTKMpOvQY0boZGNlnp88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ClHwcsIlMmZUAMITtwWpOw++je7wM2N9Oj2MNSUU2K5aZpL+rclbCkj8AJT9eq0n5
         EZH3oekKT0tWyhKvxQ8sHpCyJidS/ADwYz9h7WtNhr0jLtkT60JiRhLM4V+ykTY1XM
         wQ4GxfvM4Q6B/UoVYlMJDS0hriAM/FqP/FuEI3pg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 4.4 02/18] drm/qxl: qxl_release leak in qxl_hw_surface_alloc()
Date:   Mon,  4 May 2020 19:57:00 +0200
Message-Id: <20200504165442.104569991@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165441.533160703@linuxfoundation.org>
References: <20200504165441.533160703@linuxfoundation.org>
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


