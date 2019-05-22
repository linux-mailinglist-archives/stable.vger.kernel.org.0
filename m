Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E3525BAE
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 03:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbfEVBlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 21:41:00 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35027 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfEVBlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 21:41:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id t1so439641pgc.2;
        Tue, 21 May 2019 18:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eQzqkhxI3qa/Amfi4+MaJnGzxdoXyf8xsQLVTG3Nbzk=;
        b=PCPt8QOBQDpcMqZX6Glkj72cW9ordL2aWMtZkCD7PBW0RitfmmYGOwQQ79pt27sHbH
         j/kJ0VzC3gtNoMvnk3qIFgvRUf29MpwCpY5hvmjmHkIf70+cO5eHjhGPZ0Z8eEEoo/66
         SpJQJ43epSEgyX4sFyj83zEITkHHcTi4vPjYK8bHnVTEr2IAIo8gkuX3V5g+EyOsj8oi
         wgKPMglkF+MQvoLnR74SsNLCq+IMcMaWtRtvX0f9JnP21HICHJZ6W6aXXbEStfMLy1h/
         SaFB0le6Ak807sR9Y4Q3OmaUOl68jGwXXwuBFfavv8w4U8tCKlmj5WVVxWc07cRzeiJx
         EPSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eQzqkhxI3qa/Amfi4+MaJnGzxdoXyf8xsQLVTG3Nbzk=;
        b=qN2uTucygleE+yTR9973mJEuSerUN8WNl7DuwY41mH3iHNkRtAyMqDdavaTWcvdQn8
         +QQ/EaiLVxKrs7UM66TvZzUN0jE+OzIrZSfjPXjp4FOZ/RBtK7vzCmx0C2NXVBAC8AxV
         rMx2sMlEx40dwubK5W9J/ZqaIj4Lm+TOp6h1Nnn3DMMfCg2ol2lkJZbWS/WV71jR+RPr
         45gCs4J9itAYB17NBESy9LCmSH0jPZ1ucujwl/NweiOUf7jVX1+KUShWvjs2xJqJp5zS
         kwmvMu2jUNfSRtUkuToyyZjMnp03edyNyhVZND0FTKXAVY8uvNaUMmOGWFJ1qDKyfh6L
         441Q==
X-Gm-Message-State: APjAAAXzuFjx33kL3OZ6uFCPveD43GxIvU/AF/WRlQbGpAbUxFKJWQcs
        oJ0CYlCQ+Y8Ms2Oaa9xT/z++ZKX6pIA=
X-Google-Smtp-Source: APXvYqzBA5Pvd6xvdQuCUPZTCAEXx9tXL14n57MTorrnTzdZgh7ac2xw/SNW67qgq6do/h432NXo9Q==
X-Received: by 2002:a63:ca4b:: with SMTP id o11mr1583500pgi.295.1558489258850;
        Tue, 21 May 2019 18:40:58 -0700 (PDT)
Received: from localhost.lan (c-24-22-235-96.hsd1.wa.comcast.net. [24.22.235.96])
        by smtp.gmail.com with ESMTPSA id k67sm33489260pfb.44.2019.05.21.18.40.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 18:40:57 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-input@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: uinput - add compat ioctl number translation for UI_*_FF_UPLOAD
Date:   Tue, 21 May 2019 18:39:22 -0700
Message-Id: <20190522013922.25538-1-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the case of compat syscall ioctl numbers for UI_BEGIN_FF_UPLOAD and
UI_END_FF_UPLOAD need to be adjusted before being passed on
uinput_ioctl_handler() since code built with -m32 will be passing
slightly different values. Extend the code already covering
UI_SET_PHYS to cover UI_BEGIN_FF_UPLOAD and UI_END_FF_UPLOAD as well.

Reported-by: Pierre-Loup A. Griffais <pgriffais@valvesoftware.com>
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/input/misc/uinput.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index 1a6762fc38f9..1116d4cd5695 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -1051,13 +1051,24 @@ static long uinput_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 #ifdef CONFIG_COMPAT
 
-#define UI_SET_PHYS_COMPAT	_IOW(UINPUT_IOCTL_BASE, 108, compat_uptr_t)
+#define UI_SET_PHYS_COMPAT		_IOW(UINPUT_IOCTL_BASE, 108, compat_uptr_t)
+#define UI_BEGIN_FF_UPLOAD_COMPAT	_IOWR(UINPUT_IOCTL_BASE, 200, struct uinput_ff_upload_compat)
+#define UI_END_FF_UPLOAD_COMPAT		_IOW(UINPUT_IOCTL_BASE, 201, struct uinput_ff_upload_compat)
 
 static long uinput_compat_ioctl(struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
-	if (cmd == UI_SET_PHYS_COMPAT)
+	switch (cmd) {
+	case UI_SET_PHYS_COMPAT:
 		cmd = UI_SET_PHYS;
+		break;
+	case UI_BEGIN_FF_UPLOAD_COMPAT:
+		cmd = UI_BEGIN_FF_UPLOAD;
+		break;
+	case UI_END_FF_UPLOAD_COMPAT:
+		cmd = UI_END_FF_UPLOAD;
+		break;
+	}
 
 	return uinput_ioctl_handler(file, cmd, arg, compat_ptr(arg));
 }
-- 
2.21.0

