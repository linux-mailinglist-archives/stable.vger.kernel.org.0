Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EE53555AD
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 15:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244211AbhDFNt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 09:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232452AbhDFNty (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 09:49:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABADD61241;
        Tue,  6 Apr 2021 13:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617716986;
        bh=givtkE6w970XJqu87v0fdB35fYmge8p/pZlS2XlOWOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ifTuBDBoh0Jwrue0jexOqECLiomd89qyNNgwZJRXFFUlGV6Sp6sRouovNUfPw/NS2
         iaE9x7d7uivsvUF6dcEf0R/SIQ43DK/odMMI0Tq9i+OqRREcBIKi8w464+kRcnSMdk
         Rho+oltZ+ED54HrzL514jSzYanR170Xq0w/BtC5k9oH8EMXcFBzJSXHeHA+hW3aBxn
         qBM9H5oIdWbmprLJRMiDbx8uR5jMZqFVks4YVrFVyC7SgVvF1YV23gA6RF1lD1d+o8
         7qGJx1yDJ0ghe4IOgm17qNc7NwvmObgpecDipY37uzbYLUyj9KFZmnNPZRr4TFGz1P
         KhRvYMqHq9FrA==
Date:   Tue, 6 Apr 2021 09:49:45 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 5.10 096/126] KVM: x86/mmu: Use atomic ops to set SPTEs
 in TDP MMU map
Message-ID: <YGxm+WISdIqfwqXD@sashalap>
References: <20210405085031.040238881@linuxfoundation.org>
 <20210405085034.229578703@linuxfoundation.org>
 <98478382-23f8-57af-dc17-23c7d9899b9a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <98478382-23f8-57af-dc17-23c7d9899b9a@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 06, 2021 at 08:09:26AM +0200, Paolo Bonzini wrote:
>On 05/04/21 10:54, Greg Kroah-Hartman wrote:
>>From: Ben Gardon <bgardon@google.com>
>>
>>[ Upstream commit 9a77daacc87dee9fd63e31243f21894132ed8407 ]
>>
>>To prepare for handling page faults in parallel, change the TDP MMU
>>page fault handler to use atomic operations to set SPTEs so that changes
>>are not lost if multiple threads attempt to modify the same SPTE.
>>
>>Reviewed-by: Peter Feiner <pfeiner@google.com>
>>Signed-off-by: Ben Gardon <bgardon@google.com>
>>
>Whoa no, you have included basically a whole new feature, except for 
>the final patch that actually enables the feature.  The whole new MMU 

Right, we would usually grab dependencies rather than modifying the
patch. It means we diverge less with upstream, and custom backports tend
to be buggier than just grabbing dependencies.

>is still not meant to be used in production and development is still 
>happening as of 5.13.

Unrelated to this disucssion, but how are folks supposed to know which
feature can and which feature can't be used in production? If it's a
released kernel, in theory anyone can pick up 5.12 and use it in
production.

>Were all these patches (82-97) included just to enable patch 98 ("KVM: 
>x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping")?  
>Same for 105-120 in 5.11.

Yup. Is there anything wrong with those patches?

-- 
Thanks,
Sasha
