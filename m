Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7C7542F89
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 13:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238501AbiFHL7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 07:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238525AbiFHL7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 07:59:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DDC24E1C2;
        Wed,  8 Jun 2022 04:59:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CE9B617BA;
        Wed,  8 Jun 2022 11:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA5CC34116;
        Wed,  8 Jun 2022 11:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654689571;
        bh=Yf86xlWhblkjwes7kpIuQErBLfl8qFaJ5/DrHlgUCss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aH8npcjlsr4rUhvuQjtqiRsp60ipAohdpclxEvPI3wEsSuTu1sPLdPQSHYlj27M19
         O4frsjpoiOdvKgK2sTeHqC04NVbhfSx0vM0LX0pfsZh7soc7pJO68ucV09qmYgEAKG
         orFeAo2xafyllLuIUPIkBaShoq+DrG5GeEZgZo0c=
Date:   Wed, 8 Jun 2022 13:59:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 026/452] selftests/bpf: Fix vfs_link kprobe
 definition
Message-ID: <YqCPIc+ZJDWQnTyH@kroah.com>
References: <20220607164908.521895282@linuxfoundation.org>
 <20220607164909.326145660@linuxfoundation.org>
 <20220608113842.GB9333@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608113842.GB9333@duo.ucw.cz>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 08, 2022 at 01:38:42PM +0200, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit e299bcd4d16ff86f46c48df1062c8aae0eca1ed8 ]
> > 
> > Since commit 6521f8917082 ("namei: prepare for idmapped mounts")
> > vfs_link's prototype was changed, the kprobe definition in
> > profiler selftest in turn wasn't updated. The result is that all
> > argument after the first are now stored in different registers. This
> > means that self-test has been broken ever since. Fix it by updating the
> > kprobe definition accordingly.
> 
> I don't see 6521f8917082 ("namei: prepare for idmapped mounts") in
> 5.10-stable tree. In 5.10, we still have:
> 
> include/linux/fs.h:extern int vfs_link(struct dentry *, struct inode *, struct dentry *, struct inode **);
> 
> I believe that means we should not have this one, either.

Good point, will go drop this, thanks.

greg k-h
