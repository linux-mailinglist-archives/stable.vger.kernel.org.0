Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C4D3CB9DF
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 17:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240361AbhGPPf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 11:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240282AbhGPPfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 11:35:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C328601FC;
        Fri, 16 Jul 2021 15:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626449545;
        bh=4u44g4o4WWvRRIK8ATdu4kvIsQfyneMY613u8yi2+pk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wNSA9m+JXcj3cHMJYy4WSx3bAfTf8riLqqZvAQTdub9wcEpeGBeGWAvCWpy+BMlCJ
         FYxUKlf2BfHiQXr+qgy8bpP34CP4pC5+46sKANA8z2rgG4A/9ED4vpaUjHu9F7xtk3
         UPYGs1AmKfWNVBGzFZXHVpBJVakHATfQGjMLSOWw=
Date:   Fri, 16 Jul 2021 17:32:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Werner Sembach <wse@tuxedocomputers.com>
Cc:     kernel-team@lists.ubuntu.com,
        Mario Limonciello <mario.limonciello@amd.com>,
        Prike Liang <Prike.Liang@amd.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [SRU][H][PATCH v2 1/1] usb: pci-quirks: disable D3cold on xhci
 suspend for s2idle on AMD Renoir
Message-ID: <YPGmhCibWMkMWrvL@kroah.com>
References: <20210716104010.4889-1-wse@tuxedocomputers.com>
 <20210716104010.4889-2-wse@tuxedocomputers.com>
 <YPGAq1zdem2QVTsb@kroah.com>
 <b5ba1134-d557-565c-ba45-556984a66e7b@tuxedocomputers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5ba1134-d557-565c-ba45-556984a66e7b@tuxedocomputers.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 05:12:44PM +0200, Werner Sembach wrote:
> 
> Am 16.07.21 um 14:50 schrieb Greg Kroah-Hartman:
> > On Fri, Jul 16, 2021 at 12:40:10PM +0200, Werner Sembach wrote:
> >> From: Mario Limonciello <mario.limonciello@amd.com>
> >>
> >> BugLink: https://bugs.launchpad.net/bugs/1936583
> >>
> >> The XHCI controller is required to enter D3hot rather than D3cold for AMD
> >> s2idle on this hardware generation.
> >>
> >> Otherwise, the 'Controller Not Ready' (CNR) bit is not being cleared by
> >> host in resume and eventually this results in xhci resume failures during
> >> the s2idle wakeup.
> >>
> >> Link: https://lore.kernel.org/linux-usb/1612527609-7053-1-git-send-email-Prike.Liang@amd.com/
> >> Suggested-by: Prike Liang <Prike.Liang@amd.com>
> >> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> >> Cc: stable <stable@vger.kernel.org> # 5.11+
> >> Link: https://lore.kernel.org/r/20210527154534.8900-1-mario.limonciello@amd.com
> >> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> (cherry picked from commit d1658268e43980c071dbffc3d894f6f6c4b6732a)
> >> Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
> >> ---
> >>  drivers/usb/host/xhci-pci.c | 7 ++++++-
> >>  drivers/usb/host/xhci.h     | 1 +
> >>  2 files changed, 7 insertions(+), 1 deletion(-)
> >>
> > Any reason you resent us a patch that is already in a stable release?
> >
> > And why not just use the stable kernel trees as-is?  Why attempt to
> > cherry-pick random portions of them?
> >
> > thanks,
> >
> > greg k-h
> 
> I didn't add the mailing list as recipent for my last replies so here again:
> 
> I only checked the Ubuntu 5.11 tree where the patch is actually missing.
> 
> The 5.8 kernel has other issues because of outdated amdgpu, that's why we never checked the 5.4 kernel.
> 
> Testing for 5.4: often hangs on boot before display manager shows up
> 
> 5.4 + amdgpu-dkms from here: https://www.amd.com/en/support/kb/release-notes/rn-amdgpu-unified-linux-21-20 : Hang on
> boot issue gone, but does not suspend anymore, and has graphic glitches.
> 
> Should I add these findings to the SRU?

What does any of this have to do with the stable@vger.kernel.org
developers?
