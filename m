Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CF04EDFF8
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 19:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbiCaR73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 13:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbiCaR72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 13:59:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763442220E2;
        Thu, 31 Mar 2022 10:57:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36E93B82055;
        Thu, 31 Mar 2022 17:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA542C3410F;
        Thu, 31 Mar 2022 17:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648749458;
        bh=Pd8nG9z0Q3DS24pgaW2OH5ERDzXwBcXAArJQBvW+IR8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NV8527sSPkm1hnVw6VVnpKW5cabOMI4XoWbMW5iwZUJmlovW9YIOp4qAhthzhvTF3
         tu5FKaBYkAtUviG2ld1PjnK5HB3/ahc8GiVEpdLHe4StHZ2ZB+k3FeS9pyqY8WpJ4J
         dhG9X8cOxY7GWjdkLbTWgh04rNDoGP6guaKKANupatLCQumMyxxPkvQh2lof2WuPNu
         ZdufnC+3CG/gLwQhba8QujopE/O0gWTuj54kvH+hvQlTdEeEtn9zKGDexYm+i2cDf4
         gvih1fyK+08OknPxpFQrcxUAMFlF5Lz2KQbsx4MmkljFRJ3RJ2Zed7ZrqL8+r7c8eQ
         aauzDc8dm9aog==
Received: by mail-qv1-f49.google.com with SMTP id kd21so169207qvb.6;
        Thu, 31 Mar 2022 10:57:36 -0700 (PDT)
X-Gm-Message-State: AOAM533aXxSrzEC9ahAm3MEcMitVaxMvTHIYrNuy31HrijgHTGhUeTdm
        vEqyyzp/R+cr/q4wbe8JbMbcQIH/kZbMYvH8NBc=
X-Google-Smtp-Source: ABdhPJwEVeLKB7Vs1bxXRXcyvhnkH0USk3DG0DecGzpkX4X6QfinHpsmohMAYHYQCFOhu9OfhkS+0VxRE2hhH54vVbg=
X-Received: by 2002:ad4:5be9:0:b0:441:651c:2d23 with SMTP id
 k9-20020ad45be9000000b00441651c2d23mr5067459qvc.5.1648749455929; Thu, 31 Mar
 2022 10:57:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220328194157.1585642-1-sashal@kernel.org> <20220328194157.1585642-17-sashal@kernel.org>
 <YkLYhad7iX2Bv/j1@debian9.Home> <YkXd9UTuFbNDNjo3@sashalap>
In-Reply-To: <YkXd9UTuFbNDNjo3@sashalap>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 31 Mar 2022 18:57:00 +0100
X-Gmail-Original-Message-ID: <CAL3q7H5x0-7w7udtt3qCGLB=OiRY29EBoj=eJWgDVkShmYOogQ@mail.gmail.com>
Message-ID: <CAL3q7H5x0-7w7udtt3qCGLB=OiRY29EBoj=eJWgDVkShmYOogQ@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.17 17/21] btrfs: reset last_reflink_trans after
 fsyncing inode
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 31, 2022 at 5:59 PM Sasha Levin <sashal@kernel.org> wrote:
>
> On Tue, Mar 29, 2022 at 10:59:33AM +0100, Filipe Manana wrote:
> >On Mon, Mar 28, 2022 at 03:41:52PM -0400, Sasha Levin wrote:
> >> From: Filipe Manana <fdmanana@suse.com>
> >>
> >> [ Upstream commit 23e3337faf73e5bb2610697977e175313d48acb0 ]
> >>
> >> When an inode has a last_reflink_trans matching the current transaction,
> >> we have to take special care when logging its checksums in order to
> >> avoid getting checksum items with overlapping ranges in a log tree,
> >> which could result in missing checksums after log replay (more on that
> >> in the changelogs of commit 40e046acbd2f36 ("Btrfs: fix missing data
> >> checksums after replaying a log tree") and commit e289f03ea79bbc ("btrfs:
> >> fix corrupt log due to concurrent fsync of inodes with shared extents")).
> >> We also need to make sure a full fsync will copy all old file extent
> >> items it finds in modified leaves, because they might have been copied
> >> from some other inode.
> >>
> >> However once we fsync an inode, we don't need to keep paying the price of
> >> that extra special care in future fsyncs done in the same transaction,
> >> unless the inode is used for another reflink operation or the full sync
> >> flag is set on it (truncate, failure to allocate extent maps for holes,
> >> and other exceptional and infrequent cases).
> >>
> >> So after we fsync an inode reset its last_unlink_trans to zero. In case
> >> another reflink happens, we continue to update the last_reflink_trans of
> >> the inode, just as before. Also set last_reflink_trans to the generation
> >> of the last transaction that modified the inode whenever we need to set
> >> the full sync flag on the inode, just like when we need to load an inode
> >> from disk after eviction.
> >>
> >> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> >> Signed-off-by: David Sterba <dsterba@suse.com>
> >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >
> >What's the motivation to backport this to stable?
> >
> >It doesn't fix a bug or any regression, as far as I know at least.
> >Or is it to make some other backport easier?
>
> I wasn't sure if it's needed for completeness for the mentioned fixes,
> so I took it. Can drop it if it's not needed.

Yes, please drop it. It's not needed (nor was intended) to go to any
stable releases.

Thanks.

>
> --
> Thanks,
> Sasha
