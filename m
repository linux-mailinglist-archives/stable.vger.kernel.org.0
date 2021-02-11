Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D7D3191E1
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 19:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhBKSIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 13:08:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232450AbhBKSHB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 13:07:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 193CC64DE1;
        Thu, 11 Feb 2021 18:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613066778;
        bh=th0ftCsf27UJO3jv9zjkAX6s8Y9ezleCWdivAs1DWDM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MyyLbn4gOvdLRAbhOvbe/370fPhQ2+7IAOgDhyQz/kAcYdxhl24ZCTjO5fBGO7LZT
         Ye8HzN+v7j32VDadLPEMzsy2CG3Xvj341iAV+GPT6KdBSnmPDhMLd81m43/hU0cv+3
         /YXpGLQhmGg+OWUXT6yyCFSj5kDDu9ni9hDph13OlOIi+0F6PWBmZSDOoXnuS94Qgy
         YO1umjnxcNQBlJ9MDdMgaztWxKeZNAT/BSycCQ9G+mZ5cbt/eqGPDFY8FKWxhEZ4V/
         eFl3lYLGqugha/phgQWCBr9YfRLD7j+F3CO+3+aEaYNDS3QxVKLEAuKKao0bKBTFue
         kjfkxZMfb10Kw==
Date:   Thu, 11 Feb 2021 13:06:17 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>
Subject: Re: [PATCH 4.19 07/24] regulator: core: avoid
 regulator_resolve_supply() race condition
Message-ID: <20210211180617.GG4035784@sasha-vm>
References: <20210211150147.743660073@linuxfoundation.org>
 <20210211150148.069380965@linuxfoundation.org>
 <20210211152656.GD5217@sirena.org.uk>
 <YCVPYEgCIbqDRYLa@kroah.com>
 <20210211154021.GE5217@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210211154021.GE5217@sirena.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 03:40:21PM +0000, Mark Brown wrote:
>On Thu, Feb 11, 2021 at 04:38:08PM +0100, Greg Kroah-Hartman wrote:
>> On Thu, Feb 11, 2021 at 03:26:56PM +0000, Mark Brown wrote:
>
>> > > The final step in regulator_register() is to call
>> > > regulator_resolve_supply() for each registered regulator
>
>> > This is buggy without a followup which doesn't seem to have been
>> > backported here.
>
>> Would that be 14a71d509ac8 ("regulator: Fix lockdep warning resolving
>> supplies")?  Looks like it made it into the 5.4.y and 5.10.y queues, but
>> not 4.19.y.
>
>Yes, that's the one.

I've grabbed these two additional commits for 4.19:

05f224ca6693 ("regulator: core: Clean enabling always-on regulators + their supplies")
2bb166636933 ("regulator: core: enable power when setting up constraints")

And queued up 14a71d509ac8. Thanks for the heads-up!

-- 
Thanks,
Sasha
