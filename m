Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1536966630A
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 19:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbjAKSun (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 13:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235650AbjAKSud (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 13:50:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2C23D1D7;
        Wed, 11 Jan 2023 10:50:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7F04B81CA3;
        Wed, 11 Jan 2023 18:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA2DC433D2;
        Wed, 11 Jan 2023 18:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673463030;
        bh=QasiENd9bQiKisFz/wSTOxxKyJP0Z+R/8glnxbreHwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XKp+ITw5MV+TlFfz1DuMuORnI4jtZKlThYSGjDdQKpoaUvY15dmekatCk8TrqUk0K
         wf1IBxtgvgcbst9AzFj3O9geFANe+G1FVFrpQfKBvXu8Tg89f2lI4pVR5f4eZBB/jv
         9k+STM0m7SSzpuuslmNxrRtGuLtsbePH5zVCQYsvspa7g0kBrG4+Bs0217pKg7pECw
         rXraBzAG741lR7+zYf6ZZAlyQQVirdUpq03ewSXLuwzT4gYQdVwX6ZF0nZjgUMAY8J
         RC/BNyayVRNERte5BNKE9vrSh5za0ryHtFecCK+TX71Ax+avEIoo8vSfMADLZRxS1c
         WNSfEng3sM9zA==
Date:   Wed, 11 Jan 2023 10:50:28 -0800
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Chao Yu <chao@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: retry to update the inode page given
 EIO
Message-ID: <Y78E9NpDxtvr2/Hs@google.com>
References: <20230105233908.1030651-1-jaegeuk@kernel.org>
 <Y74O+5SklijYqMU1@google.com>
 <77b18266-69c4-c7f0-0eab-d2069a7b21d5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77b18266-69c4-c7f0-0eab-d2069a7b21d5@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/11, Chao Yu wrote:
> On 2023/1/11 9:20, Jaegeuk Kim wrote:
> > In f2fs_update_inode_page, f2fs_get_node_page handles EIO along with
> > f2fs_handle_page_eio that stops checkpoint, if the disk couldn't be recovered.
> > As a result, we don't need to stop checkpoint right away given single EIO.
> 
> f2fs_handle_page_eio() only covers the case that EIO occurs on the same
> page, should we cover the case EIO occurs on different pages?

Which case are you looking at?

> 
> Thanks,
> 
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Randall Huang <huangrandall@google.com>
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> > 
> >   Change log from v1:
> >    - fix a bug
> > 
> >   fs/f2fs/inode.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> > index ff6cf66ed46b..2ed7a621fdf1 100644
> > --- a/fs/f2fs/inode.c
> > +++ b/fs/f2fs/inode.c
> > @@ -719,7 +719,7 @@ void f2fs_update_inode_page(struct inode *inode)
> >   	if (IS_ERR(node_page)) {
> >   		int err = PTR_ERR(node_page);
> > -		if (err == -ENOMEM) {
> > +		if (err == -ENOMEM || (err == -EIO && !f2fs_cp_error(sbi))) {
> >   			cond_resched();
> >   			goto retry;
> >   		} else if (err != -ENOENT) {
