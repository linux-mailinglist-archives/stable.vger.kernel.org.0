Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84C159FA26
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 14:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236296AbiHXMn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 08:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbiHXMnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 08:43:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B1A696C6;
        Wed, 24 Aug 2022 05:43:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E49B4B823EE;
        Wed, 24 Aug 2022 12:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392B9C433C1;
        Wed, 24 Aug 2022 12:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661345001;
        bh=eUDEcyDSoKd3iXeAYc6HrNZyJVRX0GLyiR77eO5bfhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LMQeii5kpZ6oVSzn0mobOeiGb2XIN5zTEyAnYQj5i4fWMsUxN2YjnWXrGulcUiiTV
         xID+H0L+3ungwiKO6z2C9xKdxYQd9zIRYUaBZuzlPA4nruWKJybzbieQhZQ8aTVxQ6
         7OSyIEUmkeXhRpPmBNlL5b5Q8kt28dkne5MDc5lk=
Date:   Wed, 24 Aug 2022 14:43:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     kishon@ti.com, lpieralisi@kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, mie@igel.co.jp, kw@linux.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/5] misc: pci_endpoint_test: Fix the return value of
 IOCTL
Message-ID: <YwYc5kcdv+5RQDsK@kroah.com>
References: <20220824123010.51763-1-manivannan.sadhasivam@linaro.org>
 <20220824123010.51763-2-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824123010.51763-2-manivannan.sadhasivam@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 24, 2022 at 06:00:06PM +0530, Manivannan Sadhasivam wrote:
> IOCTLs are supposed to return 0 for success and negative error codes for
> failure. Currently, this driver is returning 0 for failure and 1 for
> success, that's not correct. Hence, fix it!
> 
> Cc: stable@vger.kernel.org #5.10
> Fixes: 2c156ac71c6b ("misc: Add host side PCI driver for PCI test function device")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

> ---
>  drivers/misc/pci_endpoint_test.c | 163 ++++++++++++++-----------------
>  1 file changed, 76 insertions(+), 87 deletions(-)
> 
> diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
> index 8f786a225dcf..a7d8ae9730f6 100644
> --- a/drivers/misc/pci_endpoint_test.c
> +++ b/drivers/misc/pci_endpoint_test.c
> @@ -174,13 +174,12 @@ static void pci_endpoint_test_free_irq_vectors(struct pci_endpoint_test *test)
>  	test->irq_type = IRQ_TYPE_UNDEFINED;
>  }
>  
> -static bool pci_endpoint_test_alloc_irq_vectors(struct pci_endpoint_test *test,
> +static int pci_endpoint_test_alloc_irq_vectors(struct pci_endpoint_test *test,
>  						int type)
>  {
> -	int irq = -1;
> +	int irq = -ENOSPC;

No need to set this if you:

>  	struct pci_dev *pdev = test->pdev;
>  	struct device *dev = &pdev->dev;
> -	bool res = true;
>  
>  	switch (type) {
>  	case IRQ_TYPE_LEGACY:
> @@ -202,15 +201,16 @@ static bool pci_endpoint_test_alloc_irq_vectors(struct pci_endpoint_test *test,
>  		dev_err(dev, "Invalid IRQ type selected\n");

This should now return -EINVAL;


>  	}
>  
> +	test->irq_type = type;

Again, do not make a change to the kernel state if there is an error
above.  That's wrong to do, and yes, the current code is incorrect,
don't keep that bug here as well when it's so easy to fix up
automatically.


I stopped reviewing here...

thanks,

greg k-h
