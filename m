Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4454A0090
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 20:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350727AbiA1TAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 14:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350723AbiA1TAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 14:00:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17DEC06173B;
        Fri, 28 Jan 2022 11:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C681B826E5;
        Fri, 28 Jan 2022 19:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCA5C340EE;
        Fri, 28 Jan 2022 19:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643396414;
        bh=JBkyHUEEIK2NkmwkLCfSdEHCKGjUhXFMjam+YzyL9pU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mb2uSSA61b3blQ0D+gojuqpuWBPHply69ksvNtu1oNgT9oUSLYjiJwjoLAQYbvXIf
         1ccKy4+4GZsgG3dZw1LaHgbV/zm1YrmUgwgqG4YYZlQxNido9645Pdt63B9PQ9DFSt
         Q74uRvV2/R4jsDxSLyuGTDiijQsX8Mg2Sz7hIhrRnHsiTN5NXmqxJrBG6njxS3Q4X4
         vPJmctZGAzzSNXOA/eFqTZ4zjuMFNIl4gCLs3ASdctV6PYKst9Wknj3lMNoEV5ngae
         waKv3xMoNUVD6HxtYwE0lxTFkMfcNYIdRcqpYzrQ84k/9nCqVUU/1EIkzSuVlJ7JS+
         NwoJHq/GagnxA==
Date:   Fri, 28 Jan 2022 11:00:12 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     keyrings@vger.kernel.org, Denis Kenzior <denkenz@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        James Morris <james.morris@microsoft.com>,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KEYS: asym_tpm: fix buffer overreads in
 extract_key_parameters()
Message-ID: <YfQ9PEp9zi+xWvQk@sol.localdomain>
References: <20220113235440.90439-1-ebiggers@kernel.org>
 <20220113235440.90439-2-ebiggers@kernel.org>
 <YeM/YIUTEwL4jNf3@iki.fi>
 <Yedigyl+WNhB58MO@sol.localdomain>
 <YfFY/trrVl3vse5I@iki.fi>
 <YfFZPbKkgYJGWu1Q@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfFZPbKkgYJGWu1Q@iki.fi>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 04:22:53PM +0200, Jarkko Sakkinen wrote:
> On Wed, Jan 26, 2022 at 04:21:53PM +0200, Jarkko Sakkinen wrote:
> > On Tue, Jan 18, 2022 at 04:59:47PM -0800, Eric Biggers wrote:
> > > On Sat, Jan 15, 2022 at 11:40:48PM +0200, Jarkko Sakkinen wrote:
> > > > > 
> > > > > - Avoid integer overflows when validating size fields; 'sz + 12' and
> > > > >   '4 + sz' overflowed if 'sz' is near U32_MAX.
> > > > 
> > > > So we have a struct tpm_header in include/linux/tpm.h. It would be way
> > > > more informative to use sizeof(struct tpm_header) than number 12, even
> > > > if the patch does not otherwise use the struct. It tells what it is, 12
> > > > does not.
> > > 
> > > I don't think that would be an improvement, given that the code is using
> > > hard-coded offsets.  If it's reading 4 bytes from cur + 8, it's much easier to
> > > understand that it needs 12 bytes than 'sizeof(struct tpm_header)' bytes.
> > > 
> > > I'd certainly encourage whoever is maintaining this code to change it to use
> > > structs instead, but that's not what this patch is meant to do.
> > 
> > I would consider dropping asym_tpm as it has no practical use cases
> > existing.
> 
> At least I have zero motivation to maintain it as it does not meet
> any quality standards and is based on insecure crypto algorithms.
> I neither have participated to its review process.

Fair enough, I'll send a patch to remove it then.

- Eric
