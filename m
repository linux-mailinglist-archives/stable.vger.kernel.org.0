Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115AF377D63
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 09:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhEJHrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 03:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhEJHrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 03:47:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0D4D6112F;
        Mon, 10 May 2021 07:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620632772;
        bh=gUYJxsLCToreCgBACfi76iqMzXU4C+HzFNCr/DPbTiA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cgMUfS70HCFT60bypbzxQKGg/Ph1P3q6xdnnAwFsshIME4nWhzeC5gc8fN7/CjR07
         Dltk5IawRFC/LH/oBpuQTmeWRqtbc4IUGCxLKxq5Gi49hYqK9HC0ElEPchfMUDlm5d
         HSzBTV8Ud8n0NVqIA92ux5S1coWDQbIxcYZ5FXYg=
Date:   Mon, 10 May 2021 09:46:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Shyam Prasad <Shyam.Prasad@microsoft.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>,
        Paulo Alcantara <palcantara@suse.de>, pc <pc@cjr.nz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Message-ID: <YJjkwdiGSdV6U4HO@kroah.com>
References: <YGx3u01Wa/DDnjlV@eldamar.lan>
 <YG7r0UaivWZL762N@eldamar.lan>
 <YHP+XbVWfGv21EL1@kroah.com>
 <YHwo5prs4MbXEzER@eldamar.lan>
 <PSAP153MB04224202F4A2BE668533F94794499@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YH25PZn5Eb3qC6JA@eldamar.lan>
 <PSAP153MB04225D77E22AFC17C4AEA52E94469@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YIJ6a77TVaZGzQIg@kroah.com>
 <YJaQlVyFoUHyxHM/@eldamar.lan>
 <KL1P15301MB0343C783FAA171868E45619C94559@KL1P15301MB0343.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <KL1P15301MB0343C783FAA171868E45619C94559@KL1P15301MB0343.APCP153.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A: http://en.wikipedia.org/wiki/Top_post
Q: Were do I find info about this thing called top-posting?
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Sun, May 09, 2021 at 10:16:06AM +0000, Shyam Prasad wrote:
> Hi Salvatore,
> 
> Thanks for reminding me. I had to do some reading to reply to this one. 
> The situation right now is this:
> The patch "cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath." has been reverted. Which means that the DFS bug which you originally faced will not be seen. 
> 
> Hi Greg,
> 
> Here are the two patches which I'm referring to:
> 1. cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.12&id=a738c93fb1c17e386a09304b517b1c6b2a6a5a8b
> This fixed an issue when two cifs mount points shared a common prefix in the path which they mounted from the same server. The patch was marked for CC:stable considering that this fix can be important for some users.
> However, there was a dependent change for DFS scenario, which is present in the Linus' mainline tree, but were not marked for CC:stable, so missing from the stable trees.
> Due to the missing dependent changes, DFS users faced issues with pre-5.11 kernels, and this patch was reverted in the stable trees.

So, you need that a738c93fb1c1 ("cifs: Set CIFS_MOUNT_USE_PREFIX_PATH
flag on setting cifs_sb->prepath.") merged to where exactly?

> 2. Due to a major change that went into the 5.11 kernel (the new mount API support), the code differs significantly, and the missing patch cannot be applied to pre-5.11 trees.
> Hence, Paulo submitted the attached patch (cifs: fix prefix path in dfs mounts), which fixes this for pre-5.11 kernels.

Can you submit this in a proper format (i.e. not dos line ends, and good
changelog and most importantly, YOUR signed off by on it saying that the
patch came through you?

Make this a 2 patch series please, and be specific as to what tree(s)
this needs to be backported to, and I will be glad to review it.

thnaks,

greg k-h
