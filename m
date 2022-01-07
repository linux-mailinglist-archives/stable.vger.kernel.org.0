Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC30487662
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 12:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346877AbiAGLVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 06:21:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57124 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237830AbiAGLVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 06:21:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0868760A6D
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 11:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D1EC36AE9;
        Fri,  7 Jan 2022 11:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641554480;
        bh=TIKtwdLyiyF92hZb62dr30nuCXc4HPQXsYaVnDcJ4x4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CuAL9VN6zqyqXY+fhFVSHaJNBpCgh94g7Lt/kLqqYtkizgUYHSKbZ2kfq9Sh7p/3m
         VZiA7ZPHq5UteS+GtUp7r1oIeHn9pWoweEV9a0PO38smNTdn8lVVLzolRYOc5AGelZ
         3nZWnebCr4V+5MeVtKKUwBhZIfUapu3ZX3aYr8yM=
Date:   Fri, 7 Jan 2022 12:21:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Wei <albin.yangwei@alibaba-inc.com>
Cc:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org,
        yang.wei@linux.alibaba.com
Subject: Re: [PATCH 4.9] virtio_pci: Support surprise removal of virtio pci
 device
Message-ID: <YdgiKa9YLXrWVfxZ@kroah.com>
References: <20220107085128.100165-1-albin.yangwei@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107085128.100165-1-albin.yangwei@alibaba-inc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 07, 2022 at 04:51:28PM +0800, Yang Wei wrote:
> From: Parav Pandit <parav@nvidia.com>
> 
> commit 43bb40c5b92659966bdf4bfe584fde0a3575a049 upstream.
> 
> When a virtio pci device undergo surprise removal (aka async removal in
> PCIe spec), mark the device as broken so that any upper layer drivers can
> abort any outstanding operation.
> 
> When a virtio net pci device undergo surprise removal which is used by a
> NetworkManager, a below call trace was observed.
> 
> kernel:watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [kworker/1:1:27059]
> watchdog: BUG: soft lockup - CPU#1 stuck for 52s! [kworker/1:1:27059]
> CPU: 1 PID: 27059 Comm: kworker/1:1 Tainted: G S      W I  L    5.13.0-hotplug+ #8
> Hardware name: Dell Inc. PowerEdge R640/0H28RR, BIOS 2.9.4 11/06/2020
> Workqueue: events linkwatch_event
> RIP: 0010:virtnet_send_command+0xfc/0x150 [virtio_net]
> Call Trace:
>  virtnet_set_rx_mode+0xcf/0x2a7 [virtio_net]
>  ? __hw_addr_create_ex+0x85/0xc0
>  __dev_mc_add+0x72/0x80
>  igmp6_group_added+0xa7/0xd0
>  ipv6_mc_up+0x3c/0x60
>  ipv6_find_idev+0x36/0x80
>  addrconf_add_dev+0x1e/0xa0
>  addrconf_dev_config+0x71/0x130
>  addrconf_notify+0x1f5/0xb40
>  ? rtnl_is_locked+0x11/0x20
>  ? __switch_to_asm+0x42/0x70
>  ? finish_task_switch+0xaf/0x2c0
>  ? raw_notifier_call_chain+0x3e/0x50
>  raw_notifier_call_chain+0x3e/0x50
>  netdev_state_change+0x67/0x90
>  linkwatch_do_dev+0x3c/0x50
>  __linkwatch_run_queue+0xd2/0x220
>  linkwatch_event+0x21/0x30
>  process_one_work+0x1c8/0x370
>  worker_thread+0x30/0x380
>  ? process_one_work+0x370/0x370
>  kthread+0x118/0x140
>  ? set_kthread_struct+0x40/0x40
>  ret_from_fork+0x1f/0x30
> 
> Hence, add the ability to abort the command on surprise removal
> which prevents infinite loop and system lockup.
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Link: https://lore.kernel.org/r/20210721142648.1525924-5-parav@nvidia.com
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Yang Wei <yang.wei@linux.alibaba.com>
> ---
>  drivers/virtio/virtio_pci_common.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index d9a905827967..37e3ba5dadf6 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -547,6 +547,13 @@ static void virtio_pci_remove(struct pci_dev *pci_dev)
>  	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
>  	struct device *dev = get_device(&vp_dev->vdev.dev);
>  
> +	/*
> +	 * Device is marked broken on surprise removal so that virtio upper
> +	 * layers can abort any ongoing operation.
> +	 */
> +	if (!pci_device_is_present(pci_dev))
> +		virtio_break_device(&vp_dev->vdev);
> +
>  	unregister_virtio_device(&vp_dev->vdev);
>  
>  	if (vp_dev->ioaddr)
> -- 
> 2.19.1.6.gb485710b
> 

Both patches now queued up, thanks.

greg k-h
