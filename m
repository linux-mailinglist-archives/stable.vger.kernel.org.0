Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5884A126D91
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfLSShk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:37:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:55414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727860AbfLSShj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:37:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC3B920716;
        Thu, 19 Dec 2019 18:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780659;
        bh=ukK3tZ03T2ojLubsfuqKbVnsJ0LNvG8yLEX+MReaYbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGbruHSQtIMlc7JtiwfrTbgPmJa8Iys90ng+KqAX914QZ0jKLiXozr5eqUCdFJ/ph
         yT26IkkNPP1xJ4gl1BNK5nM5MeAYq0/RaYNTcs7ZshClF0oOoNE5p0sTQlgawo9rKu
         AwQ2ICJYj9ufqy4SSJ9pt87Un9pumTECHO8pkkqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH 4.4 063/162] drm/i810: Prevent underflow in ioctl
Date:   Thu, 19 Dec 2019 19:32:51 +0100
Message-Id: <20191219183211.688422226@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 4f69851fbaa26b155330be35ce8ac393e93e7442 upstream.

The "used" variables here come from the user in the ioctl and it can be
negative.  It could result in an out of bounds write.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20191004102251.GC823@mwanda
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i810/i810_dma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i810/i810_dma.c
+++ b/drivers/gpu/drm/i810/i810_dma.c
@@ -723,7 +723,7 @@ static void i810_dma_dispatch_vertex(str
 	if (nbox > I810_NR_SAREA_CLIPRECTS)
 		nbox = I810_NR_SAREA_CLIPRECTS;
 
-	if (used > 4 * 1024)
+	if (used < 0 || used > 4 * 1024)
 		used = 0;
 
 	if (sarea_priv->dirty)
@@ -1043,7 +1043,7 @@ static void i810_dma_dispatch_mc(struct
 	if (u != I810_BUF_CLIENT)
 		DRM_DEBUG("MC found buffer that isn't mine!\n");
 
-	if (used > 4 * 1024)
+	if (used < 0 || used > 4 * 1024)
 		used = 0;
 
 	sarea_priv->dirty = 0x7f;


