Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C423236DA
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 06:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhBXF3K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 00:29:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbhBXF3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 00:29:09 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8007C061574;
        Tue, 23 Feb 2021 21:28:29 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o6so560700pjf.5;
        Tue, 23 Feb 2021 21:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hi+AZFYgCXbYt2WMhW/I8Ur+lvFGHwgs4K8iNAqVuQ8=;
        b=r4yFDs1Y24MbSbSh6W9/Vbaj4iskoM7h9rnUs5fX7Ugo8eOBKrz3Uk0WmLoY8xrgrR
         V57STqJyN8WwWEUj4KguJ0htbAqul/cPWt5Wb+kDe6aCUZQGCuq67z8m/I16mm69Cijx
         w8lpR1Uy/TxQbSEEhmuAxBgMHfaL4XHpsHAfbkRO51kVE9vAMdoaXYO57P5acLDPU3D8
         QkDqEdsPzj4BKZ+cRRPrnhvkLGqgSsMP5s5ZtMpg91o9nDb+Ot0laWijO0wmx7TnIfAu
         5nPugtf+jDRAnmKSFg/tDtzugG/iqeC3gJ6WEsjMib6wxiAlWggOFLaRde2BLXi8axqP
         O3HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hi+AZFYgCXbYt2WMhW/I8Ur+lvFGHwgs4K8iNAqVuQ8=;
        b=jdcclAu8RaDeSEL/Id1p25hXZMM/hvdjMgl/moOWC9YdpaC5L0q4FQPHUR3TfOAEfI
         voCit8EAdWcLeOhYX6mu+9+ZO9uG8snxNOrvjjM2eQcLhU9kamAomf2Vdi6gghdOdVvO
         BPoTxdZAUPZKF3hy/9Crx0j9Aw1y+oslFs4OQum1bXxykbUhuKhmXLSjfZYyluHDTOSG
         bNm/52IGE7+L+9soTxasdz5REJSndJvbwi1YfPBEHiawsbzlMWFIbfehQH4iEb9uDJkc
         VEvtSgoApY74sLxI32ZQbmsrL2uSIykZCToFj0RUmAV/EPOtSZYaGPGuMdPuP+eA+bU3
         1OmA==
X-Gm-Message-State: AOAM533M4O7+XlfO606zGqFXYt6axsEWU+6nh4wKGwgmOrdaP2vXddwh
        ydzLdpDD8ZaZqsdkimR9b5fc9JFWrcEyUA==
X-Google-Smtp-Source: ABdhPJwh7E55NwVg7SB/yPu5NMeSWBtHE3B+15k+Moq13uQxrVGcjp4MKHyPwRn9RPFC6j0rGiSO0w==
X-Received: by 2002:a17:90a:517:: with SMTP id h23mr2656543pjh.108.1614144509229;
        Tue, 23 Feb 2021 21:28:29 -0800 (PST)
Received: from localhost.localdomain (host-61-70-202-235.static.kbtelecom.net. [61.70.202.235])
        by smtp.googlemail.com with ESMTPSA id w13sm6631693pjg.0.2021.02.23.21.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 21:28:28 -0800 (PST)
From:   Kun-Chuan Hsieh <jetswayss@gmail.com>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, jolsa@kernel.org, andrii@kernel.org,
        Kun-Chuan Hsieh <jetswayss@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2] tools/resolve_btfids: Fix build error with older host toolchains
Date:   Wed, 24 Feb 2021 05:27:52 +0000
Message-Id: <20210224052752.5284-1-jetswayss@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Older libelf.h and glibc elf.h might not yet define the ELF compression
types.

Checking and defining SHF_COMPRESSED fix the build error when compiling
with older toolchains. Also, the tool resolve_btfids is compiled with host
toolchain. The host toolchain is more likely to be older than the cross
compile toolchain.

Cc: stable@vger.kernel.org

Signed-off-by: Kun-Chuan Hsieh <jetswayss@gmail.com>
---
 tools/bpf/resolve_btfids/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index 7409d7860aa6..80d966cfcaa1 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -260,6 +260,11 @@ static struct btf_id *add_symbol(struct rb_root *root, char *name, size_t size)
 	return btf_id__add(root, id, false);
 }
 
+/* Older libelf.h and glibc elf.h might not yet define the ELF compression types. */
+#ifndef SHF_COMPRESSED
+#define SHF_COMPRESSED (1 << 11) /* Section with compressed data. */
+#endif
+
 /*
  * The data of compressed section should be aligned to 4
  * (for 32bit) or 8 (for 64 bit) bytes. The binutils ld
-- 
2.25.1

