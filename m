Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3E9370424
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 01:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbhD3Xk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 19:40:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:40618 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230508AbhD3Xk7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 19:40:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CE488B24C;
        Fri, 30 Apr 2021 23:40:06 +0000 (UTC)
Date:   Sat, 1 May 2021 01:40:05 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, aaptel@suse.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] cifs: fix regression when mounting shares with prefix
 paths
Message-ID: <20210501014005.41545d44@suse.de>
In-Reply-To: <20210430221621.7497-1-pc@cjr.nz>
References: <20210430221621.7497-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 30 Apr 2021 19:16:21 -0300, Paulo Alcantara wrote:

> The commit 315db9a05b7a ("cifs: fix leak in cifs_smb3_do_mount() ctx")
> revealed an existing bug when mounting shares that contain a prefix
> path or DFS links.

Sorry for the mess. One question...

...
>  	if (mntopts) {
>  		char *ip;
>  
> -		cifs_dbg(FYI, "%s: mntopts=%s\n", __func__, mntopts);
>  		rc = smb3_parse_opt(mntopts, "ip", &ip);
> -		if (!rc && !cifs_convert_address((struct sockaddr *)&ctx->dstaddr, ip,
> -						 strlen(ip))) {
> -			cifs_dbg(VFS, "%s: failed to convert ip address\n", __func__);
> -			return -EINVAL;
> +		if (!rc) {
> +			rc = cifs_convert_address((struct sockaddr *)&ctx->dstaddr, ip, strlen(ip));
> +			kfree(ip);
> +			if (!rc) {
> +				cifs_dbg(VFS, "%s: failed to convert ip address\n", __func__);
> +				return -EINVAL;
> +			}
>  		}
>  	}
>  
> @@ -3189,7 +3198,7 @@ cifs_setup_volume_info(struct smb3_fs_context *ctx, const char *mntopts, const c
>  		return -EINVAL;
>  	}
>  
> -	return rc;
> +	return 0;
>  }

It seems that smb3_parse_opt() errors will no longer be propagated here.
Is that intentional?

Cheers, David
