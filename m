Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC29150C24
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbgBCQdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:33:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730359AbgBCQdn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:33:43 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 619912051A;
        Mon,  3 Feb 2020 16:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747622;
        bh=bRDxASd4pXuwaIG0C6ZLI8ag5CYBoRgCK8NpwNg/rFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E3jgazon0PEmbKJpi8cXh0WvZ/5scamVh0NSVkB8I4qxNmMVDBwz10UnGuXCUlKfV
         S6SVFkTAq51uB0zQyKC/HYT0zpNBg0g8J1fXNYy1WJA5MyuJcneR4IgC9WqFBcwIPc
         Ljzs06QvjkQLAd3wAvbg1lcnARtVMWpN59dzORCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Vladis Dronov <vdronov@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 52/70] Input: aiptek - use descriptors of current altsetting
Date:   Mon,  3 Feb 2020 16:20:04 +0000
Message-Id: <20200203161919.888636372@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
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
index dc2ad1cc8fe1d..8632ca509887d 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -1726,7 +1726,7 @@ aiptek_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	aiptek->inputdev = inputdev;
 	aiptek->intf = intf;
-	aiptek->ifnum = intf->altsetting[0].desc.bInterfaceNumber;
+	aiptek->ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
 	aiptek->inDelay = 0;
 	aiptek->endDelay = 0;
 	aiptek->previousJitterable = 0;
-- 
2.20.1



