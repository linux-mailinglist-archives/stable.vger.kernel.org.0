Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD8412F6B9
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 11:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgACKaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 05:30:01 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:9433 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbgACKaB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 05:30:01 -0500
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jan 2020 05:29:59 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1578047398;
        s=strato-dkim-0002; d=gerhold.net;
        h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=ptzf07pECs+0aSDlIJmrKwxK6Srl79d80vBcpL7VdiE=;
        b=GONJzla0/9mNsnBKZ5PrxQPMrkzAWVbTpG21I2xsT1lLFG1mcCTdqL74j5WrekEE3s
        q1GIMl0fxnqzgi3Gbi4K8Qa85NS9wZbF/P3F4BiSnQFtgrI5OY7+XjytP1P43E+CO1Jw
        Qk3ct4OExZkCo2ywfetjB6yUOwzM3zjDmTrmCsuMNcbjpc0emjV5rXictmdI/vs63MPN
        hj2jmaAs3XxkQtEYY6hLVs72GOl2Cr0HOkJcC9wK1ff/GtQ07xn7hRXBlsvAwt9dPj0I
        VSHR1Snpb4/By/Dp5i5EwAFa2wZFYCiIZfJRVzV7CFansve8XkEjh9PnAKCM31tCLOJm
        AHtA==
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u266EZF6ORJDdPLYs76f"
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
        by smtp.strato.de (RZmta 46.1.3 AUTH)
        with ESMTPSA id z012abw03ANqcuB
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 3 Jan 2020 11:23:52 +0100 (CET)
Date:   Fri, 3 Jan 2020 11:23:47 +0100
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Barry Song <Baohua.Song@csr.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 055/191] mfd: mfd-core: Honour Device Trees request
 to disable a child-device
Message-ID: <20200103102347.GA879@gerhold.net>
References: <20200102215829.911231638@linuxfoundation.org>
 <20200102215835.819082035@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102215835.819082035@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 11:05:37PM +0100, Greg Kroah-Hartman wrote:
> From: Lee Jones <lee.jones@linaro.org>
> 
> [ Upstream commit 6b5c350648b857047b47acf74a57087ad27d6183 ]
> 
> Until now, MFD has assumed all child devices passed to it (via
> mfd_cells) are to be registered. It does not take into account
> requests from Device Tree and the like to disable child devices
> on a per-platform basis.
> 
> Well now it does.
> 
> Link: https://www.spinics.net/lists/arm-kernel/msg366309.html
> Link: https://lkml.org/lkml/2019/8/22/1350

As far as I understand it, this commit is not suitable for backporting.
The link above explains the problem for a similar patch:

	But I believe this would introduce a rather ugly bug in
	mfd_remove_devices() if the first sub-device is set to disabled:
	It iterates over the children devices to find the base address
	of the allocated "usage count" array, which is then used to free it.
	If the first sub-device is missing, it would free the wrong address.

This problem does not exist in mainline because the MFD usage counting
was removed entirely as part of the larger "Simplify MFD Core" series [1].

None of the device trees in the stable kernels should depend on
disabling MFD devices from the device tree. (They were written at a time
when the MFD core ignored that request entirely...)
Therefore, I would suggest to drop this patch entirely.

[1]: https://lore.kernel.org/lkml/20191101074518.26228-1-lee.jones@linaro.org/

> 
> Reported-by: Barry Song <Baohua.Song@csr.com>
> Reported-by: Stephan Gerhold <stephan@gerhold.net>
> Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Tested-by: Stephan Gerhold <stephan@gerhold.net>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/mfd/mfd-core.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> index 23276a80e3b4..b0afefdc9eac 100644
> --- a/drivers/mfd/mfd-core.c
> +++ b/drivers/mfd/mfd-core.c
> @@ -174,6 +174,11 @@ static int mfd_add_device(struct device *parent, int id,
>  	if (parent->of_node && cell->of_compatible) {
>  		for_each_child_of_node(parent->of_node, np) {
>  			if (of_device_is_compatible(np, cell->of_compatible)) {
> +				if (!of_device_is_available(np)) {
> +					/* Ignore disabled devices error free */
> +					ret = 0;
> +					goto fail_alias;
> +				}
>  				pdev->dev.of_node = np;
>  				pdev->dev.fwnode = &np->fwnode;
>  				break;
> -- 
> 2.20.1
> 
> 
> 
