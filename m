Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E081DF5C7
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 09:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387689AbgEWH4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 03:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387627AbgEWH4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 May 2020 03:56:37 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3DAC05BD43;
        Sat, 23 May 2020 00:56:37 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id f21so3083446pgg.12;
        Sat, 23 May 2020 00:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qfp4yZyJhFbbwPcF+vBxspab423+TYrLon5VaFM6mOQ=;
        b=qKt68FL6knNx22492KjI7dofR8nLWj1uFsCNtT9M+/7gH8jAfO4j90PM8e03Xne0Ug
         dNGBaboyHUe7RTkxi+tkMyTbTZ5sGq/RMiY5xHfzfeVyWs+hOV6Ox7BhiVIczUpThKLI
         fIKunyYzoK6AR1kqTvG+dlYXZL3SLbcprkvS7HXqQCy+94Fioj8wKTR0nMqXkdaaRO34
         j27N5+v1d74RHX49D8j/51v9YxM5oD1pVUQtN0WLf9LDY9WydgA9FcOK48pn7M9oemeC
         yLq8XoITOIFhL8U7aBcf7p03MRCMWem+t2G+O2whXLdrTJjoY7wwDfRkHipI6nSjESzS
         D6/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=Qfp4yZyJhFbbwPcF+vBxspab423+TYrLon5VaFM6mOQ=;
        b=RVn5G9hUaYynwsqTHlAS1tgu2dSWEd/Zpz4EFpgISf9W0oZztjAKfIiwPJ7zJWUiOa
         o5no2ieg8CMDgt+sr7P+tvsbkmLF9ROxeaO0LpdMoHHUipY/up3ES6SCmLajX1MQFMkd
         wbUA206bmJAWU6v5nWF3VRN6gg7j9hHuKFNv/sBUGDfoqWOlOSZ2+pyS+ZwpTAfOabKV
         YdIns60K5hEJWOxJArLi662Vyw/P0NiKbEFTWzshA4pQ/KcqrRzyry4CaECtYyDxyY1r
         9D9K+03j4d8YDwii+Tnbx6YjQXqDrvNUhkXEqCbt7Wh1WZflWS4q8giCY3JxSGaUaiEi
         9tEw==
X-Gm-Message-State: AOAM532ssyViVb2Xmp38viL3tKo2KP/mD8j3ISEK/e9ZKh2Gn3FXLlS3
        J0nM2znd4BV6qnaX3GcqmDg=
X-Google-Smtp-Source: ABdhPJyNeZUAnuYrVDbTxjPNLgE78WW8noHorDS/yW0zaDqkSzMEvLMUwxZukXfB/c4DhEFNqmB+8A==
X-Received: by 2002:a62:b402:: with SMTP id h2mr7806324pfn.221.1590220597128;
        Sat, 23 May 2020 00:56:37 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id w7sm678491pfu.117.2020.05.23.00.56.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 May 2020 00:56:36 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Xing Li <lixing@loongson.cn>,
        "Stable #4 . 9+" <stable@vger.kernel.org>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH V7 01/15] KVM: MIPS: Define KVM_ENTRYHI_ASID to cpu_asid_mask(&boot_cpu_data)
Date:   Sat, 23 May 2020 15:56:28 +0800
Message-Id: <1590220602-3547-2-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
References: <1590220602-3547-1-git-send-email-chenhc@lemote.com>
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

Cc: Stable <stable@vger.kernel.org>  #4.9+
Reviewed-by: Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>
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

