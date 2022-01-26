Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EC349CC38
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 15:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241704AbiAZOXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 09:23:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44662 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241653AbiAZOXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 09:23:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCB2D61748;
        Wed, 26 Jan 2022 14:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6E8C340E3;
        Wed, 26 Jan 2022 14:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643206994;
        bh=8DSYXalK5kSrxQ9s1eHHwRmM7s51ea7r7mvSXt3y89A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SOAoWeEJ3Sn4QHdSlaXJGXXCQ4kSaz1ykKHSTJMmfzwyS8iAdGFQXSD5PsawDRZ2g
         FaKhpfJiQkXkgA00pvcMo1EOCT9GhG35Z+R/UInDc90IW24U0yqhybGOC1nDOFinjF
         S520lHdw23iqwFLvClJQvli37GVrdAz2Dc79NfOZ5U1bH8dMQgfNLF4j5XZm5sOKfg
         wvJOweV+A5FobZxBYaqBPDfYpd8TfIv1DHs5DXGnSMNZmRLy5n7dKa9R4mkIjjap0g
         bOqNepPU3uW5ENI6N8oRmITFsirkLEo1ooj4IKdh2yDV+upiDzx/BiklqTQ5EZfPWy
         SzRN9ik6ZLB5g==
Date:   Wed, 26 Jan 2022 16:22:53 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Denis Kenzior <denkenz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        James Morris <james.morris@microsoft.com>,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KEYS: asym_tpm: fix buffer overreads in
 extract_key_parameters()
Message-ID: <YfFZPbKkgYJGWu1Q@iki.fi>
References: <20220113235440.90439-1-ebiggers@kernel.org>
 <20220113235440.90439-2-ebiggers@kernel.org>
 <YeM/YIUTEwL4jNf3@iki.fi>
 <Yedigyl+WNhB58MO@sol.localdomain>
 <YfFY/trrVl3vse5I@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfFY/trrVl3vse5I@iki.fi>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 04:21:53PM +0200, Jarkko Sakkinen wrote:
> On Tue, Jan 18, 2022 at 04:59:47PM -0800, Eric Biggers wrote:
> > On Sat, Jan 15, 2022 at 11:40:48PM +0200, Jarkko Sakkinen wrote:
> > > > 
> > > > - Avoid integer overflows when validating size fields; 'sz + 12' and
> > > >   '4 + sz' overflowed if 'sz' is near U32_MAX.
> > > 
> > > So we have a struct tpm_header in include/linux/tpm.h. It would be way
> > > more informative to use sizeof(struct tpm_header) than number 12, even
> > > if the patch does not otherwise use the struct. It tells what it is, 12
> > > does not.
> > 
> > I don't think that would be an improvement, given that the code is using
> > hard-coded offsets.  If it's reading 4 bytes from cur + 8, it's much easier to
> > understand that it needs 12 bytes than 'sizeof(struct tpm_header)' bytes.
> > 
> > I'd certainly encourage whoever is maintaining this code to change it to use
> > structs instead, but that's not what this patch is meant to do.
> 
> I would consider dropping asym_tpm as it has no practical use cases
> existing.

At least I have zero motivation to maintain it as it does not meet
any quality standards and is based on insecure crypto algorithms.
I neither have participated to its review process.

/Jarkko
