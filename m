Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD831D94B0
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 12:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgESKsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 06:48:04 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43950 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbgESKsE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 06:48:04 -0400
Received: by mail-ot1-f68.google.com with SMTP id a68so10705695otb.10;
        Tue, 19 May 2020 03:48:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vWJ6AHtN5VbM8RUMqJBeMcbRLaQ6vTNU0sZq+lRo6Ak=;
        b=cSl8xIgp3vHbr5V0/1l/JHUBv/F9NCZyOKsbtgFicdixRwEtVOCSiqJO8ia+r1egRB
         r2lADxd/XJpbeeIMkhHkAQojPPHTKXRuBjE3HzMbhFwyPbL+9fumu0rbvdKdYvN7aPRN
         89/VkbBDGZgfyLs9O5b7OUwB+5feAQZpKyjRPxItzlIDtd9n74beDOFx4pkBUqKHM1Wn
         lcw04Zyk82O6hyVwXdpfbHMxRz6BrzXjNEZdWgh9vqjRDM6DkN2sBpU24K0owG0beo2v
         qMY6clbT3E5557N/9ALUOg9/8nwZTxpMoHuq7HJ+uRWIbPpgdRmgS/zyKMq/gehEA0Po
         eGGw==
X-Gm-Message-State: AOAM530+wFA8AZA7sqMHqVcTX5FxPawKwpXSf+weQvgLfIllg0aMpxI2
        R1gqw0AyQoHA7ye3Y/+bxPwl7IK2y9TEdIvnY8s=
X-Google-Smtp-Source: ABdhPJzz0kx117x4rrxclOsGqgsOyF4wpH3ncg2wBxCoWdcqNdpiJ8vCSMiSCZ1Qgj9jUQAhYBsP4Gblxvla6Um6h9I=
X-Received: by 2002:a05:6830:10ce:: with SMTP id z14mr14940215oto.118.1589885282772;
 Tue, 19 May 2020 03:48:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200518080327.GA3126260@kroah.com> <20200519063000.128819-1-saravanak@google.com>
In-Reply-To: <20200519063000.128819-1-saravanak@google.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 19 May 2020 12:47:50 +0200
Message-ID: <CAJZ5v0i_nWPykPF9V4-OQABVmRkX2hD17WuT_FbdyiM=hn_8Aw@mail.gmail.com>
Subject: Re: [PATCH v3] driver core: Fix SYNC_STATE_ONLY device link implementation
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Stable <stable@vger.kernel.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 19, 2020 at 8:30 AM Saravana Kannan <saravanak@google.com> wrote:
>
> When SYNC_STATE_ONLY support was added in commit 05ef983e0d65 ("driver
> core: Add device link support for SYNC_STATE_ONLY flag"),
> device_link_add() incorrectly skipped adding the new SYNC_STATE_ONLY
> device link to the supplier's and consumer's "device link" list.
>
> This causes multiple issues:
> - The device link is lost forever from driver core if the caller
>   didn't keep track of it (caller typically isn't expected to). This is
>   a memory leak.
> - The device link is also never visible to any other code path after
>   device_link_add() returns.
>
> If we fix the "device link" list handling, that exposes a bunch of
> issues.
>
> 1. The device link "status" state management code rightfully doesn't
> handle the case where a DL_FLAG_MANAGED device link exists between a
> supplier and consumer, but the consumer manages to probe successfully
> before the supplier. The addition of DL_FLAG_SYNC_STATE_ONLY links break
> this assumption. This causes device_links_driver_bound() to throw a
> warning when this happens.
>
> Since DL_FLAG_SYNC_STATE_ONLY device links are mainly used for creating
> proxy device links for child device dependencies and aren't useful once
> the consumer device probes successfully, this patch just deletes
> DL_FLAG_SYNC_STATE_ONLY device links once its consumer device probes.
> This way, we avoid the warning, free up some memory and avoid
> complicating the device links "status" state management code.
>
> 2. Creating a DL_FLAG_STATELESS device link between two devices that
> already have a DL_FLAG_SYNC_STATE_ONLY device link will result in the
> DL_FLAG_STATELESS flag not getting set correctly. This patch also fixes
> this.
>
> Lastly, this patch also fixes minor whitespace issues.
>
> Cc: stable@vger.kernel.org
> Fixes: 05ef983e0d65 ("driver core: Add device link support for SYNC_STATE_ONLY flag")
> Signed-off-by: Saravana Kannan <saravanak@google.com>

No issues found, so

Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
> v3:
> - Added this changelog text
> v2:
> - Delete DL_FLAG_SYNC_STATE_ONLY device links on consumer probe
> - Set DL_FLAG_STATELESS correct when added to an existing
>   DL_FLAG_SYNC_STATE_ONLY device link.
> v1:
> - Add device link to list
> - Minor whitespace fixes
>
>  drivers/base/core.c | 61 +++++++++++++++++++++++++++++----------------
>  1 file changed, 39 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 84c569726d75..f804e561e0a2 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -363,13 +363,12 @@ struct device_link *device_link_add(struct device *consumer,
>
>                 if (flags & DL_FLAG_STATELESS) {
>                         kref_get(&link->kref);
> +                       link->flags |= DL_FLAG_STATELESS;
>                         if (link->flags & DL_FLAG_SYNC_STATE_ONLY &&
> -                           !(link->flags & DL_FLAG_STATELESS)) {
> -                               link->flags |= DL_FLAG_STATELESS;
> +                           !(link->flags & DL_FLAG_STATELESS))
>                                 goto reorder;
> -                       } else {
> +                       else
>                                 goto out;
> -                       }
>                 }
>
>                 /*
> @@ -436,12 +435,16 @@ struct device_link *device_link_add(struct device *consumer,
>             flags & DL_FLAG_PM_RUNTIME)
>                 pm_runtime_resume(supplier);
>
> +       list_add_tail_rcu(&link->s_node, &supplier->links.consumers);
> +       list_add_tail_rcu(&link->c_node, &consumer->links.suppliers);
> +
>         if (flags & DL_FLAG_SYNC_STATE_ONLY) {
>                 dev_dbg(consumer,
>                         "Linked as a sync state only consumer to %s\n",
>                         dev_name(supplier));
>                 goto out;
>         }
> +
>  reorder:
>         /*
>          * Move the consumer and all of the devices depending on it to the end
> @@ -452,12 +455,9 @@ struct device_link *device_link_add(struct device *consumer,
>          */
>         device_reorder_to_tail(consumer, NULL);
>
> -       list_add_tail_rcu(&link->s_node, &supplier->links.consumers);
> -       list_add_tail_rcu(&link->c_node, &consumer->links.suppliers);
> -
>         dev_dbg(consumer, "Linked as a consumer to %s\n", dev_name(supplier));
>
> - out:
> +out:
>         device_pm_unlock();
>         device_links_write_unlock();
>
> @@ -832,6 +832,13 @@ static void __device_links_supplier_defer_sync(struct device *sup)
>                 list_add_tail(&sup->links.defer_sync, &deferred_sync);
>  }
>
> +static void device_link_drop_managed(struct device_link *link)
> +{
> +       link->flags &= ~DL_FLAG_MANAGED;
> +       WRITE_ONCE(link->status, DL_STATE_NONE);
> +       kref_put(&link->kref, __device_link_del);
> +}
> +
>  /**
>   * device_links_driver_bound - Update device links after probing its driver.
>   * @dev: Device to update the links for.
> @@ -845,7 +852,7 @@ static void __device_links_supplier_defer_sync(struct device *sup)
>   */
>  void device_links_driver_bound(struct device *dev)
>  {
> -       struct device_link *link;
> +       struct device_link *link, *ln;
>         LIST_HEAD(sync_list);
>
>         /*
> @@ -885,18 +892,35 @@ void device_links_driver_bound(struct device *dev)
>         else
>                 __device_links_queue_sync_state(dev, &sync_list);
>
> -       list_for_each_entry(link, &dev->links.suppliers, c_node) {
> +       list_for_each_entry_safe(link, ln, &dev->links.suppliers, c_node) {
> +               struct device *supplier;
> +
>                 if (!(link->flags & DL_FLAG_MANAGED))
>                         continue;
>
> -               WARN_ON(link->status != DL_STATE_CONSUMER_PROBE);
> -               WRITE_ONCE(link->status, DL_STATE_ACTIVE);
> +               supplier = link->supplier;
> +               if (link->flags & DL_FLAG_SYNC_STATE_ONLY) {
> +                       /*
> +                        * When DL_FLAG_SYNC_STATE_ONLY is set, it means no
> +                        * other DL_MANAGED_LINK_FLAGS have been set. So, it's
> +                        * save to drop the managed link completely.
> +                        */
> +                       device_link_drop_managed(link);
> +               } else {
> +                       WARN_ON(link->status != DL_STATE_CONSUMER_PROBE);
> +                       WRITE_ONCE(link->status, DL_STATE_ACTIVE);
> +               }
>
> +               /*
> +                * This needs to be done even for the deleted
> +                * DL_FLAG_SYNC_STATE_ONLY device link in case it was the last
> +                * device link that was preventing the supplier from getting a
> +                * sync_state() call.
> +                */
>                 if (defer_sync_state_count)
> -                       __device_links_supplier_defer_sync(link->supplier);
> +                       __device_links_supplier_defer_sync(supplier);
>                 else
> -                       __device_links_queue_sync_state(link->supplier,
> -                                                       &sync_list);
> +                       __device_links_queue_sync_state(supplier, &sync_list);
>         }
>
>         dev->links.status = DL_DEV_DRIVER_BOUND;
> @@ -906,13 +930,6 @@ void device_links_driver_bound(struct device *dev)
>         device_links_flush_sync_list(&sync_list, dev);
>  }
>
> -static void device_link_drop_managed(struct device_link *link)
> -{
> -       link->flags &= ~DL_FLAG_MANAGED;
> -       WRITE_ONCE(link->status, DL_STATE_NONE);
> -       kref_put(&link->kref, __device_link_del);
> -}
> -
>  /**
>   * __device_links_no_driver - Update links of a device without a driver.
>   * @dev: Device without a drvier.
> --
> 2.26.2.761.g0e0b3e54be-goog
>
