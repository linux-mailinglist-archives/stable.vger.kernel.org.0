Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5307F3783EC
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhEJKsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233409AbhEJKpo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB7A3616ED;
        Mon, 10 May 2021 10:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642986;
        bh=XCtJfkGFbC2VRs0fahHq2Xv98B7QeAWABesY4G/UWe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jodbXt7lCgchSEeVODtCj5FcRlun5YiHQrheZMfpOhSjsu3Krrm37AqC9mCm3s1MW
         JcrSsGDfOzUKoCo/T9LEgJWnmOEBPuknSykaf0EV+HSCab7CkTjTb3sXcEHZvsBRrw
         GYyoQzNBQMV4X6XHnwClz3dd2RyCQ4H8ZdIj7Ts4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/299] atomisp: dont let it go past pipes array
Date:   Mon, 10 May 2021 12:18:49 +0200
Message-Id: <20210510102009.330912169@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 1f6c45ac5fd70ab59136ab5babc7def269f3f509 ]

In practice, IA_CSS_PIPE_ID_NUM should never be used when
calling atomisp_q_video_buffers_to_css(), as the driver should
discover the right pipe before calling it.

Yet, if some pipe parsing issue happens, it could end using
it.

So, add a WARN_ON() to prevent such case.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_fops.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp_fops.c
index 453bb6913550..f1e6b2597853 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_fops.c
@@ -221,6 +221,9 @@ int atomisp_q_video_buffers_to_css(struct atomisp_sub_device *asd,
 	unsigned long irqflags;
 	int err = 0;
 
+	if (WARN_ON(css_pipe_id >= IA_CSS_PIPE_ID_NUM))
+		return -EINVAL;
+
 	while (pipe->buffers_in_css < ATOMISP_CSS_Q_DEPTH) {
 		struct videobuf_buffer *vb;
 
-- 
2.30.2



