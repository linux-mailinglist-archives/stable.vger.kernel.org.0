Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040E45B6C67
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 13:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbiIMLc4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 07:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiIMLcy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 07:32:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C9753D14
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 04:32:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B92176140F
        for <stable@vger.kernel.org>; Tue, 13 Sep 2022 11:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17F0C433C1;
        Tue, 13 Sep 2022 11:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663068773;
        bh=xKXJLlcy6ByT5onEV6Z/Y+nMbjGqigKGQtmGbsyRGUc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L7ZvfNSgX8G7rFIEsMsdqNmohlZkUN586v9FoQhS6a5LNvswSH+DtNzGgPzI826sC
         BDQKcoonD/+YqlAzpkOcwamGfK+rODMrK7mEk4tbWDx+gPONKA0BCmEMRq7aGVPXhn
         Ko8OcfiH3a0Ct+k8qoqlwTS02cWvujXwJn301byw=
Date:   Tue, 13 Sep 2022 13:33:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ye Weihua <yeweihua4@huawei.com>
Cc:     stable@vger.kernel.org
Subject: Re: Backport patch "mm: fix missing handler for __GFP_NOWARN" to
 linux-5.10.y
Message-ID: <YyBqfVDuSJ3K6tTg@kroah.com>
References: <38acddc1-143c-469e-c918-93b5589068c9@huawei.com>
 <Yxwv/82jkMjew4ZN@kroah.com>
 <164a48a0-b27f-7b0c-cf7e-b2c2cb75b78f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <164a48a0-b27f-7b0c-cf7e-b2c2cb75b78f@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 13, 2022 at 10:21:38AM +0800, Ye Weihua wrote:
> 
> On 2022/9/10 14:34, Greg KH wrote:
> > On Fri, Sep 09, 2022 at 11:40:07AM +0800, Ye Weihua wrote:
> > > The following patch is required to be patched in linux-5.10.y:
> > > 
> > > 
> > >      3f913fc5f974 mm: fix missing handler for __GFP_NOWARN
> > > 
> > > 
> > > Commit 6b9dbedbe349 ("tty: fix deadlock caused by calling printk() under
> > > tty_port->lock")
> > > 
> > > was backported to linux-5.10.y. But __GFP_NOWARN flag is still not check in
> > > fail_dump(), and
> > > 
> > > deadlock issues still occur.
> > > 
> > What about all of the other stable kernel trees that the tty patch was
> > backported to?  Do they also need the mm change as well?  That would
> > include 4.9.y, 4.14.y, 4.19.y, 5.4.y, 5.10.y, and 5.15.y.
> 
> I checked the branches and found that the status of each branch was the
> same. That is, the commit 6b9dbedbe349 ("tty: fix deadlock caused by calling
> printk() under tty_port->lock") was backported but the commit 3f913fc5f974
> ("mm: fix missing handler for __GFP_NOWARN") was not. Therefore, the problem
> occurred in all branches. The commit "mm: fix missing handler for
> __GFP_NOWARN" should be backported to 4.9.y, 4.14.y, 4.19.y, 5.4.y, 5.10.y,
> and 5.15.y.

Ok, can you provide a proper backport that has been tested for all of
these branches as it does not apply cleanly as-is.

Or we can revert the tty patch, which do you think is better?

thanks,

greg k-h
