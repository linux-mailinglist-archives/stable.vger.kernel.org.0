Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0433ADA17
	for <lists+stable@lfdr.de>; Sat, 19 Jun 2021 15:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbhFSNJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Jun 2021 09:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbhFSNJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Jun 2021 09:09:12 -0400
Received: from puleglot.ru (puleglot.ru [IPv6:2a01:4f8:1c0c:58e8::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4D0C061574;
        Sat, 19 Jun 2021 06:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tsoy.me;
        s=mymail; h=Sender:Content-Transfer-Encoding:MIME-Version:Content-Type:
        References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=OsnWsRjwnHPvLI6iAW6jBpN6mbJOj8Z4vbPIXcuZ2g8=; b=UqnuNDzUWHD7usUJe33RmQSv/Q
        ZgqHAxd9IcFaXlM8Z7Wu9fKhivX/F3SKNy1L2a/aKHfy9mNfwwRSArzvDGVWo8eLjRhjH8yFGkU9R
        9NEFtK4+9AtdKg+ILurevpelURhELJ18uEHGLZe1JRckVaP2QR64MSLn77gt4dO+V0jc=;
Received: from [2a00:1370:8125:af50::b41]
        by puleglot.ru with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <puleglot@puleglot.ru>)
        id 1luagX-0003Vu-PK; Sat, 19 Jun 2021 16:06:53 +0300
Message-ID: <bf18424cbc50fe0d8824557703f38b9888192475.camel@tsoy.me>
Subject: Re: [PATCH 5.10 35/38] rtnetlink: Fix missing error code in
 rtnl_bridge_notify()
From:   Alexander Tsoy <alexander@tsoy.me>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Date:   Sat, 19 Jun 2021 16:06:50 +0300
In-Reply-To: <YM2SpRA5lgMNP1W3@kroah.com>
References: <20210616152835.407925718@linuxfoundation.org>
         <20210616152836.507544876@linuxfoundation.org>
         <fb24ef9ad94f8b052407c5bdd4e3815675b89213.camel@tsoy.me>
         <YM2SpRA5lgMNP1W3@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: puleglot@puleglot.ru
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

В Сб, 19/06/2021 в 08:45 +0200, Greg Kroah-Hartman пишет:
> On Sat, Jun 19, 2021 at 02:58:28AM +0300, Alexander Tsoy wrote:
> > В Ср, 16/06/2021 в 17:33 +0200, Greg Kroah-Hartman пишет:
> > > From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> > > 
> > > [ Upstream commit a8db57c1d285c758adc7fb43d6e2bad2554106e1 ]
> > > 
> > > The error code is missing in this code scenario, add the error code
> > > '-EINVAL' to the return value 'err'.
> > > 
> > > Eliminate the follow smatch warning:
> > > 
> > > net/core/rtnetlink.c:4834 rtnl_bridge_notify() warn: missing error
> > > code
> > > 'err'.
> > 
> > This patch breaks systemd-resolved. It is 100% reproducible on two of
> > my systems, but there are also systems where I cannot reproduce it.
> > The
> > problem manifests itself as SERVFAIL on every DNS query.
> > 
> > Just reverting this patch from 5.10.45 fixes the problem for me.
> 
> Is Linus's tree also broken for you?  It should be reverted there
> first.

Looks like this patch was reverted in Linus's tree:
d2e381c4963663bca6f30c3b996fa4dbafe8fcb5 (rtnetlink: Fix regression in
bridge VLAN configuration)


Also after some investigation I think my problem was actually with
NetworkManager as systemd-networkd + systemd-resolved works fine.

$ grep ^dns /etc/NetworkManager/NetworkManager.conf 
dns=systemd-resolved

with this patch:

$ resolvectl
...
Link 4 (eno1)
Current Scopes: none
     Protocols: +DefaultRoute +LLMNR -mDNS -DNSOverTLS
DNSSEC=no/unsupported
   DNS Servers: 192.168.1.1 fd9f:5696:250c::1
    DNS Domain: lan

with this patch reverted:

$ resolvectl
...
Link 4 (eno1)
    Current Scopes: DNS LLMNR/IPv4 LLMNR/IPv6
         Protocols: +DefaultRoute +LLMNR -mDNS -DNSOverTLS
DNSSEC=no/unsupported
Current DNS Server: 192.168.1.1
       DNS Servers: 192.168.1.1 fd9f:5696:250c::1
        DNS Domain: lan

