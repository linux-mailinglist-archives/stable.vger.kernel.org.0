Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762D75A20BC
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 08:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbiHZGRv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 02:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbiHZGRu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 02:17:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B120FA3D13;
        Thu, 25 Aug 2022 23:17:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 568AD61B1D;
        Fri, 26 Aug 2022 06:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E6CC433D6;
        Fri, 26 Aug 2022 06:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661494668;
        bh=mwT1dGC6kgb6AMZv9hcU8/lgllHF8A8Rmy50wbfJ4hA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rFTshzAcm4WiW7FyYI+N3OS962g5eYDtI+wh3aasb+sv2dcnJ7y5LufQJNXuNP/3r
         mUlGQ35SXTU/mNazDpo+8eBn7aKw0YinYX1VVbRihk4bZbO77DFe289A4jN/2peHKh
         XF/lHQr46fZT2aRNsKw4heuVI+JhaL2kV6fdbTxVw7yi+iRO0nwzzhPlIdFukbR2+V
         r8TRYTj3wt64S26a9bs9Zudflf6WeTY1XRrrbmB0fWYuHfCrPY7/gT6mvisBRZkOAu
         WTRqMIJTObtSVg8YM6lGsTH82Ox+y6teK0AkpHkY7HapXpHMJSURROei6bE817FhFG
         CZgMwSF6OTzOQ==
Date:   Fri, 26 Aug 2022 09:17:41 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        WANG Xuerui <git@xen0n.name>,
        Huacai Chen <chenhuacai@loongson.cn>
Subject: Re: [PATCH 5.10 514/545] tpm: eventlog: Fix section mismatch for
 DEBUG_SECTION_MISMATCH
Message-ID: <YwhlhQYdgZdn63ii@kernel.org>
References: <20220819153829.135562864@linuxfoundation.org>
 <20220819153852.507832822@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819153852.507832822@linuxfoundation.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 05:44:44PM +0200, Greg Kroah-Hartman wrote:
> From: Huacai Chen <chenhuacai@loongson.cn>
> 
> commit bed4593645366ad7362a3aa7bc0d100d8d8236a8 upstream.
> 
> If DEBUG_SECTION_MISMATCH enabled, __calc_tpm2_event_size() will not be
> inlined, this cause section mismatch like this:
> 
> WARNING: modpost: vmlinux.o(.text.unlikely+0xe30c): Section mismatch in reference from the variable L0 to the function .init.text:early_ioremap()
> The function L0() references
> the function __init early_memremap().
> This is often because L0 lacks a __init
> annotation or the annotation of early_ioremap is wrong.
> 
> Fix it by using __always_inline instead of inline for the called-once
> function __calc_tpm2_event_size().
> 
> Fixes: 44038bc514a2 ("tpm: Abstract crypto agile event size calculations")
> Cc: stable@vger.kernel.org # v5.3
> Reported-by: WANG Xuerui <git@xen0n.name>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  include/linux/tpm_eventlog.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/include/linux/tpm_eventlog.h
> +++ b/include/linux/tpm_eventlog.h
> @@ -157,7 +157,7 @@ struct tcg_algorithm_info {
>   * Return: size of the event on success, 0 on failure
>   */
>  
> -static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
> +static __always_inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
>  					 struct tcg_pcr_event *event_header,
>  					 bool do_mapping)
>  {
> 
>

Thank you. I'll pick this.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
