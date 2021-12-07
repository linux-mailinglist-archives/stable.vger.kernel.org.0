Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5AF46AECE
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 01:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378004AbhLGAKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 19:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377931AbhLGAKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 19:10:04 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444C8C061746;
        Mon,  6 Dec 2021 16:06:35 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z5so50256874edd.3;
        Mon, 06 Dec 2021 16:06:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=6oO/DmCZBRIesH47nko+UAMyw7O3EO2xK/KulGn/MuY=;
        b=NLw7lDweGJvuzpZG1urmwqCOmLa8QmnqhT6s8iHpEn0tXkxfUO7CKfOlsL5+PDGllh
         FKU3TvN0wmada1BsHIVre5o2/Ca8XuhQbyAP+Hvn4FT3avURlmooBuULoG9Uaa8qOEgY
         Z2/4noS88LsB7M6B/I4jpWg7JHmDBhO8V+SuVXlHklvIQej8IQLSlnCU2paR1liZl3f9
         UM43+L9FgEAAepHQNaKgQL6DZ0Fp2KzzYbrmvgL77FQ7Qgo3Y7mMuF7ScGuleE0yJ75b
         5BLLqLL+VxymVvxqARGZY+3wyqeUKggWDJwTzi7FzTIbvJ8supifMimMaEEVpfrdsKME
         1C8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6oO/DmCZBRIesH47nko+UAMyw7O3EO2xK/KulGn/MuY=;
        b=AC8z8FhwbebrInQ3LS2/PEfzhZGPRI+9XWGuoZ4+9/WUZP9qC/fzOz9lV57ehqSYnf
         UC9/N4FtF7+OMwyRkYe/DOWo2AqfYQQKfB1YE5yRC+mc3k4dKmKI98tMGPtEjVFYA98H
         NxWEkYEUszIaEfcJIbsolq59xDfVnArZ1Eti6ZLODzg8duvJJwNJIo9E9W48zk2c5aEm
         wtGp4Sq7rP6dTyRGfdSNu0RXS6lO5E97WU30MxhaGyEsANFWxQ6JvM3CtC+2TA78s+TK
         RZ70OhGISiiD1850/2DWDBQ/5XRnSgOyxIXVfk8z8fgunitZuxIkPeja6GJasFMqX90I
         Pkyw==
X-Gm-Message-State: AOAM532cr6DyxZ3JpP67eGI2tvRdzVe2d1UNRM0ht2FyYua1713NiyZK
        yVM6Tz+1EGmcjp0/xwulCAA=
X-Google-Smtp-Source: ABdhPJzmq4YQknoDmdZDEaunDUhyHzVUxw++prxmEkRu25E6qStXkavhxBOiLTlmWpZB9qzkZmC6Ag==
X-Received: by 2002:a05:6402:1e90:: with SMTP id f16mr3564426edf.91.1638835593884;
        Mon, 06 Dec 2021 16:06:33 -0800 (PST)
Received: from piling.lan (80.71.134.83.ipv4.parknet.dk. [80.71.134.83])
        by smtp.gmail.com with ESMTPSA id w18sm8713114edx.55.2021.12.06.16.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:06:33 -0800 (PST)
From:   Ricardo Ribalda <ricardo.ribalda@gmail.com>
X-Google-Original-From: Ricardo Ribalda <ribalda@chromium.org>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        ": Ricardo Ribalda" <ribalda@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tfiga@chromium.org, stable <stable@vger.kernel.org>
Subject: [PATCH 2/3] media: v4l2-dev.c: Allow driver-defined entity names
Date:   Tue,  7 Dec 2021 01:06:28 +0100
Message-Id: <20211207000629.4985-3-ribalda@chromium.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211207000629.4985-1-ribalda@chromium.org>
References: <20211207000629.4985-1-ribalda@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the driver provides an name for an entity, use it.
This is particularly useful for drivers that export multiple video
devices for the same hardware (i.e. metadata and data).

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 drivers/media/v4l2-core/v4l2-dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index d03ace324db0..4c00503b9349 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -832,7 +832,9 @@ static int video_register_media_controller(struct video_device *vdev)
 	}
 
 	if (vdev->entity.function != MEDIA_ENT_F_UNKNOWN) {
-		vdev->entity.name = vdev->name;
+		/* Use entity names provided by the driver, if available. */
+		if (!vdev->entity.name)
+			vdev->entity.name = vdev->name;
 
 		/* Needed just for backward compatibility with legacy MC API */
 		vdev->entity.info.dev.major = VIDEO_MAJOR;
-- 
2.33.0

