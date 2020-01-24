Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D811482A7
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404090AbgAXL3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:29:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:46812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404066AbgAXL3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:29:45 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32D15206D4;
        Fri, 24 Jan 2020 11:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865383;
        bh=TSq3zEB7WHFu7lvifN1fBCHZjm7ttEDT0Y57Sg8gLvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KcThQKsNOgQUu+3i4k3Sqx5Nfl3TK/OXENvLyrTn3q3Q3z1AT6Oj5JIcPgIXvB0Kd
         vhVkBhCGWWUmSoZaAbIZNWInaFuM3bXhOmTV/maHEZ8JDDSNa8ugUe2p6es1ztl/sm
         IXidAzYbFOxLUlSOaLImsURSfRQhlMSws4jb9Dok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Markus Elfring <elfring@users.sourceforge.net>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 523/639] media: em28xx: Fix exception handling in em28xx_alloc_urbs()
Date:   Fri, 24 Jan 2020 10:31:33 +0100
Message-Id: <20200124093154.303190735@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5657f8710ca6b..69445c8e38e28 100644
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



