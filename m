Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F40F12662D8
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 18:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIKQDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 12:03:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40720 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbgIKQCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 12:02:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599840148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UzNqZBAGXS7F5Dy3gzRVUTnuTyaskfH6gaEmCpanmiQ=;
        b=H2hznv2HzIC6+jC2xylUd1+fbZeHxZ5JexRw5Nz07I1dOMGGysPfc2cGnKbI3cjHLkGqfd
        SxvK2k2SaqHm5lOB5Bzs/KOth8S9RZntbRDXOHtudY8641Rs8eO4/i7pvOG6oRBYEjsTG2
        6YtqTIyY+tp6d94/12BYAfXLDEqyAUw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148--GZ5Gz-ONc6Ytih6YfCorA-1; Fri, 11 Sep 2020 12:02:25 -0400
X-MC-Unique: -GZ5Gz-ONc6Ytih6YfCorA-1
Received: by mail-wm1-f69.google.com with SMTP id g79so2018900wmg.0
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 09:02:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UzNqZBAGXS7F5Dy3gzRVUTnuTyaskfH6gaEmCpanmiQ=;
        b=pyMqf7MbRIaA69NDctZ5iTT0FCZYPB+wL4NbZKEMxwNch7C8cV3Io2mhT5/lk5MwaI
         eYU5PIHt5GfHQnA0mXtUUpxT1XIn/bbN14MppBIIUS3inxpi8+ODSQ6zBPsQZplrvX1z
         WwWYuNt6jJAFMOiLwsA12/WhUOWeX7/jfsu6nJWXATZm+ZvSZv1ezoLVCdjB6RMyyiFF
         MBd9OPNzO4cO+jA4/szi1ck+YbIGpdKiipA0basewvGdhOn45Z7abHjyot1uuQKq5iPh
         Bgh3eyLLzIpZ5fa+pEuGZJRPmVLoG+zf8Q8gbXODZC5Chjsc/MEYZmDsRY6WzK9Y8EWG
         LBbA==
X-Gm-Message-State: AOAM5326BPo+cuU+lqWV7tJd7Z98xDL+3RLRgDzNFvWAzxHsGb043ah0
        FWQRatd+kNpLG90qAiQWA7JzqB7onvW+2NKoTl8V2Iqbn6HdUa8wOSjxjobd5ovFZ+YjYeoMDPz
        MkvgNqdaaEzvzOuB/
X-Received: by 2002:adf:f70d:: with SMTP id r13mr2807366wrp.317.1599840143601;
        Fri, 11 Sep 2020 09:02:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzlZ/52RedjxDE7fk9zVT8weEe/dNfRBYU1gf7UxBbf9Eg9Ud+Y+MHJJZv6HKemXzFN9Gm3jw==
X-Received: by 2002:adf:f70d:: with SMTP id r13mr2807329wrp.317.1599840143390;
        Fri, 11 Sep 2020 09:02:23 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id l10sm4868973wru.59.2020.09.11.09.02.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 09:02:22 -0700 (PDT)
Subject: Re: [RESEND PATCH v2] KVM: fix memory leak in
 kvm_io_bus_unregister_dev()
To:     Rustam Kovhaev <rkovhaev@gmail.com>, vkuznets@redhat.com,
        gustavoars@kernel.org, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
References: <20200907185535.233114-1-rkovhaev@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <979a4030-6934-41bd-ee55-a3e301f04cc6@redhat.com>
Date:   Fri, 11 Sep 2020 18:02:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200907185535.233114-1-rkovhaev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/09/20 20:55, Rustam Kovhaev wrote:
> when kmalloc() fails in kvm_io_bus_unregister_dev(), before removing
> the bus, we should iterate over all other devices linked to it and call
> kvm_iodevice_destructor() for them
> 
> Fixes: 90db10434b16 ("KVM: kvm_io_bus_unregister_dev() should never fail")
> Cc: stable@vger.kernel.org
> Reported-and-tested-by: syzbot+f196caa45793d6374707@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=f196caa45793d6374707
> Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> v2:
> - remove redundant whitespace
> - remove goto statement and use if/else
> - add Fixes tag
> ---
>  virt/kvm/kvm_main.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 67cd0b88a6b6..cf88233b819a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4332,7 +4332,7 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
>  void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>  			       struct kvm_io_device *dev)
>  {
> -	int i;
> +	int i, j;
>  	struct kvm_io_bus *new_bus, *bus;
>  
>  	bus = kvm_get_bus(kvm, bus_idx);
> @@ -4349,17 +4349,20 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
>  
>  	new_bus = kmalloc(struct_size(bus, range, bus->dev_count - 1),
>  			  GFP_KERNEL_ACCOUNT);
> -	if (!new_bus)  {
> +	if (new_bus) {
> +		memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
> +		new_bus->dev_count--;
> +		memcpy(new_bus->range + i, bus->range + i + 1,
> +		       (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
> +	} else {
>  		pr_err("kvm: failed to shrink bus, removing it completely\n");
> -		goto broken;
> +		for (j = 0; j < bus->dev_count; j++) {
> +			if (j == i)
> +				continue;
> +			kvm_iodevice_destructor(bus->range[j].dev);
> +		}
>  	}
>  
> -	memcpy(new_bus, bus, sizeof(*bus) + i * sizeof(struct kvm_io_range));
> -	new_bus->dev_count--;
> -	memcpy(new_bus->range + i, bus->range + i + 1,
> -	       (new_bus->dev_count - i) * sizeof(struct kvm_io_range));
> -
> -broken:
>  	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
>  	synchronize_srcu_expedited(&kvm->srcu);
>  	kfree(bus);
> 

Queued, thanks.

I am currently on leave so I am going through the patches and queuing
them, but I will only push kvm/next and kvm/queue next week.  kvm/master
patches will be sent to Linus for the next -rc though.

Paolo

