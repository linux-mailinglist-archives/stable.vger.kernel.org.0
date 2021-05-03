Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A543714A7
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 14:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhECL7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 07:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233353AbhECL7s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 07:59:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C54B36121D;
        Mon,  3 May 2021 11:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620043135;
        bh=NoTJ2dDv/dnZ5GRln63k7sv1ipMxuv8TWhW4jn1pHdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btt/7h+9MEsrAgixegmXx6lzyoH+gzMlcmaQ7Gzjx5eJg+3juH5NT5Q4n6lmSc9xe
         ePCeCPbw4jtsr69DJDEnDEOISN85O+7J9L9HhNHo2bYLZaD5u/XyG1yA0TXEixtc+N
         vsC697IVcr3Y4XIjbHfJqJaGN1NDSxTSLREInLKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kangjie Lu <kjlu@umn.edu>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        stable <stable@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Subject: [PATCH 03/69] Revert "media: rcar_drif: fix a memory disclosure"
Date:   Mon,  3 May 2021 13:56:30 +0200
Message-Id: <20210503115736.2104747-4-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit d39083234c60519724c6ed59509a2129fd2aed41.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, it was determined that this commit is not needed at all as
the media core already prevents memory disclosure on this codepath, so
just drop the extra memset happening here.

Cc: Kangjie Lu <kjlu@umn.edu>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Fixes: d39083234c60 ("media: rcar_drif: fix a memory disclosure")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reviewed-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/rcar_drif.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index 83bd9a412a56..1e3b68a8743a 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -915,7 +915,6 @@ static int rcar_drif_g_fmt_sdr_cap(struct file *file, void *priv,
 {
 	struct rcar_drif_sdr *sdr = video_drvdata(file);
 
-	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	f->fmt.sdr.pixelformat = sdr->fmt->pixelformat;
 	f->fmt.sdr.buffersize = sdr->fmt->buffersize;
 
-- 
2.31.1

