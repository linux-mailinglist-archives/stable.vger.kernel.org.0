Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6911466DD
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 12:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgAWLgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 06:36:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59031 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728139AbgAWLgH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 06:36:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579779366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bi8LeW06fZZr3fzsbfcVE+s/pxdz6ITVUp+XN3fIHAk=;
        b=OmbEdp+op6A8MD0/ZQ6HZkuBhyxvUgbQQzq4u3igu2iGYHt32O26Q2iRZ6GVE2ZHiixj3D
        MmDGAQmY37iwrsu+WYRXAFSZpPJzVRrtN1wytrEPFYYtOjU7Hoi9UnTpNBaOD3kxkDNp0K
        IeyEQbGYGVz2Nelf/8GqEZPnfEwSnhQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-S3KGus-5N5uIBUe8P9nHZg-1; Thu, 23 Jan 2020 06:36:04 -0500
X-MC-Unique: S3KGus-5N5uIBUe8P9nHZg-1
Received: by mail-wr1-f69.google.com with SMTP id c6so1547169wrm.18
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 03:36:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bi8LeW06fZZr3fzsbfcVE+s/pxdz6ITVUp+XN3fIHAk=;
        b=SAzWKII+zXUhOWvRFP5DoXcjLxskvkD0scpzyg/Jw/cAo34oTGjjSUvdkP6VefU4ub
         GwDB6+Ga/nz6D8IIireVkb075VsNp3wm7Wq2XLSe7mzzdyqHeT2pNudnIGgmtyhbv6R9
         1uq+jjU1WXqg7Akk1QH4zEIqfXYOvsVhzLSmrKdjpdCKytRPBT6Fv2KiGhudV8TKUVTr
         APNetCALaD+ICPwIDgJwdABqPFbiJ4qF3NlpCEHN3jDgKm7FnwfIPXfx4F7ApCUjcI1I
         zH+hG58DGCOjNzv8Phx1K+5e4ykGW9Vcnl63XhxWtFrg2RWIoGFZr51grIlPq9HOse07
         eI2w==
X-Gm-Message-State: APjAAAUw67IzCeF33tUgiirB9ayhCbzZr4Iqlm1wTBlA12W0Pd/nU9Ty
        q+D4iCN2M0V+/8xPOAPDpp0WjoInwYUrVXrEtT1fj5Kqja8GCYpu72dyZUKD62FG9XB9/4ANeR7
        WteNmsN3UTP+apQGp
X-Received: by 2002:a5d:6ac3:: with SMTP id u3mr18058211wrw.25.1579779363167;
        Thu, 23 Jan 2020 03:36:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqwoGjn/0V+sdl+z38p2Ox7b5U5YbxLK1TAjEmzDEBF7XjGDA9XuZShzCEpQmSPi7PxX/vu43w==
X-Received: by 2002:a5d:6ac3:: with SMTP id u3mr18058190wrw.25.1579779362926;
        Thu, 23 Jan 2020 03:36:02 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id a16sm2684691wrt.37.2020.01.23.03.35.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 03:36:02 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: x86: reorganize pvclock_gtod_data members
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     mtosatti@redhat.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1579702953-24184-1-git-send-email-pbonzini@redhat.com>
 <1579702953-24184-2-git-send-email-pbonzini@redhat.com>
 <87tv4mqug3.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <09535a66-d72c-6983-3c10-09d12ed9e632@redhat.com>
Date:   Thu, 23 Jan 2020 12:35:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87tv4mqug3.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23/01/20 12:32, Vitaly Kuznetsov wrote:
> Likely a personal preference but the suggested naming is a bit
> confusing: we use 'base_cycles' to keep 'xtime_nsec' and 'offset' to
> keep ... 'base'. Not that I think that 'struct timekeeper' is perfect
> but at least it is documented. Should we maybe just stick to it (and
> name 'struct pvclock_clock' fields accordingly?)
> 

The problem is that xtime_nsec is not nanoseconds, and I'd really not
want to have a worse name just for consistency. :(  I chose
"base_cycles" as an incremental improvement over nsec_base, even though
that meant also changing struct timekeeper's "base" to "offset".

Paolo

