Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93ED6156CB8
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 22:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgBIV3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 16:29:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgBIV33 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Feb 2020 16:29:29 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2465020726;
        Sun,  9 Feb 2020 21:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581283769;
        bh=333a0iqIvpw7uaAO1dZ9y1/SXijvva+03F7OwgU5BDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wT4nQNSYX6s1RHXAd2olLnP9U44rDWK9Ekylyb8SzO80Fe2f1AaiNH2C9/8ivNiLL
         bZj2T/Va1EbqIs6dAT1n1sO0vR6gBPgC+Z/Xlq2CENllBDr4Sj/H8HO66zZRYmqNuu
         kVo9S02vd297iGq4Wa2dAmbgTlXXuYqvajdgtboM=
Date:   Sun, 9 Feb 2020 16:29:28 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     sean.j.christopherson@intel.com, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] KVM: Play nice with read-only memslots
 when querying host" failed to apply to 5.5-stable tree
Message-ID: <20200209212928.GE3584@sasha-vm>
References: <158125181221109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158125181221109@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 09, 2020 at 01:36:52PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 42cde48b2d39772dba47e680781a32a6c4b7dc33 Mon Sep 17 00:00:00 2001
>From: Sean Christopherson <sean.j.christopherson@intel.com>
>Date: Wed, 8 Jan 2020 12:24:38 -0800
>Subject: [PATCH] KVM: Play nice with read-only memslots when querying host
> page size
>
>Avoid the "writable" check in __gfn_to_hva_many(), which will always fail
>on read-only memslots due to gfn_to_hva() assuming writes.  Functionally,
>this allows x86 to create large mappings for read-only memslots that
>are backed by HugeTLB mappings.
>
>Note, the changelog for commit 05da45583de9 ("KVM: MMU: large page
>support") states "If the largepage contains write-protected pages, a
>large pte is not used.", but "write-protected" refers to pages that are
>temporarily read-only, e.g. read-only memslots didn't even exist at the
>time.
>
>Fixes: 4d8b81abc47b ("KVM: introduce readonly memslot")
>Cc: stable@vger.kernel.org
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>[Redone using kvm_vcpu_gfn_to_memslot_prot. - Paolo]
>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I'm not sure what was wrong with 5.5-4.14, it applied/built fine for me.

For 4.9 and 4.4, it depends on f9b84e19221e ("KVM: Use vcpu-specific
gva->hva translation when querying host page size") which wasn't
backported that far, so this one should also be backported to 4.9 and
4.4.

-- 
Thanks,
Sasha
