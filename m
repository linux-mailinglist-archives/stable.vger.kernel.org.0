Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE3B676D33
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjAVNqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjAVNqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:46:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4349F1CF47;
        Sun, 22 Jan 2023 05:46:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E44FDB80AE0;
        Sun, 22 Jan 2023 13:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26E05C433D2;
        Sun, 22 Jan 2023 13:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674395187;
        bh=mAScaMaqk3Vdx2xdKRJnI9bSd8fwGAJj6T7KUJE2A/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ftz29efdjZZVziwJ2eIMIHv3Szst+fjhOUQ3Yqyi0EPpHcNaqS2H2kVwtA2Qaz5iX
         DusqQMByCiG5kbZ29aU0Ftw5f6mTNBlrQRLuneFynpZJRb1tNTJ2zg//RDa6626o1j
         EaOUSI69c2f0sYZg4Y7sXvkNctl7E0OQ+u4c+His=
Date:   Sun, 22 Jan 2023 14:46:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sj@kernel.org>
Cc:     Alon Zahavi <zahavi.alon@gmail.com>,
        almaz.alexandrovich@paragon-software.com, ntfs3@lists.linux.dev,
        linux-kernel@vger.kernel.org, Tal Lossos <tallossos@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ntfs3: Fix attr_punch_hole() null pointer derenference
Message-ID: <Y80+MZLA2sXyYf2J@kroah.com>
References: <20220815110712.36982-1-zahavi.alon@gmail.com>
 <20230117202136.116810-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117202136.116810-1-sj@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 17, 2023 at 08:21:36PM +0000, SeongJae Park wrote:
> Hello,
> 
> On Mon, 15 Aug 2022 14:07:12 +0300 Alon Zahavi <zahavi.alon@gmail.com> wrote:
> 
> > From: Alon Zahavi <zahavi.alon@gmail.com>
> > 
> > The bug occours due to a misuse of `attr` variable instead of `attr_b`.
> > `attr` is being initialized as NULL, then being derenfernced
> > as `attr->res.data_size`.
> > 
> > This bug causes a crash of the ntfs3 driver itself,
> > If compiled directly to the kernel, it crashes the whole system.
> > 
> > Signed-off-by: Alon Zahavi <zahavi.alon@gmail.com>
> > Co-developed-by: Tal Lossos <tallossos@gmail.com>
> > Signed-off-by: Tal Lossos <tallossos@gmail.com>
> 
> This patch has now merged in mainline as
> 6d5c9e79b726cc473d40e9cb60976dbe8e669624.  stable@, could you please merge this
> in stable kernels?
> 
> Fixes: be71b5cba2e64 ("fs/ntfs3: Add attrib operations") # 5.14
> 

Now queued up, thanks.

greg k-h
