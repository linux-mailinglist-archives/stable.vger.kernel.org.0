Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1210B6644B0
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 16:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238997AbjAJP1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 10:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239007AbjAJP0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 10:26:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B488D5EC;
        Tue, 10 Jan 2023 07:26:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7C082CE17D2;
        Tue, 10 Jan 2023 15:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAE2C433F0;
        Tue, 10 Jan 2023 15:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673364368;
        bh=wPYDr4aEMGQ9NqfE0B6l3V9TV8MECSWNXdlhoV8R5nw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lQRiCpUcs31FXkUEtVkGKDqT8xSs4mXg4z9ptGG/uDvvl/sgnskM3ftC2upG7UzEK
         Q5HEOymQQM33ZCCfsun6hCU5gMKuLrfFPiHN5N7lRDAA/JrP1XD4GXJfX1IB7MK6FV
         NQBZjMRLysrDryzXkaDFk+t0wzWJPQwvvmwi/D4Pw0XwQKhr7kVWB7F3CTmofDxVXR
         0oCzuC1g6KQAFS06uKoRGOoFbOEqVtOzhxdPIoKLPZZ6ofHudyEBph2GBaih0gsuzA
         yWvGHvGDdnEhEex38qPJgJctMkySCGMIkAfoS3ZwLa9XAzDtvJnnDFpaDb1+l+ogFa
         +j6otpBqIDo+w==
Date:   Tue, 10 Jan 2023 10:26:07 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     David Sterba <dsterba@suse.cz>
Cc:     Wang Yugui <wangyugui@e16-tech.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: please rebase the patch queue-6.1(btrfs: fix an error handling
 path in btrfs_defrag_leaves)
Message-ID: <Y72Dj4ZbNome2aKJ@sashalap>
References: <20230110123813.7DCC.409509F4@e16-tech.com>
 <Y70aTKUaBOLah8EQ@kroah.com>
 <20230110164234.14C5.409509F4@e16-tech.com>
 <20230110143008.GB11562@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230110143008.GB11562@twin.jikos.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 03:30:08PM +0100, David Sterba wrote:
>On Tue, Jan 10, 2023 at 04:42:35PM +0800, Wang Yugui wrote:
>> Hi,
>>
>> > On Tue, Jan 10, 2023 at 12:38:14PM +0800, Wang Yugui wrote:
>> > > Hi, Sasha Levin
>> > >
>> > > please rebase the patch queue-6.1(btrfs: fix an error handling path in btrfs_defrag_leaves)
>> > > just like queue-6.0, and then drop its 8 depency patches.
>> > >
>> > > the 2 of 8 depency patches are file rename, so it will make later depency patch become
>> > > difficult?
>> > > #btrfs-move-btrfs_get_block_group-helper-out-of-disk-.patch
>> > > #btrfs-move-flush-related-definitions-to-space-info.h.patch
>> > > #btrfs-move-btrfs_print_data_csum_error-into-inode.c.patch
>> > > #btrfs-move-fs-wide-helpers-out-of-ctree.h.patch
>> > > #btrfs-move-assert-helpers-out-of-ctree.h.patch
>> > > #btrfs-move-the-printk-helpers-out-of-ctree.h.patch
>> > > #**btrfs-rename-struct-funcs.c-to-accessors.c.patch
>> > > #**btrfs-rename-tree-defrag.c-to-defrag.c.patch
>> > >
>> > > and the patch(btrfs: fix an error handling path in btrfs_defrag_leaves) is small,
>> > > so a rebase will be a good choice.
>> >
>> > I do not understand, sorry, we can not rebase anything, that's not how
>> > our patch queue works.
>> >
>> > So what exactly do you want to see changed?  What patches dropped?  And
>> > what added?
>>
>> What I suggest:
>>
>> 1)replace queue-6.1/btrfs-fix-an-error-handling-path-in-btrfs_defrag_lea.patch
>>         with queue-6.0/btrfs-fix-an-error-handling-path-in-btrfs_defrag_lea.patch
>>
>> 2) drop pathes in queue-6.1/
>> btrfs-move-btrfs_get_block_group-helper-out-of-disk-.patch
>> btrfs-move-flush-related-definitions-to-space-info.h.patch
>> btrfs-move-btrfs_print_data_csum_error-into-inode.c.patch
>> btrfs-move-fs-wide-helpers-out-of-ctree.h.patch
>> btrfs-move-assert-helpers-out-of-ctree.h.patch
>> btrfs-move-the-printk-helpers-out-of-ctree.h.patch
>> btrfs-rename-struct-funcs.c-to-accessors.c.patch
>> btrfs-rename-tree-defrag.c-to-defrag.c.patch
>
>Right, I'd rather not add all the code moving patches to stable though I
>understand that it could ease backporting. Many stable backports need to
>be adapted to versions before/after the code moves so the work has to be
>done anyway.

Okay, done.

-- 
Thanks,
Sasha
