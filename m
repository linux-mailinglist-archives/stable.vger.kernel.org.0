Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8894B15C72E
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgBMQHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:07:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:34094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbgBMPXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:23:16 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AF652469C;
        Thu, 13 Feb 2020 15:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607396;
        bh=ISIJ810rpefs2a03JAvJn/yTy3CJ2mfQscDg8waXwDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSP3vQogqA/UKaEy5uJMLx/ebDRrqdgOQGlAwI8Nv3Hxb+982sm2NrDUsffYNgIYi
         a/7on2MfBePfOzUYiQaxXPtXpllqxJC6nldR2nWTxhNVPbObAbf5fx5nqsG+3T0wE6
         Hq5ft1pkZWXbP6GiG6JU306506JeJjYmbUjhSVB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 001/116] media: iguanair: fix endpoint sanity check
Date:   Thu, 13 Feb 2020 07:19:05 -0800
Message-Id: <20200213151842.789699352@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 1b257870a78b0a9ce98fdfb052c58542022ffb5b ]

Make sure to use the current alternate setting, which need not be the
first one by index, when verifying the endpoint descriptors and
initialising the URBs.

Failing to do so could cause the driver to misbehave or trigger a WARN()
in usb_submit_urb() that kernels with panic_on_warn set would choke on.

Fixes: 26ff63137c45 ("[media] Add support for the IguanaWorks USB IR Transceiver")
Fixes: ab1cbdf159be ("media: iguanair: add sanity checks")
Cc: stable <stable@vger.kernel.org>     # 3.6
Cc: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/iguanair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 25470395c43f1..246795c315533 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -430,7 +430,7 @@ static int iguanair_probe(struct usb_interface *intf,
 	int ret, pipein, pipeout;
 	struct usb_host_interface *idesc;
 
-	idesc = intf->altsetting;
+	idesc = intf->cur_altsetting;
 	if (idesc->desc.bNumEndpoints < 2)
 		return -ENODEV;
 
-- 
2.20.1



