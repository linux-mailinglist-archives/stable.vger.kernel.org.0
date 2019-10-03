Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E81DCCA054
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 16:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730274AbfJCO3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 10:29:53 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42112 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfJCO3x (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 10:29:53 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbrezillon)
        with ESMTPSA id 33AF328E8BE
Date:   Thu, 3 Oct 2019 16:29:43 +0200
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Vitor Soares <Vitor.Soares@synopsys.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-i3c@lists.infradead.org, bbrezillon@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, pgaj@cadence.com,
        Joao.Pinto@synopsys.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/5] i3c: master: make sure ->boardinfo is
 initialized in add_i3c_dev_locked()
Message-ID: <20191003162943.4a0d0274@collabora.com>
In-Reply-To: <ed18fd927b5759a6a1edb351113ceca615283189.1567608245.git.vitor.soares@synopsys.com>
References: <cover.1567608245.git.vitor.soares@synopsys.com>
        <ed18fd927b5759a6a1edb351113ceca615283189.1567608245.git.vitor.soares@synopsys.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu,  5 Sep 2019 12:00:35 +0200
Vitor Soares <Vitor.Soares@synopsys.com> wrote:

> The newdev->boardinfo assignment was missing in
> i3c_master_add_i3c_dev_locked() and hence the ->of_node info isn't
> propagated to i3c_dev_desc.
> 
> Fix this by trying to initialize device i3c_dev_boardinfo if available.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
> Signed-off-by: Vitor Soares <vitor.soares@synopsys.com>
> ---
> Change in v3:
>   - None
> 
> Changes in v2:
>   - Change commit message
>   - Change i3c_master_search_i3c_boardinfo(newdev) to
>   i3c_master_init_i3c_dev_boardinfo(newdev)
>   - Add fixes, stable tags
> 
>  drivers/i3c/master.c | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
> index 586e34f..9fb99bc 100644
> --- a/drivers/i3c/master.c
> +++ b/drivers/i3c/master.c
> @@ -1798,6 +1798,22 @@ i3c_master_search_i3c_dev_duplicate(struct i3c_dev_desc *refdev)
>  	return NULL;
>  }
>  
> +static void i3c_master_init_i3c_dev_boardinfo(struct i3c_dev_desc *dev)
> +{
> +	struct i3c_master_controller *master = i3c_dev_get_master(dev);
> +	struct i3c_dev_boardinfo *boardinfo;
> +
> +	if (dev->boardinfo)
> +		return;
> +
> +	list_for_each_entry(boardinfo, &master->boardinfo.i3c, node) {
> +		if (dev->info.pid == boardinfo->pid) {
> +			dev->boardinfo = boardinfo;
> +			return;
> +		}
> +	}
> +}
> +
>  /**
>   * i3c_master_add_i3c_dev_locked() - add an I3C slave to the bus
>   * @master: master used to send frames on the bus
> @@ -1818,8 +1834,9 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
>  				  u8 addr)
>  {
>  	struct i3c_device_info info = { .dyn_addr = addr };
> -	struct i3c_dev_desc *newdev, *olddev;
>  	u8 old_dyn_addr = addr, expected_dyn_addr;
> +	enum i3c_addr_slot_status addrstatus;
> +	struct i3c_dev_desc *newdev, *olddev;
>  	struct i3c_ibi_setup ibireq = { };
>  	bool enable_ibi = false;
>  	int ret;
> @@ -1878,6 +1895,8 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
>  	if (ret)
>  		goto err_detach_dev;
>  
> +	i3c_master_init_i3c_dev_boardinfo(newdev);
> +
>  	/*
>  	 * Depending on our previous state, the expected dynamic address might
>  	 * differ:
> @@ -1895,7 +1914,11 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
>  	else
>  		expected_dyn_addr = newdev->info.dyn_addr;
>  
> -	if (newdev->info.dyn_addr != expected_dyn_addr) {
> +	addrstatus = i3c_bus_get_addr_slot_status(&master->bus,
> +						  expected_dyn_addr);
> +
> +	if (newdev->info.dyn_addr != expected_dyn_addr &&
> +	    addrstatus == I3C_ADDR_SLOT_FREE) {

First, this change shouldn't be part of this patch, since the commit
message only mentions the boardinfo init stuff, not the extra 'is slot
free check'. Plus, I want the fix to be backported so we should avoid
any unneeded deps.

But even with those 2 things addressed, I'm still convinced the
'free desc when device is not reachable' change you do in patch 1 is
not that great, and the fact that you can't pre-reserve the address to
make sure no one uses it until the device had a chance to show up tends
to prove me right.

Can we please do what I suggest and solve the "not enough dev slots"
problem later on (if we really have to).

>  		/*
>  		 * Try to apply the expected dynamic address. If it fails, keep
>  		 * the address assigned by the master.

