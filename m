Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1B55BF762
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 09:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiIUHPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 03:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiIUHP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 03:15:29 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEAB5508F;
        Wed, 21 Sep 2022 00:15:19 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oatwz-0000gU-He; Wed, 21 Sep 2022 09:15:17 +0200
Message-ID: <fd672632-7935-14ff-e2be-0db8443b0907@leemhuis.info>
Date:   Wed, 21 Sep 2022 09:15:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: How to quickly resolve the IOMMU regression that currently plagues a
 lot of people in 5.19.y
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
References: <1d1844f0-c773-6222-36c6-862e14f6020d@leemhuis.info>
In-Reply-To: <1d1844f0-c773-6222-36c6-862e14f6020d@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1663744521;8cf85169;
X-HE-SMSGID: 1oatwz-0000gU-He
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[resend with proper subject, sorry for the noise]

[note to self: don't get distracted when writing the subject]

On 21.09.22 08:53, Thorsten Leemhuis wrote:
> Hi Greg! As you likely heard already, 5.19.9 introduced a regression
> that breaks Thunderbolt and USB-C docks (and apparently Wifi in some
> cases as well) on quite a few (many?) modern systems. It's one of those
> problems where I think "hey, we ideally should fix this in stable as
> fast as possible" we briefly talked about last week on the LPC hallways.
> That made me wonder how to actually archive that in this particular case
> while keeping all involved parties happy and not skipping any CI testing
> queues considered important.
> 
> FWIW, here are a few few reports about the issue (I assume there are
> some for Arch Linux and openSUSE Tumbleweed as well, but didn't check).
> 
> https://lore.kernel.org/linux-iommu/485A6EA5-6D58-42EA-B298-8571E97422DE@getmailspring.com/
> https://bugzilla.kernel.org/show_bug.cgi?id=216497
> https://bugzilla.redhat.com/show_bug.cgi?id=2128458
> https://bugzilla.redhat.com/show_bug.cgi?id=2127753
> 
> A revert of the culprit (9cd4f1434479f ("iommu/vt-d: Fix possible
> recursive locking in intel_iommu_init()"); in 5.19.y it's 	9516acba29e3)
> for mainline is here:
> https://lore.kernel.org/lkml/20220920081701.3453504-1-baolu.lu@linux.intel.com/
> 
> A few hours ago the revert was queued to get send to Joerg:
> https://lore.kernel.org/linux-iommu/20220921024054.3570256-1-baolu.lu@linux.intel.com/
> 
> I fear it could easily take another week to get this fixed in stable
> depending on how fast the patch makes it to mainline and the timing of
> the next 5.19.y release and its -rc phase. That to me sounds like way
> too long for a problem like this that apparently plagues quite a few
> people.
> 
> That made me wonder: would you in cases like this be willing to start
> the -rc phase for a interim 5.19.y release with just that revert while
> it's still heading towards mainline? Then the CI systems that test
> stable -rcs could chew on things already; and the new stable release
> could go out right after the revert landed in mainline (unless the
> testing finds any problems, of course).
> 
> Ciao, Thorsten
> 
> 
