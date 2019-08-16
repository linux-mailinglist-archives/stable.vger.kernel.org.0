Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1BD990803
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 21:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfHPTBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 15:01:03 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40207 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfHPTBC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 15:01:02 -0400
Received: by mail-pf1-f195.google.com with SMTP id w16so3564381pfn.7;
        Fri, 16 Aug 2019 12:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ITQoihrqDF1S08U7GMyYDnl7GPbMNGI14Dk5cFsRq68=;
        b=eXAIKwG5SMxJqKuvyODp+0u8MLoSXqouFCunlZzl4d4MHTMqC5eXRPlTleRrc1s/KV
         cTM3rlAOaCl/D5G1DKG/nvkGDwQ4xmgLe3Tl/4NVmBSSqzochTH5NeNfdR78bLBKKpbp
         YwF+IYYmh+NhWWmc+TD7EzcKOwBje15UIK9BMYzZ3Pc+Ef6Ii2DGdDphVmAq95qrulLn
         DBmk/+6RTWFhsK9HzaFVicRdmuwJ/IBqTY+HR48yYeNou+1uoLFvg8BZPEPhlLFBmjuq
         LWNpdbpI88wAgTG6cgZ2e5JiFpBORVgnRoGuQGUS7FrQ62X4dlutUM8LxYUkeT0yn3qy
         aJzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ITQoihrqDF1S08U7GMyYDnl7GPbMNGI14Dk5cFsRq68=;
        b=O0iEmTW9Cg7jXhuXliP+35qgaEODPofiwN5WinAZm50648vs4dH36zdCViEwzCa47M
         cCH4brAQvQWpLAaL+lWAAfmbbi+enVIJTYzkmqAEFiEehu5mEMJxp4yGn5l90amg/nWa
         FrgfIa1OFAyc6uPBYL1CgTX2HoFsziCY5LATjTuCO/DfA8LfLgIAN/tyMeB8jGRx72PS
         YdO/4o53rqdUS3UIngZAEMzFG16zQ+owmU9AA407Eek9SUk70d2xK4sNI1Ij8+dQvuLW
         Aua2XXL87Y7aO69LQNuUGSYF8DFAyP2iTyfvNCg1IS+orZwqw9ozlmwATPOj10OY970n
         XxeA==
X-Gm-Message-State: APjAAAWbABICOswoVlUfJv8iM66g5ZLzxs6w0IsLVJGi8P7t1BtZdH7Y
        7vW2xH/YpDuNRkOJuHlDYXrJk0Az
X-Google-Smtp-Source: APXvYqwNJ/AgoLJQSxTWNBDU7xQALURvsduKVHz5vIsas2CpTwmbiGQCmbf+pvAitgd1i8gT/UsPMQ==
X-Received: by 2002:a65:5a44:: with SMTP id z4mr9088279pgs.41.1565982061461;
        Fri, 16 Aug 2019 12:01:01 -0700 (PDT)
Received: from west.Home ([97.115.133.135])
        by smtp.googlemail.com with ESMTPSA id b126sm6334071pfa.177.2019.08.16.12.01.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 16 Aug 2019 12:01:00 -0700 (PDT)
From:   Aaron Armstrong Skomra <skomra@gmail.com>
X-Google-Original-From: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
To:     linux-input@vger.kernel.org, jikos@kernel.org,
        benjamin.tissoires@redhat.com, ping.cheng@wacom.com,
        jason.gerecke@wacom.com
Cc:     Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        "# v4 . 3+" <stable@vger.kernel.org>
Subject: [PATCH] HID: wacom: correct misreported EKR ring values
Date:   Fri, 16 Aug 2019 12:00:54 -0700
Message-Id: <1565982054-29236-1-git-send-email-aaron.skomra@wacom.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The EKR ring claims a range of 0 to 71 but actually reports
values 1 to 72. The ring is used in relative mode so this
change should not affect users.

Signed-off-by: Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Fixes: 72b236d60218f ("HID: wacom: Add support for Express Key Remote.")
Cc: <stable@vger.kernel.org> # v4.3+
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
---
 drivers/hid/wacom_wac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index abc17f2c8ef0..e314a7564236 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -1098,7 +1098,7 @@ static int wacom_remote_irq(struct wacom_wac *wacom_wac, size_t len)
 	input_report_key(input, BTN_BASE2, (data[11] & 0x02));
 
 	if (data[12] & 0x80)
-		input_report_abs(input, ABS_WHEEL, (data[12] & 0x7f));
+		input_report_abs(input, ABS_WHEEL, (data[12] & 0x7f) - 1);
 	else
 		input_report_abs(input, ABS_WHEEL, 0);
 
-- 
2.17.1

