Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C0436D1CE
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 07:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhD1Fqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 01:46:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhD1Fqy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 01:46:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C27F961418;
        Wed, 28 Apr 2021 05:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619588769;
        bh=/VDtvHwhFQST8D9LLrhTmvCvHyw6KwHubG1UREeHc5c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oe9Q7A0rcssdeczaKRBxU3+g3xro5V2ZdQreJ6gLsWlIsPSBLzMV43YEag19m7Ygx
         X8f/pRNct0DmMh9UGsxOyKMBB6TAX/DO81Y9O1p5VQMAv3AeXz3GIKH1J0/Ay/THS4
         gmtf7aSGbLiwcoXQW9eQ80vvAjYWRD5ZohSoeb98=
Date:   Wed, 28 Apr 2021 07:46:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>,
        Aditya Pakki <pakki001@umn.edu>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 134/190] Revert "md: Fix failed allocation of
 md_register_thread"
Message-ID: <YIj2nsovH/+ujHL0@kroah.com>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-135-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421130105.1226686-135-gregkh@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 03:00:09PM +0200, Greg Kroah-Hartman wrote:
> This reverts commit e406f12dde1a8375d77ea02d91f313fb1a9c6aec.
> 
> Commits from @umn.edu addresses have been found to be submitted in "bad
> faith" to try to test the kernel community's ability to review "known
> malicious" changes.  The result of these submissions can be found in a
> paper published at the 42nd IEEE Symposium on Security and Privacy
> entitled, "Open Source Insecurity: Stealthily Introducing
> Vulnerabilities via Hypocrite Commits" written by Qiushi Wu (University
> of Minnesota) and Kangjie Lu (University of Minnesota).
> 
> Because of this, all submissions from this group must be reverted from
> the kernel tree and will need to be re-reviewed again to determine if
> they actually are a valid fix.  Until that work is complete, remove this
> change to ensure that no problems are being introduced into the
> codebase.
> 
> Cc: stable@vger.kernel.org # v3.16+
> Cc: Guoqing Jiang <gqjiang@suse.com>
> Cc: Aditya Pakki <pakki001@umn.edu>
> Cc: Song Liu <songliubraving@fb.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/md/raid10.c | 2 --
>  drivers/md/raid5.c  | 2 --
>  2 files changed, 4 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index a9ae7d113492..4fec1cdd4207 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3896,8 +3896,6 @@ static int raid10_run(struct mddev *mddev)
>  		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
>  		mddev->sync_thread = md_register_thread(md_do_sync, mddev,
>  							"reshape");
> -		if (!mddev->sync_thread)
> -			goto out_free_conf;
>  	}
>  
>  	return 0;
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 5d57a5bd171f..9b2bd50beee7 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7677,8 +7677,6 @@ static int raid5_run(struct mddev *mddev)
>  		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
>  		mddev->sync_thread = md_register_thread(md_do_sync, mddev,
>  							"reshape");
> -		if (!mddev->sync_thread)
> -			goto abort;
>  	}
>  
>  	/* Ok, everything is just fine now */
> -- 
> 2.31.1
> 

These changes look ok, but the error handling logic seems to be freeing
the incorrect thread, not the one that these functions create.  That's
independant of this change, but seems odd.  If someone cares about it,
it should probably be looked at, or if correct, a comment would be nice
as it's really confusing.

Dropping this revert.

greg k-h
