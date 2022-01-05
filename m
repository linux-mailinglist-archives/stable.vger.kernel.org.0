Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC8F4850DF
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 11:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239322AbiAEKQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 05:16:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44556 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiAEKP5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 05:15:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5474DB80D96;
        Wed,  5 Jan 2022 10:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A140C36AE9;
        Wed,  5 Jan 2022 10:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641377755;
        bh=LfNhQg+xRqmZe8b0diDkdlYo/hMV3uNLgHV9f5TP2jc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P9ozdcOBmSV5H8YeZ9xdYlCKmAjejscrggNvonzPWctYLaYODDRgJxXfrWbA9NbOq
         Iml1Sd4zM3E1g1TBII+62x4ziUCx+uwBlUsF/GL+v2h4S2tCXl7S5hFb4nywdWM76a
         pgtu0PWFZEOOZ2OFAGgTFsqEY12YD/0WYxYU9nKs=
Date:   Wed, 5 Jan 2022 11:15:52 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Richard Zhu <hongxing.zhu@nxp.com>
Cc:     l.stach@pengutronix.de, bhelgaas@google.com, broonie@kernel.org,
        lorenzo.pieralisi@arm.com, jingoohan1@gmail.com,
        festevam@gmail.com, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-imx@nxp.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v5 0/6] PCI: imx6: refine codes and add compliance tests
 mode support
Message-ID: <YdVv2K+ezwv2iG80@kroah.com>
References: <1641368602-20401-1-git-send-email-hongxing.zhu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1641368602-20401-1-git-send-email-hongxing.zhu@nxp.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 05, 2022 at 03:43:16PM +0800, Richard Zhu wrote:
> This series patches refine pci-imx6 driver and do the following changes.
> - Encapsulate the clock enable into one standalone function
> - Add the error propagation from host_init
> - Balance the usage of the regulator and clocks when link never came up
> - Add the compliance tests mode support
> 
> Main changes from v4 to v5:
> - Since i.MX8MM PCIe support had been merged. Based on Lorenzo's git repos,
>   rebase and resend the patch-set.
> 
> Main changes from v3 to v4:
> - Regarding Mark's comments, delete the regulator_is_enabled() check.
> - Squash #3 and #6 of v3 patch into #5 patch of v4 set.
> 
> Main changes from v2 to v3:
> - Add "Reviewed-by: Lucas Stach <l.stach@pengutronix.de>" tag into
>   first two patches.
> - Add a Fixes tag into #3 patch.
> - Split the #4 of v2 to two patches, one is clock disable codes move,
>   the other one is the acutal clock unbalance fix.
> - Add a new host_exit() callback into dw_pcie_host_ops, then it could be
>   invoked to handle the unbalance issue in the error handling after
>   host_init() function when link is down.
> - Add a new host_exit() callback for i.MX PCIe driver to handle this case
>   in the error handling after host_init.
> 
> Main changes from v1 to v2:
> Regarding Lucas' comments.
>   - Move the placement of the new imx6_pcie_clk_enable() to avoid the
>     forward declarition.
>   - Seperate the second patch of v1 patch-set to three patches.
>   - Use the module_param to replace the kernel command line.
> Regarding Bjorn's comments:
>   - Use the cover-letter for a multi-patch series.
>   - Correct the subject line, and refine the commit logs. For example,
>     remove the timestamp of the logs.
> 
> drivers/pci/controller/dwc/pci-imx6.c             | 197 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------
> drivers/pci/controller/dwc/pcie-designware-host.c |   5 ++-
> drivers/pci/controller/dwc/pcie-designware.h      |   1 +
> 3 files changed, 128 insertions(+), 75 deletions(-)
> 
> [PATCH v5 1/6] PCI: imx6: Encapsulate the clock enable into one
> [PATCH v5 2/6] PCI: imx6: Add the error propagation from host_init
> [PATCH v5 3/6] PCI: imx6: PCI: imx6: Move imx6_pcie_clk_disable()
> [PATCH v5 4/6] PCI: dwc: Add dw_pcie_host_ops.host_exit() callback
> [PATCH v5 5/6] PCI: imx6: Fix the regulator dump when link never came
> [PATCH v5 6/6] PCI: imx6: Add the compliance tests mode support

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
