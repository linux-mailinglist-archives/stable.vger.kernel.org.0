Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2A7F3AC9F
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 03:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729819AbfFJBKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 21:10:41 -0400
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:48400 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfFJBKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 21:10:41 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id x5A1AUBL030841; Mon, 10 Jun 2019 10:10:30 +0900
X-Iguazu-Qid: 34trJGGSgoJWdfxbTO
X-Iguazu-QSIG: v=2; s=0; t=1560129029; q=34trJGGSgoJWdfxbTO; m=aIrqk9CdBBughxTo19QPF+oC/4yEyVt+H0wlgc4JEC0=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1510) id x5A1ASfc035108;
        Mon, 10 Jun 2019 10:10:29 +0900
Received: from enc01.localdomain ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id x5A1ASBg004576;
        Mon, 10 Jun 2019 10:10:28 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.localdomain  with ESMTP id x5A1AS6h021925;
        Mon, 10 Jun 2019 10:10:28 +0900
Date:   Mon, 10 Jun 2019 10:10:25 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.14 03/35] neighbor: Call __ipv4_neigh_lookup_noref in
 neigh_xmit
X-TSB-HOP: ON
Message-ID: <20190610011024.utn5fft7nocabqxb@toshiba.co.jp>
References: <20190609164125.377368385@linuxfoundation.org>
 <20190609164125.756810906@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609164125.756810906@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sun, Jun 09, 2019 at 06:42:09PM +0200, Greg Kroah-Hartman wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> [ Upstream commit 4b2a2bfeb3f056461a90bd621e8bd7d03fa47f60 ]
> 
> Commit cd9ff4de0107 changed the key for IFF_POINTOPOINT devices to
> INADDR_ANY but neigh_xmit which is used for MPLS encapsulations was not
> updated to use the altered key. The result is that every packet Tx does
> a lookup on the gateway address which does not find an entry, a new one
> is created only to find the existing one in the table right before the
> insert since arp_constructor was updated to reset the primary key. This
> is seen in the allocs and destroys counters:
>     ip -s -4 ntable show | head -10 | grep alloc
> 
> which increase for each packet showing the unnecessary overhread.
> 
> Fix by having neigh_xmit use __ipv4_neigh_lookup_noref for NEIGH_ARP_TABLE.
> 
> Fixes: cd9ff4de0107 ("ipv4: Make neigh lookup keys for loopback/point-to-point devices be INADDR_ANY")
> Reported-by: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Tested-by: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---

This commit also requires the following commit:

commit 9b3040a6aafd7898ece7fc7efcbca71e42aa8069
Author: David Ahern <dsahern@gmail.com>
Date:   Sun May 5 11:16:20 2019 -0700

    ipv4: Define __ipv4_neigh_lookup_noref when CONFIG_INET is disabled

    Define __ipv4_neigh_lookup_noref to return NULL when CONFIG_INET is disabled.

    Fixes: 4b2a2bfeb3f0 ("neighbor: Call __ipv4_neigh_lookup_noref in neigh_xmit")
    Reported-by: kbuild test robot <lkp@intel.com>
    Signed-off-by: David Ahern <dsahern@gmail.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

And this is also necessary for 4.4.y, 4.14.y, 4.19.y and 5.1.y.
Please apply this commit.

Best regards,
  Nobuhiro
