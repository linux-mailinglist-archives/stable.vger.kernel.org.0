Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFDA21C9EF
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 17:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgGLPMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 11:12:51 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21148 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728826AbgGLPMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jul 2020 11:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594566768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NZm5xGXGIsTfeQaPHTSVnSl1UUxikxu7jO8zjXTvbMg=;
        b=cYZ2N1Riw+JQUqpfzeCQWsC5dH7nQq75hwnH+fCtoRTADqCNeRGko9CrQ0kpW3EO+k/oAf
        Lw8mhVqKYtsnkOPbpPtwCD01FsagcMZPwqQTfOwXy8Wynl7B6+eMf/pysEq8Kz7jliVQuv
        6a5kqRVWFUb+ShnZx/vgGcbwQFSKDYI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-FOY5MZCsOJqGeM7Pk1YqSQ-1; Sun, 12 Jul 2020 11:12:47 -0400
X-MC-Unique: FOY5MZCsOJqGeM7Pk1YqSQ-1
Received: by mail-qk1-f200.google.com with SMTP id 204so8807953qki.20
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 08:12:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=NZm5xGXGIsTfeQaPHTSVnSl1UUxikxu7jO8zjXTvbMg=;
        b=ssA4PBSl4muwvMkbM5zp9JYA88i1HuiYDzJ9bIjCYAyRqJvTj3F7ek4V0hXpeGMd1c
         VTw88eK97Rkijws2kjvk+xmZkTTbw7qySWKGWZ9oT4+/D5QtNH2jTVIRZZ0jPFIoR9bP
         p1KWvurXtNB6H5e+wRlH6H0Lbtayit4aZKlgi6rWgQBiMh/GlZOE4S646tM+R2Lvx+es
         zfWLj32gZL8wkSj+uj6IyiPDtPggkovt8myJEbJInN2hp6QDs8zZKp1ObJ/hMkXqfdTB
         gJ5eIkWARyGRazGRBZNqCGOftaRDL4f+FUwADktgQi9AszJS+XvpAX+eO2PLifjUStpb
         nlmA==
X-Gm-Message-State: AOAM530xmuQ8M2BNCa7PEBjkKljusC/QavXmZrhNrTg4jH8IZsSssztL
        L2lZHXNhFvnLR3MdrX3U87J1VrwRPf11Gj2wm2gl65mNjG8qrKd79qvNtC/V5bSKv1uWXRp1C0v
        1rv4LHR9iWBeWsWvt
X-Received: by 2002:a0c:8b4a:: with SMTP id d10mr75669742qvc.31.1594566766118;
        Sun, 12 Jul 2020 08:12:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxof3kIA9KQH9Uz3TMrMaWXi5uVTUSUayn/bQ9qpSptU5kRHRyiS4JyiTCOnYzaR+1VriKdew==
X-Received: by 2002:a0c:8b4a:: with SMTP id d10mr75669730qvc.31.1594566765897;
        Sun, 12 Jul 2020 08:12:45 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id 23sm14431251qkl.52.2020.07.12.08.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2020 08:12:44 -0700 (PDT)
Subject: Re: [PATCH] decompress_bunzip2: fix sizeof type in start_bunzip
To:     "H. Peter Anvin" <hpa@zytor.com>, alain@knaff.lu
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200712125952.8809-1-trix@redhat.com>
 <639c8ef5-2755-7172-fbb8-ce45c8637feb@zytor.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <9af191c2-0f2c-7637-433a-b557a07590ca@redhat.com>
Date:   Sun, 12 Jul 2020 08:12:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <639c8ef5-2755-7172-fbb8-ce45c8637feb@zytor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 7/12/20 6:09 AM, H. Peter Anvin wrote:
> On 2020-07-12 05:59, trix@redhat.com wrote:
>> From: Tom Rix <trix@redhat.com>
>>
>> clang static analysis flags this error
>>
>> lib/decompress_bunzip2.c:671:13: warning: Result of 'malloc' is converted
>>   to a pointer of type 'unsigned int', which is incompatible with sizeof
>>   operand type 'int' [unix.MallocSizeof]
>>         bd->dbuf = large_malloc(bd->dbufSize * sizeof(int));
>>                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> Reviewing the bunzip_data structure, the element dbuf is type
>>
>> 	/* Intermediate buffer and its size (in bytes) */
>> 	unsigned int *dbuf, dbufSize;
>>
>> So change the type in sizeof to 'unsigned int'
>>
> You must be kidding.
>
> If you want to change it, change it to sizeof(bd->dbuf) instead, but this flag
> is at least in my opinion a total joke. For sizeof(int) != sizeof(unsigned
> int) is beyond bizarre, no matter how stupid the platform.

Using the actual type is more correct that using a type of the same size.

trix

> 	-hpa
>

