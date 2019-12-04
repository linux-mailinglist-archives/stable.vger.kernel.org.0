Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24226113620
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 21:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbfLDUGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 15:06:16 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37218 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbfLDUGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 15:06:16 -0500
Received: by mail-pl1-f194.google.com with SMTP id bb5so179429plb.4;
        Wed, 04 Dec 2019 12:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=nAAemCfKXeNgaOb0ZS9qFXJo3PaIk8Vnx3DCMlOb9ek=;
        b=fspiSdQXI0ngXKDfo55Qu91rVSzABysaewgWJER8kGhIPaShQeZV3QbpsYfpszFFhq
         aWfUNfQCbB2iiFXipSH2/FKc6gjiATFt+syJzv1fMoASaEr9xCRgLRfIU22iY6bjEkL4
         LzVmLMfDvD0OuhfwFlpCgVr3Ehp2/PGGJZSKChOA3DfFC4dsZXx6DI1q8O7fAnYhel5j
         LJkyNMTKH3EUpzsDW38Ieh7cAn8L4rs1ekJooQeh62Yv9GWx3b7kn5AUwBMo2bKXuPlZ
         4gwM1XfabmbnI7d+9CffS9I20Dj8b3HcJKmWjFJPS5DmM73fiDlyS6nl6WVuEiKP+Nbf
         DpCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nAAemCfKXeNgaOb0ZS9qFXJo3PaIk8Vnx3DCMlOb9ek=;
        b=NOlC1c69SrVUhAhJ+njqYshVQpPGb9aWJQj/mVU2Mp6tdlnmNYzEsaf6WYbg71AnMa
         y4GE6Du7Ep+biEFPw81BbucUc0JY+4UzIeD8aGRnM1f3JMpTMHkdseCLpvCpHmNY3fPk
         dz9HiyYXQhn0J4wq59tlpBaoq0D/3NmfEvI+bzIyCtUbvgQzUepOPGpUgdABcKAuIAg/
         wluYD0uJXNdLlHmUXKWfTbM6w8M4C3aIcJURPaH5IwTSvcKUe77dd3eVyB1TnxNUn1VJ
         z7FQbgIFk3FmNTiMXiRaPglscO/IUJQP4hGIcONh3qH7w+MuyD0xnmfxZDuK8bELosQY
         babA==
X-Gm-Message-State: APjAAAWPR5SRvxERzte+HyTYpk7436pxJz06KaE4YeqHGXlc9wobb2Lq
        uh2CYU4AE8jJcONqKlvnWis=
X-Google-Smtp-Source: APXvYqzgvLsZiubKSytCTZgreAzXSJaGG75yPgOMtR+kwKa4oWxY1F6isMlE5LKK8U0lTdMu8OFbiw==
X-Received: by 2002:a17:90a:2808:: with SMTP id e8mr5160718pjd.63.1575489975157;
        Wed, 04 Dec 2019 12:06:15 -0800 (PST)
Received: from iclxps ([155.98.131.2])
        by smtp.gmail.com with ESMTPSA id s11sm8552564pfe.163.2019.12.04.12.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 12:06:14 -0800 (PST)
Message-ID: <076ff5f0165c5271f999da70d30f73501c15c72c.camel@gmail.com>
Subject: Re: [PATCH v5 2/4] lib: devres: add a helper function for ioremap_uc
From:   Tuowen Zhao <ztuowen@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Sasha Levin <sashal@kernel.org>, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org, linux@roeck-us.net,
        Luis Chamberlain <mcgrof@kernel.org>
Date:   Wed, 04 Dec 2019 13:06:13 -0700
In-Reply-To: <20191204195456.GR32742@smile.fi.intel.com>
References: <20191016210629.1005086-3-ztuowen@gmail.com>
         <20191017143144.9985421848@mail.kernel.org>
         <b113dd8da86934acc90859dc592e0234fa88cfdc.camel@gmail.com>
         <20191018164738.GY31224@sasha-vm>
         <7eb0ed7d51b53f7d720a78d9b959c462adb850d4.camel@gmail.com>
         <20191204195456.GR32742@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2019-12-04 at 21:54 +0200, Andy Shevchenko wrote:
> 
> Since Guenter submitted a fix, we can leave with these ones and fix
> applied together.
> 

Since I have apparently missed something with hexagon, I don't feel
comfortable with messing with stable with this. I'm not sure as before
that this series is self-contained.

Tuowen

