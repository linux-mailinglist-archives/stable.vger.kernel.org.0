Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C65722406C
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 18:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgGQQR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 12:17:28 -0400
Received: from foss.arm.com ([217.140.110.172]:43376 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgGQQR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jul 2020 12:17:28 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A864B142F;
        Fri, 17 Jul 2020 09:17:27 -0700 (PDT)
Received: from e107158-lin.cambridge.arm.com (e107158-lin.cambridge.arm.com [10.1.195.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AB4FF3F68F;
        Fri, 17 Jul 2020 09:17:25 -0700 (PDT)
Date:   Fri, 17 Jul 2020 17:17:23 +0100
From:   Qais Yousef <qais.yousef@arm.com>
To:     Eugeniu Rosca <erosca@de.adit-jv.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Oliver Neukum <oneukum@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: Re: [PATCH 4.14 105/136] usb/ehci-platform: Set PM runtime as active
 on resume
Message-ID: <20200717161639.37ptgbolborimcvs@e107158-lin.cambridge.arm.com>
References: <20200623195303.601828702@linuxfoundation.org>
 <20200623195308.955410923@linuxfoundation.org>
 <20200709070023.GA18414@lxhi-065.adit-jv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200709070023.GA18414@lxhi-065.adit-jv.com>
User-Agent: NeoMutt/20171215
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Eugeniu

On 07/09/20 09:00, Eugeniu Rosca wrote:
> Hello everyone,
> 
> Cc: linux-renesas-soc
> Cc: linux-pm

[...]

> After integrating v4.14.186 commit 5410d158ca2a50 ("usb/ehci-platform:
> Set PM runtime as active on resume") into downstream v4.14.x, we started
> to consistently experience below panic [1] on every second s2ram of
> R-Car H3 Salvator-X Renesas reference board.
> 
> After some investigations, we concluded the following:
>  - the issue does not exist in vanilla v5.8-rc4+
>  - [bisecting shows that] the panic on v4.14.186 is caused by the lack
>    of v5.6-rc1 commit 987351e1ea7772 ("phy: core: Add consumer device
>    link support"). Getting evidence for that is easy. Reverting
>    987351e1ea7772 in vanilla leads to a similar backtrace [2].
> 
> Questions:
>  - Backporting 987351e1ea7772 ("phy: core: Add consumer device
>    link support") to v4.14.187 looks challenging enough, so probably not
>    worth it. Anybody to contradict this?
>  - Assuming no plans to backport the missing mainline commit to v4.14.x,
>    should the following three v4.14.186 commits be reverted on v4.14.x?
>    * baef809ea497a4 ("usb/ohci-platform: Fix a warning when hibernating")
>    * 9f33eff4958885 ("usb/xhci-plat: Set PM runtime as active on resume")
>    * 5410d158ca2a50 ("usb/ehci-platform: Set PM runtime as active on resume")

Thanks for investigating this.

Alan, Greg, do you have any ideas?

Let me know if there's anything I can help with.

Thanks

--
Qais Yousef
