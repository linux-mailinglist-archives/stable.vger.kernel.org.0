Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7AA4A6A7B
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 04:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242207AbiBBDWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 22:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiBBDWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 22:22:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C60C061714;
        Tue,  1 Feb 2022 19:22:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 158C1616AD;
        Wed,  2 Feb 2022 03:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221B0C340E4;
        Wed,  2 Feb 2022 03:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643772162;
        bh=NZwM7ZA0zASZCsnmuaFltDWu2pEiqRf4QHu0eSrmoXM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jLvOrF3I5S9nS9E3LF7UzrBjN5C2hZa8uyfpkhlfsh9dCFlOD9lwsFdjsqsz1iUnN
         uj+AyYqcgHCY5SPxqjWNt5/ZkmEsHqw5k8FAC7PK2CkG6u2/79RPFcJdDpjUfuFZ+a
         2oTG1ECtjPLj4izIpUU+PuJnHQi8z75P6Ck7zetcviu2j1uH6Td9uCl5d1icA0reek
         NGW5DcukwJEu9lExzlMpM+jAgbwHjPwvF/OFD0hodysphTNRAH7E8PMytrkkZcnr9V
         u12Epjtw75kIZ2WBnAIGh8rh51N4iV8SS8KpCRpyOWe1GL+yi8FfIeECqlyUjCwsKv
         w5TPes1dEOZLg==
Date:   Tue, 1 Feb 2022 19:22:40 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     keyrings@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        David Howells <dhowells@redhat.com>,
        linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Mimi Zohar <zohar@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] KEYS: asymmetric: enforce that sig algo matches key
 algo
Message-ID: <Yfn5AFaH6mMa6FB3@sol.localdomain>
References: <20220201003414.55380-1-ebiggers@kernel.org>
 <20220201003414.55380-2-ebiggers@kernel.org>
 <20220202025230.hrfochvm3uyuh2wm@altlinux.org>
 <Yfn2KZgjuFRSJzSj@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yfn2KZgjuFRSJzSj@sol.localdomain>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 01, 2022 at 07:10:33PM -0800, Eric Biggers wrote:
> > This seem incorrect too, as sig->pkey_algo could be NULL for direct
> > signature verification calls. For example, for keyctl pkey_verify.
> 
> We can make it optional if some callers aren't providing it.  Of course, such
> callers wouldn't be able to verify ECDSA signatures.

Sorry, I got that backwards.  ECDSA signatures don't specify the curve, but the
keys do (as I noted in a comment).  So ECDSA wouldn't require sig->pkey_algo.

Since it appears that KEYCTL_PKEY_VERIFY does in fact have no way to specify a
pkey_algo, I'll allow NULL pkey_algo in v2.

Note that SM2 isn't implemented correctly when sig->pkey_algo is NULL, as the
following code incorrectly uses the signature's pkey_algo rather than the key's:

        if (sig->pkey_algo && strcmp(sig->pkey_algo, "sm2") == 0 &&
            sig->data_size) {
                ret = cert_sig_digest_update(sig, tfm);
                if (ret)
                        goto error_free_key;
        }

I'm not sure whether I should even bother fixing that, given how broken the SM2
stuff is anyway.

- Eric
