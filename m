Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967C164EBC5
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 14:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiLPNBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 08:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiLPNBa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 08:01:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA7F165BA;
        Fri, 16 Dec 2022 05:01:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB8CB620D5;
        Fri, 16 Dec 2022 13:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6944BC433D2;
        Fri, 16 Dec 2022 13:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671195688;
        bh=hoC8httNwuEgrpw8+PhmGl5xoQeJWslKhGNiJEkT2pg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XiycMFRtJ5teD9KAg2kA2J1E0lqqD2DHa1XrQcLcTZs2eeAW1uUR3TdP467WpvAee
         YLRcLGXmeyh2swnenMQBHGpvwzEdSNfa+dQnZlB+n4IHdlCDWfsti7HQUvyFLV0RuO
         ykIfKHWl7AlcPOubalCB1Qezt+Dax3aQGlI6rPgxoyBaabLxH09ak6q9/XYdn69mBv
         yOYI8vFtJBPvIzBBLxD3JlBApSuo+EacKoTyWPum+oN3UKPQ1v3I+sItcpuC91AE/N
         YtzkJy6PgkYwrk5NXj0JE46tuBCsIp4mzLknaKgZ0aNLe64PPF/yhG3L2Pf/aNo/R0
         8oovAXzrgLkZQ==
Date:   Fri, 16 Dec 2022 13:01:22 +0000
From:   Lee Jones <lee@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     syzbot <syzbot+15cd994e273307bf5cfa@syzkaller.appspotmail.com>,
        adilger.kernel@dilger.ca, gregkh@linuxfoundation.org,
        lczerner@redhat.com, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, sashal@kernel.org,
        stable@vger.kernel.org, syzkaller-android-bugs@googlegroups.com,
        tadeusz.struk@linaro.org
Subject: Re: kernel BUG in ext4_free_blocks (2)
Message-ID: <Y5xsIkpIznpObOJL@google.com>
References: <0000000000006c411605e2f127e5@google.com>
 <000000000000b60c1105efe06dea@google.com>
 <Y5vTyjRX6ZgIYxgj@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y5vTyjRX6ZgIYxgj@mit.edu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Dec 2022, Theodore Ts'o wrote:

> On Thu, Dec 15, 2022 at 08:34:35AM -0800, syzbot wrote:
> > This bug is marked as fixed by commit:
> > ext4: block range must be validated before use in ext4_mb_clear_bb()
> > But I can't find it in any tested tree for more than 90 days.
> > Is it a correct commit? Please update it by replying:
> > #syz fix: exact-commit-title
> > Until then the bug is still considered open and
> > new crashes with the same signature are ignored.
> 
> I don't know what is going on with syzkaller's commit detection, but
> commit 1e1c2b86ef86 ("ext4: block range must be validated before use
> in ext4_mb_clear_bb()") is an exact match for the commit title, and
> it's been in the upstream kernel since v6.0.
> 
> How do we make syzkaller accept this?  I'll try this again, but I
> don't hold out much hope.

I don't see the original bug report (was it posted to a lore
associated list?), so there is no way to tell what branch syzbot was
fuzzing at the time.  My assumption is that it was !Mainline.

Although this does appear to be a Stable candidate, I do not see it
in any of the Stable branches yet.  So I suspect the answer here is to
wait for the fix to filter down.

In the mean time, I guess we should discuss whether syzbot should
really be posting scans of downstream trees to upstream lists.

> #syz fix: ext4: block range must be validated before use in ext4_mb_clear_bb()
> 
> Syzkaller, go home, you're drunk.

=:-)

-- 
Lee Jones [李琼斯]
