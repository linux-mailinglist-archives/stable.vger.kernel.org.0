Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F4C423FB7
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 16:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhJFODu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 10:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231403AbhJFODu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 10:03:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBDBE60F6D;
        Wed,  6 Oct 2021 14:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633528917;
        bh=nZWRGd2zlbKt5Iiq2ux0/Ztp5SZplgWejtkIrrKZUuU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VwoQVUWdPMMqKAsgwnkx8gb9o17so3ZIUYe9uHzXfOHiiLzRpfrt4cLoGsuUyrPF8
         A3rtOl+95+B0IDUsN3uY/gjA9Hm7A0PRREBU5CQNbO8nKkf1cz+KNKV3cHq/FsZoOv
         lMTT9+X8AHFYsYOjKS93HcSU3XU9q5jOTBoNkbowOOHNLKx2zoz1H1YG0qmwA99uOU
         Bv1yCUtOR4J08xnsp7PcWSaQBFP+4lqzFYsuDxCFyKeulV5fMkr9iwlLXEQKvH5f6W
         hgjgvSO8tO7IRnpnez/Ug6E4p94On6OBMEVJMurGvkjw2Vq03Ibhkh532kdP0yiQSV
         wP7yzWrIDmJMg==
Date:   Wed, 6 Oct 2021 10:01:56 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Oliver Upton <oupton@google.com>,
        Andrew Jones <drjones@redhat.com>, shuah@kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH MANUALSEL 5.10 1/7] selftests: KVM: Align SMCCC call with
 the spec in steal_time
Message-ID: <YV2sVNoW8vbKrKr1@sashalap>
References: <20211006111234.264020-1-sashal@kernel.org>
 <1a05eaed-a725-f8fb-efb4-4e20a80fdef3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1a05eaed-a725-f8fb-efb4-4e20a80fdef3@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 06, 2021 at 01:22:31PM +0200, Paolo Bonzini wrote:
>On 06/10/21 13:12, Sasha Levin wrote:
>>From: Oliver Upton <oupton@google.com>
>>
>>[ Upstream commit 01f91acb55be7aac3950b89c458bcea9ef6e4f49 ]
>>
>>The SMC64 calling convention passes a function identifier in w0 and its
>>parameters in x1-x17. Given this, there are two deviations in the
>>SMC64 call performed by the steal_time test: the function identifier is
>>assigned to a 64 bit register and the parameter is only 32 bits wide.
>>
>>Align the call with the SMCCC by using a 32 bit register to handle the
>>function identifier and increasing the parameter width to 64 bits.
>>
>>Suggested-by: Andrew Jones <drjones@redhat.com>
>>Signed-off-by: Oliver Upton <oupton@google.com>
>>Reviewed-by: Andrew Jones <drjones@redhat.com>
>>Message-Id: <20210921171121.2148982-3-oupton@google.com>
>>Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>>  tools/testing/selftests/kvm/steal_time.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>>diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
>>index fcc840088c91..7daedee3e7ee 100644
>>--- a/tools/testing/selftests/kvm/steal_time.c
>>+++ b/tools/testing/selftests/kvm/steal_time.c
>>@@ -120,12 +120,12 @@ struct st_time {
>>  	uint64_t st_time;
>>  };
>>-static int64_t smccc(uint32_t func, uint32_t arg)
>>+static int64_t smccc(uint32_t func, uint64_t arg)
>>  {
>>  	unsigned long ret;
>>  	asm volatile(
>>-		"mov	x0, %1\n"
>>+		"mov	w0, %w1\n"
>>  		"mov	x1, %2\n"
>>  		"hvc	#0\n"
>>  		"mov	%0, x0\n"
>>
>
>Just fixing tests, but anyway:
>
>Acked-by: Paolo Bonzini <pbonzini@redhat.com>

I'll queue up all the ones you acked, thanks!

-- 
Thanks,
Sasha
