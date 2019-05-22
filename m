Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9121026CCF
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733159AbfEVTaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:30:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733173AbfEVTaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:30:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 601E4217D7;
        Wed, 22 May 2019 19:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553411;
        bh=QxLbg+iBDQ7p8auMAtANB0+lL3E39nPvC/YZnTI6xQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+1jc8IvcOjfKUl+SltfrYRUMc2iYFdmQRRilORguKMON70X17NVEnxRCh9NMYk14
         hEcl01TyJ4Yx0/K8QrrSV+XXqVeI3gAzBf+sqh2WcwTfuTrsBz38CDpxViHKnbpWfm
         JLrZehEtWgyw8CYE6QJi7tkJ3U7mKdByTApQEm7o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 059/167] media: coda: clear error return value before picture run
Date:   Wed, 22 May 2019 15:26:54 -0400
Message-Id: <20190522192842.25858-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192842.25858-1-sashal@kernel.org>
References: <20190522192842.25858-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit bbeefa7357a648afe70e7183914c87c3878d528d ]

The error return value is not written by some firmware codecs, such as
MPEG-2 decode on CodaHx4. Clear the error return value before starting
the picture run to avoid misinterpreting unrelated values returned by
sequence initialization as error return value.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-bit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 3457a5f1c8a8e..6eee55430d46a 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1948,6 +1948,9 @@ static int coda_prepare_decode(struct coda_ctx *ctx)
 	/* Clear decode success flag */
 	coda_write(dev, 0, CODA_RET_DEC_PIC_SUCCESS);
 
+	/* Clear error return value */
+	coda_write(dev, 0, CODA_RET_DEC_PIC_ERR_MB);
+
 	trace_coda_dec_pic_run(ctx, meta);
 
 	coda_command_async(ctx, CODA_COMMAND_PIC_RUN);
-- 
2.20.1

