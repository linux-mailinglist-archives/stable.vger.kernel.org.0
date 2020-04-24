Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6381B72A1
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 13:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgDXLGs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 07:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgDXLGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 07:06:48 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6866C09B045;
        Fri, 24 Apr 2020 04:06:47 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id v2so3606079plp.9;
        Fri, 24 Apr 2020 04:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PbRSEAf2iP4s0AdgPIwTBI8UU6TRpGo2RmWTv12T7ho=;
        b=tI7YDPXrk0NS/QGz2+TanWURFuX4q+QSV6t/XrOp2ZC2U9/QeUh/S37qIZB5rnRPjb
         EDOUQrMldyMGZmpEvRZAtRdBcfXkuWvFwQaQ47ZhC38vly6rGgU24tXvUxcwVBL3fVhD
         jgKoM5yKiK7AxXYfhCynTlqMrReVId3Hd3CkLTudAJnsqkHi123QRU41/P8Og1OYVRZP
         DOq0wVZs+qN1GhkAf8wsZKztwnFz/nZdHg17OoVFAnOi3e5a7v6ZuFl6v82WEMy+7edE
         symx6Qj6IBlV00vGtJ/1sfFIVZH2BxpW4NRYQ0IRFWcny7bNXEq/piEmVY9rqhtAh7dc
         r7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=PbRSEAf2iP4s0AdgPIwTBI8UU6TRpGo2RmWTv12T7ho=;
        b=joM7wF+gab8IyuzMD069Vp/wBCGqdCZPc0buVp8JeLJf8+H5gdwISRd5GAPhrdC4WP
         AqmhBzLlN7Qqhdd5T06lVtg/i5lD+PSGl6nl6JHlXJEEboKYZpeb0akstE0LqwUymMKV
         o/uKzdyTwGH7d4LrFp2MqqpqOhztzzjX1LapFxJUH+8WW8ySKg92QRNP7AmM0pzrInrS
         MiFAXEytjbYDhjzK8rhgH7kiYvR3w/NdKviGsFcBh7Ggvt9Q0o0bDzQ9lej1DdgHPQuA
         XET+ufZLIoh4QwjU0x548nEhAbUVOk320jlJpoieX5XRtpvw+CKEdZ+5FC6TliVMRJeN
         v2FQ==
X-Gm-Message-State: AGi0PuZQ+eFik7zn+z157J55BxXHVRDXUuhy8yMfHVUNnqUdZj9fmPj/
        Svbus/1PIBEIfWe4oPlD2hUrncuzmAo=
X-Google-Smtp-Source: APiQypIeKfPUIaMdSUZT4R8efpeU1guWS/zOvrO3qTYIBnTd+jwlffLhauGQ3JW+CjQgTc5B1I6nSQ==
X-Received: by 2002:a17:90a:270d:: with SMTP id o13mr5612686pje.34.1587726407471;
        Fri, 24 Apr 2020 04:06:47 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id y10sm5470110pfb.53.2020.04.24.04.06.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 04:06:46 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Xing Li <lixing@loongson.cn>, stable@vger.kernel.org,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V2 01/14] KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
Date:   Fri, 24 Apr 2020 19:15:20 +0800
Message-Id: <1587726933-31757-2-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
References: <1587726933-31757-1-git-send-email-chenhc@lemote.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xing Li <lixing@loongson.cn>

The code in decode_config4() of arch/mips/kernel/cpu-probe.c

        asid_mask = MIPS_ENTRYHI_ASID;
        if (config4 & MIPS_CONF4_AE)
                asid_mask |= MIPS_ENTRYHI_ASIDX;
        set_cpu_asid_mask(c, asid_mask);

set asid_mask to cpuinfo->asid_mask.

So in order to support variable ASID_MASK, KVM_ENTRYHI_ASID should also
be changed to cpu_asid_mask(&boot_cpu_data).

Cc: stable@vger.kernel.org
Signed-off-by: Xing Li <lixing@loongson.cn>
[Huacai: Change current_cpu_data to boot_cpu_data for optimization]
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 arch/mips/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index 2c343c3..a01cee9 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -275,7 +275,7 @@ enum emulation_result {
 #define MIPS3_PG_FRAME		0x3fffffc0
 
 #define VPN2_MASK		0xffffe000
-#define KVM_ENTRYHI_ASID	MIPS_ENTRYHI_ASID
+#define KVM_ENTRYHI_ASID	cpu_asid_mask(&boot_cpu_data)
 #define TLB_IS_GLOBAL(x)	((x).tlb_lo[0] & (x).tlb_lo[1] & ENTRYLO_G)
 #define TLB_VPN2(x)		((x).tlb_hi & VPN2_MASK)
 #define TLB_ASID(x)		((x).tlb_hi & KVM_ENTRYHI_ASID)
-- 
2.7.0

