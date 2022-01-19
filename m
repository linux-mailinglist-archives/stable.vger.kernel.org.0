Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96649493216
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 01:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350477AbiASA7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 19:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238548AbiASA7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 19:59:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE2CC061574;
        Tue, 18 Jan 2022 16:59:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D93A5B81891;
        Wed, 19 Jan 2022 00:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57940C340E0;
        Wed, 19 Jan 2022 00:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642553989;
        bh=gJAWMIQcau5ycmV+Dz361tNVb1og9lrU+y5VlU2KwVU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tYtG0o35IHnbICCJnifxqasTlvlmIbdSao6S2JmNqZViuHc1uBT3MIuITfdXW2+wQ
         1g5giP/hfnGJgwGisNb0yMSwgbfYvR1bk5Gw5rusBcpX9tQpYVbxJvO+h+KgUNnj48
         VcjwrqMQ8MviFcWla43F2AEXbMBxjWVFcVlULR8lu4WsrMfgkgTshgPUubqM2uAUQQ
         Bb5NRig1HWFycfnXppp0POq60UV2513C/5nBAdFKv2tnqFG16uusWiZOeq/J04zRGm
         RxJ9nXT0ahe4NtX27TLX3a3wrWD0iGU6pv7sS8xDOe3A+OKENqWDW6vYEuCCxpKphu
         kS0OqDb3M1Syw==
Date:   Tue, 18 Jan 2022 16:59:47 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Denis Kenzior <denkenz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        James Morris <james.morris@microsoft.com>,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KEYS: asym_tpm: fix buffer overreads in
 extract_key_parameters()
Message-ID: <Yedigyl+WNhB58MO@sol.localdomain>
References: <20220113235440.90439-1-ebiggers@kernel.org>
 <20220113235440.90439-2-ebiggers@kernel.org>
 <YeM/YIUTEwL4jNf3@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeM/YIUTEwL4jNf3@iki.fi>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 15, 2022 at 11:40:48PM +0200, Jarkko Sakkinen wrote:
> > 
> > - Avoid integer overflows when validating size fields; 'sz + 12' and
> >   '4 + sz' overflowed if 'sz' is near U32_MAX.
> 
> So we have a struct tpm_header in include/linux/tpm.h. It would be way
> more informative to use sizeof(struct tpm_header) than number 12, even
> if the patch does not otherwise use the struct. It tells what it is, 12
> does not.

I don't think that would be an improvement, given that the code is using
hard-coded offsets.  If it's reading 4 bytes from cur + 8, it's much easier to
understand that it needs 12 bytes than 'sizeof(struct tpm_header)' bytes.

I'd certainly encourage whoever is maintaining this code to change it to use
structs instead, but that's not what this patch is meant to do.

- Eric
