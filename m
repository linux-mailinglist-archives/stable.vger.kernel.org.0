Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC52C258BE2
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 11:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgIAJob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 05:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgIAJoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 05:44:30 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D40FD2083B;
        Tue,  1 Sep 2020 09:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598953470;
        bh=ITAD1vjf8jXauxtQsmS0HJmh1F7OhKbd2+cHVtIinic=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=inm3n9ajJCZkRJTnCyHgxoO9saJyRBsBoNpFccnDOQnDlXzG2jn75ZKUwrSXs4GYP
         y/WK5NqfVzT7LFDBxrSWMvSTlQfhDtxUyiLzCkjSKswu3t/kHuvsWY5ZPsvNtm7QNY
         F15PSoR9NLxLO5klxTsAqs2q85MHvpt7zsizvhUs=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kD2q4-008Epc-DL; Tue, 01 Sep 2020 10:44:28 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 01 Sep 2020 10:44:28 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] HID: core: Sanitize event code and type when mapping
 input
In-Reply-To: <20200827210555.1050190-1-maz@kernel.org>
References: <20200827210555.1050190-1-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <cf158681545c578c760a254d558f3292@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dmitry.torokhov@gmail.com, jikos@kernel.org, benjamin.tissoires@redhat.com, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-08-27 22:05, Marc Zyngier wrote:
> When calling into hid_map_usage(), the passed event code is
> blindly stored as is, even if it doesn't fit in the associated bitmap.
> 
> This event code can come from a variety of sources, including devices
> masquerading as input devices, only a bit more "programmable".
> 
> Instead of taking the event code at face value, check that it actually
> fits the corresponding bitmap, and if it doesn't:
> - spit out a warning so that we know which device is acting up
> - NULLify the bitmap pointer so that we catch unexpected uses
> 
> Code paths that can make use of untrusted inputs can now check
> that the mapping was indeed correct and bail out if not.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
> * From v2:
>   - Don't prematurely narrow the event code so that hid_map_usage()
>     catches illegal values beyond the 16bit limit.
> 
> * From v1:
>   - Dropped the input.c changes, and turned hid_map_usage() into
>     the validation primitive.
>   - Handle mapping failures in hidinput_configure_usage() and
>     mt_touch_input_mapping() (on top of hid_map_usage_clear() which
>     was already handled)
> 
>  drivers/hid/hid-input.c      |  4 ++++
>  drivers/hid/hid-multitouch.c |  2 ++
>  drivers/mfd/syscon.c         |  2 +-
>  include/linux/hid.h          | 42 +++++++++++++++++++++++++-----------
>  4 files changed, 36 insertions(+), 14 deletions(-)
> 

[...]

> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index 7a660411c562..75859e492984 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -108,6 +108,7 @@ static struct syscon *of_syscon_register(struct
> device_node *np, bool check_clk)
>  	syscon_config.max_register = resource_size(&res) - reg_io_width;
> 
>  	regmap = regmap_init_mmio(NULL, base, &syscon_config);
> +	kfree(syscon_config.name);
>  	if (IS_ERR(regmap)) {
>  		pr_err("regmap init failed\n");
>  		ret = PTR_ERR(regmap);
> @@ -144,7 +145,6 @@ static struct syscon *of_syscon_register(struct
> device_node *np, bool check_clk)
>  	regmap_exit(regmap);
>  err_regmap:
>  	iounmap(base);
> -	kfree(syscon_config.name);
>  err_map:
>  	kfree(syscon);
>  	return ERR_PTR(ret);


This hunk is totally unrelated, and is from another fix I was working
on at the same time... Sorry for the nois, I'll post v4 (hopefully 
final)
now.

         M.
-- 
Jazz is not dead. It just smells funny...
