Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDD110CD2C
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 17:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfK1QuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 11:50:09 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37401 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726730AbfK1QuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 11:50:09 -0500
Received: by mail-pf1-f193.google.com with SMTP id p24so13384622pfn.4
        for <stable@vger.kernel.org>; Thu, 28 Nov 2019 08:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3gfqS5lOXPiWWEEMhIxCyyS+fLBSJCNPeR6VbsvmT98=;
        b=jhdXMvF7E8/2RYD6Amz40/5Dec9vo4TrYTFm/r6nKztuLd4EU47wPRpIEnVGukrPq9
         6KJX/Lx31gcsN472LKTKhC9qqVht7WRMvzIuEkgW84gnYt1Q1V5qsybFpoRhsKZYSaZk
         D8zz/gLD9NiXIi51FQrr8I1tiAgYXwIfUVNtoINE4E40elNOWuicMEf8RRSLfBou5lMD
         21OIJW3h2SLpS3astqaYv2D1m65ILNsIQBe50CNQUvHJ8zlw4lYds5HZrqh88S3ZtnkY
         pMwWQeWqjtQaCpV7SrSyzXfsgvRuVQTusIn9jJ9kHRDKOfFhlkKAT3ImyVmHC6nCcJWO
         XvqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3gfqS5lOXPiWWEEMhIxCyyS+fLBSJCNPeR6VbsvmT98=;
        b=pI8/wvOI4DTNsEJtEZeMikHu3q65j/fFdeN/g09czXvOq8QZV6TRLNhwf4C0dQJVG4
         9eozFerl1LJgaqUUBk6koxP1L1FHP37DpADR1nS/96VT5ZLY1GxM5HHaCai8n1Y3bV6T
         aRfd1nJwwpNnZl6Bw7NklPEuPYsCAMLiiPCvOgUyKrNZIA13gYw7D3Znp1DczSKxvCRs
         /6TAQWTobkKONYmQhJfKK6Vw9lmUymg1s+CimcxfdgiQ3qzxcvw//fTKLW/6E4MshWa0
         NRuR28KD4QTOC+1YTtWO4RQGEib8T8By5TQiYOOXHeltGC0Iph32zPUDBVMpuWOhsHTY
         9BZA==
X-Gm-Message-State: APjAAAUYtBwhGHWEmW8dC77t+mX2JeZGBIwtNeqmucV5DGvYryPjmrwF
        4QoFcflqKFdZ625CzG0JTXuYJ0k/i/c=
X-Google-Smtp-Source: APXvYqx6xtWr8g9E9T/1JwgyO6jqtT8i4Z+88FKARM8SdyHi8DyEUM3pVBEuVW/Q2yGOKIuP1ovK8A==
X-Received: by 2002:a63:e84d:: with SMTP id a13mr1089909pgk.193.1574959808249;
        Thu, 28 Nov 2019 08:50:08 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id a15sm2450343pfh.169.2019.11.28.08.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 08:50:07 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19][PATCH 04/17] media: stm32-dcmi: fix check of pm_runtime_get_sync return value
Date:   Thu, 28 Nov 2019 09:49:49 -0700
Message-Id: <20191128165002.6234-5-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191128165002.6234-1-mathieu.poirier@linaro.org>
References: <20191128165002.6234-1-mathieu.poirier@linaro.org>
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
Cc: stable <stable@vger.kernel.org> # 4.19
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

