Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACF73E7CEF
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 17:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238831AbhHJP7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 11:59:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236598AbhHJP7y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 11:59:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6275E60EDF;
        Tue, 10 Aug 2021 15:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628611172;
        bh=6RkQphdjckd+qub6KtWUN9S2yyFXyL19GDUrNRmexHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c6kaag/KlN8JjHM0wTc5OBUEnDUdCVTM9N752Dw9VdVerRdGY+BTKn9E/fwixQFTE
         V4x+MRkSAWLo4SNnpgGhJ9cl4hzakfKHFX7L9Cqfm/9+ttNYT/NRTOyHy84LX0oZd4
         cYHmUVe8sZSG/Q7hcKZqGL6raK4NVkHDReOOx915njzEJO3pGaUEwm4CgYIzM86EGG
         gYj5XyNMc8aLt4xkXKY64Zkybs2B5ergNo2DRjsVs6O3ckMM1naaWudpoLP3k2XI0Y
         f+1DKjb7yktTCbv9YRRBcsV3Qbi6RaNSrFtM5Q/4ZIDVFSPs+ZTxOiLVOA+VjOqNav
         ffXp1DLf1ikZQ==
Date:   Tue, 10 Aug 2021 18:59:26 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Mikael Pettersson <mikpelinux@gmail.com>,
        Finn Thain <fthain@linux-m68k.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        stable <stable@vger.kernel.org>, Peter Xu <peterx@redhat.com>
Subject: Re: [BISECTED][REGRESSION] 5.10.56 longterm kernel breakage on
 m68k/aranym
Message-ID: <YRKiXiL4jk6DefMD@kernel.org>
References: <CAM43=SM4KFE8C1ekwiw_kBYZKSwycnTYcbBXfw5OhUn4h=r9YA@mail.gmail.com>
 <31298797-f791-4ac5-cfda-c95d7c7958a4@linux-m68k.org>
 <CAM43=SNV4016i2ByssN9tvXDN6ZyQiYM218_NkrebyPA=p6Rcg@mail.gmail.com>
 <380dd57-4b60-ac9c-508c-826d8ec1b0aa@linux-m68k.org>
 <CAM43=SO03vCzo4LiwSFJyNbWdVXu_wu1gdm5wzi2ArsWShCqqA@mail.gmail.com>
 <CAMuHMdUADRtNrVsJZFdymOoGe8LNEg=x2PtzRVJhh0rcyLpHoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUADRtNrVsJZFdymOoGe8LNEg=x2PtzRVJhh0rcyLpHoQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 09, 2021 at 03:40:04PM +0200, Geert Uytterhoeven wrote:
> CC Mike
> 
> On Mon, Aug 9, 2021 at 3:32 PM Mikael Pettersson <mikpelinux@gmail.com> wrote:
> > On Mon, Aug 9, 2021 at 3:59 AM Finn Thain <fthain@linux-m68k.org> wrote:
> > > On Sun, 8 Aug 2021, Mikael Pettersson wrote:
> > > > On Sun, Aug 8, 2021 at 1:20 AM Finn Thain <fthain@linux-m68k.org> wrote:
> > > > > On Sat, 7 Aug 2021, Mikael Pettersson wrote:
> > > > > > I updated the 5.10 longterm kernel on one of my m68k/aranym VMs from
> > > > > > 5.10.47 to 5.10.56, and the new kernel failed to boot:
> > > > > >
> > > > > > ARAnyM 1.1.0
> > > > > > Using config file: 'aranym1.headless.config'
> > > > > > Could not open joystick 0
> > > > > > ARAnyM RTC Timer: /dev/rtc: Permission denied
> > > > > > ARAnyM LILO: Error loading ramdisk 'root.bin'
> > > > > > Blitter tried to read byte from register ff8a00 at 0077ee
> > > > > >
> > > > > > At this point it kept running, but produced no output to the console,
> > > > > > and would never get to the point of starting user-space. Attaching gdb
> > > > > > to aranym showed nothing interesting, i.e. it seemed to be executing
> > > > > > normally.
> >
> > My initial bisect was wrong. I tried reverting 8f34f1eac382 from
> > 5.10.57 but that made no difference, so I re-ran the git bisect with
> > all known good points pre-marked. This landed on:
> > # first bad commit: [ce6ee46e0f39ed97e23ebf7b5a565e0266a8a1a3]
> > mm/page_alloc: fix memory map initialization for descending nodes
> >
> > Reverting _that_ from 5.10.57 does unbreak that kernel.

Indeed there is a problem with that commit in 5.10. The memmap
initialization relies on availability of zone_to_nid() to link struct page
to a node. But in 5.10 zone_to_nid() is only defined for NUMA, but not for
DISCONTIGMEM.

Mikael, can you please try the patch below:

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9d0c454d23cd..63b550403317 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -445,7 +445,7 @@ struct zone {
 	 */
 	long lowmem_reserve[MAX_NR_ZONES];
 
-#ifdef CONFIG_NUMA
+#ifdef CONFIG_NEED_MULTIPLE_NODES
 	int node;
 #endif
 	struct pglist_data	*zone_pgdat;
@@ -896,7 +896,7 @@ static inline bool populated_zone(struct zone *zone)
 	return zone->present_pages;
 }
 
-#ifdef CONFIG_NUMA
+#ifdef CONFIG_NEED_MULTIPLE_NODES
 static inline int zone_to_nid(struct zone *zone)
 {
 	return zone->node;

-- 
Sincerely yours,
Mike.
