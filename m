Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49AD165C908
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 22:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbjACVp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 16:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjACVpZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 16:45:25 -0500
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058AAB48E;
        Tue,  3 Jan 2023 13:45:25 -0800 (PST)
Received: by mail-pf1-f169.google.com with SMTP id k137so16746138pfd.8;
        Tue, 03 Jan 2023 13:45:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o7Jv5muMEwbo/g8i6mc6MDy/iv+Z0WW/HWuFgl0aO8w=;
        b=G1XzyG44yM3TE0/eMOvLDsbbP6SZZ4p04Ey1pg7cw2R57XUSUK5rEnu52o6UPSJZZW
         AkVHcliPL2UvIqUJb2Zmfu4kJoFpFuT3E1RlAQBwQ22qktz6/dbdv7Q1pXyac/dNoFGd
         dNap7R9+or7e77CvaK83kiuz/jqDpy4ec1NU9Va5I2A1wiE4g/rN4EFQW8iTvXsY0fgW
         2nFh70Ggot1h19k6YgItOlWOLz6L4zJtfgKljCJPGC9Ay+a/ma0vpTyzKc27+JH+ZxLc
         Qvwe2JR+KjS7ueG4c15x7QbeWkYaybD4iVTQpIPhYCQU8r6Sb6h/2fBJeQQWTsg6njRP
         xwIw==
X-Gm-Message-State: AFqh2koxEG0OWFuPchz4PqmYKvl6LXnjhvXl/KHsKkpefUv2/RjTYLHX
        teTiaJXbT0cc7XWKkP2ZjHM=
X-Google-Smtp-Source: AMrXdXv+VDgcsAMMYubJX3gPMMPS447LrTmW5ZaJO+72jSR8Bc3UkXLp/ep5sS2sefEQKBegZIyOzQ==
X-Received: by 2002:aa7:804a:0:b0:576:ebfe:e9c1 with SMTP id y10-20020aa7804a000000b00576ebfee9c1mr44658779pfm.20.1672782324469;
        Tue, 03 Jan 2023 13:45:24 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:7da8:fef9:8c31:bf89? ([2620:15c:211:201:7da8:fef9:8c31:bf89])
        by smtp.gmail.com with ESMTPSA id x15-20020aa7940f000000b00574c54423d3sm12373019pfo.145.2023.01.03.13.45.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 13:45:23 -0800 (PST)
Message-ID: <85e91255-1e6f-f428-5376-08416d2107a2@acm.org>
Date:   Tue, 3 Jan 2023 13:45:21 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] scsi: ufs: core: fix devfreq deadlocks
Content-Language: en-US
To:     Johan Hovold <johan+linaro@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Can Guo <quic_cang@quicinc.com>
References: <20221222102121.18682-1-johan+linaro@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221222102121.18682-1-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/22/22 02:21, Johan Hovold wrote:
> +	/* Enable Write Booster if we have scaled up else disable it */
> +	if (ufshcd_enable_wb_if_scaling_up(hba))
> +		ufshcd_wb_toggle(hba, scale_up);

Hi Asutosh,

This patch is the second complaint about the mechanism that toggles the 
WriteBooster during clock scaling. Can this mechanism be removed entirely?

I think this commit introduced that mechanism: 3d17b9b5ab11 ("scsi: ufs: 
Add write booster feature support"; v5.8).

Thanks,

Bart.

