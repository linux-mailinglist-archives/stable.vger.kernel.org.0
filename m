Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBB7198C19
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 08:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgCaGKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 02:10:07 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39080 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgCaGKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 02:10:07 -0400
Received: by mail-pj1-f65.google.com with SMTP id z3so625213pjr.4
        for <stable@vger.kernel.org>; Mon, 30 Mar 2020 23:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=7gDKMMIuCNqmz3/gFIq4MvPM1PkZWROW621H1HN1ayU=;
        b=YdSZ586ZUgz6lb4fgc0t9r8Jxl0i7MDKTTdEubCA94y0Y/lSiz3Igp2J+b73rVmKAp
         WU5NfS0PX4wBSXBJk49GmGvWvyzeX1+2oXcj601lkxqxAwSLXZwc2ZxYvg9rLZEqFt68
         c6ZAA6t2W27i28NDM7MwgTJV8E87k8vbH7JbSxgcD0R0DmvdjAV/f+dkkreNKkKNCUDO
         agfbOP28/ysqeYtE1zEppqKFhKQwjriGlxxqHONzXUmYrMliTMvw37yy5GCh080ZWeIz
         WJbPZCgAmk0nHSI1jC8MXbU6ycoq8bTgV9T5+NOjOxokdpHmI7rfnPISmJXhrxB2XAsH
         AVjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=7gDKMMIuCNqmz3/gFIq4MvPM1PkZWROW621H1HN1ayU=;
        b=kM3AelIbaQHAlz5mfoN5MuAWoS2ChhMtMDOZjE5af4WVftb05RkRhq1133Bzh3llje
         EZGbjX/4kWnEhdfKR9gyGBFhH8xb2am14qfA9nltXOa5zhRY6e++kOWgtcho1YN0h2Uo
         YyAHAfA/E/2/rLyQJMKA0SPouh9ctWXoGYL7XcQe1CfWdp6N0asypNy8y21SW9c8J2Ch
         1Htu0CrJRagtdEYL7+k1kHHay850Bw86yzdfKQFW+Bv6GQO4Fvx+zI57yY5B2qy18Fxi
         QPQYPyvhYgzNWzvSIQIAqlXggGHd7S48mcZRFdd9nnHbIe7NctUGE+QIeo2EchxeLijN
         KijQ==
X-Gm-Message-State: AGi0PubsrP/u7A8KprsqRFZPw6s3jGYSLxLg4rHwB3DXgCbpcyohdeLx
        go1AitfXxfOLIP2kM0C++Pc=
X-Google-Smtp-Source: APiQypL6SM9R3Junk6mCmNdTFwzDZbZ4pRbnQMT67D/+476FqoDC4YGt7uTmufgFNPymKZG+5jOt3w==
X-Received: by 2002:a17:90a:3606:: with SMTP id s6mr2035567pjb.195.1585635006492;
        Mon, 30 Mar 2020 23:10:06 -0700 (PDT)
Received: from software.domain.org ([104.207.149.93])
        by smtp.gmail.com with ESMTPSA id r29sm10890190pgm.17.2020.03.30.23.10.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 30 Mar 2020 23:10:05 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Dave Airlie <airlied@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        spice-devel@lists.freedesktop.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
Subject: [PATCH Resend] drm/qxl: Use correct notify port address when creating cursor ring
Date:   Tue, 31 Mar 2020 14:18:08 +0800
Message-Id: <1585635488-17507-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The command ring and cursor ring use different notify port addresses
definition: QXL_IO_NOTIFY_CMD and QXL_IO_NOTIFY_CURSOR. However, in
qxl_device_init() we use QXL_IO_NOTIFY_CMD to create both command ring
and cursor ring. This doesn't cause any problems now, because QEMU's
behaviors on QXL_IO_NOTIFY_CMD and QXL_IO_NOTIFY_CURSOR are the same.
However, QEMU's behavior may be change in future, so let's fix it.

P.S.: In the X.org QXL driver, the notify port address of cursor ring
      is correct.

Cc: <stable@vger.kernel.org>
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 drivers/gpu/drm/qxl/qxl_kms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/qxl/qxl_kms.c b/drivers/gpu/drm/qxl/qxl_kms.c
index bfc1631..9bdbe0d 100644
--- a/drivers/gpu/drm/qxl/qxl_kms.c
+++ b/drivers/gpu/drm/qxl/qxl_kms.c
@@ -218,7 +218,7 @@ int qxl_device_init(struct qxl_device *qdev,
 				&(qdev->ram_header->cursor_ring_hdr),
 				sizeof(struct qxl_command),
 				QXL_CURSOR_RING_SIZE,
-				qdev->io_base + QXL_IO_NOTIFY_CMD,
+				qdev->io_base + QXL_IO_NOTIFY_CURSOR,
 				false,
 				&qdev->cursor_event);
 
-- 
2.7.0

