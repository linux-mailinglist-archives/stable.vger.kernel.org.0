Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBD0498470
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 17:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243609AbiAXQMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 11:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243621AbiAXQMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 11:12:50 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C663BC06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 08:12:49 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id r14so14524604wrp.2
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 08:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dZhD9/fwf2Qn5xAQQ+ZP1nCs3cqqOn+CChdr75Mg9SA=;
        b=l3KkhKienOMvuM4phNCoYgVd54Gm7OkTn354Tp73JRjy5zLV5gpZ+YQmxh/I2RBWv1
         LwSqzl1/l0gX7mjtMQ/ramzboMNUywOt/9feKw7tFy7NDoZilt7lidgO+n1LzE0oLCgS
         9sahar4iog3E5wDzfjjwo5K8KxhWi0kCnb43sogGXqobkMvbEewAx8eXKM9R0r9k3XNS
         mMgvqxet8Vg6OUlmKyHhzduSG/iPoqXABHazL4GlrHmovAK2PNmgor1tSgIm3nJEwCW2
         cdFhjL1eEZ/bi5PYVdzHv+TiCnsy4TeXXqIZDGs4S5YRG+i3vWTH+tPpcM2Pw2GBWMMv
         CWkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dZhD9/fwf2Qn5xAQQ+ZP1nCs3cqqOn+CChdr75Mg9SA=;
        b=OR5Cll/IwcfjXc4ZHyQSV+RxLEpTKg/qZtnMoHys9dA3xelWfn9A/T8OXf4lpgFDo7
         ogHZyAWP7EpTbePkAWKoXiASKv0w6Spkh8tp5zgLoS20DxSz9uUjBslsZkJPRWHDSFFz
         bd57SkJIfnAq1NRxsjeTYLU5rClihg+FL8li91gx1RdzPFYshOPnS5cPXcFqX5w0cJmD
         OQjOBzSgV5X3D61bYVpz3nDZH4ihWWIAN6VaVuFzQABRmdqGHr7zvSY6UdDYFqoDflhM
         btuLsyMiOW4GTl/tWrdbDQu3rTP4YAgtM/1zkLLk6VsK3ss58kphEBYZBAleIcLC09Vr
         o+xg==
X-Gm-Message-State: AOAM532REx3CmfURQzSsP4hg8l1vR3pfNzjFuGURbBnvkiKDfTuO5lOF
        J122kaAJZO7Tsn6LRsIBS3O3lOYXp/Rxdw==
X-Google-Smtp-Source: ABdhPJyxF4eJkFr37OehSrk+mAWguo99XWVw97kZzbwx3gz2PkYPAJH+1n7pnB9xKdx+nfvjwpAVMw==
X-Received: by 2002:adf:d1c2:: with SMTP id b2mr7858126wrd.411.1643040768321;
        Mon, 24 Jan 2022 08:12:48 -0800 (PST)
Received: from joneslee-l.roam.corp.google.com (cpc106310-bagu17-2-0-cust853.1-3.cable.virginm.net. [86.15.223.86])
        by smtp.gmail.com with ESMTPSA id u15sm2245583wrs.17.2022.01.24.08.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 08:12:47 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 4.9 3/3] ion: Do not 'put' ION handle until after its final use
Date:   Mon, 24 Jan 2022 16:12:43 +0000
Message-Id: <20220124161243.1029417-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220124161243.1029417-1-lee.jones@linaro.org>
References: <20220124161243.1029417-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

pass_to_user() eventually calls kref_put() on an ION handle which is
still live, potentially allowing for it to be legitimately freed by
the client.

Prevent this from happening before its final use in both ION_IOC_ALLOC
and ION_IOC_IMPORT.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/staging/android/ion/ion-ioctl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/ion/ion-ioctl.c b/drivers/staging/android/ion/ion-ioctl.c
index d47e9b4171e28..a27865b94416b 100644
--- a/drivers/staging/android/ion/ion-ioctl.c
+++ b/drivers/staging/android/ion/ion-ioctl.c
@@ -165,10 +165,9 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 				     data.allocation.flags, true);
 		if (IS_ERR(handle))
 			return PTR_ERR(handle);
-		pass_to_user(handle);
 		data.allocation.handle = handle->id;
-
 		cleanup_handle = handle;
+		pass_to_user(handle);
 		break;
 	}
 	case ION_IOC_FREE:
@@ -212,11 +211,12 @@ long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 		} else {
+			data.handle.handle = handle->id;
 			handle = pass_to_user(handle);
-			if (IS_ERR(handle))
+			if (IS_ERR(handle)) {
 				ret = PTR_ERR(handle);
-			else
-				data.handle.handle = handle->id;
+				data.handle.handle = 0;
+			}
 		}
 		break;
 	}
-- 
2.35.0.rc0.227.g00780c9af4-goog

