Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E92C29EA09
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 12:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgJ2LHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 07:07:40 -0400
Received: from mailout10.rmx.de ([94.199.88.75]:51655 "EHLO mailout10.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbgJ2LHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 07:07:40 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout10.rmx.de (Postfix) with ESMTPS id 4CMN2K1pDpz312X
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 12:07:37 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CMN263nqyz2TRjV
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 12:07:26 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.83) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 29 Oct
 2020 12:07:19 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Greg KH <greg@kroah.com>
CC:     <stable@vger.kernel.org>, Willem de Bruijn <willemb@google.com>,
        "Deepa Dinamani" <deepa.kernel@gmail.com>
Subject: Re: [PATCH] socket: don't clear SOCK_TSTAMP_NEW when SO_TIMESTAMPNS is disabled
Date:   Thu, 29 Oct 2020 12:07:18 +0100
Message-ID: <14350449.KPx3aKPc1t@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201029110414.GD3840801@kroah.com>
References: <20201027171526.23151-1-ceggers@arri.de> <20201029110414.GD3840801@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.83]
X-RMX-ID: 20201029-120730-4CMN263nqyz2TRjV-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Just after sending the back port yesterday I discovered that stable patches 
related to networking should go via netdev. So I additionally posted it there.

regards
Christian

On Thursday, 29 October 2020, 12:04:14 CET, Greg KH wrote:
> On Tue, Oct 27, 2020 at 06:15:26PM +0100, Christian Eggers wrote:
> > [ Upstream commit 4e3bbb33e6f36e4b05be1b1b9b02e3dd5aaa3e69 ]
> > 
> > SOCK_TSTAMP_NEW (timespec64 instead of timespec) is also used for
> > hardware time stamps (configured via SO_TIMESTAMPING_NEW).
> > 
> > User space (ptp4l) first configures hardware time stamping via
> > SO_TIMESTAMPING_NEW which sets SOCK_TSTAMP_NEW. In the next step, ptp4l
> > disables SO_TIMESTAMPNS(_NEW) (software time stamps), but this must not
> > switch hardware time stamps back to "32 bit mode".
> > 
> > This problem happens on 32 bit platforms were the libc has already
> > switched to struct timespec64 (from SO_TIMExxx_OLD to SO_TIMExxx_NEW
> > socket options). ptp4l complains with "missing timestamp on transmitted
> > peer delay request" because the wrong format is received (and
> > discarded).
> > 
> > Fixes: 887feae36aee ("socket: Add SO_TIMESTAMP[NS]_NEW")
> > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > Acked-by: Willem de Bruijn <willemb@google.com>
> > Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>
> > ---
> > Hi Greg,
> > 
> > I just got your E-mail(s) that this patch has been applied to 5.8 and 5.9.
> > This is a back port for the same problem on 5.4. It does the same as the
> > upstream patch, only the affected code is at another position here. Please
> > decide yourself whether the Acked-by: tags (from the upstream patch)
> > should
> > be kept or removed.
> > 
> > This back port is only required for 5.4, older kernels like 4.19 are not
> > affected.
> > 
> > regards
> > Christian
> 
> Now queued up, thanks.
> 
> greg k-h




