Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10DCF13F365
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390104AbgAPRK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:10:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390096AbgAPRK5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5338A20684;
        Thu, 16 Jan 2020 17:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194657;
        bh=8pmzowCdGMNdlrVuisE8cxbRdFU+AF3IhU1RZb79fXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6DGo0TfYnHDMguMkacizVMRDWtJsZY/9KZalJIHL/uvtV2gsAwH2flLt3xwvoL5/
         +4LnV07EZM5htYrALAaAholzMU7qYEIN5EAbdeUUeTUevPtuoShHLMtsf1jwG0kDoG
         pUJNYHnkN+7SX6sh93tI2MYFsUPxTz/X41F2wmuA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Markus Elfring <elfring@users.sourceforge.net>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 509/671] media: em28xx: Fix exception handling in em28xx_alloc_urbs()
Date:   Thu, 16 Jan 2020 12:02:27 -0500
Message-Id: <20200116170509.12787-246-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit ecbce48f1ff2442371ebcd12ec0ecddb431fbd72 ]

A null pointer would be passed to a call of the function "kfree" directly
after a call of the function "kcalloc" failed at one place.
Pass the data structure member "urb" instead for which memory
was allocated before (so that this resource will be properly cleaned up).

This issue was detected by using the Coccinelle software.

Fixes: d571b592c6206d33731f41aa710fa0f69ac8611b ("media: em28xx: don't use coherent buffer for DMA transfers")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 5657f8710ca6..69445c8e38e2 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -930,7 +930,7 @@ int em28xx_alloc_urbs(struct em28xx *dev, enum em28xx_mode mode, int xfer_bulk,
 
 	usb_bufs->buf = kcalloc(num_bufs, sizeof(void *), GFP_KERNEL);
 	if (!usb_bufs->buf) {
-		kfree(usb_bufs->buf);
+		kfree(usb_bufs->urb);
 		return -ENOMEM;
 	}
 
-- 
2.20.1

