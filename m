Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3F648F98F
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 22:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbiAOVlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 16:41:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47632 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiAOVlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jan 2022 16:41:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B163760EFE;
        Sat, 15 Jan 2022 21:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB49C36AE7;
        Sat, 15 Jan 2022 21:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642282861;
        bh=1MzPi0BXY8b13RSJb71FRfp5CNfpUxsORzKKV2hp2rw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VZydSC4GsSbo545jx5E9CTMD/cBbwrLU5a9khdoy9ZYMHm3TGY+9P5KlE9x2BUSP2
         43ZuvgL2eWI4w1UlbZhyp2AG80ukDWPRD3HHDmQAEoTYl5K/e9Y0M+aSowAC8Jcpa3
         MF41d7oT4+OY9IniSltO1wloMv8ZIs1mqYhXhVpzFVCoAS7x8kFWxNiIKig0Bz55qa
         3z13iCn0G978EyMQ1X2VY8qxc42ki96TCMh1C/AzRJ62t7s5GD06x8PqQn+Ql7b9QT
         Vrrcvh8/ft0PJq+PW8pya2IVvcrv+YXnb/OawnGHpVAa8ILmnwJ7JDYVQl1YtEv7Qc
         0UMXCj1j0icXw==
Date:   Sat, 15 Jan 2022 23:40:48 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Denis Kenzior <denkenz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        James Morris <james.morris@microsoft.com>,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] KEYS: asym_tpm: fix buffer overreads in
 extract_key_parameters()
Message-ID: <YeM/YIUTEwL4jNf3@iki.fi>
References: <20220113235440.90439-1-ebiggers@kernel.org>
 <20220113235440.90439-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220113235440.90439-2-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022 at 03:54:38PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> extract_key_parameters() can read past the end of the input buffer due
> to buggy and missing bounds checks.  Fix it as follows:
> 
> - Before reading each key length field, verify that there are at least 4
>   bytes remaining.

Maybe start with a "Key length is described as an unsigned 32-bit integer
in the TPM header". Just for clarity.

> 
> - Avoid integer overflows when validating size fields; 'sz + 12' and
>   '4 + sz' overflowed if 'sz' is near U32_MAX.

So we have a struct tpm_header in include/linux/tpm.h. It would be way
more informative to use sizeof(struct tpm_header) than number 12, even
if the patch does not otherwise use the struct. It tells what it is, 12
does not.

> - Before saving the pointer to the public key, check that it doesn't run
>   past the end of the buffer.
> 
> Fixes: f8c54e1ac4b8 ("KEYS: asym_tpm: extract key size & public key [ver #2]")
> Cc: <stable@vger.kernel.org> # v4.20+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

BR, Jarkko
