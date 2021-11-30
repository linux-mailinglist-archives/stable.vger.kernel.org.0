Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C013462DF6
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 08:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbhK3H7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 02:59:08 -0500
Received: from mail-pj1-f46.google.com ([209.85.216.46]:38555 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239244AbhK3H7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 02:59:06 -0500
Received: by mail-pj1-f46.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so17634596pju.3;
        Mon, 29 Nov 2021 23:55:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=VYPuISL5AV9b4E/5sq8DgKC5OFOrBQe6hWM4JGgFD7o=;
        b=qNoOGEFgWIZgA4tBDVsZq62otoKejdLUpOuiIKkoyzRNXYTl0KYfifv92sRraIt+EX
         trgR1zG4w1zkea3rXjCfjB8J3vi0QuRLVc7NPJviKuuzD1iT37GeO66cnXBN5+6K99xw
         OeAGPLPvoKxB5HQOpi1ELZvpvULuGgt9xbviWbifSbRSJ75PBw0yGGeluqcAb6HyHcsF
         /qRR9OYPhpaUP+HZ7TJU1yZjtExy/lTAF8saW2md/h5grxYHcgScbIl+AP7leU34Pn2A
         yTpqVv5xICoEBHFiLEQBOXKJPuriEHDqRolwMRHxCL1696FxeOBfDOVKnQTZXk9yIx7r
         xdCg==
X-Gm-Message-State: AOAM533yCIKFaAFZ3ab5CjxEPcCS6xzQ6G9ig8z9nBNzA7kwkiA0QMrW
        RWjpJG3gGVd+dfgj3h7NG2FVLuBJZW5o3A==
X-Google-Smtp-Source: ABdhPJz04yNg4GA4sIOYmmtxvpiWBf/F88jQ6hPP605g1rdkloZvN21YQRwYETsFQa6KnRACldUzrg==
X-Received: by 2002:a17:90a:4414:: with SMTP id s20mr4170745pjg.132.1638258947157;
        Mon, 29 Nov 2021 23:55:47 -0800 (PST)
Received: from rocinante ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id s38sm13895518pga.40.2021.11.29.23.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 23:55:46 -0800 (PST)
Date:   Tue, 30 Nov 2021 08:55:36 +0100
From:   Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Toan Le <toan@os.amperecomputing.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>,
        stable@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: xgene: Fix IB window setup
Message-ID: <YaXY+E2Uto4O43c3@rocinante>
References: <20211129173637.303201-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211129173637.303201-1-robh@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
> broke PCI support on XGene. The cause is the IB resources are now sorted
> in address order instead of being in DT dma-ranges order. The result is
> which inbound registers are used for each region are swapped. I don't
> know the details about this h/w, but it appears that IB region 0
> registers can't handle a size greater than 4GB. In any case, limiting
> the size for region 0 is enough to get back to the original assignment
> of dma-ranges to regions.

A small nitpick: it would be "X-Gene" in the above as per Applied Micro's
(or rather MACOM Technology Solutions these days, I suppose) product line
naming.

> @@ -465,7 +465,7 @@ static int xgene_pcie_select_ib_reg(u8 *ib_reg_mask, u64 size)
>  		return 1;
>  	}
>  
> -	if ((size > SZ_1K) && (size < SZ_1T) && !(*ib_reg_mask & (1 << 0))) {
> +	if ((size > SZ_1K) && (size < SZ_4G) && !(*ib_reg_mask & (1 << 0))) {
>  		*ib_reg_mask |= (1 << 0);
>  		return 0;
>  	}

Thank you!

Reviewed-by: Krzysztof Wilczyński <kw@linux.com>

Also, thank you Stéphane for testing!  Much appreciated!

	Krzysztof
