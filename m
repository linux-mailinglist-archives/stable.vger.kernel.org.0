Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57E50FADBF
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 10:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfKMJ4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 04:56:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57294 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727513AbfKMJ4B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 04:56:01 -0500
Received: from mail-wr1-f72.google.com ([209.85.221.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1iUpNW-00059d-NI
        for stable@vger.kernel.org; Wed, 13 Nov 2019 09:55:58 +0000
Received: by mail-wr1-f72.google.com with SMTP id q12so1284784wrr.3
        for <stable@vger.kernel.org>; Wed, 13 Nov 2019 01:55:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KWqbv/EZncY/JB7jjvjEDr6KxpThc8HK4dhaPFdS5R0=;
        b=q+26TpGkiH8GZM6m9CL8/MzHOHjauS4oc1M9D8Bh3fJWDrA78YexyBgko4rpOSUFhf
         kENvwEuDnuZA7/UWGBMC83E7DIyLOgQBNdC6WKVucpvqe/2matHH6VEuDGnB0MkM+Epi
         pXjuseitTXyF68QAjn5Oe4C3A5IAa82WNaGN9kKZFIXyU1zOQsm1iPxlYj38v0LDkwcL
         V5hdGca8J8JxttU/YKv3Gf7d5CZhrc0fvYWrE6qU6gPH1UmDoDZd7T0GlFPu48WA/1lL
         DinUQrbGc8pfJ6PscTspL61EUNfHHeVNVmBIhX1owcsWzbIEwA5t40BS+GrJGATuYxJe
         mIcQ==
X-Gm-Message-State: APjAAAUNa8kCzKWRNl3ELH/Xl4NPd9j9l3eES3FsVyXaz474e0M92g/x
        D7VHRZQujZqoV/KdMWvp8GVHeLFg2+0jCzcFoi/vQ4Ubmm5FVqJXfMuzuT4NRS75ZGQvWP9M6Sn
        vUnKJS32X4bn5pG+2woPzr1nhuXxuLuxZi7tthWgzIqAErDuU
X-Received: by 2002:a1c:6588:: with SMTP id z130mr1714400wmb.87.1573638958309;
        Wed, 13 Nov 2019 01:55:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqyh5t4nGV1h7b3BLSwD5FAU6WNhjAgEkMPMfxcqyF2S1Y4s0gBiwJ0k1CwqG7GEibqubuIjsF8EAbY66aMRc/0=
X-Received: by 2002:a1c:6588:: with SMTP id z130mr1714378wmb.87.1573638957892;
 Wed, 13 Nov 2019 01:55:57 -0800 (PST)
MIME-Version: 1.0
References: <20191111181421.390326245@linuxfoundation.org> <20191111181421.883447565@linuxfoundation.org>
In-Reply-To: <20191111181421.883447565@linuxfoundation.org>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Wed, 13 Nov 2019 17:55:46 +0800
Message-ID: <CAMy_GT_gDL4gS0VmOtBR_rO7sRW-FW=rV_o98MAF9R54L1gtcQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 001/105] bonding: fix state transition issue in link monitoring
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

On Tue, Nov 12, 2019 at 3:09 AM Greg Kroah-Hartman
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
> @@ -2055,8 +2055,7 @@ static int bond_miimon_inspect(struct bo
>         ignore_updelay = !rcu_dereference(bond->curr_active_slave);
>
>         bond_for_each_slave_rcu(bond, slave, iter) {
> -               slave->new_link = BOND_LINK_NOCHANGE;
> -               slave->link_new_state = slave->link;
> +               bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>
>                 link_state = bond_check_dev_link(bond, slave->dev, 0);
>
> @@ -2092,7 +2091,7 @@ static int bond_miimon_inspect(struct bo
>                         }
>
>                         if (slave->delay <= 0) {
> -                               slave->new_link = BOND_LINK_DOWN;
> +                               bond_propose_link_state(slave, BOND_LINK_DOWN);
>                                 commit++;
>                                 continue;
>                         }
> @@ -2131,7 +2130,7 @@ static int bond_miimon_inspect(struct bo
>                                 slave->delay = 0;
>
>                         if (slave->delay <= 0) {
> -                               slave->new_link = BOND_LINK_UP;
> +                               bond_propose_link_state(slave, BOND_LINK_UP);
>                                 commit++;
>                                 ignore_updelay = false;
>                                 continue;
> @@ -2151,7 +2150,7 @@ static void bond_miimon_commit(struct bo
>         struct slave *slave, *primary;
>
>         bond_for_each_slave(bond, slave, iter) {
> -               switch (slave->new_link) {
> +               switch (slave->link_new_state) {
>                 case BOND_LINK_NOCHANGE:
>                         /* For 802.3ad mode, check current slave speed and
>                          * duplex again in case its port was disabled after
> @@ -2244,8 +2243,8 @@ static void bond_miimon_commit(struct bo
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
> @@ -2644,13 +2643,13 @@ static void bond_loadbalance_arp_mon(str
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
> @@ -2677,7 +2676,7 @@ static void bond_loadbalance_arp_mon(str
>                         if (!bond_time_in_interval(bond, trans_start, 2) ||
>                             !bond_time_in_interval(bond, slave->last_rx, 2)) {
>
> -                               slave->new_link = BOND_LINK_DOWN;
> +                               bond_propose_link_state(slave, BOND_LINK_DOWN);
>                                 slave_state_changed = 1;
>
>                                 if (slave->link_failure_count < UINT_MAX)
> @@ -2709,8 +2708,8 @@ static void bond_loadbalance_arp_mon(str
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
> @@ -2733,9 +2732,9 @@ re_arm:
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
> @@ -2747,12 +2746,12 @@ static int bond_ab_arp_inspect(struct bo
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
> @@ -2780,7 +2779,7 @@ static int bond_ab_arp_inspect(struct bo
>                 if (!bond_is_active_slave(slave) &&
>                     !rcu_access_pointer(bond->current_arp_slave) &&
>                     !bond_time_in_interval(bond, last_rx, 3)) {
> -                       slave->new_link = BOND_LINK_DOWN;
> +                       bond_propose_link_state(slave, BOND_LINK_DOWN);
>                         commit++;
>                 }
>
> @@ -2793,7 +2792,7 @@ static int bond_ab_arp_inspect(struct bo
>                 if (bond_is_active_slave(slave) &&
>                     (!bond_time_in_interval(bond, trans_start, 2) ||
>                      !bond_time_in_interval(bond, last_rx, 2))) {
> -                       slave->new_link = BOND_LINK_DOWN;
> +                       bond_propose_link_state(slave, BOND_LINK_DOWN);
>                         commit++;
>                 }
>         }
> @@ -2813,7 +2812,7 @@ static void bond_ab_arp_commit(struct bo
>         struct slave *slave;
>
>         bond_for_each_slave(bond, slave, iter) {
> -               switch (slave->new_link) {
> +               switch (slave->link_new_state) {
>                 case BOND_LINK_NOCHANGE:
>                         continue;
>
> @@ -2866,7 +2865,7 @@ static void bond_ab_arp_commit(struct bo
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
> @@ -523,7 +522,7 @@ static inline void bond_propose_link_sta
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
