Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C12C3FE7DF
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 23:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfKOWeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 17:34:13 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35528 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbfKOWeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 17:34:12 -0500
Received: by mail-pg1-f196.google.com with SMTP id k32so918086pgl.2
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 14:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0FzUVopNzASq04/LVv5rKzD9cgfLq5ObIrBYoMo9qvk=;
        b=lUnyeeCJ4IPMz/XNH2z+dyXgbsLnZDQySzkmpacsxLxrXVqQl5YYPtMDCr/HHxKjVR
         hU7Y+LuaiVCYaAjIOQjWN7XE8ySh88tskiNLwFDvEcME9WjRgKWKI31q/MYW4ijhkG95
         iB/cXtsbnEgCUngeVPLDAl6BX33rNqrbYi6fcdGtnxKTNTBQFt/aemX3uKRsgXeS0agk
         m5dsnfapvZLJb77v9GDsdm0umUO3c/oDvqDF0UXRKla1EvNzWUNN+FQGF9bj+EE7X21B
         IdzvJlAJMLMIe18u6ncmei3dFZe6zL8vc2bVx70r1wV15uwQTsYgUDsMuE3R/50EMWIJ
         uu2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0FzUVopNzASq04/LVv5rKzD9cgfLq5ObIrBYoMo9qvk=;
        b=EjzA60yPe6PbTRWaqVFCIyeRWr7fCGjA7vIl28y+h5NM+LWxJXvBo2Z2xjbItyv03b
         Y/G+tJzQWcZDTbcWabzoIi8xL2oBri3Z9fMY3E4EbFYC8tdmfJL0rbQZgfPIM22S2Xb3
         7Lc/6tQskvYh55tLv8cESeVkjDYmpcOjHCOeyDJmbCr+HurS1L1urytJ8KwlG8wwTASr
         04eB9YnlZ1PUhDOeSTdwLrYT8v7kQPoe55p9h6KQAw0Ew6YYsapv/EZh94wpK+VuYAnh
         xvsV0B1z+ORXtAtmGf4boVX6BkqLMMe0efjrXQWYcd+CIwRmbiRNX4LHZQS2aKC2v9OD
         jPXw==
X-Gm-Message-State: APjAAAXLdPsWV6t8siUNX6+IpPFsR473yisf6r6EBicAAF3gZTzbKZ2I
        A19exM3fqEN3ZmuYm3rpssS3adcA7b0=
X-Google-Smtp-Source: APXvYqwIfu18fK0DfDJ9UvpBvk2czYs+yHL1APaCSoHaNFjaDFHmk39inhfdV0r/CZWJE79UEyL9tw==
X-Received: by 2002:aa7:843d:: with SMTP id q29mr20193053pfn.156.1573857251386;
        Fri, 15 Nov 2019 14:34:11 -0800 (PST)
Received: from xps15.cg.shawcable.net (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id m15sm11699724pfh.19.2019.11.15.14.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 14:34:10 -0800 (PST)
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [stable 4.19+][PATCH 16/20] ASoC: stm32: i2s: fix 16 bit format support
Date:   Fri, 15 Nov 2019 15:33:52 -0700
Message-Id: <20191115223356.27675-16-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191115223356.27675-1-mathieu.poirier@linaro.org>
References: <20191115223356.27675-1-mathieu.poirier@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@st.com>

commit 0c4c68d6fa1bae74d450e50823c24fcc3cd0b171 upstream

I2S supports 16 bits data in 32 channel length.
However the expected driver behavior, is to
set channel length to 16 bits when data format is 16 bits.

Signed-off-by: Olivier Moysan <olivier.moysan@st.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable <stable@vger.kernel.org> # 4.19+
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 sound/soc/stm/stm32_i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/stm/stm32_i2s.c b/sound/soc/stm/stm32_i2s.c
index 449bb7049a28..004d83091505 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -501,7 +501,7 @@ static int stm32_i2s_configure(struct snd_soc_dai *cpu_dai,
 	switch (format) {
 	case 16:
 		cfgr = I2S_CGFR_DATLEN_SET(I2S_I2SMOD_DATLEN_16);
-		cfgr_mask = I2S_CGFR_DATLEN_MASK;
+		cfgr_mask = I2S_CGFR_DATLEN_MASK | I2S_CGFR_CHLEN;
 		break;
 	case 32:
 		cfgr = I2S_CGFR_DATLEN_SET(I2S_I2SMOD_DATLEN_32) |
-- 
2.17.1

