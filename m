Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDF532439C
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 19:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbhBXSMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 13:12:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:41174 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233732AbhBXSM0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 13:12:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1FFF7AAAE;
        Wed, 24 Feb 2021 18:11:42 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 50A29DA7B0; Wed, 24 Feb 2021 19:09:42 +0100 (CET)
Date:   Wed, 24 Feb 2021 19:09:42 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 54/67] btrfs: make
 btrfs_start_delalloc_root's nr argument a long
Message-ID: <20210224180942.GZ1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210224125026.481804-1-sashal@kernel.org>
 <20210224125026.481804-54-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224125026.481804-54-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 07:50:12AM -0500, Sasha Levin wrote:
> From: Nikolay Borisov <nborisov@suse.com>
> 
> [ Upstream commit 9db4dc241e87fccd8301357d5ef908f40b50f2e3 ]
> 
> It's currently u64 which gets instantly translated either to LONG_MAX
> (if U64_MAX is passed) or cast to an unsigned long (which is in fact,
> wrong because writeback_control::nr_to_write is a signed, long type).
> 
> Just convert the function's argument to be long time which obviates the
> need to manually convert u64 value to a long. Adjust all call sites
> which pass U64_MAX to pass LONG_MAX. Finally ensure that in
> shrink_delalloc the u64 is converted to a long without overflowing,
> resulting in a negative number.

This patch is a cleanup and I don't see any other patch depend on it, so
please drop it from autosel.
