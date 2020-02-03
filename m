Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71C26150D89
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbgBCQa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:30:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:43808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730102AbgBCQay (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:30:54 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C64F02082E;
        Mon,  3 Feb 2020 16:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747454;
        bh=GHKj6+IsDPLoDtMNaA82wH1qhm2lOju9DwL9PSoNYDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7/lGbnNSzAZpLjFu2FSZbH7HV1sSjQ4y1pEMdIkGMWH0uL1PJlpLo2G9cxzTN6cK
         el1l6SxaWRqzaW+kew5ZV5r+MrAsxZIKGeLXjb5WuVldQVEdNM+ZnNwKCfGkvqMrvF
         qxi1wKIT2xfLpTvZig5Ro14UCQmzcPOiNM5MmkkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 70/89] Input: aiptek - use descriptors of current altsetting
Date:   Mon,  3 Feb 2020 16:19:55 +0000
Message-Id: <20200203161925.604951657@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit cfa4f6a99fb183742cace65ec551b444852b8ef6 ]

Make sure to always use the descriptors of the current alternate setting
to avoid future issues when accessing fields that may differ between
settings.

Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Vladis Dronov <vdronov@redhat.com>
Link: https://lore.kernel.org/r/20191210113737.4016-4-johan@kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/tablet/aiptek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index fbe2df91aad3a..838b91337cd03 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -1733,7 +1733,7 @@ aiptek_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	aiptek->inputdev = inputdev;
 	aiptek->intf = intf;
-	aiptek->ifnum = intf->altsetting[0].desc.bInterfaceNumber;
+	aiptek->ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
 	aiptek->inDelay = 0;
 	aiptek->endDelay = 0;
 	aiptek->previousJitterable = 0;
-- 
2.20.1



