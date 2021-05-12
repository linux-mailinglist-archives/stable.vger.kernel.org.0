Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F36337BDA4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 15:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhELNGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 09:06:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36686 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230472AbhELNGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 09:06:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620824710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XiWG5W8/qq3Xi8QrRG8Im7h5YU3YX3P+mOuP3GGjhHA=;
        b=SnFOjI7+8GXDdRi3Z4urOtWpvH6Npcy0gM4MPf2f/uUhWyUwyeVODbt4xLD3X6QJgScndH
        02ZppkD7ITHPmD7QGGw49NAs7JUIHXTlo6bhyKLk7znrF8LH/WpsU0iMn9FsPrSass2Td3
        v2PCmHWz2UAx2aysycDyJVnqyxq9DxI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-zGeoUMUYOrKFY8ONM933Jg-1; Wed, 12 May 2021 09:05:06 -0400
X-MC-Unique: zGeoUMUYOrKFY8ONM933Jg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD3C5801B13;
        Wed, 12 May 2021 13:05:05 +0000 (UTC)
Received: from [10.36.112.87] (ovpn-112-87.ams2.redhat.com [10.36.112.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ABEAA189A5;
        Wed, 12 May 2021 13:05:04 +0000 (UTC)
Subject: Re: FAILED: patch "[PATCH] KVM: arm/arm64: Fix
 KVM_VGIC_V3_ADDR_TYPE_REDIST read" failed to apply to 4.19-stable tree
To:     Marc Zyngier <maz@kernel.org>, gregkh@linuxfoundation.org
Cc:     Stable@vger.kernel.org, gshan@redhat.com
References: <162081638318160@kroah.com> <87k0o4nr4u.wl-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <b874a8b0-7532-e423-b918-2a5c95d0c3b1@redhat.com>
Date:   Wed, 12 May 2021 15:05:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <87k0o4nr4u.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Marc,

On 5/12/21 1:11 PM, Marc Zyngier wrote:
> On Wed, 12 May 2021 11:46:23 +0100,
> <gregkh@linuxfoundation.org> wrote:
>>
>>
>> The patch below does not apply to the 4.19-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>> ------------------ original commit in Linus's tree ------------------
>>
>> From 94ac0835391efc1a30feda6fc908913ec012951e Mon Sep 17 00:00:00 2001
>> From: Eric Auger <eric.auger@redhat.com>
>> Date: Mon, 12 Apr 2021 17:00:34 +0200
>> Subject: [PATCH] KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read
>>
>> When reading the base address of the a REDIST region
>> through KVM_VGIC_V3_ADDR_TYPE_REDIST we expect the
>> redistributor region list to be populated with a single
>> element.
>>
>> However list_first_entry() expects the list to be non empty.
>> Instead we should use list_first_entry_or_null which effectively
>> returns NULL if the list is empty.
>>
>> Fixes: dbd9733ab674 ("KVM: arm/arm64: Replace the single rdist region by a list")
>> Cc: <Stable@vger.kernel.org> # v4.18+
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Reported-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> Link: https://lore.kernel.org/r/20210412150034.29185-1-eric.auger@redhat.com
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
>> index 2f66cf247282..7740995de982 100644
>> --- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
>> +++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
>> @@ -87,8 +87,8 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
>>  			r = vgic_v3_set_redist_base(kvm, 0, *addr, 0);
>>  			goto out;
>>  		}
>> -		rdreg = list_first_entry(&vgic->rd_regions,
>> -					 struct vgic_redist_region, list);
>> +		rdreg = list_first_entry_or_null(&vgic->rd_regions,
>> +						 struct vgic_redist_region, list);
>>  		if (!rdreg)
>>  			addr_ptr = &undef_value;
>>  		else
> 
> Eric, any chance you could look at a potential backport of this patch
> to both 4.19 and 5.4?

yes I will have a look.

Thanks

Eric
> 
> Thanks a lot,
> 
> 	M.
> 

