Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50CA917D68B
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 22:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgCHVvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Mar 2020 17:51:32 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45790 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbgCHVvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Mar 2020 17:51:32 -0400
Received: by mail-pg1-f193.google.com with SMTP id m15so3783502pgv.12
        for <stable@vger.kernel.org>; Sun, 08 Mar 2020 14:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZlOalXGJ0g4v25xci+HBe6kQtIUiwlu5j/yrHHeZbSo=;
        b=T0qmzo+1x50fSlJDK0+8r30oDpXt7n9DPiLjkg/c+hCP9MRGcUJq65Q1dXTrXWBNYB
         Z+dW9jgDRmE4PJHLuUdJiBZWsfCmTj3zTxmUfupgGjuM5b5oj4Bla3NQrb6mXGjPedbG
         oePFsjWAXNIk+Jl8Z/CchvR649KNzoDcGoBXo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZlOalXGJ0g4v25xci+HBe6kQtIUiwlu5j/yrHHeZbSo=;
        b=gswUgkQyjd72TKHFbOqREnMnnJox2u/ryYMRw3joA6OQTV5EDfgHDYDFUKDejPvcOS
         iewzi9VRxiALo+/X20hERZphVy71f/8c927l2VrG7wKQxq7xnHkd6cVptDrmFbE8MEtM
         Hv6QH/RwkpJcp/HQGeS6awHmdT7rL06CvsQlpw41ZkkumSoevfhn7TISyUF/+j8BoPwR
         LtDAgVot8n9fhFg7YEX18ep24gwaWDOYmB8DKpUWBbje6XWjB0KN1gl32fZDr0Ka2A27
         3WLh0m4GvLhrNNwKwvj6Hjph6iIFzAlLhT0jmxNayvAaCuiWIvXtHdOCbDXMPFtLEe+P
         jqrQ==
X-Gm-Message-State: ANhLgQ214vk1cb18RIqyx/agAR/i5rlL47b4OJnkeMzRm2QjwtvM2tgw
        vIIrRAXtW1oFs3QaGmJGvJmYqApnHdo=
X-Google-Smtp-Source: ADFU+vvz56MZaLHLiMYAY3J1U/EjtjkxRPGKZF3DRJArQPYrDp4M79xuJL4hGywWgWiZBiuTID95sA==
X-Received: by 2002:a62:1b12:: with SMTP id b18mr3010055pfb.258.1583704289673;
        Sun, 08 Mar 2020 14:51:29 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u126sm42358894pfu.182.2020.03.08.14.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2020 14:51:28 -0700 (PDT)
Date:   Sun, 8 Mar 2020 14:51:27 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] slub: Improve bit diffusion for freelist ptr obfuscation
Message-ID: <202003081450.CEBF081F@keescook>
References: <202003051623.AF4F8CB@keescook>
 <20200307232038.3880B2075A@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200307232038.3880B2075A@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 07, 2020 at 11:20:37PM +0000, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: 2482ddec670f ("mm: add SLUB free list pointer obfuscation").
> 
> The bot has tested the following trees: v5.5.8, v5.4.24, v4.19.108, v4.14.172.
> 
> v5.5.8: Build failed! Errors:
>     mm/slub.c:262:4: error: implicit declaration of function ‘swab’; did you mean ‘swap’? [-Werror=implicit-function-declaration]
> 

Eek; this must be missing an include that is implicit from something
recent? I will investigate...

-Kees

> v5.4.24: Build failed! Errors:
>     mm/slub.c:264:4: error: implicit declaration of function ‘swab’; did you mean ‘swap’? [-Werror=implicit-function-declaration]
> 
> v4.19.108: Failed to apply! Possible dependencies:
>     d36a63a943e3 ("kasan, slub: fix more conflicts with CONFIG_SLAB_FREELIST_HARDENED")
> 
> v4.14.172: Failed to apply! Possible dependencies:
>     d36a63a943e3 ("kasan, slub: fix more conflicts with CONFIG_SLAB_FREELIST_HARDENED")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 
> -- 
> Thanks
> Sasha

-- 
Kees Cook
