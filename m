Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A31FBBA497
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392820AbfIVSuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388840AbfIVSuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:50:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0293B21A4A;
        Sun, 22 Sep 2019 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178212;
        bh=1gu4rf+5VEszUoONBv6+5oClhIK+BZ/7dqRQHE6quhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vy+/X5xMnnK2bZhhctWcojWVNNrrvs3m6QJHBrJnqzyOBFKfSUevzEOGwXgGbI6ey
         zuKm/et+uvpA6uoLZAsbGDWGNgvdDbZwF6vfQpWnkzsX5gOegCBJSKoPWeB9h4TSFZ
         sQ6jwevp1LXW30rIp59+oLwUt4RbO5BHsU1OL/9M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 018/185] media: vivid: work around high stack usage with clang
Date:   Sun, 22 Sep 2019 14:46:36 -0400
Message-Id: <20190922184924.32534-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

