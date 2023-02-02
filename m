Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B29F6873A3
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 04:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjBBDHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 22:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjBBDHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 22:07:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C49F9
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 19:07:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 291EFB823CD
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 03:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA589C433EF;
        Thu,  2 Feb 2023 03:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675307254;
        bh=1hKt+yKUDjHDjtKbIC+UgrMpPGDJAvIDKOWoYHfjiHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=seppIWRfxbKqmVgki6q354YActngRAnKpkKI75ClChixAeS3UI9Lh2lA3I7HT+Jy8
         qVJmUAh3nhiYcW9MwXlhWzolMeGV0+WHhYcSnSzFgt/lkGMyFpYeHL0km8OBjDOsVb
         QgxG/2pViwmImLjDYOocIOpCDsFMdC740iFYswBxU5a92RYzSFLj2bJpGl0i16xwI+
         zgJVIjwnR7mIdkAKYtCD8Y2fQ6GUXGzCngOxzaL+9kOlbeigkdaMCZUiDHwUJXuCZI
         ldvE1d2eGeNOpQqpbq1XIFgcoElIhFSkC1N+J5T8DhSLxq6f13eADSn9Bte/uoptrL
         xeZJlZgsLuVWw==
Date:   Wed, 1 Feb 2023 22:07:33 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Oleksandr Tymoshenko <ovt@google.com>
Cc:     stable@vger.kernel.org, Baokun Li <libaokun1@huawei.com>,
        "Darrick J . Wong" <djwong@kernel.org>, Jan Kara <jack@suse.cz>,
        stable@kernel.org, Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5.15 v2 1/1] ext4: fix bad checksum after online resize
Message-ID: <Y9so9dguyVJ83Mdc@sashalap>
References: <20230130235212.698665-1-ovt@google.com>
 <20230130235212.698665-2-ovt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230130235212.698665-2-ovt@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 30, 2023 at 11:52:12PM +0000, Oleksandr Tymoshenko wrote:
>From: Baokun Li <libaokun1@huawei.com>
>
>commit a408f33e895e455f16cf964cb5cd4979b658db7b upstream.
>
>When online resizing is performed twice consecutively, the error message
>"Superblock checksum does not match superblock" is displayed for the
>second time. Here's the reproducer:
>
>	mkfs.ext4 -F /dev/sdb 100M
>	mount /dev/sdb /tmp/test
>	resize2fs /dev/sdb 5G
>	resize2fs /dev/sdb 6G
>
>To solve this issue, we moved the update of the checksum after the
>es->s_overhead_clusters is updated.
>
>Fixes: 026d0d27c488 ("ext4: reduce computation of overhead during resize")
>Fixes: de394a86658f ("ext4: update s_overhead_clusters in the superblock during an on-line resize")
>Signed-off-by: Baokun Li <libaokun1@huawei.com>
>Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>Reviewed-by: Jan Kara <jack@suse.cz>
>Cc: stable@kernel.org
>Link: https://lore.kernel.org/r/20221117040341.1380702-2-libaokun1@huawei.com
>Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>

I've grabbed it, thanks!

-- 
Thanks,
Sasha
