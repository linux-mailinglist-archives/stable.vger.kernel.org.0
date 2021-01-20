Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED0C2FD714
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 18:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbhATRcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 12:32:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:45166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730918AbhATOrn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 09:47:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 355AB2336E;
        Wed, 20 Jan 2021 14:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611154023;
        bh=yLWV0XQA/4Lu96TmSFhjto8/f/VHxSmgW7RNswkF/JY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mBZgZt3hcIdHaUurmg219Nf8az94ZH2e3FQUh1xWhzGK9h74QxeIdCPnYd5r4h9yS
         U1sMic87rdMU20yYjwqQT9xgfbAQS8H0Q3+82JLFbQlBLhY+S3VlSZ4f4XrJOFbwHg
         85vuKWeNo4MAFUAvb7SlXGvZACU35GepIGpJ4kv0IUThSie41dBbmSssMFnupI+h/a
         zREt5hR57HIn3ljsXoekMkPPB2yUObOeyd0kMebJXgln7b0dul2v0cN9A2H4UiRgF0
         xpiWOBSaCYHqEcACplYIBESspQjvfKzASy36dlw+ZlbfdF4VtfGAIFNV3waKmY//65
         +uyytWLM+4RKQ==
Date:   Wed, 20 Jan 2021 16:46:57 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     torvalds@linux-foundation.org,
        Tobias Markus <tobias@markus-regensburg.de>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re:
Message-ID: <YAhCYS9a4nPCcqO1@kernel.org>
References: <163546.1611015033@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <163546.1611015033@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 19, 2021 at 12:10:33AM +0000, David Howells wrote:
> 
> From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> 
> On the following call path, `sig->pkey_algo` is not assigned
> in asymmetric_key_verify_signature(), which causes runtime
> crash in public_key_verify_signature().
> 
>   keyctl_pkey_verify
>     asymmetric_key_verify_signature
>       verify_signature
>         public_key_verify_signature
> 
> This patch simply check this situation and fixes the crash
> caused by NULL pointer.
> 
> Fixes: 215525639631 ("X.509: support OSCCA SM2-with-SM3 certificate verification")
> Reported-by: Tobias Markus <tobias@markus-regensburg.de>
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-and-tested-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Tested-by: João Fonseca <jpedrofonseca@ua.pt>
> Cc: stable@vger.kernel.org # v5.10+
> ---

For what it's worth

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko

> 
>  crypto/asymmetric_keys/public_key.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
> index 8892908ad58c..788a4ba1e2e7 100644
> --- a/crypto/asymmetric_keys/public_key.c
> +++ b/crypto/asymmetric_keys/public_key.c
> @@ -356,7 +356,8 @@ int public_key_verify_signature(const struct public_key *pkey,
>  	if (ret)
>  		goto error_free_key;
>  
> -	if (strcmp(sig->pkey_algo, "sm2") == 0 && sig->data_size) {
> +	if (sig->pkey_algo && strcmp(sig->pkey_algo, "sm2") == 0 &&
> +	    sig->data_size) {
>  		ret = cert_sig_digest_update(sig, tfm);
>  		if (ret)
>  			goto error_free_key;
> 
> 
