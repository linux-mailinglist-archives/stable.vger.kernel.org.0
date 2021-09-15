Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5812640CC5A
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 20:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhIOSLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 14:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhIOSLG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 14:11:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 235A7611C6;
        Wed, 15 Sep 2021 18:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631729387;
        bh=1Il5af7mztKOfAwvyH4d2bypRKGRV9VZICNB6zMdUOg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YgtSBXPrHRwQvkCuaoHqn0iTgmC3JzAWXDEueFY8o3B5/1uF5A6GBsJjT59hS1nrE
         GmHLFy3uPKAYq4GVYVHd59fyCMwSTg1oQ2My54j7mYmOdH8gzZyxkNbf+HszUvzN2U
         BRu7sxQ8ne1U1MyUG5GLTJZR+5KeybqOkWRF3j68=
Date:   Wed, 15 Sep 2021 20:09:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Alan J. Wylie" <alan@wylie.me.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Regression in posix-cpu-timers.c (was Re: Linux 5.14.4)
Message-ID: <YUI26QI7dfgjUioT@kroah.com>
References: <1631693373201133@kroah.com>
 <87ilz1pwaq.fsf@wylie.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilz1pwaq.fsf@wylie.me.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 06:45:33PM +0100, Alan J. Wylie wrote:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> 
> > I'm announcing the release of the 5.14.4 kernel.
> 
> I'm seeing a regression in 5.14.4
> 
> Running Nextcloud (a PHP web application) with a PostgreSQL backend
> 
> All was fine with 5.14.3
> 
> With 5.14.4, Nextcloud hangs loading events/contacts, etc.
> 
> As well as the web interface hanging, running this command on the command
> line also errors:
> 
> # su apache -s /bin/bash -c "cd /var/www/htdocs/nextcloud/ && php occ maintenance:mode --on"
> PHP Fatal error:  Maximum execution time of 0 seconds exceeded in
> /var/www/htdocs/nextcloud/lib/private/Files/AppData/AppData.php on line 41
> 
> # su apache -s /bin/bash -c "cd /var/www/htdocs/nextcloud/ && php occ maintenance:mode --on"
> PHP Fatal error:  Maximum execution time of 0 seconds exceeded in
> /var/www/htdocs/nextcloud/3rdparty/symfony/console/Application.php on line 65
> 
> # su apache -s /bin/bash -c "cd /var/www/htdocs/nextcloud/ && php occ maintenance:mode --on"
> PHP Fatal error:  Maximum execution time of 0 seconds exceeded in
> /var/www/htdocs/nextcloud/lib/public/Files/SimpleFS/ISimpleRoot.php on line 68
> 
> # su apache -s /bin/bash -c "cd /var/www/htdocs/nextcloud/ && php occ maintenance:mode --on"
> PHP Fatal error:  Maximum execution time of 0 seconds exceeded in
> /var/www/htdocs/nextcloud/apps/theming/lib/ImageManager.php on line 313
> 
> Note that the above commands were all run immediately after each other,
> but showed up in different php scripts.
> 
> Similar errors appear in the Apache log.
> 
> After reverting this commit in 5.14.4, Nextcloud resumed working.
> 
> $ git revert 564005805aadec9cb7e5dc4e14071b8f87cd6b58
> 
> This commit is 406dd42bd1ba0c01babf9cde169bb319e52f6147 in Linus's tree

Thanks for bisecting this down.

Does 5.15-rc1 also fail in this same way, or does it work ok?

thanks,

greg k-h
