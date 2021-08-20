Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92DAA3F302E
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 17:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241110AbhHTPxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 11:53:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25997 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240865AbhHTPxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 11:53:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629474743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JlZGKQdLiYduLYkrU1ycwzHzZ/QPrtvBjhejt7xEWxE=;
        b=FD3IUmW5wOeh1WiNCZUeNRs/ar0AKJk4PisJqED4PayKk2+NPomEd3baDFrDyrpWBz7MDq
        w35zrGxiHyvFihX5eh4RSrxkRkxPf9uKEwSFJDIxyabbXUM98f2uMQOu/obIVHcdE2fpM5
        qls5iIoTf+4jrzoonAVjSLjfKOUKkoc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-swIcuJU6N9-kLfLR5bJbPg-1; Fri, 20 Aug 2021 11:52:22 -0400
X-MC-Unique: swIcuJU6N9-kLfLR5bJbPg-1
Received: by mail-wm1-f72.google.com with SMTP id 201-20020a1c01d2000000b002e72ba822dcso633335wmb.6
        for <stable@vger.kernel.org>; Fri, 20 Aug 2021 08:52:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=JlZGKQdLiYduLYkrU1ycwzHzZ/QPrtvBjhejt7xEWxE=;
        b=GGFz+2uOKZ1YirWOfrpId7uZCgcfaulYnxMDm+RChwiQsPFPbYbbyCHKIwqZFZt2qF
         Vy1989NEqHV8NU9kP5GbVrJatJKpNVbdySR8Vya6MhWhzwJgT18gqb8kl5YiN60/88MS
         0i+NgEpLpcldw55/HIBm8UcUsWqT9rtE6k+1It9I/xxYg9FjcmEc77BqbAgAlzqKfhu4
         ELleYStRiijjgul++l2luhgKKXMbYbVleQrM2y0FxJDEIAXHv3Cm04QcA/PfQlP3+MAf
         H6OieC+u6/NY2drj1F3aS5Rl0nacX7Dq0KUJXFT31F0O11CbHBBU/Po1JqkEjAc1gfb9
         s58A==
X-Gm-Message-State: AOAM532clmAhU1SBqr/e0B2a8U7n9BBzFJA749jCVAoh/V0EUKzx66yT
        A1AMcjjpTaAPvoJimpqZeGxZ58bISMZnH7LT2Z5CWU7CsRQUhMBvnWDA+vpYnOr23k9cbZt3pE8
        87iha+V0cIkJcvHGq83JEx1LAtaPj/QFM3cUCU0HnSZCjEUm6Jdsy/7i4LsJHQg82
X-Received: by 2002:a7b:c112:: with SMTP id w18mr4714059wmi.60.1629474741163;
        Fri, 20 Aug 2021 08:52:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaJBeCrGw4MnIfr+I5SADEkPPbDd6DJwmXEz/DXBgKbV1Dt/yBLdB7ItdMspgW4ZXDhi9QGA==
X-Received: by 2002:a7b:c112:: with SMTP id w18mr4714020wmi.60.1629474740919;
        Fri, 20 Aug 2021 08:52:20 -0700 (PDT)
Received: from ?IPv6:2003:d8:2f0a:7f00:fad7:3bc9:69d:31f? (p200300d82f0a7f00fad73bc9069d031f.dip0.t-ipconnect.de. [2003:d8:2f0a:7f00:fad7:3bc9:69d:31f])
        by smtp.gmail.com with ESMTPSA id a18sm10107804wmg.43.2021.08.20.08.52.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 08:52:20 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] fs: warn about impending deprecation of mandatory
 locks
To:     Jeff Layton <jlayton@kernel.org>, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     ebiederm@xmission.com, willy@infradead.org,
        linux-nfs@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-doc@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-afs@lists.infradead.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org,
        akpm@linux-foundation.org, luto@kernel.org, bfields@fieldses.org,
        w@1wt.eu, rostedt@goodmis.org, stable@vger.kernel.org
References: <20210820135707.171001-1-jlayton@kernel.org>
 <20210820135707.171001-2-jlayton@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <0f4f3e65-1d2d-e512-2a6f-d7d63effc479@redhat.com>
Date:   Fri, 20 Aug 2021 17:52:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210820135707.171001-2-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 20.08.21 15:57, Jeff Layton wrote:
> We've had CONFIG_MANDATORY_FILE_LOCKING since 2015 and a lot of distros
> have disabled it. Warn the stragglers that still use "-o mand" that
> we'll be dropping support for that mount option.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/namespace.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index ab4174a3c802..ffab0bb1e649 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1716,8 +1716,16 @@ static inline bool may_mount(void)
>   }
>   
>   #ifdef	CONFIG_MANDATORY_FILE_LOCKING
> +static bool warned_mand;
>   static inline bool may_mandlock(void)
>   {
> +	if (!warned_mand) {
> +		warned_mand = true;
> +		pr_warn("======================================================\n");
> +		pr_warn("WARNING: the mand mount option is being deprecated and\n");
> +		pr_warn("         will be removed in v5.15!\n");
> +		pr_warn("======================================================\n");
> +	}

Is there a reason not to use pr_warn_once() ?


-- 
Thanks,

David / dhildenb

