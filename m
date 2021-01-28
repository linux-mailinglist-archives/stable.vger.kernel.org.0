Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B718A307835
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 15:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhA1OgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 09:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhA1OgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 09:36:06 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630C2C0613ED
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 06:35:26 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id e9so4420715pjj.0
        for <stable@vger.kernel.org>; Thu, 28 Jan 2021 06:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+iw74D6kwkV2/01b/gOAeHsEBAoEbZ0PHlHz6VLO6IE=;
        b=V9XDxIHAdMoU5T5MKAy4pizmltrUjWIvT2qlTEzrPOxHOgWfPSRhmY2tMcQ7tUpdtX
         yymXutlkvUKbAxH0w2JrfQr6sy3LgXuFEXxDM3gPCZgPayDMKKVlyonUOM11S+CcZ1Jh
         xACbeHRvhDHemi4qeDFmUDHNe/cbDKKirvrJqKZbH5Q1hd6FdjnkHN85/2zYjvzRRUVq
         x41HPic7uLmIHzaew0lEqoeSZiGe7CqwdW3C6lmhgruSkPrxhqqC0FvuOrpet6ESV0xT
         gURukbksXMTruI6CmD8h8IAD+gNJ6Lgm/wVkuc+jVbkNge+H5+v8p1ybxK1dQJANQRdn
         bdoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+iw74D6kwkV2/01b/gOAeHsEBAoEbZ0PHlHz6VLO6IE=;
        b=GxVpHOY7cjmpAcLI2WHGlO4awT2h2/ZRsrHne8XVra/I5ON2iLtDtY+rlxJsWm723A
         duFdebH9Um2rqI0M/pBXsog2FUvH9ahy28dT+mhfXkLDknR7jTdVa5HAk+8yeTNeAs7/
         eG0WVy6cHy9Uh+VfxlrM2O2rQBIltDyzzuXoltsgfvg+pvN1JdfZdg6xrUG5PLvfAYag
         8wU0q10nGsOZX4ezn0Le1INQziA2gQOXwmNSBAgVufB42bmAP57jLgPKj6WJCyai9iYg
         0sNX6J3b3GJRv9VJuY+UPi8g6zm3nNAabAMJMtlmXmNXqMAvAoNgyzP3fDUuhLEfTRvd
         zPLg==
X-Gm-Message-State: AOAM5316jxnEwUKHAOBPx+UL3dF903OPdttaAD24PBqE++JtwO1kTYa4
        tnpd4bY9NzlwLxt5AwRcmNTEeop+XqWc4w==
X-Google-Smtp-Source: ABdhPJx0UHo847QBEMRkQRZakA65Owwf8bw4LgeF+4QcdcUSFYrREWCyzM2UMARkbl3yyG4l8Sf3ww==
X-Received: by 2002:a17:90a:de10:: with SMTP id m16mr11642090pjv.6.1611844525983;
        Thu, 28 Jan 2021 06:35:25 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id w14sm5353718pjl.38.2021.01.28.06.35.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 06:35:25 -0800 (PST)
Subject: Re: [PATCH] bcache: only check feature sets when sb->version >=
 BCACHE_SB_VERSION_CDEV_WITH_FEATURES
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        stable@vger.kernel.org,
        Bockholdt Arne <a.bockholdt@precitec-optronik.de>
References: <20210128104847.22773-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f7ca907e-abe4-d103-d818-c62dffa04987@kernel.dk>
Date:   Thu, 28 Jan 2021 07:35:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210128104847.22773-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/28/21 3:48 AM, Coly Li wrote:
> For super block version < BCACHE_SB_VERSION_CDEV_WITH_FEATURES, it
> doesn't make sense to check the feature sets. This patch checks
> super block version in bch_has_feature_* routines, if the version
> doesn't have feature sets yet, returns 0 (false) to the caller.

Applied, thanks.

-- 
Jens Axboe

