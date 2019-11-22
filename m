Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67989107170
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfKVLdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:33:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:46284 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726563AbfKVLdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:33:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 36C23AF19;
        Fri, 22 Nov 2019 11:33:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 38C16DA898; Fri, 22 Nov 2019 12:33:37 +0100 (CET)
Date:   Fri, 22 Nov 2019 12:33:37 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 071/219] btrfs: Check for missing device
 before bio submission in btrfs_map_bio
Message-ID: <20191122113337.GB3001@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Anand Jain <anand.jain@oracle.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20191122054911.1750-1-sashal@kernel.org>
 <20191122054911.1750-64-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122054911.1750-64-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 12:46:43AM -0500, Sasha Levin wrote:
> From: Nikolay Borisov <nborisov@suse.com>
> 
> [ Upstream commit fc8a168aa9ab1680c2bd52bf9db7c994e0f2524f ]
> 
> Before btrfs_map_bio submits all stripe bios it does a number of checks
> to ensure the device for every stripe is present. However, it doesn't do
> a DEV_STATE_MISSING check, instead this is relegated to the lower level
> btrfs_schedule_bio (in the async submission case, sync submission
> doesn't check DEV_STATE_MISSING at all). Additionally
> btrfs_schedule_bios does the duplicate device->bdev check which has
> already been performed in btrfs_map_bio.
> 
> This patch moves the DEV_STATE_MISSING check in btrfs_map_bio and
> removes the duplicate device->bdev check. Doing so ensures that no bio
> cloning/submission happens for both async/sync requests in the face of
> missing device. This makes the async io submission path slightly shorter
> in terms of instruction count. No functional changes.
                                 ^^^^^^^^^^^^^^^^^^^^^

This should be a strong indication that the patch is not suitable for
autosel/stable, please remove it. Thanks.
