Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08BD4921E3
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 10:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345183AbiARJEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 04:04:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57526 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233395AbiARJD7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 04:03:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642496637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4cpLiQMcErJzWhIDXR2AnM/EUlXksHxp14JrWbBjQIE=;
        b=WqdKxcr5lT6ivbzdEoiUDIMYa84T4qvryIB5SuwKUN89e0gZsfFwopBty5eY0zIrDh8NVz
        YmM893g5v0VIegSeSvbD+Ed7CRRqcAQMRnwuySyyL1JIcUZkbjRio7UJfpgqWjseAaCA8x
        OPR0dte1m/VOVaOr/MWg1Ca4wkwEth8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-9HdYWgXePzK5ge8P5fcNsA-1; Tue, 18 Jan 2022 04:03:53 -0500
X-MC-Unique: 9HdYWgXePzK5ge8P5fcNsA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFA8610168C0;
        Tue, 18 Jan 2022 09:03:51 +0000 (UTC)
Received: from work (unknown [10.40.194.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BC4CD1F2FA;
        Tue, 18 Jan 2022 09:03:49 +0000 (UTC)
Date:   Tue, 18 Jan 2022 10:03:46 +0100
From:   Lukas Czerner <lczerner@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Laurent GUERBY <laurent@guerby.net>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 116/116] ext4: allow to change
 s_last_trim_minblks via sysfs
Message-ID: <20220118090346.nw4ckd5smuvui2rp@work>
References: <20220118024007.1950576-1-sashal@kernel.org>
 <20220118024007.1950576-116-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118024007.1950576-116-sashal@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Why was this selected? It is a new feature not a fix, it's not marked
for a stable kernel and moreover it's incomplete
(2327fb2e23416cfb2795ccca2f77d4d65925be99 is a prerequisite).

I have the same question for the patches for 5.15 and 5.16.

I think we should either drop it, or at the very least include the above
mentioned commit as well.

Thanks!
-Lukas

On Mon, Jan 17, 2022 at 09:40:07PM -0500, Sasha Levin wrote:
> From: Lukas Czerner <lczerner@redhat.com>
> 
> [ Upstream commit 4a69aecbfb30a3fc85bf8028386c047d5607a97a ]
> 
> Ext4 has an optimization mechanism for batched disacrd (FITRIM) that
> should help speed up subsequent calls of FITRIM ioctl by skipping the
> groups that were previously trimmed. However because the FITRIM allows
> to set the minimum size of an extent to trim, ext4 stores the last
> minimum extent size and only avoids trimming the group if it was
> previously trimmed with minimum extent size equal to, or smaller than
> the current call.
> 
> There is currently no way to bypass the optimization without
> umount/mount cycle. This becomes a problem when the file system is
> live migrated to a different storage, because the optimization will
> prevent possibly useful discard calls to the storage.
> 
> Fix it by exporting the s_last_trim_minblks via sysfs interface which
> will allow us to set the minimum size to the number of blocks larger
> than subsequent FITRIM call, effectively bypassing the optimization.
> 
> By setting the s_last_trim_minblks to ULONG_MAX the optimization will be
> effectively cleared regardless of the previous state, or file system
> configuration.
> 
> For example:
> getconf ULONG_MAX > /sys/fs/ext4/dm-1/last_trim_minblks
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reported-by: Laurent GUERBY <laurent@guerby.net>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Link: https://lore.kernel.org/r/20211103145122.17338-2-lczerner@redhat.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/ext4/sysfs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index f24bef3be48a3..4192b4af10602 100644
> --- a/fs/ext4/sysfs.c
> +++ b/fs/ext4/sysfs.c
> @@ -250,6 +250,7 @@ EXT4_ATTR(last_error_time, 0444, last_error_time);
>  EXT4_ATTR(journal_task, 0444, journal_task);
>  EXT4_RW_ATTR_SBI_UI(mb_prefetch, s_mb_prefetch);
>  EXT4_RW_ATTR_SBI_UI(mb_prefetch_limit, s_mb_prefetch_limit);
> +EXT4_RW_ATTR_SBI_UL(last_trim_minblks, s_last_trim_minblks);
>  
>  static unsigned int old_bump_val = 128;
>  EXT4_ATTR_PTR(max_writeback_mb_bump, 0444, pointer_ui, &old_bump_val);
> @@ -299,6 +300,7 @@ static struct attribute *ext4_attrs[] = {
>  #endif
>  	ATTR_LIST(mb_prefetch),
>  	ATTR_LIST(mb_prefetch_limit),
> +	ATTR_LIST(last_trim_minblks),
>  	NULL,
>  };
>  ATTRIBUTE_GROUPS(ext4);
> -- 
> 2.34.1
> 

