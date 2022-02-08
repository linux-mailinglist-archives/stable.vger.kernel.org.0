Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044434AD4DD
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 10:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354747AbiBHJaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 04:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354765AbiBHJaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 04:30:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52758C03FEC1;
        Tue,  8 Feb 2022 01:30:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E062B81904;
        Tue,  8 Feb 2022 09:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBD5C004E1;
        Tue,  8 Feb 2022 09:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644312601;
        bh=sJbnbAI3ywBQ7hx30HFqlVdAKbjSjmRv7VYOn/IssGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K0l/w9CHwNMnI6/9cwaN+5LXE0+L7wKw1mduHWwFts752hr/etqzO3avLRsZ+4UtW
         gMYnKot+uHjOiNtu3b5CgP9SPfMHblTTrG8vsUxbQM9vHd3m+h5M+pjrkmfAOjoTFM
         VQ1uUXPn+zNWJA2p9xgqx2p1l2DkIZoFYKXEVqNmh15Fr1jmLRCvEEnELPzJOK43Rt
         +8kPLyV/LkaDUPGHLvBlS59w7/pDoZsrpjFAliOazqXRIaCasJYg9bEE9W3F07r65N
         XOHaqyWGNnYo53MspwRti3haAZ+ejLKjFBerHS9rsFRU+pcMA3oUUtgMaenOHeuJyI
         1k90G1sRylq8Q==
Date:   Tue, 8 Feb 2022 10:30:27 +0100
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     keyrings@vger.kernel.org, Denis Kenzior <denkenz@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        James Morris <james.morris@microsoft.com>,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KEYS: asym_tpm: fix buffer overreads in
 extract_key_parameters()
Message-ID: <YgI4M88wvxcY41RK@iki.fi>
References: <20220113235440.90439-1-ebiggers@kernel.org>
 <20220113235440.90439-2-ebiggers@kernel.org>
 <YeM/YIUTEwL4jNf3@iki.fi>
 <Yedigyl+WNhB58MO@sol.localdomain>
 <YfFY/trrVl3vse5I@iki.fi>
 <YfFZPbKkgYJGWu1Q@iki.fi>
 <YfQ9PEp9zi+xWvQk@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfQ9PEp9zi+xWvQk@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 28, 2022 at 11:00:12AM -0800, Eric Biggers wrote:
> On Wed, Jan 26, 2022 at 04:22:53PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Jan 26, 2022 at 04:21:53PM +0200, Jarkko Sakkinen wrote:
> > > On Tue, Jan 18, 2022 at 04:59:47PM -0800, Eric Biggers wrote:
> > > > On Sat, Jan 15, 2022 at 11:40:48PM +0200, Jarkko Sakkinen wrote:
> > > > > > 
> > > > > > - Avoid integer overflows when validating size fields; 'sz + 12' and
> > > > > >   '4 + sz' overflowed if 'sz' is near U32_MAX.
> > > > > 
> > > > > So we have a struct tpm_header in include/linux/tpm.h. It would be way
> > > > > more informative to use sizeof(struct tpm_header) than number 12, even
> > > > > if the patch does not otherwise use the struct. It tells what it is, 12
> > > > > does not.
> > > > 
> > > > I don't think that would be an improvement, given that the code is using
> > > > hard-coded offsets.  If it's reading 4 bytes from cur + 8, it's much easier to
> > > > understand that it needs 12 bytes than 'sizeof(struct tpm_header)' bytes.
> > > > 
> > > > I'd certainly encourage whoever is maintaining this code to change it to use
> > > > structs instead, but that's not what this patch is meant to do.
> > > 
> > > I would consider dropping asym_tpm as it has no practical use cases
> > > existing.
> > 
> > At least I have zero motivation to maintain it as it does not meet
> > any quality standards and is based on insecure crypto algorithms.
> > I neither have participated to its review process.
> 
> Fair enough, I'll send a patch to remove it then.

It is IMHO. I mean having this advertising insecure ways to to do crypto.

Thank you.

PS. My latency is because I've been moving to a new job. It is temporary.

/Jarkko
