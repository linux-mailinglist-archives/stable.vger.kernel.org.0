Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2B765927D
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 23:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbiL2Wid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Dec 2022 17:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiL2Wib (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Dec 2022 17:38:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B670714024;
        Thu, 29 Dec 2022 14:38:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F1688CE16FF;
        Thu, 29 Dec 2022 22:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDBFC433EF;
        Thu, 29 Dec 2022 22:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672353507;
        bh=A9gotjONIBv6IFFnxiV0ZpJT3luAFunzfuUNR0nSF6M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=psNC/lmYxEKZESOKibYosuZ8dO7kCkTl0O/qdp0AYjf77J9vz5ucj8GzKuuiZTDRd
         Q6a2krcvh2/G/jvPlFSXGznrMXOTNfJN/ta4OkHBEEs+c9r2EORjONxrGtH/+tNcdn
         EUwQSPr/t1AnpQoWMLbJyCIISSVcNpDJg+hss9VcGwbn3JUAmsGXA/jrqr29U3kZw2
         +jxW5Wn66QpIW8kk0bp6iro9MPqNyNqr2HY+EB/He+ifXKEUaAaqTMu5hgBYid1iWT
         1MUUKXO1DLvmKUUazhYwaGufrounOXgvHMMA1MEVCtWvG7jdnaM+neZlxI/SqIGXRj
         Bo81+Qxo9rTrQ==
Date:   Thu, 29 Dec 2022 14:38:24 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc:     dhowells@redhat.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, zohar@linux.ibm.com,
        dmitry.kasatkin@gmail.com, paul@paul-moore.com, jmorris@namei.org,
        serge@hallyn.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 1/2] lib/mpi: Fix buffer overrun when SG is too long
Message-ID: <Y64W4BqHbA+lf/8v@sol.localdomain>
References: <20221227142740.2807136-1-roberto.sassu@huaweicloud.com>
 <20221227142740.2807136-2-roberto.sassu@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221227142740.2807136-2-roberto.sassu@huaweicloud.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 27, 2022 at 03:27:39PM +0100, Roberto Sassu wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> 
> The helper mpi_read_raw_from_sgl sets the number of entries in
> the SG list according to nbytes.  However, if the last entry
> in the SG list contains more data than nbytes, then it may overrun
> the buffer because it only allocates enough memory for nbytes.
> 
> Fixes: 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers")
> Reported-by: Roberto Sassu <roberto.sassu@huaweicloud.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  lib/mpi/mpicoder.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
