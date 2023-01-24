Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2296F67A45C
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 21:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbjAXUzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 15:55:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbjAXUzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 15:55:10 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0582469B
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 12:55:08 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id i1so12096270pfk.3
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 12:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4iif8uOvCWoECAPC960J0vT0zRUyTNY5Xp1ISUwKG1o=;
        b=lq2fSJtIZK8svWsVJH3RAgO00ixB7IhxPLOv95YiLUyzutJxolmr/3OMwrSctvHOGc
         Sg3R9z97VLF7Zl6Su8Jt616hCNVFi+D4KhpUbMxuE+Snxg/M0HUJpJDezv2gs0raPsOv
         69y6dKa+lGeK3Ujy+sk1zSy1LogbWVKSyJQEcmsmcz7F4Bhy8CWxo/CW2S9eS0fjMmQF
         GTTJA7qbuRBmhyFXlQiSlNSEHaYYKwyVtY3adttlhyM3KiqGoYcXYf6eccahPiJzLKtt
         lkDof1e6ORlcGJxeXC27Q9Xv0xQlF7hEoQfec8Fe1ycIObeLD+avF4V4G7idurb3qpMw
         i2NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4iif8uOvCWoECAPC960J0vT0zRUyTNY5Xp1ISUwKG1o=;
        b=nju3CiD5myw3HAbDrguYiyoTgLNCqwg0ubuThYUI733Qh2RoAxtStY0gET8avzQcuL
         M55QijshmR8sbYmwQXO+XN5HGFFrfWhapnLH1VpP4qaWfctzYxlvq4KqYe1R35shSpWI
         kibXOfXDoixzDSdUVHetn4YHy5vU53Br2fv35qEfwta3sV06i8J7C8aw7fD7xfzZSPs8
         MszO+UmPeYtVLuAOn2UNMvxgelJ7mQOUBJ28/kKum0hZJiE0z198xaFXA3gzSWi1OOpm
         4nkvWDckFhO6fDj7t+Yqp401sMLviWWYRQdSqouEl1GQ1fu+eHBJ8n9tjFdjkiluZVOq
         LfEA==
X-Gm-Message-State: AO0yUKVp7/oVpDaiUbyC6RNU3BuKPyZNBcMeVOpUmtUhJD8VSdlQgb4B
        JWxVdR8135lRn8HvkwVIoOBuxjPSUTVG7hcdNpo=
X-Google-Smtp-Source: AK7set9bk+Z6mIxbxK6n+1smZ+XJVNFEetrz2jVIJ+/M2MgwAdcDlChSfdCNcRW9J/xj95CcEpRw7Q==
X-Received: by 2002:a62:7988:0:b0:58b:cb1b:978f with SMTP id u130-20020a627988000000b0058bcb1b978fmr303379pfc.1.1674593708105;
        Tue, 24 Jan 2023 12:55:08 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c7-20020a056a00008700b005769b23260fsm2111261pfj.18.2023.01.24.12.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 12:55:07 -0800 (PST)
Date:   Tue, 24 Jan 2023 20:55:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     Wei Wang <wei.w.wang@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        =?utf-8?B?5p+z6I+B5bOw?= <liujingfeng@qianxin.com>
Subject: Re: [PATCH v1] KVM: destruct kvm_io_device while unregistering it
 from kvm_io_bus
Message-ID: <Y9BFqIK04V6fBMz7@google.com>
References: <20221229123302.4083-1-wei.w.wang@intel.com>
 <Y88XYR0L2DyiKnIM@google.com>
 <85285ccd-7b1a-9a94-5471-8036cb824b28@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85285ccd-7b1a-9a94-5471-8036cb824b28@rbox.co>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023, Michal Luczaj wrote:
> On 1/24/23 00:25, Sean Christopherson wrote:
> > On Thu, Dec 29, 2022, Wei Wang wrote:
> >> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> >> index 2a3ed401ce46..1b277afb545b 100644
> >> --- a/virt/kvm/eventfd.c
> >> +++ b/virt/kvm/eventfd.c
> >> @@ -898,7 +898,6 @@ kvm_deassign_ioeventfd_idx(struct kvm *kvm, enum kvm_bus bus_idx,
> >>  		bus = kvm_get_bus(kvm, bus_idx);
> >>  		if (bus)
> >>  			bus->ioeventfd_count--;
> >> -		ioeventfd_release(p);
> >>  		ret = 0;
> >>  		break;
> >>  	}
> 
> I was wondering: would it make sense to simplify from
> list_for_each_entry_safe() to list_for_each_entry() in this loop?

Ooh, yeah, that's super confusing, at least to me, because the "safe" part implies
that the loop processes entries after kvm_io_bus_unregister_dev(), i.e. needs to
guard against failure same as the coalesced MMIO case.

Wei, want to tack on a patch in v2?

> >> @@ -5453,18 +5459,18 @@ int kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
> >>  	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
> >>  	synchronize_srcu_expedited(&kvm->srcu);
> >>  
> >> -	/* Destroy the old bus _after_ installing the (null) bus. */
> >> +	/*
> >> +	 * If (null) bus is installed, destroy the old bus, including all the
> >> +	 * attached devices. Otherwise, destroy the caller's device only.
> >> +	 */
> >>  	if (!new_bus) {
> >>  		pr_err("kvm: failed to shrink bus, removing it completely\n");
> >> -		for (j = 0; j < bus->dev_count; j++) {
> >> -			if (j == i)
> >> -				continue;
> >> -			kvm_iodevice_destructor(bus->range[j].dev);
> >> -		}
> >> +		kvm_io_bus_destroy(bus);
> >> +		return -ENOMEM;
> > 
> > Returning an error code is unnecessary if unregister_dev() destroys the bus.
> > Nothing ultimately consumes the result, e.g. kvm_vm_ioctl_unregister_coalesced_mmio()
> > intentionally ignores the result other than to bail from the loop, and destroying
> > the bus means it will immediately bail from the loop anyways.
> 
> But it is important to know _if_ the bus was destroyed, right?
> IOW, doesn't your comment from commit 5d3c4c79384a still hold?

/facepalm

Yes, it matters.  I somehow got on the train of thought that list_for_each_entry_safe()
magically bails if the list is purged, but the safe variant only plays nice with
the _current_ entry being deleted.

So yeah, the return code needs to stay.

>     (...) But, it doesn't tell the caller that it obliterated the
>     bus and invoked the destructor for all devices that were on the bus.  In
>     the coalesced MMIO case, this can result in a deleted list entry
>     dereference due to attempting to continue iterating on coalesced_zones
>     after future entries (in the walk) have been deleted.
> 
> Michal
> 
