Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64FB31F223
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbfEOLNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:13:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729988AbfEOLNe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:13:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 930F72084E;
        Wed, 15 May 2019 11:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918814;
        bh=/AiU08ka8+dVsEJGtAMl6vYttxKX5SWO+2AiJuBBxEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpDAQLsU2BcDNjHrjVb5RFAPvCBD5GwanKY5ijj5vQ+0fWl+cRDehlra5Kgre29M9
         kqjuG3nZj/GJQouB15MJy1HGUYUb+GCFRhy2Pyo0XOepUv4gdlIB/9QL5eSgUHBydj
         X2/oj4QYSoPdLyF/mx2MwMEuCUxFxAogMwmxxbTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 10/51] HID: input: add mapping for "Toggle Display" key
Date:   Wed, 15 May 2019 12:55:45 +0200
Message-Id: <20190515090620.495149719@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090616.669619870@linuxfoundation.org>
References: <20190515090616.669619870@linuxfoundation.org>
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
index 302a24931147b..9f7b1cf726a8d 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -607,6 +607,14 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
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



