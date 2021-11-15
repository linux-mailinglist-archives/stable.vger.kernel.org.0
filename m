Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823444511E2
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244548AbhKOTPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244352AbhKOTNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 14:13:52 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2C7C04C342
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 10:04:57 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id j28so17663494ila.1
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 10:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oNWkn0euYrddlaTUxBt9RiKgvk8R4zpd09YZVYXC3PM=;
        b=HJJsyzPFhUHPoNx6u4rIshbZ6jGAPTmRri3/8H4wPY4YDZBbXrbW+JD1PHIZBXSs8r
         13t5MIS62BpH/ywAzixrUC0Rz5y7XZ7Gedbsa8xLAJk1u9ddZZrhYSvMK7TOA3eMC/rp
         CL9kcM0FsXlvzb34vvbZnCGe0w+eyxKG4vXEqE1F5Wdhx88mn993b+plVNDee+RjldCr
         ukxMJCSO5lEuVYaLSq+BY3JD240Hm3aWkUKHDVg54/AmHUyA+73JH/JmV89WX2Zgwo68
         uMHLMwZMq66bjiHdWfxcU10tWeR+UxPL5jOJ2R4zOKp1U8m9NTHK07vx7EaeJT424wUJ
         wh7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oNWkn0euYrddlaTUxBt9RiKgvk8R4zpd09YZVYXC3PM=;
        b=QEFv/Sl7GON3ZNzaW0sYXdMlp8c+s9LDEWL/EGYreVikFjcfIg+RN5mMzIW0YqgK4i
         Mu0BLL7d1qqtM5vqlL69VbMTf/2jLDa7FlA0/ThZ6kbLgNWp0lcgNFoZCJFomsjngGtV
         2Js3MS6D7w7jOmHIMGfRtAhVVAN8lpFnPl3MCJp7kLoAlVfxdKS7+e/rbPYIr+86ahCV
         tyYL8H9vIgy4QrLll6/EgDmXjMIErkZI4VwUdpACZcv/UpSHIMr2qsb/ZmFXti589d3g
         oN3spKpjUCXurCkQJLR8y7BJAnnOi5KDB5xek+Hky93wrsBGoF/EIZ2vD9Q1lSHgT6OL
         J4yA==
X-Gm-Message-State: AOAM531PZgHXpJ58XqFNca25eCe7rU8XVNIL/Z55y4ngwCuX5kr+AzXF
        aIvIsmsr+TKWufEluDzVfJgUSfnAR1KksXpH
X-Google-Smtp-Source: ABdhPJyp6zFNAuBeuoyQU4kkL68fGK2NiaH9e5RPs0cd09v4NWGILyi6DmolYUr1ntMgjfQFN9p19g==
X-Received: by 2002:a92:c569:: with SMTP id b9mr517353ilj.39.1636999496758;
        Mon, 15 Nov 2021 10:04:56 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id b15sm10200671iln.36.2021.11.15.10.04.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 10:04:56 -0800 (PST)
Subject: Re: [PATCH] block: Check ADMIN before NICE for IOPRIO_CLASS_RT
To:     Alistair Delva <adelva@google.com>, linux-kernel@vger.kernel.org
Cc:     Khazhismel Kumykov <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Serge Hallyn <serge@hallyn.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Moore <paul@paul-moore.com>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, kernel-team@android.com,
        stable@vger.kernel.org
References: <20211115173850.3598768-1-adelva@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <74179f08-3529-7502-db33-2ea18cab3f58@kernel.dk>
Date:   Mon, 15 Nov 2021 11:04:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211115173850.3598768-1-adelva@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/21 10:38 AM, Alistair Delva wrote:
> Booting to Android userspace on 5.14 or newer triggers the following
> SELinux denial:
> 
> avc: denied { sys_nice } for comm="init" capability=23
>      scontext=u:r:init:s0 tcontext=u:r:init:s0 tclass=capability
>      permissive=0
> 
> Init is PID 0 running as root, so it already has CAP_SYS_ADMIN. For
> better compatibility with older SEPolicy, check ADMIN before NICE.

Seems a bit wonky to me, but the end result is the same. In any case,
this warrants a comment above it detailing why the ordering is
seemingly important.

-- 
Jens Axboe

