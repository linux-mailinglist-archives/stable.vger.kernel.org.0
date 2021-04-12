Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185C135BB8A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbhDLIBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:01:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230034AbhDLIBx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:01:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D04860231;
        Mon, 12 Apr 2021 08:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618214496;
        bh=lQJ5xOkKaQ0nfBE12zDwupltjDzg5ecLmKM8bCo/Gpg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LYhpkn8gAU+PZMIQ2Si0Wo2sWgmdOxK55tbjwyYs7w8R6pLiO4RojXh9LnSjo2Qg8
         mq5G1dh4oluDs0xyK9BG8pIC8kHm3zG5FPvubUF/1ubhMZH+qdYDGAlUwZTINC628R
         xOJPKcvzNrZYhCnLrt0HUjVs+dKfZgqM5M+kDyMc=
Date:   Mon, 12 Apr 2021 10:01:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Shyam Prasad <Shyam.Prasad@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Message-ID: <YHP+XbVWfGv21EL1@kroah.com>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161032.337414143@linuxfoundation.org>
 <YGxIMCsclG4E1/ck@eldamar.lan>
 <YGxlJXv/+IPaErUr@kroah.com>
 <PSAP153MB04220682838AC9D025414B6094769@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YGx3u01Wa/DDnjlV@eldamar.lan>
 <YG7r0UaivWZL762N@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YG7r0UaivWZL762N@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 08, 2021 at 01:41:05PM +0200, Salvatore Bonaccorso wrote:
> Hi Shyam,
> 
> On Tue, Apr 06, 2021 at 05:01:17PM +0200, Salvatore Bonaccorso wrote:
> > Hi,
> > 
> > On Tue, Apr 06, 2021 at 02:00:48PM +0000, Shyam Prasad wrote:
> > > Hi Greg,
> > > We'll need to debug this further to understand what's going on. 
> > 
> > Greg asked it the same happens with 5.4 as well, I do not know I was
> > not able to test 5.4.y (yet) but only 5.10.y and 4.19.y.
> > > 
> > > Hi Salvatore,
> > > Any chance that you'll be able to provide us the cifsFYI logs from the time of mount failure?
> > > https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Enabling_Debugging
> > 
> > Please find it attached. Is this enough information?
> > 
> > The mentioned home DFS link 'home' is a DFS link to
> > msdfs:SECONDHOST\REDACTED on a Samba host.
> > 
> > The mount is triggered as
> > 
> > mount -t cifs //HOSTIP/REDACTED/home /mnt --verbose -o username='REDACTED,domain=DOMAIN'
> 
> So I can confirm the issue is both present in 4.19.185 and 5.4.110
> upstream (without any Debian patches applied, we do not anyway apply
> any cifs related one on top of the respetive upstream version).
> 
> The issue is not present in 5.10.28.
> 
> So I think there are commits as dependency of a738c93fb1c1 ("cifs: Set
> CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.") which
> are required and not applied in the released before 5.10.y which make
> introducing the regression.

Ok, I've dropped this from 5.4 and older kernel trees now, thanks for
the report.

greg k-h
