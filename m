Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C937849CC34
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 15:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241673AbiAZOWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 09:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241653AbiAZOWN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 09:22:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBDBC06161C;
        Wed, 26 Jan 2022 06:22:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C124B81E72;
        Wed, 26 Jan 2022 14:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7D8C340E3;
        Wed, 26 Jan 2022 14:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643206930;
        bh=ZtI4chQntI8QNKw9ePJvO3D4GLlyMfkrD6BhOjHdV/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BQyWWhv1h9/AozoNbxfPhgcJ1h0RV8Gn1zeBwNWgaErlb8IKRKYTlpogXmKJ5zg5J
         FBsI19DqRE8iESNOPu0ircxPimR5lIoXcJ7TZILltXmdJ0pS6RBz6ICbLM7eDZXbXX
         HKmTXvpk0M9EXhzKQCQ3yhhXWo5ikGOYkzq+QVv8f6QysCNYl1d+d/0aIioI7jgNSz
         dPLE8iH0opxPETI1SsbsDoKqqje77TPxRktaeqhfiWC6IVFVqpDqtI6wiHJcs/ggDu
         w6TKLXHt3WVuxkjmEs2UH2l/UvtOnSjT3YQFbUssaceJ6x609R1EjbBnq5LM3ULE/T
         tbSEKrxOsEt9g==
Date:   Wed, 26 Jan 2022 16:21:50 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Denis Kenzior <denkenz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        James Morris <james.morris@microsoft.com>,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KEYS: asym_tpm: fix buffer overreads in
 extract_key_parameters()
Message-ID: <YfFY/trrVl3vse5I@iki.fi>
References: <20220113235440.90439-1-ebiggers@kernel.org>
 <20220113235440.90439-2-ebiggers@kernel.org>
 <YeM/YIUTEwL4jNf3@iki.fi>
 <Yedigyl+WNhB58MO@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yedigyl+WNhB58MO@sol.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 04:59:47PM -0800, Eric Biggers wrote:
> On Sat, Jan 15, 2022 at 11:40:48PM +0200, Jarkko Sakkinen wrote:
> > > 
> > > - Avoid integer overflows when validating size fields; 'sz + 12' and
> > >   '4 + sz' overflowed if 'sz' is near U32_MAX.
> > 
> > So we have a struct tpm_header in include/linux/tpm.h. It would be way
> > more informative to use sizeof(struct tpm_header) than number 12, even
> > if the patch does not otherwise use the struct. It tells what it is, 12
> > does not.
> 
> I don't think that would be an improvement, given that the code is using
> hard-coded offsets.  If it's reading 4 bytes from cur + 8, it's much easier to
> understand that it needs 12 bytes than 'sizeof(struct tpm_header)' bytes.
> 
> I'd certainly encourage whoever is maintaining this code to change it to use
> structs instead, but that's not what this patch is meant to do.

I would consider dropping asym_tpm as it has no practical use cases
existing.

/Jarkko
