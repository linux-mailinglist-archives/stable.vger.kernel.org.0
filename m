Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 987B121CB5C
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 22:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbgGLUiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 16:38:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49815 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729287AbgGLUiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jul 2020 16:38:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594586294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2qBve8P2iGMkyjOWMAQQIHIgHGMhCrdFQndb3uLOLP0=;
        b=RTbEEIQCnZzC1fggiH1DvwcEwif0Sd2Dtk1sxySxtA625HCUmhIOhDOSm4qG+NrfTUDWo9
        d5XMVIDqQ61OsQ2HyIjy0hgrmb3p1qiZzMmFswAL6mmti8AYuZUdYudbTdyXF5zeN1BgCz
        ryPdYO+OSU9puN0Bwa2+ODdN7Hzl9BQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-o-dHY2TIMYeafoY1jdibKw-1; Sun, 12 Jul 2020 16:38:12 -0400
X-MC-Unique: o-dHY2TIMYeafoY1jdibKw-1
Received: by mail-qk1-f198.google.com with SMTP id p126so9310863qkf.15
        for <stable@vger.kernel.org>; Sun, 12 Jul 2020 13:38:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=2qBve8P2iGMkyjOWMAQQIHIgHGMhCrdFQndb3uLOLP0=;
        b=U8t5yPQoCDek/2OkJkChhFQKrQU0n4mVo/op7Ewg5cfHt8imvrrfXuljFtNe1L0EqF
         aTV+b3R16YeNZPMmO77HH+a25YcztC60HDiPoV0WYhdd0FQhXFEIqR38DuFdaJf5Mbld
         ZkpAL04Tav6ndTDsF3nTJnMV2HyFgymw0G6o1hh+h+vA6Nyk67/Qh/NPtWVxZL8Xv6Nn
         Hx6KEeY6L7tz19wsjdsUrx3doJZAiotu31efS3vvwQfPGNxQt/f6tmjpNorkfKpHpn1C
         zGWgQilcNp2gS3WS/OS3Tpe++e+cPfrv9J8ZTkp3J7ppeElqssZed1tK1VHdJNvxUZ69
         PPkQ==
X-Gm-Message-State: AOAM531OmVcFxe0wIqF03YZEKmlDv2Z89rYsUbCFkfks1nCsx9EhPoQI
        mDr/7lUkEtaKvR+ML/+fgP27WsvgWl2sSWEz74kkksp8fx/dJYcLZUfit86ddX5YaW3g62oUuG2
        MhE8O8U0pJ9NH9Uwb
X-Received: by 2002:a37:a6ce:: with SMTP id p197mr77389772qke.211.1594586291879;
        Sun, 12 Jul 2020 13:38:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxu5vmq81STqIAWaA8vKj+4yrVNtB6fhaAqeiECOx5LnqlE72lt6VYPIxlLT4MvQlZKWCzZQ==
X-Received: by 2002:a37:a6ce:: with SMTP id p197mr77389763qke.211.1594586291593;
        Sun, 12 Jul 2020 13:38:11 -0700 (PDT)
Received: from [192.168.23.174] (c-73-253-167-23.hsd1.ma.comcast.net. [73.253.167.23])
        by smtp.gmail.com with ESMTPSA id o10sm16085503qtq.71.2020.07.12.13.38.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2020 13:38:10 -0700 (PDT)
Subject: Re: [PATCH 1/2] bcache: avoid nr_stripes overflow in
 bcache_device_init()
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        stable@vger.kernel.org
References: <20200712174736.9840-1-colyli@suse.de>
 <1011c22f-d186-6398-98e1-83f1c363dedd@suse.de>
From:   Ken Raeburn <raeburn@redhat.com>
Organization: Red Hat, Inc.
Message-ID: <a504604d-ac8a-3276-e0b8-f42cb3782356@redhat.com>
Date:   Sun, 12 Jul 2020 16:38:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1011c22f-d186-6398-98e1-83f1c363dedd@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 7/12/20 1:49 PM, Coly Li wrote:
> On 2020/7/13 01:47, Coly Li wrote:
>> For some block devices which large capacity (e.g. 8TB) but small io_opt
>> size (e.g. 8 sectors), in bcache_device_init() the stripes number calcu-
>> lated by,
>> 	DIV_ROUND_UP_ULL(sectors, d->stripe_size);
>> might be overflow to the unsigned int bcache_device->nr_stripes.
>>
>> This patch uses an unsigned long variable to store DIV_ROUND_UP_ULL()
>> and after the value is checked to be available in unsigned int range,
>> sets it to bache_device->nr_stripes. Then the overflow is avoided.
> Hi Ken,
>
> Could you please to try whether these two patches may avoid the kernel
> panic ? I will post the overwhelm stripe_size patch later.
>
> Thanks.
>
> Coly Li
>
I will. But, from inspection: On a 32-bit system, "unsigned long" will 
still be 32 bits, but sector_t (u64) will still be 64 bits, so that 
assignment will still discard high bits before validation in that 
environment. I suggest "unsigned long long" or another specifically 
64-bit type.

Also, the VDO driver I work on doesn't support 32-bit platforms 
currently, so my own testing will be limited to 64-bit platforms.

Ken

