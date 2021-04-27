Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31A336C7F8
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 16:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236226AbhD0OvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 10:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236173AbhD0OvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Apr 2021 10:51:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 667C861178;
        Tue, 27 Apr 2021 14:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619535026;
        bh=iNsvgRE01W7/a9BHsoNdnbgxHY9ecdExpGdDP4iL7C0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yu/TmoXxEoZUArGCSHNfVx6mQFuw1hOr/YNMi0UUf/q6l2PlKMrEgsfmspiAO3Prz
         4pO6cw5oafeuVGefgEgoWvgLCLjyH+wtJ8lzwlHI6yLJo6nrkSQ1rF4lt4VIv/UeGo
         h489k6xxe6Jrfo3/H+eDp/FW+/PWVCdqw7nRjqWY=
Date:   Tue, 27 Apr 2021 16:50:23 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>, "4 . 10+" <stable@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 040/190] Revert "ACPI: CPPC: Fix reference count leak in
 acpi_cppc_processor_probe()"
Message-ID: <YIgkr/swUm/8sjPf@kroah.com>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
 <20210421130105.1226686-41-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421130105.1226686-41-gregkh@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 21, 2021 at 02:58:35PM +0200, Greg Kroah-Hartman wrote:
> This reverts commit 4d8be4bc94f74bb7d096e1c2e44457b530d5a170.
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
> Cc: Qiushi Wu <wu000273@umn.edu>
> Cc: 4.10+ <stable@vger.kernel.org> # 4.10+
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/acpi/cppc_acpi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
> index 69057fcd2c04..42650b34e45e 100644
> --- a/drivers/acpi/cppc_acpi.c
> +++ b/drivers/acpi/cppc_acpi.c
> @@ -830,7 +830,6 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
>  			"acpi_cppc");
>  	if (ret) {
>  		per_cpu(cpc_desc_ptr, pr->id) = NULL;
> -		kobject_put(&cpc_ptr->kobj);
>  		goto out_free;
>  	}
>  
> -- 
> 2.31.1
>

The original change here looks correct, so I will drop this revert from
my tree.

greg k-h
