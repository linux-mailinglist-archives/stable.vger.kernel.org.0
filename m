Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369433AAF86
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 11:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhFQJSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 05:18:34 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57216 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbhFQJSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 05:18:32 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5D38C21A9B;
        Thu, 17 Jun 2021 09:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623921383;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o2IFaG1pJ+KKCA6UI+uIfNqPeRkZ6u1ke0NxbG0u2PA=;
        b=kRg53xvmMb7G4t/ZLSHjzynum3+a6QeI+YkGKmEzK+GX+Fi2C4GsnTEEsPQu8iXWbVF8EK
        8pVN0R1NR7i27f3DLfaIxEeXfThQVcuMV6PNdZt0WfyeG6SuVMYcctqccypQQx5PYUn+cE
        URNpLc5i4cjy5BENGd3KxF2mrKqUYQ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623921383;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o2IFaG1pJ+KKCA6UI+uIfNqPeRkZ6u1ke0NxbG0u2PA=;
        b=i/U5/IGTVkfQF1q36uyc5GHtJc9aWDNpBu/OGSVBs2SXYN43DWmWkekbFO5pSIM+EUf3nP
        bPHMjEYTu9a5PnAw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 3116BA3BB9;
        Thu, 17 Jun 2021 09:16:23 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1D38FDB225; Thu, 17 Jun 2021 11:13:35 +0200 (CEST)
Date:   Thu, 17 Jun 2021 11:13:34 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix negative space_info->bytes_readonly
Message-ID: <20210617091334.GU28158@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        stable@vger.kernel.org
References: <20210617045618.1179079-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617045618.1179079-1-naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 17, 2021 at 01:56:18PM +0900, Naohiro Aota wrote:
> Consider we have a using block group on zoned btrfs.
> 
> |<- ZU ->|<- used ->|<---free--->|
>                      `- Alloc offset
> ZU: Zone unusable
> 
> Marking the block group read-only will migrate the zone unusable bytes
> to the read-only bytes. So, we will have this.
> 
> |<- RO ->|<- used ->|<--- RO --->|
> RO: Read only
> 
> When marking it back to read-write, btrfs_dec_block_group_ro()
> subtracts the above "RO" bytes from the
> space_info->bytes_readonly. And, it moves the zone unusable bytes back
> and again subtracts those bytes from the space_info->bytes_readonly,
> leading to negative bytes_readonly.
> 
> This commit fixes the issue by reordering the operations.
> 
> Link: https://github.com/naota/linux/issues/37

I've copied the 'fi df' output to changelog.

> Fixes: 169e0da91a21 ("btrfs: zoned: track unusable bytes for zones")
> Cc: stable@vger.kernel.org # 5.12+
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Added to misc-next, thanks.
