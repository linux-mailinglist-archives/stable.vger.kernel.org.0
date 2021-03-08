Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E133317D7
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 20:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbhCHTzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 14:55:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231534AbhCHTzX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 14:55:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F4E76525F;
        Mon,  8 Mar 2021 19:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615233322;
        bh=9ywRveD8nNIaS+o07B9zOPt2MAjD36psdj4z02v+qE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H9yYpxrnrkuLqaGXglW44bs/i24Tgsdy9ShSJ5vPUSq0bYkXNIc2k43L5T4yXY15A
         xCI8h6Yd/Lq94iXE9ngmbnMJ+2PRBNDpmgpKOqkU0379DpESJG5lTOoAcdVZoj1dvD
         naM+3cqLLV7q/hmFiRN8srch5+NAVksZlvRaI5O8=
Date:   Mon, 8 Mar 2021 20:55:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     stable@vger.kernel.org, Alexander Lobakin <bloodyreaper@yandex.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH] net: dsa: add GRO support via gro_cells
Message-ID: <YEaBKCkT/Fw/CeXe@kroah.com>
References: <20210308175757.8373-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210308175757.8373-1-pali@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 08, 2021 at 06:57:57PM +0100, Pali Rohár wrote:
> From: Alexander Lobakin <bloodyreaper@yandex.ru>
> 
> commit e131a5634830047923c694b4ce0c3b31745ff01b upstream.
> 
> gro_cells lib is used by different encapsulating netdevices, such as
> geneve, macsec, vxlan etc. to speed up decapsulated traffic processing.
> CPU tag is a sort of "encapsulation", and we can use the same mechs to
> greatly improve overall DSA performance.
> skbs are passed to the GRO layer after removing CPU tags, so we don't
> need any new packet offload types as it was firstly proposed by me in
> the first GRO-over-DSA variant [1].
> 
> The size of struct gro_cells is sizeof(void *), so hot struct
> dsa_slave_priv becomes only 4/8 bytes bigger, and all critical fields
> remain in one 32-byte cacheline.
> The other positive side effect is that drivers for network devices
> that can be shipped as CPU ports of DSA-driven switches can now use
> napi_gro_frags() to pass skbs to kernel. Packets built that way are
> completely non-linear and are likely being dropped without GRO.
> 
> This was tested on to-be-mainlined-soon Ethernet driver that uses
> napi_gro_frags(), and the overall performance was on par with the
> variant from [1], sometimes even better due to minimal overhead.
> net.core.gro_normal_batch tuning may help to push it to the limit
> on particular setups and platforms.
> 
> iperf3 IPoE VLAN NAT TCP forwarding (port1.218 -> port0) setup
> on 1.2 GHz MIPS board:
> 
> 5.7-rc2 baseline:
> 
> [ID]  Interval         Transfer     Bitrate        Retr
> [ 5]  0.00-120.01 sec  9.00 GBytes  644 Mbits/sec  413  sender
> [ 5]  0.00-120.00 sec  8.99 GBytes  644 Mbits/sec       receiver
> 
> Iface      RX packets  TX packets
> eth0       7097731     7097702
> port0      426050      6671829
> port1      6671681     425862
> port1.218  6671677     425851
> 
> With this patch:
> 
> [ID]  Interval         Transfer     Bitrate        Retr
> [ 5]  0.00-120.01 sec  12.2 GBytes  870 Mbits/sec  122  sender
> [ 5]  0.00-120.00 sec  12.2 GBytes  870 Mbits/sec       receiver
> 
> Iface      RX packets  TX packets
> eth0       9474792     9474777
> port0      455200      353288
> port1      9019592     455035
> port1.218  353144      455024
> 
> v2:
>  - Add some performance examples in the commit message;
>  - No functional changes.
> 
> [1] https://lore.kernel.org/netdev/20191230143028.27313-1-alobakin@dlink.ru/
> 
> Signed-off-by: Alexander Lobakin <bloodyreaper@yandex.ru>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> ---
> This patch radically increase network performance on DSA setup.
> 
> Please include this patch into stable releases.
> 
> I have done following tests:
> 
> NAT is a tested Espressobin board (ARM64 Marvell Armada 3720 SoC with
> Marvell 88E6141 DSA switch) which was configured for IPv4 masquerade.
> WAN and LAN are another two static boxes on which was running iperf3.
> 
> 4.19.179 without e131a5634830047923c694b4ce0c3b31745ff01b
> 
> WAN --> NAT --> LAN
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.01  sec   440 MBytes   369 Mbits/sec   12             sender
> [  5]   0.00-10.00  sec   437 MBytes   367 Mbits/sec                  receiver
> 
> WAN <-- NAT <-- LAN
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec   390 MBytes   327 Mbits/sec   90             sender
> [  5]   0.00-10.01  sec   388 MBytes   326 Mbits/sec                  receiver
> 
> 4.19.179 with e131a5634830047923c694b4ce0c3b31745ff01b
> 
> WAN --> NAT --> LAN
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.01  sec   616 MBytes   516 Mbits/sec   18             sender
> [  5]   0.00-10.00  sec   613 MBytes   515 Mbits/sec                  receiver
> 
> WAN <-- NAT <-- LAN
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec   573 MBytes   480 Mbits/sec   32             sender
> [  5]   0.00-10.01  sec   570 MBytes   478 Mbits/sec                  receiver
> 
> 5.4.103 without e131a5634830047923c694b4ce0c3b31745ff01b
> 
> WAN --> NAT --> LAN
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.01  sec   454 MBytes   380 Mbits/sec   62             sender
> [  5]   0.00-10.00  sec   451 MBytes   378 Mbits/sec                  receiver
> 
> WAN <-- NAT <-- LAN
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec   425 MBytes   356 Mbits/sec  155             sender
> [  5]   0.00-10.01  sec   422 MBytes   354 Mbits/sec                  receiver
> 
> 5.4.103 with e131a5634830047923c694b4ce0c3b31745ff01b
> 
> WAN --> NAT --> LAN
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.01  sec   604 MBytes   506 Mbits/sec    8             sender
> [  5]   0.00-10.00  sec   601 MBytes   504 Mbits/sec                  receiver
> 
> WAN <-- NAT <-- LAN
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec   578 MBytes   485 Mbits/sec   79             sender
> [  5]   0.00-10.01  sec   575 MBytes   482 Mbits/sec                  receiver
> ---
>  net/dsa/Kconfig    |  1 +
>  net/dsa/dsa.c      |  2 +-
>  net/dsa/dsa_priv.h |  3 +++
>  net/dsa/slave.c    | 10 +++++++++-
>  4 files changed, 14 insertions(+), 2 deletions(-)

So this patch should be applied to the 4.19 and 5.4 stable queues?
Speed increases like this are always nice to see :)

thanks,

greg k-h
