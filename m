Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E9DFE7F5
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfKOWeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:34:05 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38663 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfKOWeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:34:04 -0500
Received: by mail-pf1-f195.google.com with SMTP id c13so7336711pfp.5
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 14:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6V0ioyUbzQMXQMBXE7qcEPEwz5yqv4QBePomZ4UZPqc=;
        b=k7kBlMxXsG6gA/UcmlwTDggZ65v+ipn3YUceSw3Oegz9WKEnqSckQYHfAT76F7fPjN
         s7QKdRMaRPqZFZSI/xOc6FPxjFzbfDiSqxO16UNRWzwpNND4qj7rCnHyntrgf8gWE2+b
         z31khVZDNGGcS5gNaQpHfSp84XhywQ1G5jrK5dsnXgm8xzY2Bttagju6GbfsQCuUz1t1
         a1jGQru7049kf1xVk9PcTip/XRGMTQ3ZDi5E07+5EowNcQ7XYcGxNTDsz6/vv89SFEC4
         rOkGhyiZz4rpSal4odmYlyBahCIUN9rZMet/cta0i71K0Th0xdUbgnAkFRClk3lff4d1
         /chw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6V0ioyUbzQMXQMBXE7qcEPEwz5yqv4QBePomZ4UZPqc=;
        b=caDamFoNfr59euT8dZJBkwchRFOw4sc/e3rpFeMbJW6RGzxLzUMB2RrOKwwseZdQyy
         UydfXz0KJVmYRnlb2LUraBO0tF6Rot4Cy/j1W7AorVNh9FmitbbUocVl9WSUxnWPbgr+
         lwvYvqF0+eeIXV7JTiQJcAEWIQORoaYXkV8M/rFMwmTeDof0a332au+OYvVAWDeaUI2F
         HxAhn1NcMYMfqr+NqHTRxR4t6Sh5nFvqKlXPKoIjm42JBQhP056hF3j1DwTRlOUeEonz
         nFPUH+D0LjGzyNdg7rnhFxXiT65YQfGGGEynUCWgF6dwJhIeyM6VbOmzq2DdgEptEUKo
         866A==
X-Gm-Message-State: APjAAAWZrHVxNvO2he43zP5x8I4WZmtFMUIq14zjnDyd95fFxIH+y6ge
        7ZxUj41GNSY0nSYBAr0MWATtEe3IyeU=
X-Google-Smtp-Source: APXvYqwPDrxT0ltVk6U0vCs9B/kupiJwArvMyWvfpOn2zdkBUlstoIR7TdNRADNMqnuUZbeIdUbysg==
X-Received: by 2002:a62:1c8:: with SMTP id 191mr20454995pfb.152.1573857242567;
        Fri, 15 Nov 2019 14:34:02 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m15sm11699724pfh.19.2019.11.15.14.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:34:01 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19+][PATCH 06/20] media: stm32-dcmi: fix check of pm_runtime_get_sync return value
Date:   Fri, 15 Nov 2019 15:33:42 -0700
Message-Id: <20191115223356.27675-6-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115223356.27675-1-mathieu.poirier@linaro.org>
References: <20191115223356.27675-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugues Fruchet <hugues.fruchet@st.com>

commit ab41b99e7e55c85f29ff7b54718ccbbe051905e7 upstream

Start streaming was sometimes failing because of pm_runtime_get_sync()
non-0 return value. In fact return value was not an error but a
positive value (1), indicating that PM was already enabled.
Fix this by going to error path only with negative return value.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/media/platform/stm32/stm32-dcmi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index d86944109cbf..18d0b5641789 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -584,9 +584,9 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
 	int ret;
 
 	ret = pm_runtime_get_sync(dcmi->dev);
-	if (ret) {
-		dev_err(dcmi->dev, "%s: Failed to start streaming, cannot get sync\n",
-			__func__);
+	if (ret < 0) {
+		dev_err(dcmi->dev, "%s: Failed to start streaming, cannot get sync (%d)\n",
+			__func__, ret);
 		goto err_release_buffers;
 	}
 
-- 
2.17.1

