Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB3A21150C4
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 14:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfLFNDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 08:03:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbfLFNDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Dec 2019 08:03:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2591321835;
        Fri,  6 Dec 2019 13:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575637430;
        bh=FzzokkCcsl2DCADaSPwOIroR+3F5YdUB7UOvT1k/t0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=knZBFrdnZxQK9YfYLjhMkJD99VKX+jihYEEYGQOeS09PK4lUz6HiSsTxOP29zLYPZ
         d5NaPkp/R83BBLNEfH/6AmVSaWshlTm7KVtlvu56sdURwpEbfqd870oUGGG6yl7n76
         sdrh/x9Ja+kOzY/6X4QniRNSEU+p33voG2TH3I9c=
Date:   Fri, 6 Dec 2019 14:03:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+7857962b4d45e602b8ad@syzkaller.appspotmail.com
Subject: Re: [PATCH 4.19 242/321] kvm: properly check debugfs dentry before
 using it
Message-ID: <20191206130348.GC1399220@kroah.com>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223439.731003476@linuxfoundation.org>
 <20191205222928.GD25107@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205222928.GD25107@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 05, 2019 at 11:29:28PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > [ Upstream commit 8ed0579c12b2fe56a1fac2f712f58fc26c1dc49b ]
> > 
> > debugfs can now report an error code if something went wrong instead of
> > just NULL.  So if the return value is to be used as a "real" dentry, it
> > needs to be checked if it is an error before dereferencing it.
> > 
> > This is now happening because of ff9fb72bc077 ("debugfs: return error
> > values, not NULL").  syzbot has found a way to trigger multiple debugfs
> > files attempting to be created, which fails, and then the error code
> > gets passed to dentry_path_raw() which obviously does not like it.
> 
> 4.19-stable does not contain patch ff9fb72bc077, so is this still good
> idea? It should not break anything, as it still uses IS_ERR_OR_NULL,
> but...

Yes it should as just testing for NULL was incorrect in the first place.

thanks,

greg k-h
