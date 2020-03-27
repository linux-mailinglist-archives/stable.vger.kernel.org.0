Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C93819510D
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 07:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbgC0G2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 02:28:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbgC0G2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Mar 2020 02:28:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2727E20705;
        Fri, 27 Mar 2020 06:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585290493;
        bh=bRwgGEY2000N6QzlYVLDl5qvPjTeEzrZxRrzp+VEPRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FnmbPozAtnbMcLw42ZKLPMUtrZG+J7t1QWVH+q97IvH38vjS6RGeH9BxBNoxZsJEg
         a2rn4bfDFegz3wKMakKSE894IsCIsjPkSETG6wfkphdPzoqdh59yM2zny7Ghr21NoN
         c5B0iM/mk6v1aURacglZOmLX8k0PBg2kXkt/Ak6A=
Date:   Fri, 27 Mar 2020 07:28:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, greybus-dev@lists.linaro.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH AUTOSEL 5.5 12/28] staging: greybus: loopback_test: fix
 potential path truncation
Message-ID: <20200327062810.GD1601217@kroah.com>
References: <20200326232357.7516-1-sashal@kernel.org>
 <20200326232357.7516-12-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326232357.7516-12-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 26, 2020 at 07:23:41PM -0400, Sasha Levin wrote:
> From: Johan Hovold <johan@kernel.org>
> 
> [ Upstream commit f16023834863932f95dfad13fac3fc47f77d2f29 ]
> 
> Newer GCC warns about a possible truncation of a generated sysfs path
> name as we're concatenating a directory path with a file name and
> placing the result in a buffer that is half the size of the maximum
> length of the directory path (which is user controlled).
> 
> loopback_test.c: In function 'open_poll_files':
> loopback_test.c:651:31: warning: '%s' directive output may be truncated writing up to 511 bytes into a region of size 255 [-Wformat-truncation=]
>   651 |   snprintf(buf, sizeof(buf), "%s%s", dev->sysfs_entry, "iteration_count");
>       |                               ^~
> loopback_test.c:651:3: note: 'snprintf' output between 16 and 527 bytes into a destination of size 255
>   651 |   snprintf(buf, sizeof(buf), "%s%s", dev->sysfs_entry, "iteration_count");
>       |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fix this by making sure the buffer is large enough the concatenated
> strings.
> 
> Fixes: 6b0658f68786 ("greybus: tools: Add tools directory to greybus repo and add loopback")
> Fixes: 9250c0ee2626 ("greybus: Loopback_test: use poll instead of inotify")
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Link: https://lore.kernel.org/r/20200312110151.22028-3-johan@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/staging/greybus/tools/loopback_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/greybus/tools/loopback_test.c b/drivers/staging/greybus/tools/loopback_test.c
> index ba6f905f26fad..5ce7d6fa086cc 100644
> --- a/drivers/staging/greybus/tools/loopback_test.c
> +++ b/drivers/staging/greybus/tools/loopback_test.c
> @@ -637,7 +637,7 @@ int find_loopback_devices(struct loopback_test *t)
>  static int open_poll_files(struct loopback_test *t)
>  {
>  	struct loopback_device *dev;
> -	char buf[MAX_STR_LEN];
> +	char buf[MAX_SYSFS_PATH + MAX_STR_LEN];
>  	char dummy;
>  	int fds_idx = 0;
>  	int i;
> -- 
> 2.20.1
> 

Already in all stable releases, so no need to add it again.
