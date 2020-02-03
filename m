Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D28DB1506FB
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 14:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgBCNVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 08:21:17 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42938 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727905AbgBCNVR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 08:21:17 -0500
Received: by mail-wr1-f66.google.com with SMTP id k11so18059024wrd.9
        for <stable@vger.kernel.org>; Mon, 03 Feb 2020 05:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wi18qa0MrlL/7K66WwSCllXqfZXEgraYZcR91lSYDNE=;
        b=bp8+Uco/w5cV6S55A/YKo5bqO7+Pr/oxNg0Z6oluQH68KFgb2DyxJH1EwAdG4K/oCA
         RgZ8wCPi+pDA22I3GDZ+m/tglWqftq6a2mbvb0dmPxDZIl6MlarANf/SciK/eh01HGNg
         zH7H9/rPxFUMrbqchrYmegcJnZL0vNEEiNesSql4aYUXj1ljvecw397nIZH3qASJWysu
         NXQvoUfF9qP9WQYbBDslrIyaU0HYyFNfUUoReu2ao0QXNWUrFGMOZCSRMEg09zjRiJLw
         3AxNeaITML3GClFIA311nFdYiGnKiC2ehyUigKDabL9y7VQ+GrENKIYocO2ZosgQRBZ3
         Yd3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wi18qa0MrlL/7K66WwSCllXqfZXEgraYZcR91lSYDNE=;
        b=NRqnwX7XhPpzjzcWwvLARF7EvP0b6Xp9wDtxgvzBg6GeftGQBoVwUGFmxPiPMMqAJX
         OfB/Ey7fRlbzbBlNcMewwYchAuz/6ki/SmALNpC9RPO+gHFBITvxfLEQzpoQkkEywBWG
         Kvm278O2wgsd2sFKJYPhJ4ietGQ8XmscrCaAnnvEMugMp+/JyJQ0bWJ+lR7+8k1eGYJi
         MLJ6d8kYm5eGu1U8sU3A8FEeeO1awkC3BLFgt8ArTJQyPbJVVdMiHel+yS9FjugTdYmF
         YpPGE2TZ5P1U3YQTQt+Lt0LtFcTvo2xTRvfnt+37j/PRsf4f9y0RHt4l2klrLD2KEVai
         Pjqw==
X-Gm-Message-State: APjAAAWJqIrq4T1UFjr/7/eZPaLnihL0fo9rsGkFKEsjqhtcgCS0KSgs
        YeOxCxgwD+omK2DXGtZxIAAH5IoKG30=
X-Google-Smtp-Source: APXvYqzSJpvUoeMx6zIu+JC/mHzWGsTSVjVo4y40fmiz9jSCiVrpzfukntQzLAl4MzTE3YGEZljuuA==
X-Received: by 2002:adf:f1cb:: with SMTP id z11mr15054437wro.375.1580736075590;
        Mon, 03 Feb 2020 05:21:15 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.227])
        by smtp.gmail.com with ESMTPSA id z133sm24623094wmb.7.2020.02.03.05.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 05:21:15 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] media: si470x-i2c: Move free() past last use of 'radio'
Date:   Mon,  3 Feb 2020 13:21:30 +0000
Message-Id: <20200203132130.12748-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A pointer to 'struct si470x_device' is currently used after free:

  drivers/media/radio/si470x/radio-si470x-i2c.c:462:25-30: ERROR: reference
    preceded by free on line 460

Shift the call to free() down past its final use.

NB: Not sending to Mainline, since the problem does not exist there.

Cc: <stable@vger.kernel.org> # v3.18+
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/media/radio/si470x/radio-si470x-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index ae7540b765e1d..aa12fd2663895 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -483,10 +483,10 @@ static int si470x_i2c_remove(struct i2c_client *client)
 
 	free_irq(client->irq, radio);
 	video_unregister_device(&radio->videodev);
-	kfree(radio);
 
 	v4l2_ctrl_handler_free(&radio->hdl);
 	v4l2_device_unregister(&radio->v4l2_dev);
+	kfree(radio);
 	return 0;
 }
 
-- 
2.24.0

