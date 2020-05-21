Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E921DD9DA
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 00:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbgEUWGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 18:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728327AbgEUWGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 18:06:17 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2D7C05BD43
        for <stable@vger.kernel.org>; Thu, 21 May 2020 15:06:16 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m7so3532898plt.5
        for <stable@vger.kernel.org>; Thu, 21 May 2020 15:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=OhAMbFkeBYkh1YD4II233lD+yGJ3K0G9Oci8yZ/ZBA0=;
        b=bxpp78PWsbxwSFm6fyiRLWCl3wvWThr8h5f6oLQhDzrgcsFD/DEKoS7oK7x73h0A/T
         jkNibCb1jeIWkzy3aP6PUgSiyo949bJH8y5SprysWFZIm0TDKU7RGvQBn33uwRkJh/DS
         w/vFLbaIY20+q/biEmbBhYNgWajV+Fk2/gAYNIFmDHFsd5p59Wx5H484OmlaYPbjPym3
         sU2LetexScCIAqh6kkrHgoU1XctXZ50V31VsXmQRuTxWZbfSfJCOz5ubNXYZGK0wDSCE
         czWKmK0JYYzhmO0Xxs3ezU17nwQHdInAS2MJUDhzjKmXUL2kqju4Gh/ZtM1k6KWtl6KL
         6Mvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=OhAMbFkeBYkh1YD4II233lD+yGJ3K0G9Oci8yZ/ZBA0=;
        b=ILc/Fe0kQbFL4IaYM6hi/cDlykxyXJzBSp0P/Ywr2tFuVNzc0i8TENni/QOfchUsFy
         Sg1OHU6fduB4X3Z2M0d8e85xs7/ncZjsr9HtQHCnqlkEyxMlN6epWr1Ov8vIqQr8PQaU
         nnzLYvTkY/B9SHAuHhv1u6EiedJgeRAafTOpVH9KgFLxdw95upQmKhf49aOF7HUP0F7i
         QZ3pcDPqTUvsaf5K//VwjonSGA4YP0jLOCtG/4c44dKm8gYUHRBp4z0jvOV1Cq7xUbc5
         HVQoijZ0OQcH16bIHGTFlT0uTbJ2qjiw9IkllLTsN6A/iu8ffpeEe7Ndjb89ISIm9x64
         /qww==
X-Gm-Message-State: AOAM530Dfq1YNU5w5EeUjBBTED4Zcxsryu91LoHfl9sbQ5XUm+aqUKQY
        OMOWoMW6MrAAS5ghFgpy40d2Tw==
X-Google-Smtp-Source: ABdhPJwN1m6K9hPFs82tA6eWxV2r1TLL4YbjntnvjsyVqmjBlB6uawDniHorXAEwxlNqOq1bJjqFxA==
X-Received: by 2002:a17:90b:23d4:: with SMTP id md20mr776706pjb.164.1590098775476;
        Thu, 21 May 2020 15:06:15 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id d4sm2888946pjo.43.2020.05.21.15.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 15:06:14 -0700 (PDT)
Date:   Thu, 21 May 2020 15:06:14 -0700 (PDT)
X-Google-Original-Date: Thu, 21 May 2020 14:36:15 PDT (-0700)
Subject:     Re: [PATCH v2 1/3] irqchip/sifive-plic: Set default irq affinity in plic_irqdomain_map()
In-Reply-To: <20200518091441.94843-2-anup.patel@wdc.com>
CC:     Paul Walmsley <paul.walmsley@sifive.com>, tglx@linutronix.de,
        jason@lakedaemon.net, Marc Zyngier <maz@kernel.org>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        anup@brainfault.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <Anup.Patel@wdc.com>,
        stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     Anup Patel <Anup.Patel@wdc.com>
Message-ID: <mhng-724b2ebd-3b41-4b3e-8685-26860402e663@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 May 2020 02:14:39 PDT (-0700), Anup Patel wrote:
> For multiple PLIC instances, each PLIC can only target a subset of
> CPUs which is represented by "lmask" in the "struct plic_priv".
>
> Currently, the default irq affinity for each PLIC interrupt is all
> online CPUs which is illegal value for default irq affinity when we
> have multiple PLIC instances. To fix this, we now set "lmask" as the
> default irq affinity in for each interrupt in plic_irqdomain_map().
>
> Fixes: f1ad1133b18f ("irqchip/sifive-plic: Add support for multiple PLICs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> ---
>  drivers/irqchip/irq-sifive-plic.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
> index 822e074c0600..9f7f8ce88c00 100644
> --- a/drivers/irqchip/irq-sifive-plic.c
> +++ b/drivers/irqchip/irq-sifive-plic.c
> @@ -176,9 +176,12 @@ static struct irq_chip plic_chip = {
>  static int plic_irqdomain_map(struct irq_domain *d, unsigned int irq,
>  			      irq_hw_number_t hwirq)
>  {
> +	struct plic_priv *priv = d->host_data;
> +
>  	irq_domain_set_info(d, irq, hwirq, &plic_chip, d->host_data,
>  			    handle_fasteoi_irq, NULL, NULL);

If you're going to re-spin this, d->host_data could be priv here.

>  	irq_set_noprobe(irq);
> +	irq_set_affinity(irq, &priv->lmask);
>  	return 0;
>  }

Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
