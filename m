Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E337C22D88F
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 17:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgGYPug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 11:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726870AbgGYPug (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jul 2020 11:50:36 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F3FC08C5C1
        for <stable@vger.kernel.org>; Sat, 25 Jul 2020 08:50:35 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id z5so7035628pgb.6
        for <stable@vger.kernel.org>; Sat, 25 Jul 2020 08:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bcLcYtn/5EXjyyKK+pdJfQFFgGu5Nf11dS5S/Z/JYdA=;
        b=TKpyxyvQofSWhMw/ULpw8l0YUvfCsNuArU58WtzTf5mmfKXj9cJdscPlLD28Wr1rZl
         RLTlzE5cJeKX8910OpbdxX9OgYKEttD58FM/UdbzhmKORezH7LFec2H2qaPUMoc12959
         u1nOlANeu/eFp+031emHEa3vJAeascp/sG7Rw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bcLcYtn/5EXjyyKK+pdJfQFFgGu5Nf11dS5S/Z/JYdA=;
        b=n7Fkk0dm4+GOXnvlNiRYbZRhmOYzgVH6Hf2087w7FMOOYeuRtzPGANrcz+7cTbNTxL
         XpZYMhV3RKGws+KCuYih79llV0DKTuYGxyk6IhnRYChjaLzrNaYCCCldZyU++8YTQo2i
         fSJJYZGrC1hu65jtVLFXFUATMkF5z5OaiwPwIyFUyo8rjYOQ9g620XSqbXCtXKxNE63W
         hmcqYbYMAyRIaAOThsEehFbi9vmWW2RfLUBNFvA5CBXEhB61W55IJ2GoudWnQJxggPQV
         ZmdxYXAIQCdlNL49eVZkM/E15cNFzsy4n+SAGTn+YOVAwGmTkTVC5itN6H1dh2EcPIb6
         2Atg==
X-Gm-Message-State: AOAM533OQODEkISCIxtRetVgtFMjBbWnkEugHGkUrsi6WlSiiIfbnHGi
        iaTKG/pd7nA36VLZaan1BloTLQ==
X-Google-Smtp-Source: ABdhPJwA2gHcQ6pTTJcKgRnxdYSRIi/wTmQWm8YUexB647QP8HPj8ygmB8SXoUSnqs/kfBozVfUi5g==
X-Received: by 2002:aa7:9ac3:: with SMTP id x3mr13028951pfp.261.1595692235526;
        Sat, 25 Jul 2020 08:50:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id m31sm9813112pjb.52.2020.07.25.08.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 08:50:34 -0700 (PDT)
Date:   Sat, 25 Jul 2020 08:50:33 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Scott Branden <scott.branden@broadcom.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jessica Yu <jeyu@kernel.org>, SeongJae Park <sjpark@amazon.de>,
        KP Singh <kpsingh@chromium.org>, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 03/19] firmware_loader: EFI firmware loader must
 handle pre-allocated buffer
Message-ID: <202007250849.2B58CD3B@keescook>
References: <20200724213640.389191-1-keescook@chromium.org>
 <20200724213640.389191-4-keescook@chromium.org>
 <20200725100700.GB1073708@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200725100700.GB1073708@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 25, 2020 at 12:07:00PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jul 24, 2020 at 02:36:24PM -0700, Kees Cook wrote:
> > The EFI platform firmware fallback would clobber any pre-allocated
> > buffers. Instead, correctly refuse to reallocate when too small (as
> > already done in the sysfs fallback), or perform allocation normally
> > when needed.
> > 
> > Fixes: e4c2c0ff00ec ("firmware: Add new platform fallback mechanism and firm ware_request_platform()")
> 
> "firmware_request_platform()" :)

Weird... I'm not sure where that mangling happened. Perhaps a bad
cut/paste at 80 columns? Hmpf; thanks for catching. I've updated it on
my end (I assume you fixed this manually, though?)

Thanks!

-- 
Kees Cook
