Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF5F49DB1F
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 08:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237065AbiA0HCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 02:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237047AbiA0HCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 02:02:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1262CC061714;
        Wed, 26 Jan 2022 23:02:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF91561984;
        Thu, 27 Jan 2022 07:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBACEC340E4;
        Thu, 27 Jan 2022 07:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643266926;
        bh=FEDscaRYBQwJH6GLsPAmvTFyqeo2iRJEKEQWnaCfndk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WU7bHJ1t+MRI1oX3FfPjy+aAdM8u/rg4WpIJqBp1lW6u6U0WTMeKPo+l5OvItZYxi
         JPQtbYOryH2VacybHpaE49nZQiqtw6kgYb9mrLDz3dRQZhiqVQzNDZzjDpxC6x/oeV
         deTAk7usORJI65R6cay+1lmUv2h43DZmmX2Mat7JnlBpil2xaC4Okqvxa8HgJxFGSn
         9FzYynvDIPbqWnpkubyBtbswM/2EFIZhuMy3D/EvEJSaHxGBBXi1hn2ffCxIgnXCVL
         xqJmjlGMuIV8/StJW6lElW8HpcgQ69YcHfqjt0OeChOyFs8yMyxZYQabZXyvO5POTE
         DVmk2MDqJ2FGw==
Date:   Thu, 27 Jan 2022 09:01:43 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3] x86/sgx: Free backing memory after faulting the
 enclave page
Message-ID: <YfJDV63oGmWOmO4F@iki.fi>
References: <20220108140510.76583-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220108140510.76583-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 08, 2022 at 04:05:10PM +0200, Jarkko Sakkinen wrote:
> +static inline pgoff_t sgx_encl_get_backing_pcmd_nr(struct sgx_encl *encl, pgoff_t index)
> +{
> +	return PFN_DOWN(encl->size) + 1 + (index / sizeof(struct sgx_pcmd));
> +}

Found it.

This should be 

static inline pgoff_t sgx_encl_get_backing_pcmd_nr(struct sgx_encl *encl, pgoff_t index)
{
	return PFN_DOWN(encl->size) + 1 + (index * PAGE_SIZE) / sizeof(struct sgx_pcmd);
}

/Jarkko
