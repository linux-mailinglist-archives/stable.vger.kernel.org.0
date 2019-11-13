Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75631FADD3
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 10:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfKMJ46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 04:56:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57319 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727626AbfKMJ4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 04:56:55 -0500
Received: from mail-wm1-f70.google.com ([209.85.128.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1iUpOQ-0005G5-2Z
        for stable@vger.kernel.org; Wed, 13 Nov 2019 09:56:54 +0000
Received: by mail-wm1-f70.google.com with SMTP id g13so2572394wme.0
        for <stable@vger.kernel.org>; Wed, 13 Nov 2019 01:56:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EoiUDOwW4wxyzppZmSS5uyFip4bzvGiAJfL4Yfo2Xi4=;
        b=d+V6BGAEgpvJfmzEYKWmHLP1hfitJuB2yVoAw1Dj74qitpoVfkk6QJ0UvfQgn9VBfD
         zgdjwRcLoLkwr6BflEZlsz1LyvVUoWg6rFVXOrhQ7AULKq0d3C6mbSuHBWazoOsdxtYG
         5V61w5gCosHQu9bijffnKVJDrL1YFNjcdaLPo373J5U2n3ixVfbALynVmPpEmHnGLNqK
         DZZrGV2lzAeNdi519S42vqbCU7pr8w1CQGbHNL1kZgDLpuEvxAJ7/4lKMxe6/PpvS4ob
         aT3mxH5iGKZcsmiNPnnylrftQz0ClCwg6Ukl0QjgIm070HA1fxwFuJw5exfnu41De8/Y
         S74A==
X-Gm-Message-State: APjAAAWwlrdCkbbbPNzNAO1cFG5TRVkbeOEUCFcHNiWe7+iOkdzuo0z9
        YgORJLO9YG/zkPu3upnXpEEaTSONU32MoGsymLqKjNl8O5q173z6Xsdz5Hcj3JZxurFC/Tchrxe
        NqmD+cKm0hc7Mh4saE6lE7h72Hj8iEz7rCsRXuMTa0iL/bPFf
X-Received: by 2002:a1c:64d4:: with SMTP id y203mr1922465wmb.27.1573639013549;
        Wed, 13 Nov 2019 01:56:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqxIwwlbA2u7qRPwiMpiXC42i8bF2tanN97OE0837IyPaTeg2C7rGjV+1OzU+YxpI0lxjhWvod6mSB8CrawZMCA=
X-Received: by 2002:a1c:64d4:: with SMTP id y203mr1922435wmb.27.1573639013177;
 Wed, 13 Nov 2019 01:56:53 -0800 (PST)
MIME-Version: 1.0
References: <20191111181438.945353076@linuxfoundation.org> <20191111181439.215958503@linuxfoundation.org>
In-Reply-To: <20191111181439.215958503@linuxfoundation.org>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Wed, 13 Nov 2019 17:56:42 +0800
Message-ID: <CAMy_GT_Snw-e6sLt9apftWjTagGuMYUPqsuqnSFbJJ39uGOZ2g@mail.gmail.com>
Subject: Re: [PATCH 4.19 001/125] bonding: fix state transition issue in link monitoring
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aleksei Zakharov <zakharov.a.g@yandex.ru>,
        Sha Zhang <zhangsha.zhang@huawei.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 12, 2019 at 3:05 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Jay Vosburgh <jay.vosburgh@canonical.com>
>
> [ Upstream commit 1899bb325149e481de31a4f32b59ea6f24e176ea ]
>
> Since de77ecd4ef02 ("bonding: improve link-status update in
> mii-monitoring"), the bonding driver has utilized two separate variables
> to indicate the next link state a particular slave should transition to.
> Each is used to communicate to a different portion of the link state
> change commit logic; one to the bond_miimon_commit function itself, and
> another to the state transition logic.
>
>         Unfortunately, the two variables can become unsynchronized,
> resulting in incorrect link state transitions within bonding.  This can
> cause slaves to become stuck in an incorrect link state until a
> subsequent carrier state transition.
>
>         The issue occurs when a special case in bond_slave_netdev_event
> sets slave->link directly to BOND_LINK_FAIL.  On the next pass through
> bond_miimon_inspect after the slave goes carrier up, the BOND_LINK_FAIL
> case will set the proposed next state (link_new_state) to BOND_LINK_UP,
> but the new_link to BOND_LINK_DOWN.  The setting of the final link state
> from new_link comes after that from link_new_state, and so the slave
> will end up incorrectly in _DOWN state.
>
>         Resolve this by combining the two variables into one.
>
> Reported-by: Aleksei Zakharov <zakharov.a.g@yandex.ru>
> Reported-by: Sha Zhang <zhangsha.zhang@huawei.com>
> Cc: Mahesh Bandewar <maheshb@google.com>
> Fixes: de77ecd4ef02 ("bonding: improve link-status update in mii-monitoring")
> Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/bonding/bond_main.c |   41 +++++++++++++++++++---------------------
>  include/net/bonding.h           |    3 --
>  2 files changed, 21 insertions(+), 23 deletions(-)
>
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -2074,8 +2074,7 @@ static int bond_miimon_inspect(struct bo
>         ignore_updelay = !rcu_dereference(bond->curr_active_slave);
>
>         bond_for_each_slave_rcu(bond, slave, iter) {
> -               slave->new_link = BOND_LINK_NOCHANGE;
> -               slave->link_new_state = slave->link;
> +               bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>
>                 link_state = bond_check_dev_link(bond, slave->dev, 0);
>
> @@ -2111,7 +2110,7 @@ static int bond_miimon_inspect(struct bo
>                         }
>
>                         if (slave->delay <= 0) {
> -                               slave->new_link = BOND_LINK_DOWN;
> +                               bond_propose_link_state(slave, BOND_LINK_DOWN);
>                                 commit++;
>                                 continue;
>                         }
> @@ -2150,7 +2149,7 @@ static int bond_miimon_inspect(struct bo
>                                 slave->delay = 0;
>
>                         if (slave->delay <= 0) {
> -                               slave->new_link = BOND_LINK_UP;
> +                               bond_propose_link_state(slave, BOND_LINK_UP);
>                                 commit++;
>                                 ignore_updelay = false;
>                                 continue;
> @@ -2188,7 +2187,7 @@ static void bond_miimon_commit(struct bo
>         struct slave *slave, *primary;
>
>         bond_for_each_slave(bond, slave, iter) {
> -               switch (slave->new_link) {
> +               switch (slave->link_new_state) {
>                 case BOND_LINK_NOCHANGE:
>                         /* For 802.3ad mode, check current slave speed and
>                          * duplex again in case its port was disabled after
> @@ -2263,8 +2262,8 @@ static void bond_miimon_commit(struct bo
>
>                 default:
>                         netdev_err(bond->dev, "invalid new link %d on slave %s\n",
> -                                  slave->new_link, slave->dev->name);
> -                       slave->new_link = BOND_LINK_NOCHANGE;
> +                                  slave->link_new_state, slave->dev->name);
> +                       bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>
>                         continue;
>                 }
> @@ -2664,13 +2663,13 @@ static void bond_loadbalance_arp_mon(str
>         bond_for_each_slave_rcu(bond, slave, iter) {
>                 unsigned long trans_start = dev_trans_start(slave->dev);
>
> -               slave->new_link = BOND_LINK_NOCHANGE;
> +               bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>
>                 if (slave->link != BOND_LINK_UP) {
>                         if (bond_time_in_interval(bond, trans_start, 1) &&
>                             bond_time_in_interval(bond, slave->last_rx, 1)) {
>
> -                               slave->new_link = BOND_LINK_UP;
> +                               bond_propose_link_state(slave, BOND_LINK_UP);
>                                 slave_state_changed = 1;
>
>                                 /* primary_slave has no meaning in round-robin
> @@ -2697,7 +2696,7 @@ static void bond_loadbalance_arp_mon(str
>                         if (!bond_time_in_interval(bond, trans_start, 2) ||
>                             !bond_time_in_interval(bond, slave->last_rx, 2)) {
>
> -                               slave->new_link = BOND_LINK_DOWN;
> +                               bond_propose_link_state(slave, BOND_LINK_DOWN);
>                                 slave_state_changed = 1;
>
>                                 if (slave->link_failure_count < UINT_MAX)
> @@ -2729,8 +2728,8 @@ static void bond_loadbalance_arp_mon(str
>                         goto re_arm;
>
>                 bond_for_each_slave(bond, slave, iter) {
> -                       if (slave->new_link != BOND_LINK_NOCHANGE)
> -                               slave->link = slave->new_link;
> +                       if (slave->link_new_state != BOND_LINK_NOCHANGE)
> +                               slave->link = slave->link_new_state;
>                 }
>
>                 if (slave_state_changed) {
> @@ -2753,9 +2752,9 @@ re_arm:
>  }
>
>  /* Called to inspect slaves for active-backup mode ARP monitor link state
> - * changes.  Sets new_link in slaves to specify what action should take
> - * place for the slave.  Returns 0 if no changes are found, >0 if changes
> - * to link states must be committed.
> + * changes.  Sets proposed link state in slaves to specify what action
> + * should take place for the slave.  Returns 0 if no changes are found, >0
> + * if changes to link states must be committed.
>   *
>   * Called with rcu_read_lock held.
>   */
> @@ -2767,12 +2766,12 @@ static int bond_ab_arp_inspect(struct bo
>         int commit = 0;
>
>         bond_for_each_slave_rcu(bond, slave, iter) {
> -               slave->new_link = BOND_LINK_NOCHANGE;
> +               bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>                 last_rx = slave_last_rx(bond, slave);
>
>                 if (slave->link != BOND_LINK_UP) {
>                         if (bond_time_in_interval(bond, last_rx, 1)) {
> -                               slave->new_link = BOND_LINK_UP;
> +                               bond_propose_link_state(slave, BOND_LINK_UP);
>                                 commit++;
>                         }
>                         continue;
> @@ -2800,7 +2799,7 @@ static int bond_ab_arp_inspect(struct bo
>                 if (!bond_is_active_slave(slave) &&
>                     !rcu_access_pointer(bond->current_arp_slave) &&
>                     !bond_time_in_interval(bond, last_rx, 3)) {
> -                       slave->new_link = BOND_LINK_DOWN;
> +                       bond_propose_link_state(slave, BOND_LINK_DOWN);
>                         commit++;
>                 }
>
> @@ -2813,7 +2812,7 @@ static int bond_ab_arp_inspect(struct bo
>                 if (bond_is_active_slave(slave) &&
>                     (!bond_time_in_interval(bond, trans_start, 2) ||
>                      !bond_time_in_interval(bond, last_rx, 2))) {
> -                       slave->new_link = BOND_LINK_DOWN;
> +                       bond_propose_link_state(slave, BOND_LINK_DOWN);
>                         commit++;
>                 }
>         }
> @@ -2833,7 +2832,7 @@ static void bond_ab_arp_commit(struct bo
>         struct slave *slave;
>
>         bond_for_each_slave(bond, slave, iter) {
> -               switch (slave->new_link) {
> +               switch (slave->link_new_state) {
>                 case BOND_LINK_NOCHANGE:
>                         continue;
>
> @@ -2886,7 +2885,7 @@ static void bond_ab_arp_commit(struct bo
>
>                 default:
>                         netdev_err(bond->dev, "impossible: new_link %d on slave %s\n",

Hello,

I think the error message here should be: "impossible: link_new_state
%d on slave %s\n" instead?
As in the upstream commit it's:
         slave_err(bond->dev, slave->dev,
                         "impossible: link_new_state %d on slave\n",
                          slave->link_new_state);

Thanks




> -                                  slave->new_link, slave->dev->name);
> +                                  slave->link_new_state, slave->dev->name);
>                         continue;
>                 }
>
> --- a/include/net/bonding.h
> +++ b/include/net/bonding.h
> @@ -149,7 +149,6 @@ struct slave {
>         unsigned long target_last_arp_rx[BOND_MAX_ARP_TARGETS];
>         s8     link;            /* one of BOND_LINK_XXXX */
>         s8     link_new_state;  /* one of BOND_LINK_XXXX */
> -       s8     new_link;
>         u8     backup:1,   /* indicates backup slave. Value corresponds with
>                               BOND_STATE_ACTIVE and BOND_STATE_BACKUP */
>                inactive:1, /* indicates inactive slave */
> @@ -539,7 +538,7 @@ static inline void bond_propose_link_sta
>
>  static inline void bond_commit_link_state(struct slave *slave, bool notify)
>  {
> -       if (slave->link == slave->link_new_state)
> +       if (slave->link_new_state == BOND_LINK_NOCHANGE)
>                 return;
>
>         slave->link = slave->link_new_state;
>
>
