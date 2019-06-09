Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 281AF3A9AB
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbfFIQ7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:59:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732775AbfFIQ67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:58:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9B84207E0;
        Sun,  9 Jun 2019 16:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099538;
        bh=8a0EsAMS8bFTkPkp4ApwbHUXiaDh5qCTKRyWLlGhSpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUzJifvGJPrfTkZVXysOCJLLOPf8HFve1U8UFlxuRjAljbvnr5lR6rrsT2vgY2Lnv
         ENZ21TKFlca8I5DljhaHGqN0Ta0XPU+ACf85YzVTwmP0UqJwmGzDpBY0YG19//UxtM
         gSCCtXXhIFzPM0v3n0NDMyRLOzU7M6iGBcI+eIvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Yifeng Li <tomli@tomli.me>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 4.4 075/241] fbdev: sm712fb: fix memory frequency by avoiding a switch/case fallthrough
Date:   Sun,  9 Jun 2019 18:40:17 +0200
Message-Id: <20190609164149.936716585@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifeng Li <tomli@tomli.me>

commit 9dc20113988b9a75ea6b3abd68dc45e2d73ccdab upstream.

A fallthrough in switch/case was introduced in f627caf55b8e ("fbdev:
sm712fb: fix crashes and garbled display during DPMS modesetting"),
due to my copy-paste error, which would cause the memory clock frequency
for SM720 to be programmed to SM712.

Since it only reprograms the clock to a different frequency, it's only
a benign issue without visible side-effect, so it also evaded Sudip
Mukherjee's code review and regression tests. scripts/checkpatch.pl
also failed to discover the issue, possibly due to nested switch
statements.

This issue was found by Stephen Rothwell by building linux-next with
-Wimplicit-fallthrough.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: f627caf55b8e ("fbdev: sm712fb: fix crashes and garbled display during DPMS modesetting")
Signed-off-by: Yifeng Li <tomli@tomli.me>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/fbdev/sm712fb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/sm712fb.c
+++ b/drivers/video/fbdev/sm712fb.c
@@ -898,6 +898,7 @@ static int smtc_blank(int blank_mode, st
 		case 0x712:
 			smtc_seqw(0x6a, 0x16);
 			smtc_seqw(0x6b, 0x02);
+			break;
 		case 0x720:
 			smtc_seqw(0x6a, 0x0d);
 			smtc_seqw(0x6b, 0x02);


