Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF286A193B
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 10:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjBXJ4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 04:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjBXJ4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 04:56:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F070CDEF
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 01:56:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5D02B81646
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 09:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF73C4339B;
        Fri, 24 Feb 2023 09:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677232607;
        bh=SL8/NsDIWLgQ8OBhNl3bDFnDk4/LIRlWTG6ucMLkIAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wtKDxITL7FzGBkTlQPp/e7ZV+iYef7NTF9cklfFlo+RCG2L8Z2Cgx/4Hx8ScbgdoG
         O3M5mjLjPvmW87udUuYTKddTKpm02BE+pHYYhPT7/u4tnopUkjga7rG6BGGAG7Upq1
         LoortE8tZL52/LvbWo/RhJgq5mKz1oC2Fdvi88xg=
Date:   Fri, 24 Feb 2023 10:56:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Jordy Zomer <jordyzomer@google.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4.14 6/7] uaccess: Add speculation barrier to
 copy_from_user()
Message-ID: <Y/iJ3T6gJkbdoW9v@kroah.com>
References: <20230223130423.369876969@linuxfoundation.org>
 <20230223130423.662749238@linuxfoundation.org>
 <dfcc6afe-0400-44f9-42b0-005a60c9162e@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfcc6afe-0400-44f9-42b0-005a60c9162e@iogearbox.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 24, 2023 at 10:13:45AM +0100, Daniel Borkmann wrote:
> On 2/23/23 2:04 PM, Greg Kroah-Hartman wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> > 
> > commit 74e19ef0ff8061ef55957c3abd71614ef0f42f47 upstream.
> > 
> > The results of "access_ok()" can be mis-speculated.  The result is that
> > you can end speculatively:
> > 
> > 	if (access_ok(from, size))
> > 		// Right here
> > 
> > even for bad from/size combinations.  On first glance, it would be ideal
> > to just add a speculation barrier to "access_ok()" so that its results
> > can never be mis-speculated.
> 
> Keep in mind this also needs commit f3dd0c53370e ("bpf: add missing header file include")
> as follow-up everywhere you queue this one.

Already queued up in the -rc2 releases, thanks!

greg k-h
