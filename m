Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8196D328CEE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240530AbhCATCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:02:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:57718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240648AbhCASzw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:55:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B9BC600EF;
        Mon,  1 Mar 2021 17:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620765;
        bh=u9t6BL1p0f8PS6MYJW+YcVCkee3Z1XBfa82xIIMJofg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sSa3qnIWkusH/FDgqMpdc+zdw8yHQp0P4uG9asEldS3WuxafCogwMnIdRNA50CUG0
         F2XHuUYBeAlMmFA44ceGNHd7TDOh9PD/FUouahpHa9eg+fN4oWrO0lMAfeK91AFP3m
         ribMI7t0S8qDC6bog5oRushHHi2nYLOcifeeh/uo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 231/775] media: pxa_camera: declare variable when DEBUG is defined
Date:   Mon,  1 Mar 2021 17:06:39 +0100
Message-Id: <20210301161213.045839683@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 031b9212eeee365443aaef013360ea6cded7b2c4 ]

When DEBUG is defined this error occurs

drivers/media/platform/pxa_camera.c:1410:7: error:
  ‘i’ undeclared (first use in this function)
  for (i = 0; i < vb->num_planes; i++)
       ^
The variable 'i' is missing, so declare it.

Fixes: 6f28435d1c15 ("[media] media: platform: pxa_camera: trivial move of functions")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/pxa_camera.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index b664ce7558a1a..75fad9689c901 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -1386,6 +1386,9 @@ static int pxac_vb2_prepare(struct vb2_buffer *vb)
 	struct pxa_camera_dev *pcdev = vb2_get_drv_priv(vb->vb2_queue);
 	struct pxa_buffer *buf = vb2_to_pxa_buffer(vb);
 	int ret = 0;
+#ifdef DEBUG
+	int i;
+#endif
 
 	switch (pcdev->channels) {
 	case 1:
-- 
2.27.0



