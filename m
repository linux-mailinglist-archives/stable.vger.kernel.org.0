Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCFA655C41
	for <lists+stable@lfdr.de>; Sun, 25 Dec 2022 04:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiLYDeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Dec 2022 22:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLYDeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Dec 2022 22:34:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1408895A5;
        Sat, 24 Dec 2022 19:33:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF676B803F2;
        Sun, 25 Dec 2022 03:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FB0C433EF;
        Sun, 25 Dec 2022 03:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671939236;
        bh=HBs48LNTjteYim6wGJgPGSaGT7qA/LzlKBR3O8bHfls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jtDumGesS6zPX7w7WZPcPtT9aQpJ0Wf/p4LZ5LMUQq7BKFDyf8Mx4Kx/gFXhel7u1
         z+HQQETjQ6xeG5nYSoHtMEzwcZxoPOXgYNnezzrE+D+W9g+HVuh2tKIBJqK9eZZyle
         yFlOu7MRBMIqIU3UiVAZHujhfdLej1Aivbo7TomFhwNqc41uhp+5gYn2vNRPFBvgcA
         0E/E5xcrODfgxk8pa4QPkKLxliIHXETYKgzy1aL9HcY+VWB7vwN2U3/dn+5mVD3Ctw
         XtkhDrdcl0KZSSTr8PIJHDg0+uWZNFdp7MdT0VPnGZddHWHUVmmTGtJwPzo1FS3f3v
         h5Pb3hLVW+SsA==
Date:   Sat, 24 Dec 2022 22:33:54 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Tyler Hicks <code@tyhicks.com>, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Karolina Drobnik <karolinadrobnik@gmail.com>,
        Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH 5.15 0/2] Fix kvm selftest build failures in linux-5.15.y
Message-ID: <Y6fEohBcwosOVKch@sashalap>
References: <20221223000958.729256-1-code@tyhicks.com>
 <d0519826-79ae-38b4-5ec2-04c7e0874ef6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d0519826-79ae-38b4-5ec2-04c7e0874ef6@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 23, 2022 at 05:45:44PM +0100, Paolo Bonzini wrote:
>On 12/23/22 01:09, Tyler Hicks wrote:
>>From: "Tyler Hicks" <code@tyhicks.com>
>>
>>The backport of commit 05c2224d4b04 ("KVM: selftests: Fix number of
>>pages for memory slot in memslot_modification_stress_test") broke the
>>build of the KVM selftest memslot_modification_stress_test.c source file
>>in two ways:
>>
>>- Incorrectly assumed that max_t() was defined despite commit
>>   5cf67a6051ea ("tools/include: Add _RET_IP_ and math definitions to
>>   kernel.h") not being present
>>- Incorrectly assumed that kvm_vm struct members could be directly
>>   accessed despite b530eba14c70 ("KVM: selftests: Get rid of
>>   kvm_util_internal.h") not being present
>>
>>Backport the first commit, as it is simple enough. Work around the lack
>>of the second commit by using the accessors to get to the kvm_vm struct
>>members.
>>
>>Note that the linux-6.0.y backport of commit 05c2224d4b04 ("KVM:
>>selftests: Fix number of pages for memory slot in
>>memslot_modification_stress_test") is fine because the two prerequisite
>>commits, mentioned above, are both present in v6.0.
>>
>>Tyler
>>
>>Karolina Drobnik (1):
>>   tools/include: Add _RET_IP_ and math definitions to kernel.h
>>
>>Tyler Hicks (Microsoft) (1):
>>   KVM: selftests: Fix build regression by using accessor function
>>
>>  tools/include/linux/kernel.h                                | 6 ++++++
>>  .../selftests/kvm/memslot_modification_stress_test.c        | 2 +-
>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>
>
>Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>

Queued up, thanks!

-- 
Thanks,
Sasha
