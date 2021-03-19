Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E782534145C
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 05:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhCSEqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 00:46:19 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:45838 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbhCSEqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 00:46:01 -0400
Received: by mail-wm1-f47.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo4525113wmq.4;
        Thu, 18 Mar 2021 21:46:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=scHpeEvXZJxUtO28cL3xBc5mW0T6oSgAncD6re2VLx0=;
        b=Hg8lYD3M6pJKAkqTSccHg3MO8rm+y+f4YA63bMvfYRufVLcqPVZX2OCJ++UJ5Eui9O
         f1fU0x0mhtAARSdbGD1xVYJ/SYPvL4hr+t+17QYLSuyerviOOkdj0LxGdgB9XixN2c2Q
         RZ7fH7lkcxy3xL4T47ZlW0RfLxKOmQXgMLslomsUkfpGuulk33I7wJhx57VBgauI79hJ
         1rd2Gb7EyrVKuqOfGAef5MmOUafBWdEAD+OjSSqzu/Thzq2/8xYw+MXG/VTopXKq5D2Z
         muFVHnyvqrkYZQvs6puI2q/wd7p7E4Senl1dPC1T4RpkuUDm76mFxvjP9tqn1N0j06Vc
         WwDw==
X-Gm-Message-State: AOAM532NeBIVPe2RQXwmpw9YSsz/I33QKcNwyZvYDy74ebH8xgmnb1/I
        68ttDyDK6K3nGpWa9xizUsE=
X-Google-Smtp-Source: ABdhPJzQItZ7vJfQkjljBfAh+t+TcfDCRltPaw207Oi/uCSM/4wNPdhhzq/bK3DCLBxz5QYVG0j5nw==
X-Received: by 2002:a1c:6707:: with SMTP id b7mr1932695wmc.185.1616129160554;
        Thu, 18 Mar 2021 21:46:00 -0700 (PDT)
Received: from rocinante ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id c8sm6211170wrd.55.2021.03.18.21.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 21:45:59 -0700 (PDT)
Date:   Fri, 19 Mar 2021 05:45:58 +0100
From:   Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Rob Herring <robh+dt@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Lokesh Vutla <lokeshvutla@ti.com>, stable@vger.kernel.org
Subject: Re: [PATCH] PCI: keystone: Let AM65 use the pci_ops defined in
 pcie-designware-host.c
Message-ID: <YFQshiQIORaF7tr0@rocinante>
References: <20210317131518.11040-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210317131518.11040-1-kishon@ti.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Kishon,

Thank you for the fix!

[...]
> @@ -798,7 +798,8 @@ static int __init ks_pcie_host_init(struct pcie_port *pp)
>  	int ret;
>  
>  	pp->bridge->ops = &ks_pcie_ops;
> -	pp->bridge->child_ops = &ks_child_pcie_ops;
> +	if (!ks_pcie->is_am6)
> +		pp->bridge->child_ops = &ks_child_pcie_ops;
>  
>  	ret = ks_pcie_config_legacy_irq(ks_pcie);
>  	if (ret)
[...]

Reviewed-by: Krzysztof Wilczyński <kw@linux.com>

Krzysztof
