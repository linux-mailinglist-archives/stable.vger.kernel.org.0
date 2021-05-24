Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A9C38EF1C
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbhEXP4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233430AbhEXPzK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6425E610A6;
        Mon, 24 May 2021 15:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870896;
        bh=z/0ZIzRTAXnsmjvowKRG/KFQdJ1tm7t7WH8MCLSYgok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDF8DTnXZpoNRGbIcx596S1QhuMZtTBYI0r6/5A8ib4ACjJYJNfZ+UunzRFTzY30s
         sI4nAR6/xvYvUM6CmdUZ/4ELm0mtZOJeK/k84uqOwsLOcsS9LMyBZXxCfqigLkHk00
         mBd8HKITKiGSlArXWz4QviXzzktNCR3lkvCw7rkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Subject: [PATCH 5.10 083/104] Revert "media: rcar_drif: fix a memory disclosure"
Date:   Mon, 24 May 2021 17:26:18 +0200
Message-Id: <20210524152335.602551401@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
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
@@ -915,7 +915,6 @@ static int rcar_drif_g_fmt_sdr_cap(struc
 {
 	struct rcar_drif_sdr *sdr = video_drvdata(file);
 
-	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	f->fmt.sdr.pixelformat = sdr->fmt->pixelformat;
 	f->fmt.sdr.buffersize = sdr->fmt->buffersize;
 


