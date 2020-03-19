Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE5C418B561
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgCSNR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729728AbgCSNR4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:17:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08C3B20724;
        Thu, 19 Mar 2020 13:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623876;
        bh=mtnlBCmHerKf8Q879eLnDJEOQK8W1BiYUPGGqs279ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPqIGR9vzNrzNELYbX35dQ2Ru7i2oRUevCV+gbM0Ve22mFPyQEn/nARrcayqYJVjN
         vMUaag3U7NtbVcSM3SLn15NRUapI7T4OzM6SYHkIzHg9J5150pLSLiYX3A/6ydmc1B
         lRDxjSttwE2hQHVTkLszJ+0cb9mABHYUXDK8gF9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mansour Behabadi <mansour@oxplot.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 84/99] HID: apple: Add support for recent firmware on Magic Keyboards
Date:   Thu, 19 Mar 2020 14:04:02 +0100
Message-Id: <20200319124005.445655231@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mansour Behabadi <mansour@oxplot.com>

[ Upstream commit e433be929e63265b7412478eb7ff271467aee2d7 ]

Magic Keyboards with more recent firmware (0x0100) report Fn key differently.
Without this patch, Fn key may not behave as expected and may not be
configurable via hid_apple fnmode module parameter.

Signed-off-by: Mansour Behabadi <mansour@oxplot.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index d0a81a03ddbdd..8ab8f2350bbcd 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -343,7 +343,8 @@ static int apple_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		unsigned long **bit, int *max)
 {
 	if (usage->hid == (HID_UP_CUSTOM | 0x0003) ||
-			usage->hid == (HID_UP_MSVENDOR | 0x0003)) {
+			usage->hid == (HID_UP_MSVENDOR | 0x0003) ||
+			usage->hid == (HID_UP_HPVENDOR2 | 0x0003)) {
 		/* The fn key on Apple USB keyboards */
 		set_bit(EV_REP, hi->input->evbit);
 		hid_map_usage_clear(hi, usage, bit, max, EV_KEY, KEY_FN);
-- 
2.20.1



