Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A5660990F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 06:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiJXEH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 00:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiJXEHZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 00:07:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B468D6AA36
        for <stable@vger.kernel.org>; Sun, 23 Oct 2022 21:07:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AFF760FDA
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 04:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC74C433C1;
        Mon, 24 Oct 2022 04:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666584443;
        bh=HXyirKWpIXHQOUqXQWHR/9Al/NkActGtP1/nW2uMm44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M8Tgd2tKuHU/biicgtFRwaZqqe+DypetGVHIlAELY0kVYM7iB39TjJjK47M6hPyWH
         pL2O+AVDvaR+0qGq/WTQXIsog3h2n9dFdtDCf4Xgfms54HrbKycaMws1h8dHKXKyTr
         WuVGn31HLLo2ed1LqqXhr8M6jZnC0BX207qlcGuo=
Date:   Mon, 24 Oct 2022 06:08:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     James Smart <jsmart2021@gmail.com>
Cc:     Sasha Levin <alexander.levin@microsoft.com>,
        stable <stable@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Justin Tee <justintee8345@gmail.com>
Subject: Re: LTS 5.15 and state of lpfc
Message-ID: <Y1YPrvniFIaO/jzJ@kroah.com>
References: <cdc7d1cf-3ad2-c2d2-8006-22bf51f8df4a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cdc7d1cf-3ad2-c2d2-8006-22bf51f8df4a@gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 23, 2022 at 07:25:05PM -0700, James Smart wrote:
> Greg, Sasha,
> 
> We were notified of an lpfc issue in the LTS 5.15 kernel. Its a pretty
> fundamental error that keeps us from connecting to the FC switch.
> 
> In the past several kernel releases, we have been reworking areas of the
> driver to fix issues in the broader design rather than continuing to create
> a patchwork on an issue-by-issue basis. This means there are a lot of
> inter-related patches.
> 
> In this case, it appears that a portion of the "path split" rework was
> pulled into 5.15, and the portion that wasn't picked up introduced the
> error.
> 
> I had Justin look at simply reverting patches, which wasn't too bad, but we
> have identified an issue in the result. The fix, of course, is embedded into
> the "path split" patches.
> 
> I don't think we want to create one-off patches that won't move forward, so
> I had him look at rolling forward to pick up all the "path split" patches.
> This looks like a fairly viable alternative.  The steps are listed below.
> This brings it up to a point that is pretty close to the content in 5.18.y
> 
> How do we best resolve this in the 5.15 LTS tree ?
> 
> -- james
> 
> 
> 
> Here are the steps to roll-forward:
> 
> 
> 1.) git remote add -t 6.1/scsi-staging mkp-scsi
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
> 2.) git fetch mkp-scsi
> 3.) git rebase -i 1c5e670d6a5a~

What will the rebase -i do?

> 
> 4.) Remove the following commits:
> 1c5e670d6a5a scsi: lpfc: SLI path split: Refactor lpfc_iocbq
> c56cc7fefc31 scsi: lpfc: SLI path split: Refactor fast and slow paths to
> native SLI4
> b4543dbea84c scsi: lpfc: SLI path split: Refactor SCSI paths
> 2b5ef6430c21 scsi: lpfc: Remove extra atomic_inc on cmd_pending in
> queuecommand after VMID
> 9a570069cdbb scsi: lpfc: Fix locking for lpfc_sli_iocbq_lookup()
> 6e99860de6f4 scsi: lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()
> 17bf429b913b scsi: lpfc: Resolve some cleanup issues following SLI path
> refactoring
> 
> Rebase is expected to be clean after removal of mentioned patches.

Ah, you want the rebase to just remove the commits.  That is nice, but
we can't do that as part of a released branch for obvious reasons.

We need real reverts.

> 5.) Cherry-pick SLI path split patches from mkp-scsi:
> git cherry-pick a680a9298e7b 1b64aa9eae28 561341425bcc 6831ce129f19
> cad93a089031 3bea83b68d54 3f607dcb43f1 e0367dfe90d6 9d41f08aa2eb
> 351849800157 2d1928c57df6 61910d6a5243 3512ac094293 31a59f75702f
> 0e082d926f59

All of these commits are already in Linus's tree, right?  So why do we
need an additional branch?

> 
> 6.) Cherry-pick the atomic_inc VMID fix:
> git cherry-pick 0948a9c53860
> 
> 7.) Cherry-pick all known SLI path split fixes:
> git cherry-pick 7294a9bcaa7e c26bd6602e1d c2024e3b33ee cc28fac16ab7
> 775266207105 84c6f99e3907 596fc8adb171 44ba9786b673 24e1f056677e
> e27f05147bff
> 
> All the cherry-picks are expected to apply cleanly.

Can you just send a patch series that does all of this so that we know
it is correct and works properly?  I'll be glad to take that into
5.15.y.

thanks,

greg k-h
