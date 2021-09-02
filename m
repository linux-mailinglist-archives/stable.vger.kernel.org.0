Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E2C3FEA32
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 09:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233428AbhIBHst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 03:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbhIBHst (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 03:48:49 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C584C061575
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 00:47:51 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id i21so2258095ejd.2
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 00:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ptsiWmJ3REZ+TxIg9IEdN89n1Hy/1BXt2HF8envKx84=;
        b=dj8bLavuu2HourZqcwRyM7BeTo+l2ZzdiQ2YPlXJenA6YDEYSjJfgXWRhm0ZdUBzMB
         ARk46VIzqkajCo3b+1ebFIDVcLZlz1SOdSTKGq87nagaoyUow7ujuxAVNbrSP7N25Y9h
         fDNLIjKQFjbzYVbOR1RUo8FswQ617Ehf7InDRFBVzuRtpFK9ACf7vH2LrKj9kTcnmSnO
         9v1dJ40fAimAmfxioCu+1U1o+VuCw5Ll7yGS7wJ+diGwDKzKsZp5TJbmDIuzT+HU8b4x
         aW9CNJPpQ2FsVC43cpmB09sUm5oEqo9czNOu/qzbdCSSFwslG2zopzdUh5XrrFmyDY4e
         Vfdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ptsiWmJ3REZ+TxIg9IEdN89n1Hy/1BXt2HF8envKx84=;
        b=j8GHWyihvYcxgf+eTa2JZgWQuyWXqlLvoLdjfd6yQpryILWeEL9zxrWTIJJ3Rn+Mbp
         KQ/0NuF4nUzdAiwpErlLlMy3u8PJCUD3ZFSu1y0B0zm3WV2uKNPxV31V81ojfhCaSUbR
         cMv5W+N8y7h24h070O7N1Q/A8SI9fnQd/U5B/WydK2RQ3HDPaNCcqa/noy4RTdlTID9s
         ZN5yYOIP3o+NKMnOByZ++vYLMLrYBH0xY9ROgwFKjHbNxwON6Yu/swrFVWkaYDFYzHXK
         oDqFRl0xxOfYR5RPwlFcGyY6mTuF3q39dra2FAhfrnu5E3aPssunER5ZomJfDZiEuLf4
         EfwA==
X-Gm-Message-State: AOAM530K4msMnQH6AoZco13SyoZsKlS4wtgnreAQaBZ0TCfk04agjeLS
        DA7r3TL3N08nL1h7c7C0Ks2/W8U73Ow=
X-Google-Smtp-Source: ABdhPJxkzmxQ70Q/bNqlnZguZXLU7+zpODK5wD+9nSx8SzYCQ6frheLSeqVe7C/cyNk53/CcQkkNyQ==
X-Received: by 2002:a17:906:8da:: with SMTP id o26mr2313660eje.424.1630568870020;
        Thu, 02 Sep 2021 00:47:50 -0700 (PDT)
Received: from mammut.. (c83-254-134-100.bredband.tele2.se. [83.254.134.100])
        by smtp.gmail.com with ESMTPSA id c21sm509305ejz.69.2021.09.02.00.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 00:47:49 -0700 (PDT)
From:   =?UTF-8?q?Ernst=20Sj=C3=B6strand?= <ernstp@gmail.com>
To:     ernstp@gmail.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] drm/amd/amdgpu: Increase HWIP_MAX_INSTANCE to 10
Date:   Thu,  2 Sep 2021 09:47:41 +0200
Message-Id: <20210902074741.7957-1-ernstp@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Seems like newer cards can have even more instances now.
Found by UBSAN: array-index-out-of-bounds in
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:318:29
index 8 is out of range for type 'uint32_t *[8]'

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1697
Cc: stable@vger.kernel.org
Signed-off-by: Ernst Sjöstrand <ernstp@gmail.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index dc3c6b3a00e5..d356e329e6f8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -758,7 +758,7 @@ enum amd_hw_ip_block_type {
 	MAX_HWIP
 };
 
-#define HWIP_MAX_INSTANCE	8
+#define HWIP_MAX_INSTANCE	10
 
 struct amd_powerplay {
 	void *pp_handle;
-- 
2.30.2

