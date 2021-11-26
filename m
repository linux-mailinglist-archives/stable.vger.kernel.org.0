Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34CB145EC4F
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 12:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239042AbhKZLSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 06:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhKZLQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 06:16:52 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CCDC08EB2E
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 02:33:45 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id 133so7745389wme.0
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 02:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C8q1AchaMWb0GKIv7zr+g4ND1GFzTN4Jde2EJf4unnY=;
        b=Yrn/h4AphtEQy7tgQMLbTcUSvM0DlR9dXEV//uQXWew3Qjmt6XALjjMVoOfRIfyJbT
         klSt8AlHWHfWtf5zj+wqpTcEfsdxIn64NOwDEIlKoLX+5Hm0gZMBKdzIhe00U/f6shQM
         vhkTxc6Izdk6sLHVT8coN0HlkRev5glZRWmIlWV7D6JehXDhsL5Y/jdqhJ03amVXn9sx
         HdilZTIlcxb/6LAI/SOCE0MIrfssZlDvO/YXfCg6hMP2SG3W1Zo8zO0rGekHRTaufLVj
         TAhtqHrOTcMmw+/+KyTr+S7kUgXQ5LfR0BzYawmrds1EwWPr9vvNXeqIwPgvm5VXCluS
         fR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C8q1AchaMWb0GKIv7zr+g4ND1GFzTN4Jde2EJf4unnY=;
        b=EG1+c7kCfcRvRTZgw1VgLehbA5xn2qx0j3A9rpXZISlzBSp7vf8xaxHP+5I+24rH/W
         IVw1U+TIBi4+aZuP7IryBLDfG92iGZQzjRzCub4Ar8xxNuayC5v2qdN6kLEwdG9w+6ce
         aYwtsu8KuwW8ZLTtKfMw/UGjO0NI/pyPvRFgxkrFejj3tB726fsV2EOgy7eUljXwuUcq
         nf3eRnVNq94U3PaZuKdxmXbZhy4aQm8JebSfto7oMb/1jQNfHpTfjwVdalDTQHiIQzGp
         8D3H3ppeQ5I3LNJlfe/X0PKCmw84Nt5hfcD/l7848k9x7/jReSm85rYRuM7WrkuIEjEG
         UaWA==
X-Gm-Message-State: AOAM531pLkKkIOQEP9ibna0HljWfWTUBCx0c1kslgQ12tqAhw30fLjdn
        iHwvOa+oxyC2YsMAHOQpPZlIrg==
X-Google-Smtp-Source: ABdhPJwTFh+hjNJsJ7f8xorEQnyQxtE2eXzPjrIGAWxPBjt8DUI81eopgtvL0TM69o89VoX4P9Ox5g==
X-Received: by 2002:a05:600c:19c8:: with SMTP id u8mr14082514wmq.155.1637922823624;
        Fri, 26 Nov 2021 02:33:43 -0800 (PST)
Received: from localhost.localdomain ([2.31.167.18])
        by smtp.gmail.com with ESMTPSA id q4sm5016591wrs.56.2021.11.26.02.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 02:33:43 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     stable@vger.kernel.org, labbott@redhat.com,
        sumit.semwal@linaro.org, arve@android.com, riandrews@android.com,
        devel@driverdev.osuosl.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v3 1/1] staging: ion: Prevent incorrect reference counting behavour
Date:   Fri, 26 Nov 2021 10:33:35 +0000
Message-Id: <20211126103335.880816-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Supply additional checks in order to prevent unexpected results.

Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
Destined for v4.4.y and v4.9.y

 drivers/staging/android/ion/ion.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 806e9b30b9dc8..aac9b38b8c25c 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -489,6 +489,9 @@ static void *ion_buffer_kmap_get(struct ion_buffer *buffer)
 	void *vaddr;
 
 	if (buffer->kmap_cnt) {
+		if (buffer->kmap_cnt == INT_MAX)
+			return ERR_PTR(-EOVERFLOW);
+
 		buffer->kmap_cnt++;
 		return buffer->vaddr;
 	}
@@ -509,6 +512,9 @@ static void *ion_handle_kmap_get(struct ion_handle *handle)
 	void *vaddr;
 
 	if (handle->kmap_cnt) {
+		if (handle->kmap_cnt == INT_MAX)
+			return ERR_PTR(-EOVERFLOW);
+
 		handle->kmap_cnt++;
 		return buffer->vaddr;
 	}
-- 
2.34.0.rc2.393.gf8c9666880-goog

