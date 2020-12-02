Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9A82CCABC
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 00:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgLBXxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 18:53:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbgLBXxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Dec 2020 18:53:49 -0500
Date:   Wed, 2 Dec 2020 18:53:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606953188;
        bh=nxraud1so4X4CpHWIt+N3aVKYnhWwVdXg+cr93YJPxs=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=mW4IzRBUNyPI1MOXlyDTOCV709Gt58pz0xBHvRAQmE8vieFh3hGmezUGpQI7HRkhi
         cUJttO1Qz22Z6PafhusGZFFqRLLgp3cGhmcbr7uOOL7MitWnCUw8hYWohF/p12ROYO
         HHzNqICZ+eZ39jwIcluPPgFHFIYkqKHVShnD3MSHmbvkIzIJYmKt346I+uCFB2SsLi
         WDbqFe7nRF9EU2qd76a8D/oaVJdlPCf1ljR1C8QDQETHHDT6RI8XkMirB6h0+Y6cmU
         M+VQHj9/4Vet14bkKtE17oqWg60kq9PDaqNEj/NOFyukdnlcP0xkwSzN1Nu3Xrqkh0
         RX/6Jis2VwtGw==
From:   Sasha Levin <sashal@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Maurizio Drocco <maurizio.drocco@ibm.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.7 03/30] ima: extend boot_aggregate with kernel
 measurements
Message-ID: <20201202235307.GX643756@sasha-vm>
References: <20200708154116.3199728-1-sashal@kernel.org>
 <20200708154116.3199728-3-sashal@kernel.org>
 <1594224793.23056.251.camel@linux.ibm.com>
 <20200709012735.GX2722994@sasha-vm>
 <5b8dcdaf66fbe2a39631833b03772a11613fbbbf.camel@linux.ibm.com>
 <20201201002157.GT643756@sasha-vm>
 <02e53ce5fc00a2eaff3cace9c94b8b375dc580ef.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <02e53ce5fc00a2eaff3cace9c94b8b375dc580ef.camel@linux.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 30, 2020 at 10:13:02PM -0500, Mimi Zohar wrote:
>On Mon, 2020-11-30 at 19:21 -0500, Sasha Levin wrote:
>> On Sun, Nov 29, 2020 at 08:17:38AM -0500, Mimi Zohar wrote:
>> >Hi Sasha,
>> >
>> >On Wed, 2020-07-08 at 21:27 -0400, Sasha Levin wrote:
>> >> On Wed, Jul 08, 2020 at 12:13:13PM -0400, Mimi Zohar wrote:
>> >> >Hi Sasha,
>> >> >
>> >> >On Wed, 2020-07-08 at 11:40 -0400, Sasha Levin wrote:
>> >> >> From: Maurizio Drocco <maurizio.drocco@ibm.com>
>> >> >>
>> >> >> [ Upstream commit 20c59ce010f84300f6c655d32db2610d3433f85c ]
>> >> >>
>> >> >> Registers 8-9 are used to store measurements of the kernel and its
>> >> >> command line (e.g., grub2 bootloader with tpm module enabled). IMA
>> >> >> should include them in the boot aggregate. Registers 8-9 should be
>> >> >> only included in non-SHA1 digests to avoid ambiguity.
>> >> >
>> >> >Prior to Linux 5.8, the SHA1 template data hashes were padded before
>> >> >being extended into the TPM.  Support for calculating and extending
>> >> >the per TPM bank template data digests is only being upstreamed in
>> >> >Linux 5.8.
>> >> >
>> >> >How will attestation servers know whether to include PCRs 8 & 9 in the
>> >> >the boot_aggregate calculation?  Now, there is a direct relationship
>> >> >between the template data SHA1 padded digest not including PCRs 8 & 9,
>> >> >and the new per TPM bank template data digest including them.
>> >>
>> >> Got it, I'll drop it then, thank you!
>> >
>> >After re-thinking this over, I realized that the attestation server can
>> >verify the "boot_aggregate" based on the quoted PCRs without knowing
>> >whether padded SHA1 hashes or per TPM bank hash values were extended
>> >into the TPM[1], but non-SHA1 boot aggregate values [2] should always
>> >include PCRs 8 & 9.
>> >
>> >Any place commit 6f1a1d103b48 was backported [2], this commit
>> >20c59ce010f8 ("ima: extend boot_aggregate with kernel measurements")
>> >should be backported as well.
>>
>> Which kernels should it apply to? 5.7 is EOL now, so I looked at 5.4 but
>> it doesn't apply cleanly there.
>
>For 5.4, both "git cherry-pick" and "git am --3way" for 20c59ce010f8
>seem to work.

You're right, I've grabbed it too. Thanks!

-- 
Thanks,
Sasha
