Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E429E12FA89
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 17:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgACQfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 11:35:38 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45524 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbgACQfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 11:35:37 -0500
Received: by mail-lj1-f193.google.com with SMTP id j26so44403262ljc.12;
        Fri, 03 Jan 2020 08:35:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fvUvyPauFgb0gSD0dBGAKRr2laNeAtuutqe4RwswNwo=;
        b=HNkvjSfytuTs2BsFxEvBmoTJbcNYqlO1KkHDd0GLJa1b9Th60vzPBrEKocrypaPFX8
         5awHdLZ5FlRU1rr+lyV1tA1HTgwXu8etVZneBbcoxsORI/1QdKxiKqiOLPK0QIZsOtQe
         WlNzOnSGwUz7i4X/O+ywARE26ke9sxqyHpptdqPHdk/YAB87s0ofD34k7YVBX/iL7+Nb
         56AvxYU/TOvtGiXxpB5LinrLY8vNqFD9G3pPETFFh4i+RkjryIjSJr9CSonlZQsffQPY
         1+F3e241z1GWaPt/vViKGFrgiYRanmwfqkiDpyutfNUAoRRsGn1sJ0a6WAmCui3sWrPs
         Iadw==
X-Gm-Message-State: APjAAAUqqNpsJJd5SVon3svXFAEIMMTNwhFNNj3tFZt8BIhU47LKqSKP
        g4l/fns1ei/vJeQpkrKWXMM=
X-Google-Smtp-Source: APXvYqw7CC0QU8Touq6DWulQjWAKvYvfvYb2oEEcSrTqdjfy566G+5e/mN2WX3nEvGCEmfRtDY0bTw==
X-Received: by 2002:a2e:9592:: with SMTP id w18mr52088640ljh.98.1578069334478;
        Fri, 03 Jan 2020 08:35:34 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id r21sm24849749ljn.64.2020.01.03.08.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 08:35:32 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1inPvB-0000Kp-6W; Fri, 03 Jan 2020 17:35:33 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sean Young <sean@mess.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/6] media: ov519: add missing endpoint sanity checks
Date:   Fri,  3 Jan 2020 17:35:09 +0100
Message-Id: <20200103163513.1229-3-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200103163513.1229-1-johan@kernel.org>
References: <20200103163513.1229-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to check that we have at least one endpoint before accessing
the endpoint array to avoid dereferencing a NULL-pointer on stream
start.

Note that these sanity checks are not redundant as the driver is mixing
looking up altsettings by index and by number, which need not coincide.

Fixes: 1876bb923c98 ("V4L/DVB (12079): gspca_ov519: add support for the ov511 bridge")
Fixes: b282d87332f5 ("V4L/DVB (12080): gspca_ov519: Fix ov518+ with OV7620AE (Trust spacecam 320)")
Cc: stable <stable@vger.kernel.org>     # 2.6.31
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/gspca/ov519.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/usb/gspca/ov519.c b/drivers/media/usb/gspca/ov519.c
index f417dfc0b872..0afe70a3f9a2 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -3477,6 +3477,11 @@ static void ov511_mode_init_regs(struct sd *sd)
 		return;
 	}
 
+	if (alt->desc.bNumEndpoints < 1) {
+		sd->gspca_dev.usb_err = -ENODEV;
+		return;
+	}
+
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	reg_w(sd, R51x_FIFO_PSIZE, packet_size >> 5);
 
@@ -3603,6 +3608,11 @@ static void ov518_mode_init_regs(struct sd *sd)
 		return;
 	}
 
+	if (alt->desc.bNumEndpoints < 1) {
+		sd->gspca_dev.usb_err = -ENODEV;
+		return;
+	}
+
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	ov518_reg_w32(sd, R51x_FIFO_PSIZE, packet_size & ~7, 2);
 
-- 
2.24.1

