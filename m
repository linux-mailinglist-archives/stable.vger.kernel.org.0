Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF752CFDD5
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 17:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbfJHPkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 11:40:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38277 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfJHPkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 11:40:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id 3so3617990wmi.3
        for <stable@vger.kernel.org>; Tue, 08 Oct 2019 08:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/vtISEtUshe9NBLXroiK2UL/EjV2n3/vwtTUKw/aRUg=;
        b=wClrywn5UcceOArqPVuFG5qra/XM6cZtX5DJAjrVEQ6P3d4L+EjGNzW/MpRKhBcIaG
         J9HsmQ0BProl6Vcac0VvkGjBaPy4j/I8j579RADXXKYnRJpVp/q1BF4cYTfKI7qyV1bd
         kzyj212cWgbL10r9YpsRYZVd9GEjmFpIoZCSKa4wo0j/PeCYLcArzdAc47nm3Zkzl50b
         9Uz2LcEz/Oky1r9nEsJcBl5KVhiUSLNi6PlpwHg3lZjwmqg1KResZ6Py8GLN5dfxB9Qk
         hxtb9BaABS++wxkzCa0e3g2aflnAipyDYjz+THMbhRM+vGS+G6LZLbruSenT/0Jirqdx
         NXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/vtISEtUshe9NBLXroiK2UL/EjV2n3/vwtTUKw/aRUg=;
        b=eITOSgWxn00+wUquZmf2APTGkUs3Jz+0y66tGKI8WDzq8q+haaDGF8cvh50GsKor3f
         OwwIuRTd2aO2B/O5Z+8cnqtIHJKG356F0JuXYlFmrKt3ojOvT63Ws/YaOBXtdrwcD5l5
         9aW0ACszCVrKRkVjHdzRGDH9Dc760VsS/MDGY+Z2PQ2QNi9t0fM0TdtokO1B6woLGXTZ
         cT95aHZgv+CYanq11zGiMiB6wIzgMSSV9N7ueRrIK2JJBSvqRltkD++JVit5o/Keprp+
         A2nEntQxWoHMQPdy2hYsPGYBScCUDXrxVQho7nSNK16hQJIlKSex4kNWA2iYLAXT5hYu
         WzVQ==
X-Gm-Message-State: APjAAAWeHswlwUno5Do/EOpGHT9x41IQGdW3VScXiCE1hWcEu89fasdN
        Va7ZthxDUwmYbVSShHWLnaE36Q==
X-Google-Smtp-Source: APXvYqxFgFAFIFAlikaO+CHAaCebM4FYhoCtoCnhF00EWGcXRmoAlDFtYiCUGLNTma/t+OHQoE3LRw==
X-Received: by 2002:a05:600c:2319:: with SMTP id 25mr4461682wmo.3.1570549215716;
        Tue, 08 Oct 2019 08:40:15 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id x16sm16784723wrl.32.2019.10.08.08.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 08:40:14 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Mian Yousaf Kaukab <ykaukab@suse.de>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH for-stable-v4.19 06/16] arm64: Add sysfs vulnerability show for spectre-v1
Date:   Tue,  8 Oct 2019 17:39:20 +0200
Message-Id: <20191008153930.15386-7-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
References: <20191008153930.15386-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mian Yousaf Kaukab <ykaukab@suse.de>

[ Upstream commit 3891ebccace188af075ce143d8b072b65e90f695 ]

spectre-v1 has been mitigated and the mitigation is always active.
Report this to userspace via sysfs

Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/cpu_errata.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 7fe3a60d1086..3758ba538a43 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -729,3 +729,9 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	{
 	}
 };
+
+ssize_t cpu_show_spectre_v1(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	return sprintf(buf, "Mitigation: __user pointer sanitization\n");
+}
-- 
2.20.1

