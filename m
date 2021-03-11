Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDA433719A
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 12:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhCKLnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 06:43:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232661AbhCKLnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 06:43:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4E6964E66;
        Thu, 11 Mar 2021 11:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615462983;
        bh=SJvUwOgHYeZrMQA2j7jKaS2TCInTiPF4Sz/b8/O4uFo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HZQRWLFPZRkeKZqvA/5rQctnNHPWpIpptJI7//+gEFfvTiKEnEQsm6fB/nze4CJYg
         5EFZGiL3opxdUQMA9WN52YUYWmHeJ3k9Uzb9kGLU52vipIG7FHPNg00tQqqQcOjkAf
         0kh+qHU4SElvJeAb94BKC26XK7OznmTlbyYuCyHU=
Date:   Thu, 11 Mar 2021 12:43:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Joel Becker <jlbec@evilplan.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Daniel Rosenberg <drosen@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] configfs: Fix config_item refcnt error in
 __configfs_open_file()
Message-ID: <YEoCRFiDTool4g3Z@kroah.com>
References: <20210311113510.1031406-1-gregkh@linuxfoundation.org>
 <20210311113940.GA17668@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311113940.GA17668@lst.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 11, 2021 at 12:39:40PM +0100, Christoph Hellwig wrote:
> On Thu, Mar 11, 2021 at 12:35:10PM +0100, gregkh@linuxfoundation.org wrote:
> > From: Daniel Rosenberg <drosen@google.com>
> > 
> > __configfs_open_file() used to use configfs_get_config_item, but changed
> > in commit b0841eefd969 ("configfs: provide exclusion between IO and
> > removals") to just call to_item. The error path still tries to clean up
> > the reference, incorrectly decrementing the ref count.
> 
> This should already be covered by:
> 
> http://git.infradead.org/users/hch/configfs.git/commitdiff/14fbbc8297728e880070f7b077b3301a8c698ef9

Yup, identical patch, sorry I missed that one, hopefully it hits Linus's
tree soon.

thanks,

greg k-h
