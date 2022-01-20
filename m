Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0159F494468
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 01:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345226AbiATAX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 19:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345179AbiATAXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 19:23:55 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7597C061574
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 16:23:55 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id a10-20020a9d260a000000b005991bd6ae3eso5459008otb.11
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 16:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+zOzBednldscnhra6JkUaxzTXlQRRyK3OUBhQ9RJ0wI=;
        b=NpbjfuoZWYoirSiXxGLn/doWeM127etmTOHNo1OItL5dp01OmD4hyhCDg/xM0UfCT1
         rOxi8tW+uJMockG2eaGOkKyQkhejkhEHCXiyqfrzq+ciH0g6dpIRKcYX07utdfhT3bDK
         VYmw5pI/A/scDX13g6SvUKDgDgrx8Jn6KdQXFqHaVOksRgZ28FTLBAqzIMZENvjfAHSf
         ivs0JEfRrZF9cW/oIqtR4yVAvSkhulG6nWnApHAvLLhY8hHKNqQK5hg1QwyQ6oagmBKc
         iWKbvRHLeasZuqyYveCKMJcVVvgf5/hOJufpLa4HW+6VoZ9+PLLXF+dg64v0fz1t8vLe
         tX0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+zOzBednldscnhra6JkUaxzTXlQRRyK3OUBhQ9RJ0wI=;
        b=kUrYBB/1vqqkZ1AJUUGklZSAeQcWMGJUwHt/UEb99+3N9fgIsaWwIRR+jnOS5vVq1V
         8KPs0mzk5kUlYoI0lZ4iaS7Rl96roJpvclEmmtpQXZI0BbBA508oPDYqKC+fQqQjhG7G
         22cblDOqCs4TrzpA6C/KNaG0SszEkuODlLBmIf/0sWp38tC1iV2tzCIuInONgcum/lep
         gS4JoS+Nln7b6toXZqooujFtzsP9OEIFPQg7C+XedHPFecgsQLX7GYTxZvCJJyNjt2vI
         S++CrSlittnfdbF7T+pBRjzgixyHQJ+zYnFXtpAcJVhx1Q1vF43wxqvfVIuRDXM1NUS3
         U5Cw==
X-Gm-Message-State: AOAM53309lKiVc3QmbevK1V2mk8wbOP7gsowHhLpLFJJRVpROjot8Rx8
        z0EHWsPUxunwSeG9YPi7JuijNQ==
X-Google-Smtp-Source: ABdhPJy37utAjcXmDJpvkZf5F+Wf0nXgH3gIhBsUk14LTso8ERUlIkmIzuj9uCtuTYG1ry2DQ346/Q==
X-Received: by 2002:a05:6830:4425:: with SMTP id q37mr7059637otv.14.1642638235040;
        Wed, 19 Jan 2022 16:23:55 -0800 (PST)
Received: from ripper ([2600:1700:a0:3dc8:205:1bff:fec0:b9b3])
        by smtp.gmail.com with ESMTPSA id l18sm732081otv.49.2022.01.19.16.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 16:23:54 -0800 (PST)
Date:   Wed, 19 Jan 2022 16:24:29 -0800
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alistair Delva <adelva@google.com>
Cc:     linux-kernel@vger.kernel.org,
        Rishabh Bhatnagar <rishabhb@codeaurora.org>,
        stable@vger.kernel.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        linux-remoteproc@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH] remoteproc: Fix count check in rproc_coredump_write()
Message-ID: <YeirvbTh5Cztcgxh@ripper>
References: <20220119232139.1125908-1-adelva@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119232139.1125908-1-adelva@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 19 Jan 15:21 PST 2022, Alistair Delva wrote:

> Check count for 0, to avoid a potential underflow. Make the check the
> same as the one in rproc_recovery_write().
> 
> Fixes: 3afdc59e4390 ("remoteproc: Add coredump debugfs entry")
> Signed-off-by: Alistair Delva <adelva@google.com>
> Cc: Rishabh Bhatnagar <rishabhb@codeaurora.org>
> Cc: stable@vger.kernel.org
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
> Cc: Sibi Sankar <sibis@codeaurora.org>
> Cc: linux-remoteproc@vger.kernel.org
> Cc: kernel-team@android.com

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  drivers/remoteproc/remoteproc_debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/remoteproc/remoteproc_debugfs.c b/drivers/remoteproc/remoteproc_debugfs.c
> index b5a1e3b697d9..581930483ef8 100644
> --- a/drivers/remoteproc/remoteproc_debugfs.c
> +++ b/drivers/remoteproc/remoteproc_debugfs.c
> @@ -76,7 +76,7 @@ static ssize_t rproc_coredump_write(struct file *filp,
>  	int ret, err = 0;
>  	char buf[20];
>  
> -	if (count > sizeof(buf))
> +	if (count < 1 || count > sizeof(buf))
>  		return -EINVAL;
>  
>  	ret = copy_from_user(buf, user_buf, count);
> -- 
> 2.30.2
> 
