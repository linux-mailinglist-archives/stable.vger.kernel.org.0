Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82F358FDA8
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 15:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbiHKNqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 09:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235024AbiHKNqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 09:46:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F621DA6E
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 06:46:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 836F6B82100
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 13:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF840C433D6;
        Thu, 11 Aug 2022 13:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660225600;
        bh=+6MpB4kohM7qC5hUvF5JIpzyTPEpOZoNiHsz7S/eZPE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M21PLpsc2U6SUhkgWO6RPBpMNglaIHFd33WG79KlDi7sm2kWT/nx1YXkylu7kV6fU
         gVfD+w6f39FnC55qJelwi6WQOuJcRnArEukUmm4IhU5/HaiuEpXT/mkovTZSeaiy2a
         U0/gIB8t4PQO9GImu/MxJQFpfTZ7pY7oM2+bkUO0=
Date:   Thu, 11 Aug 2022 15:46:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Grund <theflamefire89@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9 0/1] selinux: drop super_block backpointer from
 superblock_security_struct
Message-ID: <YvUIPffUjUMjb3IH@kroah.com>
References: <20220808115922.331003-1-theflamefire89@gmail.com>
 <YvEPfSBGdBV0ZohA@kroah.com>
 <7769a909-9054-3215-dd3e-00bfb822d003@gmail.com>
 <YvTYGJh2JQR4vOVZ@kroah.com>
 <22d70809-5db1-8258-b695-bc6aaa9ab9bf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22d70809-5db1-8258-b695-bc6aaa9ab9bf@gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 01:04:35PM +0200, Alexander Grund wrote:
> On 11.08.22 12:21, Greg KH wrote:
> > On Thu, Aug 11, 2022 at 11:46:09AM +0200, Alexander Grund wrote:
> >> I mean this patch removes a superflous pointer of the superblock struct
> >> making the kernel use less memory.
> > 
> > Also, how much measurable memory does this save?  You did not quantify
> > it.
> 
> It saves one pointer, i.e. usually 8 Byte, per superblock when using SELinux.
> 
> I don't know how many of those superblocks will be allocated in total on usual systems
> as I'm not familiar with the details of the filesystems.
> However following one callchain leads to
> 
> > /*
> > * Common helper for pseudo-filesystems (sockfs, pipefs, bdev - stuff that
> > * will never be mountable)
> > */
> > struct dentry *mount_pseudo_xattr(struct file_system_type *fs_type, char *name,
> 
> So it seems one superblock even for each pseudo-fs of which there can be many.
> 
> A quick experiment [1] on my phone shows about 300 superblocks allocated which means
> that the patch saves a bit over 2kB of memory.
> So not that much on usual systems but could be much for some embedded systems.

Again, we are not adding "slim the kernel down by an infinitesimal %"
patches to older stable kernels, especially ones that only have a few
more months to live.  Let's stick with real bugfixes please, that's what
matters here.

thanks,

greg k-h
