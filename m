Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407DB1F936B
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 11:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbgFOJay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 05:30:54 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:44194 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728773AbgFOJax (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 05:30:53 -0400
Received: by mail-ej1-f66.google.com with SMTP id gl26so16627458ejb.11;
        Mon, 15 Jun 2020 02:30:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=h/M83iD3faCNV0o/Y7FN4nAygVEAlSlnzSZwyREl0qc=;
        b=ESRVGfFM+5FRbNUwN8JsxZeCu+CapM95kuzSgkyeEpV3T3dtx4QXbeRn+5/vfxYPqB
         MlAAF/LPJHCd627hfc7wC5r7+/Tt9rXk/DuWGqhunkpOX6uFGbbNbhl4ppzDmLK77sgN
         B8YZ0UuXwEnLi0E+aBoe8axeiemCFBcxIQ2NG46jf1N4b5pAt+z+pMeUPaDAgbVFs0fW
         ThaAAIouAx6Kaa0kqTq1gAoiNzVtRDH29notNW5Bfc3+7ixi6Y33eXTVbv4VoUfc6MHn
         s9AOsEgpBeOwluImapflAYb/P0FKxdv6cK5zx4ffVDifF3K+GLP4Ej7lyQLxdkUcwz42
         s8jA==
X-Gm-Message-State: AOAM532DaveKD9lvRc8gRNzx3e1HrDfPSUu8Ln9WGgage4fdSLQtj9q1
        CS/FtUBD7En55IZlcAMntgDsXI5b
X-Google-Smtp-Source: ABdhPJzj4fF0KjiTqoA2MyuBdX99hOHf6yiRkEUdkWHf10sT0uT2w/tHmSsHPNGfhKgKePOHINaHYw==
X-Received: by 2002:a17:906:b28e:: with SMTP id q14mr12088035ejz.484.1592213451621;
        Mon, 15 Jun 2020 02:30:51 -0700 (PDT)
Received: from kozik-lap ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id m2sm8652597ejg.7.2020.06.15.02.30.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jun 2020 02:30:50 -0700 (PDT)
Date:   Mon, 15 Jun 2020 11:30:48 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] spi: spi-fsl-dspi: Initialize completion before
 possible interrupt
Message-ID: <20200615093048.GA26906@kozik-lap>
References: <1592132154-20175-1-git-send-email-krzk@kernel.org>
 <1592132154-20175-2-git-send-email-krzk@kernel.org>
 <CA+h21ho_pa0H2MG-aAmUCFj37aYW4es-2V75P4KL-Zjq7qtfRQ@mail.gmail.com>
 <20200614111829.GA9694@kozik-lap>
 <CA+h21hqE3RbD2XTBbcRsMhsO2OaZ65tAaevFOr00p9ezu8O+iA@mail.gmail.com>
 <CA+h21hoVjJkGyxTEnh2Bixjoqxb12k-KK37U4Xy-27ntZz8aTw@mail.gmail.com>
 <20200614151247.GA2494@kozik-lap>
 <CA+h21hotvdXUgUzMaVfb_6EM-9kcoHvvnT4r+EHx7m6z4R0pxg@mail.gmail.com>
 <20200615070858.GA20941@kozik-lap>
 <CA+h21hoLq59R2p=+f4jZFmd5OSQ3590FeRB+oHBKLKDHq5knRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+h21hoLq59R2p=+f4jZFmd5OSQ3590FeRB+oHBKLKDHq5knRg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 12:26:37PM +0300, Vladimir Oltean wrote:
 > Let's rephrase it: you think therefore that completion should be
> > initialzed *after* requesting shared interrupts? You think that exactly
> > that order shall be used in the source code?
> >
> > Best regards,
> > Krzysztof
> >
> >
> 
> I think that completion should be initialized before it is used, just
> like any other variable. So far you have not proven any code path
> through which it can be used uninitialized, therefore I don't see why
> this should be accepted as a bug fix. Cleanup, cosmetic refactoring,
> design patterns, whatever, sure.

Sure, let it call then cleanup, cosmetic refactoring.

Best regards,
Krzysztof

