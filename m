Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F76566025
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 21:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbfGKTq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 15:46:28 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33493 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728798AbfGKTq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 15:46:28 -0400
Received: by mail-qk1-f195.google.com with SMTP id r6so4649916qkc.0
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 12:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0MV3Xo8JXCmgPVPj78lec025mCDr/1718DU+JOppzoA=;
        b=WfctH2kez7F8xf8pjozxz28muLcSmecGPp9EI7So4GsVHGxF7SDpICIcvDHC1JXn8p
         P86t62V30/1dmxJXPNqrtlEHW9cgm0f5FyJfwlBVcq3YasFS7ETZZQvmogrpLHaa7uOM
         7NbiZbwZp2GA/SX6zrq3GxfYIDznH9v7yWLCC8dbvNc8PwHLxI7TvjV9gdthli9cOeOu
         DHFLfK3nsnu4ttTWt8P33qOTOxTzEBa7Ne0dOy3SLh3E7xCeimipp+1WGjvmFEGN7fo7
         JoRnyDfZNylUrQO052pWCoN/88mot5CdDfRBp7a4/Tyr7SlLexn9/scgIqreDrP5VOuN
         rzkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0MV3Xo8JXCmgPVPj78lec025mCDr/1718DU+JOppzoA=;
        b=KJ7RAb2OYJaDQvligxmcJ05n1BpTZQRayV8VezZus4z3IIBbhe54ODiJbZjmDsouui
         g/WQ5QJ7Y0PXyqMA6d8rimid6cG8WKDp4f6ya6JRNZxyPrfqzHFWYNpFaZLHbaCtrGfU
         pcwHG8j7UggY5ho8MuNf3Z3aPaiV4T1Dgo2F+E1pN49Mxe42ClNK0tPPLu9P4K8wD8Hx
         Sdu1KVC8TpqyrB8h2Dugbmc6M3a1HkH1s0aOFthNN+VOYZglQHt9SLhk0H+VD0wS98A0
         h+VpW7YRHuc9vRk0bUZfdoyFZFgkOpmoUfzt8RpSbm7h7WnsEbwz6qD2jS7zedxrdqNP
         EAqw==
X-Gm-Message-State: APjAAAU+GOZbxJH3K2Zr/KWzyhnpVQOgs6rkiOqxmM6BaCBnfo55OXAL
        uhfqVX7bz61VJFwsxZRL56hl7rdhTp8k/Q==
X-Google-Smtp-Source: APXvYqzjwdP+mZ7dRkBy3VJYWZpIAzR3fAEad0kJ+VLPyzuhPdeZhdwijUigUy10iMlGPnMN0HUT3Q==
X-Received: by 2002:a37:9a96:: with SMTP id c144mr37475qke.468.1562874387437;
        Thu, 11 Jul 2019 12:46:27 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id a6sm2363257qkd.135.2019.07.11.12.46.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Jul 2019 12:46:26 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hlf1O-0002M5-5F; Thu, 11 Jul 2019 16:46:26 -0300
Date:   Thu, 11 Jul 2019 16:46:26 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Douglas Anderson <dianders@chromium.org>, stable@vger.kernel.org,
        groeck@chromium.org, gregkh@linuxfoundation.org,
        sukhomlinov@google.com, Arnd Bergmann <arnd@arndb.de>,
        Peter Huewe <peterhuewe@gmx.de>, linux-kernel@vger.kernel.org,
        linux-integrity@vger.kernel.org
Subject: Re: [PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM
 operations
Message-ID: <20190711194626.GI25807@ziepe.ca>
References: <20190711162919.23813-1-dianders@chromium.org>
 <20190711163915.GD25807@ziepe.ca>
 <20190711183533.lypj2gwffwheq3qu@linux.intel.com>
 <20190711194313.3w6gkbayq7yifvgg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711194313.3w6gkbayq7yifvgg@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 11, 2019 at 10:43:13PM +0300, Jarkko Sakkinen wrote:
> On Thu, Jul 11, 2019 at 09:35:33PM +0300, Jarkko Sakkinen wrote:
> > > Careful with this, you can't backport this to any kernels that don't
> > > have the sysfs ops locking changes or they will crash in sysfs code.
> > 
> > Oops, I was way too fast! Thanks Jason.
> 
> Hmm... hold on a second.
> 
> How would the crash realize? I mean this is at the point when user space
> should not be active. 

Not strictly, AFAIK

> Secondly, why the crash would not realize with
> TPM2? The only thing the fix is doing is to do the same thing with TPM1
> essentially.

TPM2 doesn't use the unlocked sysfs path

Jason
