Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF3D2C7CC6
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 03:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgK3CcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 21:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgK3CcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Nov 2020 21:32:05 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACC3C0613D2
        for <stable@vger.kernel.org>; Sun, 29 Nov 2020 18:31:19 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id u19so12325453edx.2
        for <stable@vger.kernel.org>; Sun, 29 Nov 2020 18:31:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EMrBGIYRCauK+kgCvThhHlPwPG6uXDLHeYr60pnOrSo=;
        b=Kje1TCyTDXxzkS54EhleTCApleyH99KJlxBWtbleQEe4kI1YfixWcHKqclCH5xFXuL
         QlEsnuuJsDSCF4bbyV0pwi4O6UuPbueasbwDcW5oGKxSLatgh3hIrJQbLyzt/2H5VvHH
         yIXI1UhEUkzS/SY048zdn3kDXajwPWw53cLut3Kr36VOTFxIyPUFy+1HbMtT4tHDvZw2
         THiIQrf+HshsW8sMOhuMBi45rntDPPNwiUj/mPqKk9K1yoQyGyO7wW7kWN8H0pbZhPti
         dGO8/FU1oRjDPbyrHmjWHU+TohYxE4ynynwlsSSKdAriXIf03W04ZhUr9IAuJq3caUd/
         urAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EMrBGIYRCauK+kgCvThhHlPwPG6uXDLHeYr60pnOrSo=;
        b=iEZQZaSgrWEF5IdVxmmJKSbLBwJJbgWu+EwnTVjPfeAQdO4ehZ7rJ6Lqb7/fSfUnUG
         AiuzQz+glEdC6QU8gwlMMR8ft2CHPjPN+D4DfhTCl7+fQ4GYDWz7iT24C5PYdoUK1ToZ
         RdBq+9fkqqnuuu3Qj7vk1B2ArSrelB590wcQYBINS/0OJS2f20pMnYOvzHRLv3WiJt0m
         2cqcrQcxgK8ZMmbXCPwjVwtQfvkXivHeBlRKy6y/66cTdlH2ojH8cmljcMiDdLlMiRpB
         S66ZxxMl9A57ySrgZq5+DxpOmJSobEhFC1mG0/aSQ1ZFQvbv2pOjQAd5N44R9VVWbt1G
         FQbw==
X-Gm-Message-State: AOAM5338ZbH6drR6rCBVAIaH6JIlg45Ie9FKw37aSRHw1Lx+YM6bz67C
        tSNzhUlN/KwvhA5+UEjZrPDwUYV1xbn97Q==
X-Google-Smtp-Source: ABdhPJwM87aosHJO/9vPRF55NPMJp0HAPyQ2sZ68XrJqA/qaO9vj4xYYLpo/9UEUVdv5VL66WMGm7g==
X-Received: by 2002:a05:6402:54d:: with SMTP id i13mr20110784edx.3.1606703477597;
        Sun, 29 Nov 2020 18:31:17 -0800 (PST)
Received: from ?IPv6:240e:82:0:92f3:e12d:4673:cbec:1111? ([240e:82:0:92f3:e12d:4673:cbec:1111])
        by smtp.gmail.com with ESMTPSA id dk14sm7891781ejb.97.2020.11.29.18.31.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Nov 2020 18:31:17 -0800 (PST)
Subject: Re: [PATCH v4 2/2] md/cluster: fix deadlock when node is doing resync
 job
To:     Zhao Heming <heming.zhao@suse.com>, linux-raid@vger.kernel.org,
        song@kernel.org, xni@redhat.com
Cc:     lidong.zhong@suse.com, neilb@suse.de, colyli@suse.de,
        stable@vger.kernel.org
References: <1605786094-5582-1-git-send-email-heming.zhao@suse.com>
 <1605786094-5582-3-git-send-email-heming.zhao@suse.com>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <b120e2b5-f322-6dd2-2b3e-8b7eb7f2bc3d@cloud.ionos.com>
Date:   Mon, 30 Nov 2020 03:31:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1605786094-5582-3-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 11/19/20 12:41, Zhao Heming wrote:
> mkfs.xfs /dev/md0

This would make people think clustered raid can co-work with local fs 
well ...

> mdadm --manage --add /dev/md0 /dev/sdi
> mdadm --wait /dev/md0
> mdadm --grow --raid-devices=3 /dev/md0
> 
> mdadm /dev/md0 --fail /dev/sdg
> mdadm /dev/md0 --remove /dev/sdg
> mdadm --grow --raid-devices=2 /dev/md0

The above is good fit for a new test case in mdadm.

Thanks,
Guoqing
