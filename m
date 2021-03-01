Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA0B3286AF
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237763AbhCARNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:13:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:37668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237399AbhCARIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:08:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B62D64F81;
        Mon,  1 Mar 2021 16:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616857;
        bh=/GYx9Lh4Pkq2HzPen200ucKkieI6gaXj6ncSJ59UDEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujst5itTuDBsNoaIXx4qC03pzwsnuImVt5Yl0rtWMZSY88OrM6AXpY/Xy8RkE3V7D
         WI3+JwCd5V1eaEzNQUGIuSrasXf2/cGaTERu1g+cccFNoEfsbjvPfPMtzjY8k5aTB3
         R8rpnF7fI3+Mk2gqR6hyio5OTx6ywk0+i+5pFln0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 092/247] media: pxa_camera: declare variable when DEBUG is defined
Date:   Mon,  1 Mar 2021 17:11:52 +0100
Message-Id: <20210301161036.177398711@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
index 406ac673ad84c..0281b8e53fef2 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -1452,6 +1452,9 @@ static int pxac_vb2_prepare(struct vb2_buffer *vb)
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



