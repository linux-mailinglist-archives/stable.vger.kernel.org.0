Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBBE6A0497
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 10:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbjBWJSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 04:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjBWJR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 04:17:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0989298CA;
        Thu, 23 Feb 2023 01:17:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 613886162F;
        Thu, 23 Feb 2023 09:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D451C433EF;
        Thu, 23 Feb 2023 09:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677143878;
        bh=T56qU1zrO2f5+K1m/Z6RBr2ce1etS1rt6dWCDZpakl8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bs1Xqmlv+nia1vrclkQDK/+JL/H1bK/qHyJAptXZmpvv3RsxbWUKWYV9RjB+C9G94
         fw1OUgN/YOilIvBcmVTLyEwtRmnjPklNiT9QAcAqff1bNZy8FA/NuFDFcaCV0Mwbt9
         LGhBk6AvfmnsdTE1GG3+2nOmcdNFq3oyKb86WtBE=
Date:   Thu, 23 Feb 2023 10:17:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     maennich@google.com
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH 4/5] lib/Kconfig.debug: Use CONFIG_PAHOLE_VERSION
Message-ID: <Y/cvQ4WfpKRrzKKK@kroah.com>
References: <20220201205624.652313-1-nathan@kernel.org>
 <20230222112141.278066-5-maennich@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222112141.278066-5-maennich@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 22, 2023 at 11:21:45AM +0000, maennich@google.com wrote:
> From: Nathan Chancellor <nathan@kernel.org>
> 
> Now that CONFIG_PAHOLE_VERSION exists, use it in the definition of
> CONFIG_PAHOLE_HAS_SPLIT_BTF and CONFIG_PAHOLE_HAS_BTF_TAG to reduce the
> amount of duplication across the tree.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> Link: https://lore.kernel.org/bpf/20220201205624.652313-5-nathan@kernel.org
> Signed-off-by: Matthias Maennich <maennich@google.com>
> ---
>  lib/Kconfig.debug | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index f71db0cc3bf1..0743c9567d7e 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -328,7 +328,15 @@ config DEBUG_INFO_BTF
>  	  DWARF type info into equivalent deduplicated BTF type info.
>  
>  config PAHOLE_HAS_SPLIT_BTF
> -	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
> +	def_bool PAHOLE_VERSION >= 119
> +
> +config PAHOLE_HAS_BTF_TAG
> +	def_bool PAHOLE_VERSION >= 123
> +	depends on CC_IS_CLANG
> +	help
> +	  Decide whether pahole emits btf_tag attributes (btf_type_tag and
> +	  btf_decl_tag) or not. Currently only clang compiler implements
> +	  these attributes, so make the config depend on CC_IS_CLANG.

Note, this is very different from the original commit, are you sure this
is correct?

You took a MAINTAINERS file update in patch 1/5 to make a later patch
simpler, but yet you massively changed this commit and included stuff
from a different one and did not mention it anywhere?

Please fix this commit up, and resubmit the whole series with the git
commit ids in the commits to make it easier for me to review and apply
properly.

thanks,

greg k-h
