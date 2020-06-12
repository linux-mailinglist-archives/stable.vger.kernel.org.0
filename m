Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9981F76A9
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 12:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgFLKV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 06:21:28 -0400
Received: from mail-ej1-f67.google.com ([209.85.218.67]:32792 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgFLKVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 06:21:18 -0400
Received: by mail-ej1-f67.google.com with SMTP id n24so9597501ejd.0;
        Fri, 12 Jun 2020 03:21:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UCmnkQ+7r4Yl/XA1DWNILW2Cx3UCtYcdqwjb2/DioLQ=;
        b=mD1pqe16Ipvj13XKi+L6puzVnNsydwHvj2mShUC1LP7O7rpujc3NPfkyTu/ai9Q36Z
         4K9Y5dOzQm9ARVstVW4TVFnTzbluZuuFh4bqL+PhRki24UwjrE9+cYC06eLfOqTRYoOg
         wwvJdjjmu2FKGe7RevBWw4qVloBg5SNwm69jLgfnoz8FItCBOmQkCwb0M0309BCfa3fM
         PSLu3CGI7ftK9S13AfTOYqKEWg97GPpuR0wKuM8SuM8CaHG1oTazE3P35Cld90+K1Y3p
         LurczdAsYM/8aY4y/gwh7cmWVZdqD9gsBVM1zDzeYjX6B7pLxVd6Efn5NaNrYlT5XIaN
         oZNA==
X-Gm-Message-State: AOAM5331XfNb2iMkxPAsTnfkMUe5HeVVgJYvZuJTH4pbVmKbBkLPtaIx
        n+gItteF3MTsN9vz2ES2Vxs=
X-Google-Smtp-Source: ABdhPJzJ6RaY0eAM4hGkuYlc3SLJUwUFh4TiDwD8FMRxFmZkjqZLgmm7NPWi924xDJTeY04nohakWQ==
X-Received: by 2002:a17:906:c2c6:: with SMTP id ch6mr12273554ejb.36.1591957276099;
        Fri, 12 Jun 2020 03:21:16 -0700 (PDT)
Received: from pi3 ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id ws10sm3227738ejb.24.2020.06.12.03.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 03:21:15 -0700 (PDT)
Date:   Fri, 12 Jun 2020 12:21:13 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Wolfram Sang <wsa@kernel.org>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] i2c: imx: Fix external abort on early interrupt
Message-ID: <20200612102113.GA26056@pi3>
References: <1591796802-23504-1-git-send-email-krzk@kernel.org>
 <20200612090517.GA3030@ninjato>
 <20200612092941.GA25990@pi3>
 <20200612095604.GA17763@ninjato>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200612095604.GA17763@ninjato>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 12, 2020 at 11:56:04AM +0200, Wolfram Sang wrote:
> On Fri, Jun 12, 2020 at 11:29:41AM +0200, Krzysztof Kozlowski wrote:
> > On Fri, Jun 12, 2020 at 11:05:17AM +0200, Wolfram Sang wrote:
> > > On Wed, Jun 10, 2020 at 03:46:42PM +0200, Krzysztof Kozlowski wrote:
> > > > If interrupt comes early (could be triggered with CONFIG_DEBUG_SHIRQ),
> > > 
> > > That code is disabled since 2011 (6d83f94db95c ("genirq: Disable the
> > > SHIRQ_DEBUG call in request_threaded_irq for now"))? So, you had this
> > > without fake injection, I assume?
> > 
> > No, I observed it only after enabling DEBUG_SHIRQ (to a kernel with
> > some debugging options already).
> 
> Interesting. Maybe probe was deferred and you got the extra irq when
> deregistering?

Yes, good catch. The abort happens right after deferred probe exit.  It
could be then different reason than I thought - the interrupt is freed
through devm infrastructure quite late.  At this time, the clock might
be indeed disabled (error path of probe()).

Best regards,
Krzysztof

