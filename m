Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D70E9E36C8
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 17:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503260AbfJXPgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 11:36:25 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36818 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503224AbfJXPgZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 11:36:25 -0400
Received: by mail-qt1-f196.google.com with SMTP id d17so23886162qto.3
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 08:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PO7ANvqkotQ+g2bEe1Hw5w8nqdc9eXAxdBwSeKbXh9w=;
        b=FId3UXasjX6Go4JKCdP9+7lxwA49XZBN71M4vkDWmLldPXBkrsuqTO2rO7bgkx3O6t
         LgQkEtHBKo1SxGszCEqiQoQeClXADtm2nJBTrrpjFqT1cIk3juNv2mW2/whMq36OkZ+B
         tTEUF80A8yDyZURrNU6/LEggk00JMBoW48WuMDoJh7+KQfQ8v9NoEa7ohwZWfEjQpE7T
         BHR9nfWruZWnGJaLhVzlFWwqqVH7iLWz64UdtjvMuuq206vU8/Lihh/yCKV/elWqRqbf
         fflz6yKsmNNmp3+gdXLZFfDYH1zS5MRES24kZjpxYE+aEbJRW6nm76rZ858kq7rUksqC
         9aZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PO7ANvqkotQ+g2bEe1Hw5w8nqdc9eXAxdBwSeKbXh9w=;
        b=S/Mjs/Ix8SxoPBsMVVpvNIoyu2GpSWi7a3Ti2EsjxI+bwcqQE8ZzNeP2hl8/808Au/
         QSXRkgOLChAtBLCtgMu0gGYGXWNVkhTLfoLVNet/Pp34SHJQgbDc6jOimzv6h1yaSQoY
         GL6CI1sLI17DwM6AJaOLn/9EBOYqK7ARknrqixcYAaNVC5W1jMratDIrcM+gOdnjp7eC
         CfXOO4G0ev+P8bWLtfDVeqFVYqRawgr9hCsUZ+eJryhladH9u+HbhtLXsTqhgIv60bWv
         JVcFEUpaEnHtFmR29FG8Q7eZwNpsvca4ztAIKf4CPrAHyvXdo6uznOzDB8jud/ziXiRd
         KoWA==
X-Gm-Message-State: APjAAAXBxFpLjm8ZysJ/zaKfN/oHaK+Degynp1CTBL3zGT/Visx/0U86
        V/fXQqPs8H0/nOJ82SlPfB5ftA==
X-Google-Smtp-Source: APXvYqwCZloe629xxoBYgjtTP/gXJ5ZCbyJJpXE/9FDAkwrQZD9eu8FjjhnLm6HCLqlPMhdSZu1wNQ==
X-Received: by 2002:a0c:e64e:: with SMTP id c14mr2422699qvn.13.1571931384065;
        Thu, 24 Oct 2019 08:36:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id k187sm3427463qkb.20.2019.10.24.08.36.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Oct 2019 08:36:23 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iNf9y-0007SF-Sp; Thu, 24 Oct 2019 12:36:22 -0300
Date:   Thu, 24 Oct 2019 12:36:22 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Peter Huewe <peterhuewe@gmx.de>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] tpm: Switch to platform_get_irq_optional()
Message-ID: <20191024153622.GU23952@ziepe.ca>
References: <20191019094528.27850-1-hdegoede@redhat.com>
 <20191021140502.GA25178@ziepe.ca>
 <20191023113248.GA21973@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023113248.GA21973@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 23, 2019 at 02:32:48PM +0300, Jarkko Sakkinen wrote:
> On Mon, Oct 21, 2019 at 11:05:02AM -0300, Jason Gunthorpe wrote:
> > On Sat, Oct 19, 2019 at 11:45:28AM +0200, Hans de Goede wrote:
> > > Since commit 7723f4c5ecdb ("driver core: platform: Add an error message to
> > > platform_get_irq*()"), platform_get_irq() will call dev_err() on an error,
> > > as the IRQ usage in the tpm_tis driver is optional, this is undesirable.
> > 
> > This should have a fixes line for the above, or maybe the commit that
> > addtion the _optional version..
> 
> Is this fixing something?

Yes, an earlier commit caused new bogus warnings to appear, this is
fixing that regression

Jason
