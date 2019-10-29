Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17596E8614
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 11:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730616AbfJ2Kux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 06:50:53 -0400
Received: from forward105p.mail.yandex.net ([77.88.28.108]:35385 "EHLO
        forward105p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726175AbfJ2Kux (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Oct 2019 06:50:53 -0400
Received: from mxback30g.mail.yandex.net (mxback30g.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:330])
        by forward105p.mail.yandex.net (Yandex) with ESMTP id 466B54D41890;
        Tue, 29 Oct 2019 13:50:49 +0300 (MSK)
Received: from sas1-e6a95a338f12.qloud-c.yandex.net (sas1-e6a95a338f12.qloud-c.yandex.net [2a02:6b8:c08:37a4:0:640:e6a9:5a33])
        by mxback30g.mail.yandex.net (nwsmtp/Yandex) with ESMTP id prv0bwwOtD-ontqu6G0;
        Tue, 29 Oct 2019 13:50:49 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; s=mail; t=1572346249;
        bh=jduwSQJoGEIcWRg2hiWnE/M3uIcfKhtBYbUPGIA3qEI=;
        h=In-Reply-To:From:To:Subject:Cc:Date:References:Message-ID;
        b=p03N6vxVxS+eI7QMvFQ8rel15iQgyxucrjYAMK7I25h6P25uTkdjO6kX/+drF7Ucx
         bEquFatGt17ECcIWsxBds+cR2Olw+lhB1mRipNOjU2uWPyqMOa28r7lBgWuG27TIED
         flWIyKDdv/DC+PkQt79IY0wDgqdM8hmZ6rshpKRs=
Authentication-Results: mxback30g.mail.yandex.net; dkim=pass header.i=@flygoat.com
Received: by sas1-e6a95a338f12.qloud-c.yandex.net (nwsmtp/Yandex) with ESMTPSA id zBH7CLbfZX-ogVeiGb9;
        Tue, 29 Oct 2019 13:50:47 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH 4.14 027/119] MIPS: elf_hwcap: Export userspace ASEs
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Meng Zhuo <mengzhuo1203@gmail.com>,
        linux-mips@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Sasha Levin <sashal@kernel.org>
References: <20191027203259.948006506@linuxfoundation.org>
 <20191027203308.417745883@linuxfoundation.org>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <c7cea5a0-bb68-b8ad-0548-6f246465a8b6@flygoat.com>
Date:   Tue, 29 Oct 2019 18:50:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191027203308.417745883@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


在 2019/10/28 上午5:00, Greg Kroah-Hartman 写道:
> From: Jiaxun Yang <jiaxun.yang@flygoat.com>
>
> [ Upstream commit 38dffe1e4dde1d3174fdce09d67370412843ebb5 ]
>
> A Golang developer reported MIPS hwcap isn't reflecting instructions
> that the processor actually supported so programs can't apply optimized
> code at runtime.
>
> Thus we export the ASEs that can be used in userspace programs.
>
> Reported-by: Meng Zhuo <mengzhuo1203@gmail.com>
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> Cc: linux-mips@vger.kernel.org
> Cc: Paul Burton <paul.burton@mips.com>
> Cc: <stable@vger.kernel.org> # 4.14+
> Signed-off-by: Paul Burton <paul.burton@mips.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   arch/mips/include/uapi/asm/hwcap.h | 11 ++++++++++
>   arch/mips/kernel/cpu-probe.c       | 33 ++++++++++++++++++++++++++++++
>   2 files changed, 44 insertions(+)
>
> diff --git a/arch/mips/include/uapi/asm/hwcap.h b/arch/mips/include/uapi/asm/hwcap.h
> index 600ad8fd68356..2475294c3d185 100644
> --- a/arch/mips/include/uapi/asm/hwcap.h
> +++ b/arch/mips/include/uapi/asm/hwcap.h
> @@ -5,5 +5,16 @@
>   /* HWCAP flags */
>   #define HWCAP_MIPS_R6		(1 << 0)
>   #define HWCAP_MIPS_MSA		(1 << 1)
> +#define HWCAP_MIPS_MIPS16	(1 << 3)
> +#define HWCAP_MIPS_MDMX     (1 << 4)
> +#define HWCAP_MIPS_MIPS3D   (1 << 5)
> +#define HWCAP_MIPS_SMARTMIPS (1 << 6)
> +#define HWCAP_MIPS_DSP      (1 << 7)
> +#define HWCAP_MIPS_DSP2     (1 << 8)
> +#define HWCAP_MIPS_DSP3     (1 << 9)
> +#define HWCAP_MIPS_MIPS16E2 (1 << 10)
> +#define HWCAP_LOONGSON_MMI  (1 << 11)
> +#define HWCAP_LOONGSON_EXT  (1 << 12)
> +#define HWCAP_LOONGSON_EXT2 (1 << 13)
>   
>   #endif /* _UAPI_ASM_HWCAP_H */
> diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
> index 3007ae1bb616a..c38cd62879f4e 100644
> --- a/arch/mips/kernel/cpu-probe.c
> +++ b/arch/mips/kernel/cpu-probe.c
> @@ -2080,6 +2080,39 @@ void cpu_probe(void)
>   		elf_hwcap |= HWCAP_MIPS_MSA;
>   	}
>   
> +	if (cpu_has_mips16)
> +		elf_hwcap |= HWCAP_MIPS_MIPS16;
> +
> +	if (cpu_has_mdmx)
> +		elf_hwcap |= HWCAP_MIPS_MDMX;
> +
> +	if (cpu_has_mips3d)
> +		elf_hwcap |= HWCAP_MIPS_MIPS3D;
> +
> +	if (cpu_has_smartmips)
> +		elf_hwcap |= HWCAP_MIPS_SMARTMIPS;
> +
> +	if (cpu_has_dsp)
> +		elf_hwcap |= HWCAP_MIPS_DSP;
> +
> +	if (cpu_has_dsp2)
> +		elf_hwcap |= HWCAP_MIPS_DSP2;
> +
> +	if (cpu_has_dsp3)
> +		elf_hwcap |= HWCAP_MIPS_DSP3;
> +
> +	if (cpu_has_loongson_mmi)
> +		elf_hwcap |= HWCAP_LOONGSON_MMI;
> +
> +	if (cpu_has_loongson_mmi)
> +		elf_hwcap |= HWCAP_LOONGSON_CAM;

Hi:

Sorry, there is a typo causing build failure.

Should be:

---
  arch/mips/include/uapi/asm/hwcap.h | 11 ++++++++++
  arch/mips/kernel/cpu-probe.c       | 33 ++++++++++++++++++++++++++++++
  2 files changed, 44 insertions(+)

diff --git a/arch/mips/include/uapi/asm/hwcap.h b/arch/mips/include/uapi/asm/hwcap.h
index a2aba4b059e6..1ade1daa4921 100644
--- a/arch/mips/include/uapi/asm/hwcap.h
+++ b/arch/mips/include/uapi/asm/hwcap.h
@@ -6,5 +6,16 @@
  #define HWCAP_MIPS_R6		(1 << 0)
  #define HWCAP_MIPS_MSA		(1 << 1)
  #define HWCAP_MIPS_CRC32	(1 << 2)
+#define HWCAP_MIPS_MIPS16	(1 << 3)
+#define HWCAP_MIPS_MDMX     (1 << 4)
+#define HWCAP_MIPS_MIPS3D   (1 << 5)
+#define HWCAP_MIPS_SMARTMIPS (1 << 6)
+#define HWCAP_MIPS_DSP      (1 << 7)
+#define HWCAP_MIPS_DSP2     (1 << 8)
+#define HWCAP_MIPS_DSP3     (1 << 9)
+#define HWCAP_MIPS_MIPS16E2 (1 << 10)
+#define HWCAP_LOONGSON_MMI  (1 << 11)
+#define HWCAP_LOONGSON_EXT  (1 << 12)
+#define HWCAP_LOONGSON_EXT2 (1 << 13)
  
  #endif /* _UAPI_ASM_HWCAP_H */
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index c2eb392597bf..f521cbf934e7 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -2180,6 +2180,39 @@ void cpu_probe(void)
  		elf_hwcap |= HWCAP_MIPS_MSA;
  	}
  
+	if (cpu_has_mips16)
+		elf_hwcap |= HWCAP_MIPS_MIPS16;
+
+	if (cpu_has_mdmx)
+		elf_hwcap |= HWCAP_MIPS_MDMX;
+
+	if (cpu_has_mips3d)
+		elf_hwcap |= HWCAP_MIPS_MIPS3D;
+
+	if (cpu_has_smartmips)
+		elf_hwcap |= HWCAP_MIPS_SMARTMIPS;
+
+	if (cpu_has_dsp)
+		elf_hwcap |= HWCAP_MIPS_DSP;
+
+	if (cpu_has_dsp2)
+		elf_hwcap |= HWCAP_MIPS_DSP2;
+
+	if (cpu_has_dsp3)
+		elf_hwcap |= HWCAP_MIPS_DSP3;
+
+	if (cpu_has_mips16e2)
+		elf_hwcap |= HWCAP_MIPS_MIPS16E2;
+
+	if (cpu_has_loongson_mmi)
+		elf_hwcap |= HWCAP_LOONGSON_MMI;
+
+	if (cpu_has_loongson_ext)
+		elf_hwcap |= HWCAP_LOONGSON_EXT;
+
+	if (cpu_has_loongson_ext2)
+		elf_hwcap |= HWCAP_LOONGSON_EXT2;
+
  	if (cpu_has_vz)
  		cpu_probe_vz(c);
  
-- 2.23.0


