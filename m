Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF573967A4
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 20:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbhEaSOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 14:14:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:41500 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232116AbhEaSOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 14:14:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1622484777;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=47bCWrIlEB0h/F4JvTXvRhRRxl6Sqwvm4/gxlUlz0Aw=;
        b=Itybkx1s88ghBYpLrfA7zyunNHh9yzYVMhDCVje8JrPo8ngzn6SxNWdSg9JywurCFmP9ql
        YpJf3xpouTtrjAUANGsht/PZyJpKhFAt/rarM+Wod1EDIbdcwQGE4c929tFf5rUghF8d/T
        k/AZgrmzDT78Fw8lB/fX+iSOW1X95uw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1622484777;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=47bCWrIlEB0h/F4JvTXvRhRRxl6Sqwvm4/gxlUlz0Aw=;
        b=5mIdPzbxM6HKiDhr7Wo+tBvnkplDrXRX66I1NhgZHcB6xI/8ZE8wqkT/x2JVRiFbcopEqO
        KboIEJ6n02FNhuDA==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 624D3B9DC;
        Mon, 31 May 2021 18:12:57 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 993A8DA70B; Mon, 31 May 2021 20:10:17 +0200 (CEST)
Date:   Mon, 31 May 2021 20:10:17 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        stable@vger.kernel.org, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v2] btrfs: zoned: fix zone number to sector/physical
 calculation
Message-ID: <20210531181017.GA31483@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        stable@vger.kernel.org, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
References: <20210527062732.2683788-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527062732.2683788-1-naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 27, 2021 at 03:27:32PM +0900, Naohiro Aota wrote:
> In btrfs_get_dev_zone_info(), we have "u32 sb_zone" and calculate "sector_t
> sector" by shifting it. But, this "sector" is calculated in 32bit, leading
> it to be 0 for the 2nd superblock copy.
> 
> Since zone number is u32, shifting it to sector (sector_t) or physical
> address (u64) can easily trigger a missing cast bug like this.
> 
> This commit introduces helpers to convert zone number to sector/LBA, so we
> won't fall into the same pitfall again.
> 
> Fixes: 12659251ca5d ("btrfs: implement log-structured superblock for ZONED mode")
> Cc: stable@vger.kernel.org # 5.11+
> Reported-by: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Added to misc-next, thanks.
