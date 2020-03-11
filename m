Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 551201822AC
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 20:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbgCKTl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 15:41:27 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36867 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730705AbgCKTl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 15:41:26 -0400
Received: by mail-oi1-f194.google.com with SMTP id w13so3101583oih.4;
        Wed, 11 Mar 2020 12:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dI6sJcdtz7nc50Bt/3fFcsotsOXM7BkdNH0XrYOC1w0=;
        b=SehN6XSBNOQwcDg+tUtHwa4z9mz9AKT2G4MyjvG9P/Njven5E6k/+A7jTHT0fsbIZX
         lq1MLTmaPi7/b8Ywj3yEvI0YzFJtG156VCEtUj40e0b5d7/8lupkyNFWYwIpPt2/loEC
         Zf4HWeGBHoxunIf/knTwmVCmjdB9K9dIgscInoJGZiemQlEt5lDL9cNi/qThD5t2Tdp4
         4DVuVEv7NkHPOf6N0RE+QKpuH+SVc4x2iGrvFlzslkG3S2l9D7LUBUOUGttIw82ZN3IP
         KPBwYquOsu3Q/h7vj/lb56SdtvDeCglDuJZT5nhU6mEwjg2dPKb35mXDxjizci1Z2uvC
         VHIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dI6sJcdtz7nc50Bt/3fFcsotsOXM7BkdNH0XrYOC1w0=;
        b=kNqzEdbrQQbS3d0HYihsMwmDCEDlGOaprtUiC3qBDNMFIGYj91rwz25fEi6mDgnBoL
         9teSRnw34t04M0s0JRZnM0Gwc/RXpBvUC6YwIr49v99hCFwkhOHDIjDCI+ITh8AO72U4
         TPkUQmunKomWY8v0Cqhx3cbBbhEHYjKzeSb56YaJuLGe3JI1X729hx9hU2Obxge9aJzb
         cikrkuVqm8ryIQsDXWAmVgVaJEhI6rIFQh7KLV34Ah42Gkii5780buI/dZ4T42GR6ZyS
         66nFS3GswuWmbJ2FQOwcb0Ldoxc1X2IbIyiBr1INiMSMxCLefVLR9So0knZBiVM6BgJp
         eU9g==
X-Gm-Message-State: ANhLgQ19RRbidOZj8oqA6rXJ2Z1xX3ONlGOBVll9fLxHltk+HS+Y+tqg
        Jea7W9kzEN230i9bcC1RlPrRNLYTTGI=
X-Google-Smtp-Source: ADFU+vtzYTnJDvxK3gb2rD75KnJUGe55yv0DIIhmKiswyMDrFoILdSz87k7h9AgbWJhsFx+vO/bAgQ==
X-Received: by 2002:aca:db56:: with SMTP id s83mr192818oig.171.1583955686120;
        Wed, 11 Mar 2020 12:41:26 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id c3sm4520955otl.81.2020.03.11.12.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 12:41:25 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>
Cc:     linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] kbuild: Disable -Wpointer-to-enum-cast
Date:   Wed, 11 Mar 2020 12:41:21 -0700
Message-Id: <20200311194121.38047-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.26.0.rc1
In-Reply-To: <20200308073400.23398-1-natechancellor@gmail.com>
References: <20200308073400.23398-1-natechancellor@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Clang's -Wpointer-to-int-cast deviates from GCC in that it warns when
casting to enums. The kernel does this in certain places, such as device
tree matches to set the version of the device being used, which allows
the kernel to avoid using a gigantic union.

https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L428
https://elixir.bootlin.com/linux/v5.5.8/source/drivers/ata/ahci_brcm.c#L402
https://elixir.bootlin.com/linux/v5.5.8/source/include/linux/mod_devicetable.h#L264

To avoid a ton of false positive warnings, disable this particular part
of the warning, which has been split off into a separate diagnostic so
that the entire warning does not need to be turned off for clang. It
will be visible under W=1 in case people want to go about fixing these
easily and enabling the warning treewide.

Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/887
Link: https://github.com/llvm/llvm-project/commit/2a41b31fcdfcb67ab7038fc2ffb606fd50b83a84
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

v1 -> v2:

* Move under scripts/Makefile.extrawarn, as requested by Masahiro

 scripts/Makefile.extrawarn | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index ecddf83ac142..ca08f2fe7c34 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -48,6 +48,7 @@ KBUILD_CFLAGS += -Wno-initializer-overrides
 KBUILD_CFLAGS += -Wno-format
 KBUILD_CFLAGS += -Wno-sign-compare
 KBUILD_CFLAGS += -Wno-format-zero-length
+KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
 endif
 
 endif
-- 
2.26.0.rc1

