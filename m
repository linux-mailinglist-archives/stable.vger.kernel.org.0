Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDC530BFFB
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhBBNrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:47:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232904AbhBBNpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:45:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19E7D64F85;
        Tue,  2 Feb 2021 13:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273269;
        bh=6XzYNaFAg2Dv3QRnWNvsuF8NFhLJvOCLS8ni44TLn3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftsxwKH75HhaJtsb6THCZ/E4guXz22429k+Tmr42EUCQ1rlCjt8/lgkZDdHA+dbRv
         TjUPj6ZKg/JQwjApax6XsMGI7BNF7LqKUIOXE/tOj6NfGICYtZwJwjwiQRppLPh/MV
         8t8sKpko3m9glN8JaBv9Em8htq34rVQ3vWe0raqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Ribalda <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 012/142] media: hantro: Fix reset_raw_fmt initialization
Date:   Tue,  2 Feb 2021 14:36:15 +0100
Message-Id: <20210202132958.208153459@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

commit e081863ab48d9b2eee9e899cbd05752a2a30308d upstream.

raw_fmt->height in never initialized. But width in initialized twice.

Fixes: 88d06362d1d05 ("media: hantro: Refactor for V4L2 API spec compliancy")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/hantro/hantro_v4l2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/media/hantro/hantro_v4l2.c
+++ b/drivers/staging/media/hantro/hantro_v4l2.c
@@ -367,7 +367,7 @@ hantro_reset_raw_fmt(struct hantro_ctx *
 
 	hantro_reset_fmt(raw_fmt, raw_vpu_fmt);
 	raw_fmt->width = encoded_fmt->width;
-	raw_fmt->width = encoded_fmt->width;
+	raw_fmt->height = encoded_fmt->height;
 	if (ctx->is_encoder)
 		hantro_set_fmt_out(ctx, raw_fmt);
 	else


