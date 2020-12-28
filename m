Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD7D2E6BB5
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbgL1Wzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729635AbgL1W3t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 17:29:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56A3520829;
        Mon, 28 Dec 2020 22:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609194548;
        bh=Y2GOHtdtH/fvxVgbYtAC1xBKmPCbZZacEpn/jItt9Oo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JZEJYTfmS2NrYvN3hoUcpI/JfnloYWgYq4yCUaDMPqOfhFrXpAtSUR52Vycco5nNT
         bKF5EDgSNZ8jhHrU7tgg1TZ/uHnw/wnYNN7ddACdE2rXB+vhamEKE1CuwFNiMURPp1
         frIBomY16Zg13X6s/XarXOq2vTR3Qh1KXAcCXhz3yx7XdksvC6+4TYsb/+LJ4hCOkS
         WgbLSA2tnj1KTRHb4/bQ1nMXrz+4HUm1lZVCmlstWgKlm6DDcnfA+HjZZHpMrbswnX
         6TpH/EDdbYGStKchWS3pz5dnci7Ifs4OrV9T/40gB7TKCG7ncu2/ZhO2QPkYkhqY6S
         g2+ZI5To+Az8g==
Date:   Mon, 28 Dec 2020 17:29:07 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Subject: Re: [PATCH 5.10 462/717] ice, xsk: clear the status bits for the
 next_to_use descriptor
Message-ID: <20201228222907.GG2790422@sasha-vm>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125043.105740628@linuxfoundation.org>
 <20201228105423.46e77460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201228105423.46e77460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 10:54:23AM -0800, Jakub Kicinski wrote:
>On Mon, 28 Dec 2020 13:47:40 +0100 Greg Kroah-Hartman wrote:
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> [ Upstream commit 8d14768a7972b92c73259f0c9c45b969d85e3a60 ]
>>
>> On the Rx side, the next_to_use index points to the next item in the
>> HW ring to be refilled/allocated, and next_to_clean points to the next
>> item to potentially be processed.
>>
>> When the HW Rx ring is fully refilled, i.e. no packets has been
>> processed, the next_to_use will be next_to_clean - 1. When the ring is
>> fully processed next_to_clean will be equal to next_to_use. The latter
>> case is where a bug is triggered.
>>
>> If the next_to_use bits are not cleared, and the "fully processed"
>> state is entered, a stale descriptor can be processed.
>>
>> The skb-path correctly clear the status bit for the next_to_use
>> descriptor, but the AF_XDP zero-copy path did not do that.
>>
>> This change adds the status bits clearing of the next_to_use
>> descriptor.
>>
>> Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Oh wow, so much for Sasha waiting longer for code to get tested before
>auto-pulling things into stable :/

The timeline is usually for a commit to appear in a release, and it did.
Was it too early?

>I have this change and other changes here queued, but haven't sent the
>submission yet.

What do you mean with "queued"? Its in Linus's tree for about two weeks
now.

>How long is the auto-backporting delay in terms of calendar days?

The autosel stuff is about 2-3(-4) weeks at this point, stuff with a
fixes tag gets picked up in about 2 weeks.

-- 
Thanks,
Sasha
