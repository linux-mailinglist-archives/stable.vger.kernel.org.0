Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA2A4CF3F
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 15:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfFTNok (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 09:44:40 -0400
Received: from mail.skyhub.de ([5.9.137.197]:39588 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbfFTNok (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 09:44:40 -0400
Received: from zn.tnic (p200300EC2F07DE00D53AC9D946AF6654.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:de00:d53a:c9d9:46af:6654])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0A0C01EC08BF;
        Thu, 20 Jun 2019 15:44:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1561038278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=rUNsSF+JR74CeJtCQdzcIH31DxAglLW7nCzn5d5D+V4=;
        b=fpj+eHKQ3qBP+eePTJpVO4X/AbY9HoG0Yvq8uG5Y9Cp9ew5DtinheLjsu7HK2mURN4DuVl
        gSrS1eHswrhJnke5bQ5MC2hVgDBocvndRlmdAJhKmn6aqaHoKkPtnTr4bkXtZ2DyZ8sDQ6
        U8zhp7cKY1S0bJML/iUBMB1IPSDS3ww=
Date:   Thu, 20 Jun 2019 15:44:29 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     tglx@linutronix.de, fenghua.yu@intel.com, tony.luck@intel.com,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/resctrl: Prevent possible overrun during bitmap
 operations
Message-ID: <20190620134429.GD28032@zn.tnic>
References: <58c9b6081fd9bf599af0dfc01a6fdd335768efef.1560975645.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <58c9b6081fd9bf599af0dfc01a6fdd335768efef.1560975645.git.reinette.chatre@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 19, 2019 at 01:27:16PM -0700, Reinette Chatre wrote:
> @@ -2494,26 +2498,19 @@ static int mkdir_mondata_all(struct kernfs_node *parent_kn,
>   */
>  static void cbm_ensure_valid(u32 *_val, struct rdt_resource *r)
>  {
> -	/*
> -	 * Convert the u32 _val to an unsigned long required by all the bit
> -	 * operations within this function. No more than 32 bits of this
> -	 * converted value can be accessed because all bit operations are
> -	 * additionally provided with cbm_len that is initialized during
> -	 * hardware enumeration using five bits from the EAX register and
> -	 * thus never can exceed 32 bits.
> -	 */
> -	unsigned long *val = (unsigned long *)_val;
> +	unsigned long val = *_val;
>  	unsigned int cbm_len = r->cache.cbm_len;
>  	unsigned long first_bit, zero_bit;

Please sort function local variables declaration in a reverse christmas
tree order:

	<type A> longest_variable_name;
	<type B> shorter_var_name;
	<type C> even_shorter;
	<type D> i;

> -	if (*val == 0)
> +	if (val == 0)

	if (!val)

>  		return;
>  
> -	first_bit = find_first_bit(val, cbm_len);
> -	zero_bit = find_next_zero_bit(val, cbm_len, first_bit);
> +	first_bit = find_first_bit(&val, cbm_len);
> +	zero_bit = find_next_zero_bit(&val, cbm_len, first_bit);
>  
>  	/* Clear any remaining bits to ensure contiguous region */
> -	bitmap_clear(val, zero_bit, cbm_len - zero_bit);
> +	bitmap_clear(&val, zero_bit, cbm_len - zero_bit);
> +	*_val = (u32)val;

... and also, that function should simply return the u32 value instead
of using @_val as an input and output var.

But that should be a separate cleanup patch anyway.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
