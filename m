Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F212E45095C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 17:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhKOQTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 11:19:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232236AbhKOQT2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 11:19:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82C5460F26;
        Mon, 15 Nov 2021 16:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636992993;
        bh=7e+9rZ/xDzKrRii7qIt/dyC4yXmh91QvEb5sm2/oQNU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hX1CLeprqyMN+jI59EhRvbvIVJMDpVFz/sYwmke0uQ8sN3npUqM2fA330uC8D7cL5
         bbMNGb4wRYow8jyFB5iiMdM3NE3ZupXUGtXIIDCDdi9uJCe8+4tqmPkoGiLfEzp2ls
         TWJpDjHYG3RnqC6MKwsmP7qcf6WwfCdvpBo+pqpg=
Date:   Mon, 15 Nov 2021 17:16:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: Re: [PATCH v2] drm/amd/display: Look at firmware version to
 determine using dmub on dcn21
Message-ID: <YZKH3m3znx7FmnDJ@kroah.com>
References: <20211115153655.4870-1-mario.limonciello@amd.com>
 <YZKAs1rxuonK64kN@kroah.com>
 <SA0PR12MB4510EB1DC98B5156F8FCAFA8E2989@SA0PR12MB4510.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA0PR12MB4510EB1DC98B5156F8FCAFA8E2989@SA0PR12MB4510.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 03:47:24PM +0000, Limonciello, Mario wrote:
> [AMD Official Use Only]
> 
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Monday, November 15, 2021 09:46
> > To: Limonciello, Mario <Mario.Limonciello@amd.com>
> > Cc: stable@vger.kernel.org; Deucher, Alexander
> > <Alexander.Deucher@amd.com>
> > Subject: Re: [PATCH v2] drm/amd/display: Look at firmware version to
> > determine using dmub on dcn21
> > 
> > On Mon, Nov 15, 2021 at 09:36:55AM -0600, Mario Limonciello wrote:
> > > commit 91adec9e0709 ("drm/amd/display: Look at firmware version to
> > > determine using dmub on dcn21")
> > >
> > > Newer DMUB firmware on Renoir and Green Sardine do not need to
> > disable
> > > dmcu and this actually causes problems with DP-C alt mode for a number of
> > > machines.
> > >
> > > Backport the fix from this from hand modified backport because mainline
> > > switched to IP version checking which doesn't exist in linux-stable.
> > >
> > > BugLink:
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitla
> > b.freedesktop.org%2Fdrm%2Famd%2F-
> > %2Fissues%2F1772&amp;data=04%7C01%7Cmario.limonciello%40amd.com%
> > 7C6601c50631344fa7148208d9a84f050a%7C3dd8961fe4884e608e11a82d994e1
> > 83d%7C0%7C0%7C637725879609631767%7CUnknown%7CTWFpbGZsb3d8eyJ
> > WIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%
> > 7C3000&amp;sdata=jIGJARLqpAL6Vc6AyK8qVj1yZ7qFm5sXFj%2FerhoMEUc
> > %3D&amp;reserved=0
> > > BugLink:
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitla
> > b.freedesktop.org%2Fdrm%2Famd%2F-
> > %2Fissues%2F1735&amp;data=04%7C01%7Cmario.limonciello%40amd.com%
> > 7C6601c50631344fa7148208d9a84f050a%7C3dd8961fe4884e608e11a82d994e1
> > 83d%7C0%7C0%7C637725879609631767%7CUnknown%7CTWFpbGZsb3d8eyJ
> > WIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%
> > 7C3000&amp;sdata=t8iG0MlBgncmZ5Py%2FhWuWBHMbSCCK%2BtFTV4faxcl
> > N3c%3D&amp;reserved=0
> > > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > > Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> > > ---
> > > Changes from v1->v2:
> > >  * Update commit message syntax for hand modified commit
> > >  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 9 ++++++++-
> > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > What tree(s) are you wanting this backported to?
> 
> 5.13+

Now queued up, thanks.

greg k-h
