Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D1337FAB7
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbhEMPcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:40990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhEMPcL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:32:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D252613BF;
        Thu, 13 May 2021 15:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620919862;
        bh=8ZFQvXar/GDmDnRIMrm5GaxSZm+CptKZfsUq0u+uWUU=;
        h=Subject:To:From:Date:From;
        b=HZ/qi7yWhxrepLiRlnFXwicT3scDSVuz6iktD830p9xHwxW6+iGF9s9o0NgF3VdPm
         mG8H9yNxEpuBx5P7H/dsBtJK3mbS7fbxm1gpgD8bpp0jRogRXAbRNIUR+nMiEE7T33
         H/k2pzebf3FDHe/IMaCEVDGnB/gy8Yay+31KdpoE=
Subject: patch "Revert "media: rcar_drif: fix a memory disclosure"" added to char-misc-linus
To:     gregkh@linuxfoundation.org, fabrizio.castro.jz@renesas.com,
        geert+renesas@glider.be, hverkuil-cisco@xs4all.nl, kjlu@umn.edu,
        mchehab+huawei@kernel.org, mchehab@kernel.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:31:00 +0200
Message-ID: <162091986037139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "media: rcar_drif: fix a memory disclosure"

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3e465fc3846734e9489273d889f19cc17b4cf4bd Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 3 May 2021 13:56:30 +0200
Subject: Revert "media: rcar_drif: fix a memory disclosure"

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


