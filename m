Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6B6328489
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbhCAQhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:37:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:36926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231668AbhCAQ37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:29:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1012B64F12;
        Mon,  1 Mar 2021 16:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615817;
        bh=bJZPrEQmEUULAGCg89U6fclNa7EqcOCmvCi9Sa8b2Gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCxCfwenA8sCHmdMm1hFUpgIb09h7SzGLxjn09fi5KCwnpMDZjdq/fWvgBFZ/n5nK
         ce8GMwVIq7hZBucBn3I76f7h1dF9tNmF8c/wBIalefInI9H/NcJdMEzZs1vnrx7vED
         /6zb5gxKQw+uDFss0TeRSeh+WXbI/kKrFeKlhejA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 041/134] media: pxa_camera: declare variable when DEBUG is defined
Date:   Mon,  1 Mar 2021 17:12:22 +0100
Message-Id: <20210301161015.601336368@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
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
index 3fab9f776afa7..425eda460e013 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -1420,6 +1420,9 @@ static int pxac_vb2_prepare(struct vb2_buffer *vb)
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



