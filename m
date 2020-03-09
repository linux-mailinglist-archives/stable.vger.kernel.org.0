Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1639417E4E9
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 17:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgCIQlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 12:41:22 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43126 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgCIQlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 12:41:22 -0400
Received: by mail-pf1-f195.google.com with SMTP id c144so5053147pfb.10
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 09:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=6FQJZkm0UygJJFOENXPjP2IJliA7sx0EyXoCWTpQ5b4=;
        b=YHf6CPjxpFtYvxLoM/zH0EJCEN93kan72wNWpVR0F9nTdg9ur20JOkgvQnQL2YbXzs
         qaBI3rwgrZwdriMdrozrYugo/esVd7bObm6Bxl1sUe39dUx99Iv0UtTMRXKRyq+fgZUe
         DGRx8GRb1Oo/OvhVX96qofCmJAgbQUICMJJJ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6FQJZkm0UygJJFOENXPjP2IJliA7sx0EyXoCWTpQ5b4=;
        b=NBrxxs3QyQ+u5t0ppBeDFec0peqpTVgjROGh8pTctQb4yaVKq1uxb2kpCzbFEx1xl+
         P3bHA/Wy30ba2aipRUnrlstjShnZQufcDTfJmrg2cFUP3CsAct2LMAgxn+kz0P5ZFs0/
         qFrlbUoD6iyap2hLQXysHxdRdUikqLHhkzxIOYcF0Tz81KR7umAJhmzkuoe7zZ0pjBHk
         gBBB4xvGbR6k4n5/T/Pq2JcU+ac6ICwYkcDWTkTgS793/I11MF0nbAxDOaQCU+rk2FYb
         gC0WKaSAoIPbI01aMJdM2Kry4gSYD6FGMlrU+obGq7YL+9zplXJEWnBWhl2H/ubyC6/3
         0RCw==
X-Gm-Message-State: ANhLgQ23s5t3MitNxT1fF23D4zWRNVH+KbDbyxqnFuqnVWpeXEt/y62f
        mgS1XgL14dfwgBFroC7LuOs1JQ==
X-Google-Smtp-Source: ADFU+vsXNUGrxtBJKrhSPlCSQGk/BGbPaueE0ZAQ2zxy14www1wndRt9jOA6gu+yJzx5AJNmhkE3Qg==
X-Received: by 2002:a62:2f01:: with SMTP id v1mr17360630pfv.148.1583772081299;
        Mon, 09 Mar 2020 09:41:21 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h4sm2665554pfo.87.2020.03.09.09.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 09:41:20 -0700 (PDT)
Date:   Mon, 9 Mar 2020 09:41:19 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] slub: Improve bit diffusion for freelist ptr obfuscation
Message-ID: <202003090941.1F1FEE75@keescook>
References: <202003051623.AF4F8CB@keescook>
 <20200307232038.3880B2075A@mail.kernel.org>
 <202003081450.CEBF081F@keescook>
 <20200309005112.GU21491@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200309005112.GU21491@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 08, 2020 at 08:51:12PM -0400, Sasha Levin wrote:
> On Sun, Mar 08, 2020 at 02:51:27PM -0700, Kees Cook wrote:
> > On Sat, Mar 07, 2020 at 11:20:37PM +0000, Sasha Levin wrote:
> > > Hi
> > > 
> > > [This is an automated email]
> > > 
> > > This commit has been processed because it contains a "Fixes:" tag
> > > fixing commit: 2482ddec670f ("mm: add SLUB free list pointer obfuscation").
> > > 
> > > The bot has tested the following trees: v5.5.8, v5.4.24, v4.19.108, v4.14.172.
> > > 
> > > v5.5.8: Build failed! Errors:
> > >     mm/slub.c:262:4: error: implicit declaration of function ‘swab’; did you mean ‘swap’? [-Werror=implicit-function-declaration]
> > > 
> > 
> > Eek; this must be missing an include that is implicit from something
> > recent? I will investigate...
> 
> swab() didn't exist "back then" :) It was introduced by d5767057c9a7
> ("uapi: rename ext2_swab() to swab() and share globally in swab.h"). I
> can just take that patch to stable kernels.

Ah, perfect. Yes, that would be very nice.

-- 
Kees Cook
