Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFE24B69E
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 13:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731143AbfFSLDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 07:03:44 -0400
Received: from foss.arm.com ([217.140.110.172]:33560 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbfFSLDo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jun 2019 07:03:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C6C9360;
        Wed, 19 Jun 2019 04:03:43 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BA003F738;
        Wed, 19 Jun 2019 04:05:28 -0700 (PDT)
Subject: Re: [PATCH v4.4 00/45] V4.4 backport of arm64 Spectre patches
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com
References: <cover.1560480942.git.viresh.kumar@linaro.org>
 <7329e6d9-140d-59bc-c835-5f6300cf60e0@arm.com>
 <20190618102122.z52oi37pp3wigqxx@vireshk-i7>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <ed7d6125-e8ec-c3a1-06c7-2a2fa2c92d32@arm.com>
Date:   Wed, 19 Jun 2019 12:03:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190618102122.z52oi37pp3wigqxx@vireshk-i7>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Viresh,

On 18/06/2019 11:21, Viresh Kumar wrote:
> On 17-06-19, 17:03, Julien Thierry wrote:
>> On 14/06/2019 04:07, Viresh Kumar wrote:

[...]

> I have updated the stable/v4.4.y/spectre branch with all the changes you
> suggested and pushed the earlier version to stable/v4.4.y/spectre-v1 branch.
> 
> Will it be possible for you to have a look at stable/v4.4.y/spectre branch to
> see if it is okay, so I can send the v2 version ? Don't want to spam list
> unnecessary with so many patches :)
> 

I've given a run for your new version and it looks like the BP hardening
is not taking place.

I believe the culprit is update_cpu_capabilities(), which in 4.4 tests
for capability.desc to know where to stop (and requires all valid
capabilities to have a description).

Since commit 644c2ae19 "arm64: cpufeature: Test 'matches' pointer to
find the end of the list", the restriction was lifted.
Unfortunately for you, the errata workarounds using BP hardening were
introduced after that commit and were not given a description. So they
do not get applied and also, in the current state, would prevent
following entries in the errata table from getting applied.

So either 644c2ae19 needs to be backported, or the workarounds need to
be given descriptions.

I'll let you know if I find anything else.

Cheers,

-- 
Julien Thierry
