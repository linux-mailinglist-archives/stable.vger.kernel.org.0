Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FD638EEB8
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbhEXPzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233967AbhEXPwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:52:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52BA0613E6;
        Mon, 24 May 2021 15:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870729;
        bh=YcawyIa5JM/v67/x5EWCPn9a+PgZuDJiyGAyh6FWTfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lbn0TxDzkh5pTjtVQh5k8eJ05iAtALxySO4q9tFKCkOnZUOMdeI0hgIu8X2VaIpAU
         S5gq/RGeTbzI3bN1fW/5ZOQ2uaj+t4dn8Am5FHx0padzhsffNVFAExbgNE7iaICZQA
         ZA5dADLKypPNKDEr7oR15J68LnlqrcZkegZX2kgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kangjie Lu <kjlu@umn.edu>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Subject: [PATCH 5.4 54/71] Revert "media: rcar_drif: fix a memory disclosure"
Date:   Mon, 24 May 2021 17:26:00 +0200
Message-Id: <20210524152328.215491912@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152326.447759938@linuxfoundation.org>
References: <20210524152326.447759938@linuxfoundation.org>
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
@@ -911,7 +911,6 @@ static int rcar_drif_g_fmt_sdr_cap(struc
 {
 	struct rcar_drif_sdr *sdr = video_drvdata(file);
 
-	memset(f->fmt.sdr.reserved, 0, sizeof(f->fmt.sdr.reserved));
 	f->fmt.sdr.pixelformat = sdr->fmt->pixelformat;
 	f->fmt.sdr.buffersize = sdr->fmt->buffersize;
 


