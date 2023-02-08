Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AA568F0DF
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 15:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbjBHOcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 09:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbjBHOcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 09:32:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C701E29E;
        Wed,  8 Feb 2023 06:32:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52B88B81BA2;
        Wed,  8 Feb 2023 14:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD27C433D2;
        Wed,  8 Feb 2023 14:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675866765;
        bh=xPqvZOaH1bqyFJ6lHg9Nw6MLEn4KVAU/Z1wBQ/IoYgM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f+JUpn8VuyxZraPwFzd+DVm0SuU3fNXfhY+REvh7ZkYVBbUScqfqfwv/QbS6F8jod
         eaAB0uSUqD7UcJUaGj3yh1C6MArspv9GETy+KIlIHItVFo7XCNVEZx4VnnSyDb3KBV
         XDgH4fGFIRNhWtWmF/KNgN3txDLolO5Tm42qqd41izYn7GdSF4tW9O120HYDK7CAXG
         o/KWS6EASNXC5xxJCs8Arf905ZNvGr564orV8ARcZAZENgwv17QI4OYworKrxYyBR8
         ejc9Mk+U4utix95W0b/S8rKTgdQcz4dUpkerum0wDllsJRuUueDgkE43Y9jgfhWMIl
         +uAgTgmxwofAw==
Date:   Wed, 8 Feb 2023 07:32:43 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Bill Wendling <morbo@google.com>, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] randstruct: disable Clang 15 support
Message-ID: <Y+Oyi1eZqKtqbL40@dev-arch.thelio-3990X>
References: <20230208065133.220589-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208065133.220589-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 10:51:33PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The randstruct support released in Clang 15 is unsafe to use due to a
> bug that can cause miscompilations: "-frandomize-layout-seed
> inconsistently randomizes all-function-pointers structs"
> (https://github.com/llvm/llvm-project/issues/60349).  It has been fixed
> on the Clang 16 release branch, so add a Clang version check.
> 
> Fixes: 035f7f87b729 ("randstruct: Enable Clang support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  security/Kconfig.hardening | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> index 53baa95cb644f..0f295961e7736 100644
> --- a/security/Kconfig.hardening
> +++ b/security/Kconfig.hardening
> @@ -281,6 +281,9 @@ endmenu
>  
>  config CC_HAS_RANDSTRUCT
>  	def_bool $(cc-option,-frandomize-layout-seed-file=/dev/null)
> +	# Randstruct was first added in Clang 15, but it isn't safe to use until
> +	# Clang 16 due to https://github.com/llvm/llvm-project/issues/60349
> +	depends on !CC_IS_CLANG || CLANG_VERSION >= 160000
>  
>  choice
>  	prompt "Randomize layout of sensitive kernel structures"
> 
> base-commit: 4ec5183ec48656cec489c49f989c508b68b518e3
> -- 
> 2.39.1
> 
> 
