Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5872C3B1CF3
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 16:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhFWPAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 11:00:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWPAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 11:00:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 067C9608FE;
        Wed, 23 Jun 2021 14:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624460273;
        bh=jeheCuGhNXjcToQ9e42ec+rI+z83Lj4B9OA/kg03fgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b8eOxJb77rUsjbTf3GLtyfcFDpUlwDEq7+BqMjLdVxWdiEvTgPX/PuTw46m+nlHcb
         t2NfeGApKqUwrXAoEPCZEDv9E194neNysGQCIIfKO7WhGKz5raUkLNIopEAcOWYd4w
         s6+LyYOwUe7j8YWJaChaf4edFrCzpM64rCLSEyNU=
Date:   Wed, 23 Jun 2021 16:57:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     stable@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [4.14.y][PATCH 2/2] unfuck sysfs_mount()
Message-ID: <YNNL7z4IvnFfDOTT@kroah.com>
References: <20210622210622.9925-1-gpiccoli@canonical.com>
 <20210622210622.9925-2-gpiccoli@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210622210622.9925-2-gpiccoli@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 22, 2021 at 06:06:22PM -0300, Guilherme G. Piccoli wrote:
> From: Al Viro <viro@zeniv.linux.org.uk>
> 
> commit 7b745a4e4051e1bbce40e0b1c2cf636c70583aa4 upstream.
> 
> new_sb is left uninitialized in case of early failures in kernfs_mount_ns(),
> and while IS_ERR(root) is true in all such cases, using IS_ERR(root) || !new_sb
> is not a solution - IS_ERR(root) is true in some cases when new_sb is true.
> 
> Make sure new_sb is initialized (and matches the reality) in all cases and
> fix the condition for dropping kobj reference - we want it done precisely
> in those situations where the reference has not been transferred into a new
> super_block instance.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
> ---
> 
> I'd like to protest this patch title heheh
> But I think it's better to keep consistency with upstream. It's the same
> case as patch 1 of the series, no clear reason for its absence in stable.
> Build-tested on x86-64 with defconfig.

Both now queued up, thanks.

greg k-h
