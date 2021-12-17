Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125ED478C8F
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 14:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbhLQNnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 08:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236709AbhLQNnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 08:43:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54EBC061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 05:43:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57451621E1
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 13:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FCC6C36AE7;
        Fri, 17 Dec 2021 13:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639748620;
        bh=WjY2SZkLsviEMLScMltnYwjVSoWqxdT+Czp5Z9E3FUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jgQoSi1/TZDZgHNMEB0A01Q9+d+WeiVWF/Hwf2ncdzFRZ7XrzAy7aliRRkPLgBkPM
         415gsonFCGsb+aLk67jBOR/IiNPkb5Hv4lABvzizPcMSCyz00pWqO+4X1xvuC04t13
         smPRKN2n3GcExeYzGkaUuCI+opfv25Ey800k5Mjo=
Date:   Fri, 17 Dec 2021 14:43:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org
Subject: Re: [PATCH 5.4] iio: adc: stm32: fix a current leak by resetting
 pcsel before disabling vdda
Message-ID: <YbyUCoCQaOThT9ff@kroah.com>
References: <1639738592-28572-1-git-send-email-fabrice.gasnier@foss.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1639738592-28572-1-git-send-email-fabrice.gasnier@foss.st.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 17, 2021 at 11:56:32AM +0100, Fabrice Gasnier wrote:
> commit f711f28e71e965c0d1141c830fa7131b41abbe75 upstream.
> 
> Some I/Os are connected to ADC input channels, when the corresponding bit
> in PCSEL register are set on STM32H7 and STM32MP15. This is done in the
> prepare routine of stm32-adc driver.
> There are constraints here, as PCSEL shouldn't be set when VDDA supply
> is disabled. Enabling/disabling of VDDA supply in done via stm32-adc-core
> runtime PM routines (before/after ADC is enabled/disabled).
> 
> Currently, PCSEL remains set when disabling ADC. Later on, PM runtime
> can disable the VDDA supply. This creates some conditions on I/Os that
> can start to leak current.
> So PCSEL needs to be cleared when disabling the ADC.
> 
> Fixes: 95e339b6e85d ("iio: adc: stm32: add support for STM32H7")
> Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
> Reviewed-by: Olivier Moysan <olivier.moysan@foss.st.com>
> Link: https://lore.kernel.org/r/1634905169-23762-1-git-send-email-fabrice.gasnier@foss.st.com
> Cc: <Stable@vger.kernel.org>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Backport for 5.4-stable

Now queued up, thanks.

greg k-h
