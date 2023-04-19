Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CFA6E75D3
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 10:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbjDSI60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 04:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbjDSI6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 04:58:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257D126A2;
        Wed, 19 Apr 2023 01:58:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B785F62BD9;
        Wed, 19 Apr 2023 08:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7E5C433EF;
        Wed, 19 Apr 2023 08:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681894701;
        bh=mBy7r4l2S8sicYbRnowa3lQqGGdm/51Xuq6XArqu3Zk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bobUFuFPQIIKHJelLDSsryC4Q5j9L7duxM1U0wdbCnHMb6jHGNVChnXC4GvQx2BlO
         jcvYNbBVew1IC9cGV409dehjC4MHIy1bAMg/tqmpMXc/LifTPfeeuYkOiCW00IXAIY
         00E1a+S5U6h/9VMiqHAzVfyNSNbRTXlbZim2glBIbHs/Rlh3XGTtJhC65G2IN+sNml
         hX79mWsy9kipjJxnXvXRRuMZQXWCVo60uWcgJerMwLU9rx4gisqp/FrH6T/qGxEWtU
         dk7H8P8obKQuR1YcCmzfkIHb4bPm/rzMe+pVN0s79Q6SGmOz3fQTL65jjQBD+U+eOV
         WIp7eTYMOi13Q==
Date:   Wed, 19 Apr 2023 09:58:15 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Quentin Perret <qperret@google.com>,
        Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] KVM: arm64: Make vcpu flag updates non-preemptible
Message-ID: <20230419085814.GA928@willie-the-truck>
References: <20230418125737.2327972-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418125737.2327972-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 01:57:37PM +0100, Marc Zyngier wrote:
> Per-vcpu flags are updated using a non-atomic RMW operation.
> Which means it is possible to get preempted between the read and
> write operations.
> 
> Another interesting thing to note is that preemption also updates
> flags, as we have some flag manipulation in both the load and put
> operations.
> 
> It is thus possible to lose information communicated by either
> load or put, as the preempted flag update will overwrite the flags
> when the thread is resumed. This is specially critical if either
> load or put has stored information which depends on the physical
> CPU the vcpu runs on.
> 
> This results in really elusive bugs, and kudos must be given to
> Mostafa for the long hours of debugging, and finally spotting
> the problem.
> 
> Fix it by disabling preemption during the RMW operation, which
> ensures that the state stays consistent. Also upgrade vcpu_get_flag
> path to use READ_ONCE() to make sure the field is always atomically
> accessed.
> 
> Fixes: e87abb73e594 ("KVM: arm64: Add helpers to manipulate vcpu flags among a set")
> Reported-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
> 
> Notes:
>     v2: add READ_ONCE() on the read path, expand commit message

Acked-by: Will Deacon <will@kernel.org>

Will
