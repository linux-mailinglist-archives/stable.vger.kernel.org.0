Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A204F2A5772
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731442AbgKCUy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:54:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:53282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732567AbgKCUyU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:54:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F765223BD;
        Tue,  3 Nov 2020 20:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436860;
        bh=PKXvgJAXqK8j6bX7Dlte8tO2NmsT5qMcDgFiPVCEyCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMgOSlGXaNomCioEtUIWd93Id9tRBlsjp/N2J0pzYwCE0U+VilqE/r+xmjCwnsPM+
         9bPMG6pXTjzauz301v1baBn2q4JLddDMoIJto5a/CbIWzDDuAaioij8wsKsC8/PoY6
         sddxUy2fvPziBk2dqntwZ1K3QdF8L1D+yV3AorNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/214] media: tw5864: check status of tw5864_frameinterval_get
Date:   Tue,  3 Nov 2020 21:34:51 +0100
Message-Id: <20201103203254.131220594@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 780d815dcc9b34d93ae69385a8465c38d423ff0f ]

clang static analysis reports this problem

tw5864-video.c:773:32: warning: The left expression of the compound
  assignment is an uninitialized value.
  The computed value will also be garbage
        fintv->stepwise.max.numerator *= std_max_fps;
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^

stepwise.max is set with frameinterval, which comes from

	ret = tw5864_frameinterval_get(input, &frameinterval);
	fintv->stepwise.step = frameinterval;
	fintv->stepwise.min = frameinterval;
	fintv->stepwise.max = frameinterval;
	fintv->stepwise.max.numerator *= std_max_fps;

When tw5864_frameinterval_get() fails, frameinterval is not
set. So check the status and fix another similar problem.

Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/tw5864/tw5864-video.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/pci/tw5864/tw5864-video.c b/drivers/media/pci/tw5864/tw5864-video.c
index 09732eed7eb4f..656142c7a2cc7 100644
--- a/drivers/media/pci/tw5864/tw5864-video.c
+++ b/drivers/media/pci/tw5864/tw5864-video.c
@@ -767,6 +767,9 @@ static int tw5864_enum_frameintervals(struct file *file, void *priv,
 	fintv->type = V4L2_FRMIVAL_TYPE_STEPWISE;
 
 	ret = tw5864_frameinterval_get(input, &frameinterval);
+	if (ret)
+		return ret;
+
 	fintv->stepwise.step = frameinterval;
 	fintv->stepwise.min = frameinterval;
 	fintv->stepwise.max = frameinterval;
@@ -785,6 +788,9 @@ static int tw5864_g_parm(struct file *file, void *priv,
 	cp->capability = V4L2_CAP_TIMEPERFRAME;
 
 	ret = tw5864_frameinterval_get(input, &cp->timeperframe);
+	if (ret)
+		return ret;
+
 	cp->timeperframe.numerator *= input->frame_interval;
 	cp->capturemode = 0;
 	cp->readbuffers = 2;
-- 
2.27.0



