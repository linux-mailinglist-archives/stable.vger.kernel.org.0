Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBD091F07A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732156AbfEOL01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:26:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731372AbfEOL00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:26:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 762C2206BF;
        Wed, 15 May 2019 11:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919586;
        bh=OViN2952whJRxYkxTvW+Qiqgi1Tliog5o+GZ38Mu6gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fx1jBEFXJyCRJFKxgQ9/Dwo8X2Cem9c4SgNrVgnddh5y91U8B6RmTF7ipyU8x6XeY
         u61Yb2taMjduevjGNfCn9DghVfQThzwf1nxXpsn/etwr4rWfr4qilQ0gP2K7ZuFVhC
         3HYujv68W0Rqg25j0KKs0bxw+xEJy5f6z6UonCv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 018/137] HID: input: add mapping for "Toggle Display" key
Date:   Wed, 15 May 2019 12:54:59 +0200
Message-Id: <20190515090654.620889118@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c01908a14bf735b871170092807c618bb9dae654 ]

According to HUT 1.12 usage 0xb5 from the generic desktop page is reserved
for switching between external and internal display, so let's add the
mapping.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 290efac7e6bfd..4f119300ce3f5 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -677,6 +677,14 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 			break;
 		}
 
+		if ((usage->hid & 0xf0) == 0xb0) {	/* SC - Display */
+			switch (usage->hid & 0xf) {
+			case 0x05: map_key_clear(KEY_SWITCHVIDEOMODE); break;
+			default: goto ignore;
+			}
+			break;
+		}
+
 		/*
 		 * Some lazy vendors declare 255 usages for System Control,
 		 * leading to the creation of ABS_X|Y axis and too many others.
-- 
2.20.1



