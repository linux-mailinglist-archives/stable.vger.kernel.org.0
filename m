Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13EA3AEDF3
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhFUQYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:24:18 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36386 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhFUQWp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 12:22:45 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id ADB1121A24;
        Mon, 21 Jun 2021 16:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1624292430;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vrjVu6OljszAi074mYeybh+ep3qShXUjjze9/Ly/2ak=;
        b=wG1Two8e3GiYC3eL7/wAkggp2NI4QI8Wcl63tS3uFCDEM+sjz+QZ0XlDkhJtHEVdZFAEf7
        +W9bOHGCbsX8Codd/WPtvz0NQIRCHoi97AD31pn0vimlAELi+n4A35kjeZxXNZ+P+PVNRO
        MtKrHrp8VvwZopeb8U+LPDhDId5Fmr8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1624292430;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vrjVu6OljszAi074mYeybh+ep3qShXUjjze9/Ly/2ak=;
        b=lPp2Oq1NsLIZUzVt7E0vOZ1j0t9am8drsEcKioBplLrFJUX+UQ7p8FVnqHQeTbW9ZEz5bS
        MMTki/RZGRSjsNBQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 7EC01A3BB3;
        Mon, 21 Jun 2021 16:20:30 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4470EDA823; Mon, 21 Jun 2021 18:17:40 +0200 (CEST)
Date:   Mon, 21 Jun 2021 18:17:40 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix unbalanced unlock in qgroup_account_snapshot()
Message-ID: <20210621161740.GB28158@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        stable <stable@vger.kernel.org>
References: <20210621012114.1884779-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621012114.1884779-1-naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 10:21:14AM +0900, Naohiro Aota wrote:
> qgroup_account_snapshot() is trying to unlock the not taken
> tree_log_mutex in a error path. Since ret != 0 in this case, we can
> just return from here.
> 
> Fixes: 2a4d84c11a87 ("btrfs: move delayed ref flushing for qgroup into qgroup helper")
> Cc: stable <stable@vger.kernel.org> # 5.12
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Added to misc-next, thanks.
