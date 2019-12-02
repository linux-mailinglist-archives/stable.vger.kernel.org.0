Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19FF10E7EE
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfLBJue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:50:34 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43618 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfLBJue (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:50:34 -0500
Received: by mail-wr1-f68.google.com with SMTP id n1so43370871wra.10
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 01:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4lRCZtScqteiIwqRIQPonN0lIzT2Jm1cQmQMPHaZrMc=;
        b=llK2OT1OgLdYuLs5HW53tdeXYmiKXBkqiOSq4cossCqWa74lkLTRq7oM7LqK8IsCjo
         2RHVH/B4l/9cmzHsBzV4TRI64Idg6whdVmU8+CswrlWsHuB0rBO31+lFkTsunnCQVJ30
         26Xlwv4PBt5tjX49nNop9xLzpcLv0bwrkYw3GqeLJKtnBnKZhxgpdvJIOpNbN8EbCZc1
         56AU23rQ4gwdH9K3/4g8YtOImBM30Yx304Y9XvFyxII6L3ToGsW3THkMnnme3JxgNbwl
         2X/AwD+PYACjzQnh93P4XyQFOdaCXsznM4f8AtOjTY1D5Q6zBzWo33efQgXozaS5tMW/
         uncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4lRCZtScqteiIwqRIQPonN0lIzT2Jm1cQmQMPHaZrMc=;
        b=DWtdOBLT4j0PPfPkRhJ1LiE5xIzLatS1bgQ+5q2ipFoB0OBo8QHr/tscb2z47Zv4fs
         tXDJ3JQu2Ucyn5okH/MnCwv9WViJLJQvX1JHNp9MblWetlVt4k+MW6S+AJvUFtEEv9mK
         4chsVB9BJDVWe+Jyc8hAW4rslwPXxTp/sMCZ2wMG2hSJw/okVEDV9uB+bxExeBc4Uy2s
         nVfdheLR8HHTvad+WwfwJkIWJvNxrV9+sLwDdZ7fJ+h9smaaqSmeUl5UXpEzAhzPA4N6
         xLLJktqsqHFj6ODraEmQATpl1iI5hGMtivCHK27KM6vJWnDHqalx2ZyCizT4ciDU7QHI
         CVsQ==
X-Gm-Message-State: APjAAAWqK75vfsHU9loAxEC5JxRdcOKpxrsGI/HInWVE8+8DljGX7k9V
        bGiSGvHJxIcHZ1FQKoUuENoJG8RT+MU=
X-Google-Smtp-Source: APXvYqyXQlJXpqOYSH9EcVKdaUHkdRWSrcRBtGsW/K2zQDjExGFEYZkCVKoxFIe0tT2BWyJwaOAI8Q==
X-Received: by 2002:a5d:6089:: with SMTP id w9mr22192260wrt.228.1575280231742;
        Mon, 02 Dec 2019 01:50:31 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id l3sm4629698wrt.29.2019.12.02.01.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 01:50:31 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 3/6] media: v4l2-ctrl: fix flags for DO_WHITE_BALANCE
Date:   Mon,  2 Dec 2019 09:50:09 +0000
Message-Id: <20191202095012.559-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202095012.559-1-lee.jones@linaro.org>
References: <20191202095012.559-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit a0816e5088baab82aa738d61a55513114a673c8e ]

Control DO_WHITE_BALANCE is a button, with read only and execute-on-write flags.
Adding this control in the proper list in the fill function.

After adding it here, we can see output of v4l2-ctl -L
do_white_balance 0x0098090d (button) : flags=write-only, execute-on-write

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b3d8b9592f8a..6c0c5de2527b 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1007,6 +1007,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_FLASH_STROBE_STOP:
 	case V4L2_CID_AUTO_FOCUS_START:
 	case V4L2_CID_AUTO_FOCUS_STOP:
+	case V4L2_CID_DO_WHITE_BALANCE:
 		*type = V4L2_CTRL_TYPE_BUTTON;
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY |
 			  V4L2_CTRL_FLAG_EXECUTE_ON_WRITE;
-- 
2.24.0

