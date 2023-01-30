Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418C1680A6D
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 11:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236031AbjA3KIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 05:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236113AbjA3KIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 05:08:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4965B86
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 02:07:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21DDCB80EBC
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 10:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DFDC433EF;
        Mon, 30 Jan 2023 10:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675073276;
        bh=IkGQGg5IjHJDEcQbWglzKWCTGxMC8TMcAub7fajHLIY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nCF2MM5c7rtzAOhyhTlRgjRkxxqlpXPnHVk8cS54XSLoWPVqQmjmvDHW2PvMsLIui
         0QkGVhq/rx0SDake9oZ0MFEnacBX7HNwQCM100dWz4Vv9nC4clvh6omIKxH1kKNI2Y
         zg4rrKvTPbJ86U62EeZTgZJn19xsY3w26FlUrq0Y=
Date:   Mon, 30 Jan 2023 11:07:53 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oleksandr Tymoshenko <ovt@google.com>
Cc:     stable@vger.kernel.org, Baokun Li <libaokun1@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        stable@kernel.org, Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5.15 1/1] ext4: fix bad checksum after online resize
Message-ID: <Y9eW+QZmt14x2GXJ@kroah.com>
References: <20230124090632.4185289-1-ovt@google.com>
 <20230124090632.4185289-2-ovt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124090632.4185289-2-ovt@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 24, 2023 at 09:06:32AM +0000, Oleksandr Tymoshenko wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> commit a408f33e895e455f16cf964cb5cd4979b658db7b upstream.
> 
> When online resizing is performed twice consecutively, the error message
> "Superblock checksum does not match superblock" is displayed for the
> second time. Here's the reproducer:
> 
> 	mkfs.ext4 -F /dev/sdb 100M
> 	mount /dev/sdb /tmp/test
> 	resize2fs /dev/sdb 5G
> 	resize2fs /dev/sdb 6G
> 
> To solve this issue, we moved the update of the checksum after the
> es->s_overhead_clusters is updated.
> 
> Fixes: 026d0d27c488 ("ext4: reduce computation of overhead during resize")
> Fixes: de394a86658f ("ext4: update s_overhead_clusters in the superblock during an on-line resize")
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Cc: stable@kernel.org
> Link: https://lore.kernel.org/r/20221117040341.1380702-2-libaokun1@huawei.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Any reason you forwarded on a modified patch and did not sign off on it
yourself?  Please fix that up and send it again.

thanks,

greg k-h
