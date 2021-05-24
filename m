Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF20438EE11
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbhEXPp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234167AbhEXPnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:43:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C436D6144E;
        Mon, 24 May 2021 15:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870525;
        bh=MWJ2Zz2Yel3zVBoC8jYfA9RGWuteaSKbd/b/YE8ezTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ko8HZ1PtrtTJWOoyIv3q10zFB6XqnqXOvIcO7D9JB4y3o0h0tH3nqXeNW/MUDALox
         L93dqWpISzgMX6u9fMrI3yYfqp+Tqrr5v40sPQ7em21VpuwcfAlK9FAWfD/N3/vu0N
         3MJhFWtb5SSnmtyTI8Y6wbobQt2RDU6/sUZmXjek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Subject: [PATCH 4.19 35/49] Revert "media: rcar_drif: fix a memory disclosure"
Date:   Mon, 24 May 2021 17:25:46 +0200
Message-Id: <20210524152325.510677822@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.382084875@linuxfoundation.org>
References: <20210524152324.382084875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 3e465fc3846734e9489273d889f19cc17b4cf4bd upstream.

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
Link: https://lore.kernel.org/r/20210503115736.2104747-4-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/rcar_drif.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -912,7 +912,6 @@ static int rcar_drif_g_fmt_sdr_cap(struc
 {
 	struct rcar_drif_sdr *sdr = video_drvdata(file);
 
-	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	f->fmt.sdr.pixelformat = sdr->fmt->pixelformat;
 	f->fmt.sdr.buffersize = sdr->fmt->buffersize;
 


