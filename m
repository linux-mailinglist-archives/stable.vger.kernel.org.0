Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F21815C833
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgBMQ1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:27:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbgBMQ1X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 11:27:23 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEF15217F4;
        Thu, 13 Feb 2020 16:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581611242;
        bh=pLlFbwgpXzZyUY0PLcmwiWVBzwZX/BtaXYVlyDM6gsk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZmX16Ia7+5e3L+ZUm9mPSymTnV7oOXSuaN1yWcAtFXaEtcJWvw8sU/kzmHj1dlMP1
         TLwjDC9pDFDJvQvrgAVp5/QE26IWna9gLEPhm28MhfGkXEZJz+wnKcyLieqm9LghKD
         7F3UvPHPPJVDaLDx0A/5p9hCEDUV/ECTY6kEw/iA=
Date:   Thu, 13 Feb 2020 08:27:21 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Will Deacon <will@kernel.org>, Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH 5.4 85/96] selinux: revert "stop passing MAY_NOT_BLOCK to
 the AVC upon follow_link"
Message-ID: <20200213162721.GA3636914@kroah.com>
References: <20200213151839.156309910@linuxfoundation.org>
 <20200213151911.147099125@linuxfoundation.org>
 <b481f512-d4dd-1c04-f39f-0ba271193d0a@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b481f512-d4dd-1c04-f39f-0ba271193d0a@tycho.nsa.gov>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 11:01:41AM -0500, Stephen Smalley wrote:
> On 2/13/20 10:21 AM, Greg Kroah-Hartman wrote:
> > From: Stephen Smalley <sds@tycho.nsa.gov>
> > 
> > commit 1a37079c236d55fb31ebbf4b59945dab8ec8764c upstream.
> > 
> > This reverts commit e46e01eebbbc ("selinux: stop passing MAY_NOT_BLOCK
> > to the AVC upon follow_link"). The correct fix is to instead fall
> > back to ref-walk if audit is required irrespective of the specific
> > audit data type.  This is done in the next commit.
> > 
> > Fixes: e46e01eebbbc ("selinux: stop passing MAY_NOT_BLOCK to the AVC upon follow_link")
> > Reported-by: Will Deacon <will@kernel.org>
> > Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This patch should be accompanied by commit
> 0188d5c025ca8fe756ba3193bd7d150139af5a88 ("selinux: fall back to ref-walk if
> audit is required").  The former is reverting an incorrect fix for
> bda0be7ad994 ("security: make inode_follow_link RCU-walk aware"), the latter
> is providing the correct fix for it.

Thanks for letting me know, now queued up for both trees.

greg k-h
