Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC4C3C532E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350631AbhGLHx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347102AbhGLHsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:48:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CBB26191A;
        Mon, 12 Jul 2021 07:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075763;
        bh=JAue6/l+GnZ/MYG41KHG3rj4ORAVQYOpyTfW0SriCYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAq9wrI0qHDjaLSafF8jnHFHyIPXd4K9ZfU5vt1c3++qujH8Sf7EnntobU/WdZZ/H
         /4XKqO80C6+9UNLtYJzx0YWtf2tZfjRJbXYot711FXvBT66IJTt+qNm95SstcmkE3K
         yMjbh5yLsh4mIzpVmKP42IVZk+aNxcvsqgUKeiJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 354/800] media: s5p-mfc: Fix display delay control creation
Date:   Mon, 12 Jul 2021 08:06:17 +0200
Message-Id: <20210712061004.752903180@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 61c6f04a988e420a1fc5e8e81cf9aebf142a7bd6 ]

v4l2_ctrl_new_std() fails if the caller provides no 'step' parameter for
integer control, so define it to fix following error:

s5p_mfc_dec_ctrls_setup:1166: Adding control (1) failed

Fixes: c3042bff918a ("media: s5p-mfc: Use display delay and display enable std controls")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index a92a9ca6e87e..c1d3bda8385b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -172,6 +172,7 @@ static struct mfc_control controls[] = {
 		.type = V4L2_CTRL_TYPE_INTEGER,
 		.minimum = 0,
 		.maximum = 16383,
+		.step = 1,
 		.default_value = 0,
 	},
 	{
-- 
2.30.2



