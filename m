Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 362B23DBAF
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 22:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406447AbfFKULl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 16:11:41 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:33095 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406137AbfFKULl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 16:11:41 -0400
Received: by mail-ua1-f66.google.com with SMTP id f20so5046797ual.0
        for <stable@vger.kernel.org>; Tue, 11 Jun 2019 13:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nbyO3nRw9JFOPLH91kkBtvdh7nt7OAaaubUh8z2eVDA=;
        b=os8qo+mXUXC9iruJi3EsqRmT4LMaZqC61kNo3rnkLtBl3e8udzOSoHS1wwciuhglLL
         BJlPeWbrSgBKm2qxMW855Pjo6Yni9P17WKi9H5YecNTx41odf7WUOaBvjNS9GD3LeYUF
         nPSjDiWf5kSdgsgcMtzBXFowhU43YoKZV43bhr1w3W3by3saOaCrrpGGu6Yfl7HhkuNT
         MQOCimeYqW6OsFxuole99zgS97HM483VckssODZkaMr/MhWptEEbcWO58l7mr+peEQnK
         fMw8mGdFhMrHHKzT3s/PuVNNOKSYEDldpNLH4x+pcyx2pajGY4r7btO1QhEho/DiF/B0
         CDGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nbyO3nRw9JFOPLH91kkBtvdh7nt7OAaaubUh8z2eVDA=;
        b=S3FdOXqaxEJsH4Rqp6WLbewVQK460+n781ad12yb0Hqa0M3iZCG0UPJiG/jAamXcDw
         UORctmmClO/xTKO+kNyan+s9wYlzmuM1th4IXfA+7o5l0kaQtZyRhqrv1r+HMhBt/i1Y
         G4rhupjqS2g2SzHqd152KflCz+XjgZppAGtlIy5m8A5Dsh91gMkyrnPUe90aHk15gpQt
         S3Ii8XunM47jOOsBKyAlbhdLPaUIpzC0Yr9gJEtelgCLAHBeB6ssUQZt3JzcEbDbVgFC
         oENB1r4BBb2pfcXacCfwcktYF6UDpelRKpKXmmMLSLpfznUodDTtUIJa9Y9uvuSLwwK2
         NhGA==
X-Gm-Message-State: APjAAAXXkWQ4sQlmerK606m+uSZ8qWuAhLtkl3JeMiJ9WEfEA1mzvvLL
        1kiVB97+PTA3RBF5s6NnEspkpA==
X-Google-Smtp-Source: APXvYqw5PczCpGIqXZv2/tM4aAFgZa9GFOdQnPYRDQgj4LRChbtO+33tz5X6VB2DWqDio7LWoejnvg==
X-Received: by 2002:ab0:6881:: with SMTP id t1mr25517766uar.65.1560283900032;
        Tue, 11 Jun 2019 13:11:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id n6sm44093vkk.20.2019.06.11.13.11.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Jun 2019 13:11:39 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1han7L-0006uA-2c; Tue, 11 Jun 2019 17:11:39 -0300
Date:   Tue, 11 Jun 2019 17:11:39 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc:     dledford@redhat.com, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kaike Wan <kaike.wan@intel.com>
Subject: Re: [PATCH for-rc 1/3] IB/hfi1: Validate fault injection opcode user
 input
Message-ID: <20190611201139.GA26457@ziepe.ca>
References: <20190607113807.157915.48581.stgit@awfm-01.aw.intel.com>
 <20190607122525.158478.61319.stgit@awfm-01.aw.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607122525.158478.61319.stgit@awfm-01.aw.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 07, 2019 at 08:25:25AM -0400, Dennis Dalessandro wrote:
> From: Kaike Wan <kaike.wan@intel.com>
> 
> The opcode range for fault injection from user should be validated
> before it is applied to the fault->opcodes[] bitmap to avoid
> out-of-bound error. In addition, this patch also simplifies the code
> by using the BIT macro.
> 
> Fixes: a74d5307caba ("IB/hfi1: Rework fault injection machinery")
> Cc: <stable@vger.kernel.org>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> Signed-off-by: Kaike Wan <kaike.wan@intel.com>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
>  drivers/infiniband/hw/hfi1/fault.c |    5 +++++
>  drivers/infiniband/hw/hfi1/fault.h |    6 +++---
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/hfi1/fault.c b/drivers/infiniband/hw/hfi1/fault.c
> index 3fd3315..13ba291 100644
> +++ b/drivers/infiniband/hw/hfi1/fault.c
> @@ -153,6 +153,7 @@ static ssize_t fault_opcodes_write(struct file *file, const char __user *buf,
>  		char *dash;
>  		unsigned long range_start, range_end, i;
>  		bool remove = false;
> +		unsigned long bound = BIT(BITS_PER_BYTE);
>  
>  		end = strchr(ptr, ',');
>  		if (end)
> @@ -178,6 +179,10 @@ static ssize_t fault_opcodes_write(struct file *file, const char __user *buf,
>  				    BITS_PER_BYTE);
>  			break;
>  		}
> +		/* Check the inputs */
> +		if (range_start >= bound || range_end >= bound)
> +			break;
> +
>  		for (i = range_start; i <= range_end; i++) {
>  			if (remove)
>  				clear_bit(i, fault->opcodes);
> diff --git a/drivers/infiniband/hw/hfi1/fault.h b/drivers/infiniband/hw/hfi1/fault.h
> index a833827..c61035c 100644
> +++ b/drivers/infiniband/hw/hfi1/fault.h
> @@ -60,13 +60,13 @@
>  struct fault {
>  	struct fault_attr attr;
>  	struct dentry *dir;
> -	u64 n_rxfaults[(1U << BITS_PER_BYTE)];
> -	u64 n_txfaults[(1U << BITS_PER_BYTE)];
> +	u64 n_rxfaults[BIT(BITS_PER_BYTE)];
> +	u64 n_txfaults[BIT(BITS_PER_BYTE)];
>  	u64 fault_skip;
>  	u64 skip;
>  	u64 fault_skip_usec;
>  	unsigned long skip_usec;
> -	unsigned long opcodes[(1U << BITS_PER_BYTE) / BITS_PER_LONG];
> +	unsigned long opcodes[BIT(BITS_PER_BYTE) / BITS_PER_LONG];
>  	bool enable;
>  	bool suppress_err;
>  	bool opcode;

I don't think this is a simplification, BIT() is intended to create
flag values, and this is an array length. I also wonder if
1<<BITS_PER_BYTE is really a sane constant to be using for something
that looks HW specific, and if opcodes is really wanting to be a
bitmap type..

So, I dropped this hunk.

Jason
