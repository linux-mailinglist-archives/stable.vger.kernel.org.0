Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6077CAAE7
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389802AbfJCRPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:15:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391032AbfJCQ0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:26:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EA4720700;
        Thu,  3 Oct 2019 16:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119971;
        bh=1gu4rf+5VEszUoONBv6+5oClhIK+BZ/7dqRQHE6quhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4Far0rOJNQMqMpHlfXGOjMAaepn0sYBDtvth+vrg//rvIKt9MGNeJsFmHxpVY3dj
         DVbI1fE/lhCZdv/jSX0yBAtCbs9zQtRRAlfeR53PiYKhGIsPOdjquEBzVGeSkOKLsd
         3xB6gO5Ja1mCMZ+gwMxfCYlxkVJcgYDlQy31ctc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 050/313] media: vivid: work around high stack usage with clang
Date:   Thu,  3 Oct 2019 17:50:28 +0200
Message-Id: <20191003154538.033733798@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 1a03f91c2c2419c3709c4554952c66695575e91c ]

Building a KASAN-enabled kernel with clang ends up in a case where too
much is inlined into vivid_thread_vid_cap() and the stack usage grows
a lot, possibly when the register allocation fails to produce efficient
code and spills a lot of temporaries to the stack. This uses more
than twice the amount of stack than the sum of the individual functions
when they are not inlined:

drivers/media/platform/vivid/vivid-kthread-cap.c:766:12: error: stack frame size of 2208 bytes in function 'vivid_thread_vid_cap' [-Werror,-Wframe-larger-than=]

Marking two of the key functions in here as 'noinline_for_stack' avoids
the pathological case in clang without any apparent downside for gcc.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vivid/vivid-kthread-cap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-kthread-cap.c b/drivers/media/platform/vivid/vivid-kthread-cap.c
index cf6dfecf879f7..96d85cd8839f3 100644
--- a/drivers/media/platform/vivid/vivid-kthread-cap.c
+++ b/drivers/media/platform/vivid/vivid-kthread-cap.c
@@ -232,8 +232,8 @@ static void *plane_vaddr(struct tpg_data *tpg, struct vivid_buffer *buf,
 	return vbuf;
 }
 
-static int vivid_copy_buffer(struct vivid_dev *dev, unsigned p, u8 *vcapbuf,
-		struct vivid_buffer *vid_cap_buf)
+static noinline_for_stack int vivid_copy_buffer(struct vivid_dev *dev, unsigned p,
+		u8 *vcapbuf, struct vivid_buffer *vid_cap_buf)
 {
 	bool blank = dev->must_blank[vid_cap_buf->vb.vb2_buf.index];
 	struct tpg_data *tpg = &dev->tpg;
@@ -672,7 +672,8 @@ static void vivid_cap_update_frame_period(struct vivid_dev *dev)
 	dev->cap_frame_period = f_period;
 }
 
-static void vivid_thread_vid_cap_tick(struct vivid_dev *dev, int dropped_bufs)
+static noinline_for_stack void vivid_thread_vid_cap_tick(struct vivid_dev *dev,
+							 int dropped_bufs)
 {
 	struct vivid_buffer *vid_cap_buf = NULL;
 	struct vivid_buffer *vbi_cap_buf = NULL;
-- 
2.20.1



