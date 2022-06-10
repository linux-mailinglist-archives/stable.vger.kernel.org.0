Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55755468DD
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 16:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiFJO4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 10:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiFJO4Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 10:56:16 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A76F55B3;
        Fri, 10 Jun 2022 07:56:15 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x138so2258994pfc.12;
        Fri, 10 Jun 2022 07:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wJsCFQid4sHaK/ZKO+qfx/hNEBYaCAv7ipedUinRSCA=;
        b=DmZwOB8yj183zZJrZAw1WK2vDFaNRohRqhiAivoZuMpBDx4rD75d9vSgogfoFOXTyA
         oNOqJux67XmaerADpU2/fXwgugw/2QujGD062CGuRuRWOHGriavWeAyfSmRPjsXYrExA
         3ktfE5K0SpyCx0x6WGvPki69v5wXWD2uEOYcLQXQ51qO1U6JAnvQUQyj5AVtLTsHfTcC
         f0jjVb1O6MdrNnIDy2U1MtQ2xH+PfAOOU8byi6x2hmh1BfIFhx/OiVle9E1mT1zYBVEK
         1ENBT1mwGJGRuiXSs5mRkHP6HEpH1/etrfnSjTlbECIay3MuEXfJUH9ooLD0ctao/0+y
         I3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wJsCFQid4sHaK/ZKO+qfx/hNEBYaCAv7ipedUinRSCA=;
        b=M4BNAAhDCRwPVvtC1bI4ECvNWYiUhyEXYuNEXRH1ym4g6ZIDA761QohXw4NMDNhjCB
         IKsJtL6sRVsnNLIy4bACmUIMOfcm7Hi77muraOAzknwshSc1FpFHVK3s2pZ7u0AOBFft
         oiC+BR4974SPKa4JnUoYzgOi74TyaN8pXMaN5SmdBurGjxRveFx31/sEExyoFHdLpp6z
         loHoeIrOrzfo5Lptd6NRGVPmWat3AIQZrflzAyFIT9V2N0SjqTGmiD7dvXUYZAooFySz
         Z8Dt0UEoG0BjxWd7+5mSlL7LYrdLvRHRzJoPAGQMakfY6JKdc7Lypwpa76GXUH6t8Gdq
         AAyA==
X-Gm-Message-State: AOAM532Gh+RlXL76u+pQrDzjqcnpQ5PFeoU91JOEBjZmbgeNgHyEyarg
        HLKcPPN4Pfheu0wGFc0jtkE+id2Uofijgj9Q
X-Google-Smtp-Source: ABdhPJxBbi7wAzOxsxQJx2yKTE9EOjkYyRVB0nQ0HCXHa7+Kx6P3rlnHpDEIDoMVIAbd0oJoRk2/sw==
X-Received: by 2002:a05:6a00:148f:b0:51c:70f9:b62e with SMTP id v15-20020a056a00148f00b0051c70f9b62emr13426346pfu.84.1654872974762;
        Fri, 10 Jun 2022 07:56:14 -0700 (PDT)
Received: from fedora ([2601:1c1:4202:28a0::ec2b])
        by smtp.gmail.com with ESMTPSA id x17-20020a056a000bd100b0051be1b4cfb5sm15393657pfu.5.2022.06.10.07.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 07:56:14 -0700 (PDT)
Date:   Fri, 10 Jun 2022 07:56:12 -0700
From:   Jared Kangas <kangas.jd@gmail.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     vaibhav.sr@gmail.com, elder@kernel.org, gregkh@linuxfoundation.org,
        greybus-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-staging@lists.linux.dev,
        mgreer@animalcreek.com, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2] staging: greybus: audio: fix loop cursor use after
 iteration
Message-ID: <YqNbjINDaEBZktbS@fedora>
References: <20220609214517.85661-1-kangas.jd@gmail.com>
 <YqL6A3pVC8LOqE4d@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqL6A3pVC8LOqE4d@hovoldconsulting.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10, 2022 at 10:00:03AM +0200, Johan Hovold wrote:
> On Thu, Jun 09, 2022 at 02:45:18PM -0700, Jared Kangas wrote:
> > gbaudio_dapm_free_controls() iterates over widgets using the
> > list_for_each_entry*() family of macros from <linux/list.h>, which
> > leaves the loop cursor pointing to a meaningless structure if it
> > completes a traversal of the list. The cursor was set to NULL at the end
> > of the loop body, but would be overwritten by the final loop cursor
> > update.
> > 
> > Because of this behavior, the widget could be non-null after the loop
> > even if the widget wasn't found, and the cleanup logic would treat the
> > pointer as a valid widget to free.
> > 
> > To fix this, introduce a temporary variable to act as the loop cursor
> > and copy it to a variable that can be accessed after the loop finishes.
> > Due to not removing any list elements, use list_for_each_entry() instead
> > of list_for_each_entry_safe() in the revised loop.
> > 
> > This was detected with the help of Coccinelle.
> > 
> > Fixes: 510e340efe0c ("staging: greybus: audio: Add helper APIs for dynamic audio modules")
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Reviewed-by: Johan Hovold <johan@kernel.org>
> > Signed-off-by: Jared Kangas <kangas.jd@gmail.com>
> > ---
> > 
> > Changes since v1:
> >  * Removed safe list iteration as suggested by Johan Hovold <johan@kernel.org>
> >  * Updated patch changelog to explain the list iteration change
> >  * Added tags to changelog based on feedback (Cc:, Fixes:, Reviewed-by:)
> 
> Apparently Greg applied this to staging-next before we had a change to
> look at it. You should have received a notification from Greg when he
> did so.
> 
> 	https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/commit/?h=staging-next&id=80c968a04a381dc0e690960c60ffd6b6aee7e157
> 
> It seems unlikely that this would cause any issues in real life, but
> there's still a chance it will be picked up by the stable team despite
> the lack of a CC stable tag.
> 
> I've just sent a follow-up patch to replace the list macro.
> 
> Johan

Sorry about that - I got a notification but thought it was still
revisable. In hindsight, it makes sense that once it gets applied to
a public branch, changes should be done in additional patches. Thanks to
both you and Dan for taking the time to review and catch my mistakes.

Jared
