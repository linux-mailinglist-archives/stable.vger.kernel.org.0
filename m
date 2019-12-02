Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7F010E8E4
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfLBKbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:31:14 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40070 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727366AbfLBKbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:31:13 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so5034423wmi.5
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:31:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=mwGk83ys5wzg6iRWDi8s7AoiHaTu4B4X10LSHfqyk8w=;
        b=Xbzty9L/X10yLpFPquKRyqRToOCooiNpWeoN2NgszE+xNlP5yTprOUlElPuc4oDgV/
         OC7KYkBj8VuhrLYeBVSe93WnDA1EYPC0/dA+bHdACYnLrlEnzaPTb8bVQQQKpwZXIB6R
         NlmoG52MvfePxweymljb7ACZ/iqjNynRBp+vEfHigWhYLWn3Ak6RFeOcXNpr7BFCSzXS
         Gf7JdhMsL/WByFDgqHNUBzk+Qmdj6tTHTxfp1N52v0oHad6K3ebxvscpOYi6CH0ng61r
         JJ1T0S5y8WJzVkGDs8iWH9sQCnVooc0djduRd+jW+sjYAi6pRmM+kE+HpzqXKU8Q8ioI
         SkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mwGk83ys5wzg6iRWDi8s7AoiHaTu4B4X10LSHfqyk8w=;
        b=hk7N5wBnX3UYqFK1R4EkZE3H8FfbeYCg430EqNKY0XCD7sJyelY/1ob5tK7T27iUVC
         XlRvPNpNePHyOHsvYLLI7Fgq2LDgQuf67NJQ6ADWRUuQAlZAvDseHGfjRKiIKvg5j5zo
         z7s4T8UcJ3tqCoqJL+YqAiCV3hHjV5J5waSJ45sCRHhUxcvXO9YEgiRtu7HXLo4Xx0jl
         iQgU9HRPD8m7wzewWRQKppluq5ciBSif3/bKcA0VyQpKbn7c3oIodZOutD5aMtOT4v0v
         QJlDGoB5VW8bYTVT/EBDi48nA+etxd6tV0Bb8I8GdHW7ArofD3uRHSvmruoaPBAk69xU
         WLlQ==
X-Gm-Message-State: APjAAAUvLaMKXj1kSsvynkI0VFFABdlpjWQYGsJGcdh4xw8Xk+341jkZ
        +4P05adnX6vzCcRAZyo6pLEMjpi71NA=
X-Google-Smtp-Source: APXvYqygsah6YkOxjOV87Q2c77dbYhW/H27lwmM7d744R4X9Cy2YEMjOcUaHRnCEa/ca36s8wqrkDg==
X-Received: by 2002:a7b:c947:: with SMTP id i7mr8328577wml.71.1575282671726;
        Mon, 02 Dec 2019 02:31:11 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id r6sm26402860wrq.92.2019.12.02.02.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:31:11 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 06/15] media: v4l2-ctrl: fix flags for DO_WHITE_BALANCE
Date:   Mon,  2 Dec 2019 10:30:41 +0000
Message-Id: <20191202103050.2668-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202103050.2668-1-lee.jones@linaro.org>
References: <20191202103050.2668-1-lee.jones@linaro.org>
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
index 0986572bbe88..f4ebff347d7a 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1145,6 +1145,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_FLASH_STROBE_STOP:
 	case V4L2_CID_AUTO_FOCUS_START:
 	case V4L2_CID_AUTO_FOCUS_STOP:
+	case V4L2_CID_DO_WHITE_BALANCE:
 		*type = V4L2_CTRL_TYPE_BUTTON;
 		*flags |= V4L2_CTRL_FLAG_WRITE_ONLY |
 			  V4L2_CTRL_FLAG_EXECUTE_ON_WRITE;
-- 
2.24.0

