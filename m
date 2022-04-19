Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85EF5065F3
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 09:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349426AbiDSHfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 03:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349427AbiDSHfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 03:35:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF42DF75;
        Tue, 19 Apr 2022 00:33:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 528D46148C;
        Tue, 19 Apr 2022 07:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A444C385A7;
        Tue, 19 Apr 2022 07:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650353590;
        bh=zeE1qBpOuQzHwmbXjqUNr9bxVBPdrhURSLT2LJ7WTC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2AURuQ+ky5cpVb1vWZXdiCL4GR0JuAFQ1aB7Wv4tWtSbvGaLT9mDIRta37uX8BWQj
         00t5YnbEVS7Gm/BU81p439GVu0HlnncqnM0gye6tfLmfvcKcTrYgBDRU8KQv6KzJkc
         Yp4rTNICiVPN8D4MsV3oIWhE8rfjUj51YPLqB+kw=
Date:   Tue, 19 Apr 2022 09:33:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Oliver Upton <oupton@google.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable@kernel.org, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 5.17 183/219] KVM: Dont create VM debugfs files outside
 of the VM directory
Message-ID: <Yl5ls9RscjTzqe3D@kroah.com>
References: <20220418121203.462784814@linuxfoundation.org>
 <20220418121212.002023130@linuxfoundation.org>
 <CAOQ_QsgUrEyqLmjWPP2k_EUgp-VYv7ocT1w6EbJD=mxU+gPAfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_QsgUrEyqLmjWPP2k_EUgp-VYv7ocT1w6EbJD=mxU+gPAfw@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 10:14:42AM -0700, Oliver Upton wrote:
> Hi Greg,
> 
> On Mon, Apr 18, 2022 at 5:24 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Oliver Upton <oupton@google.com>
> >
> > commit a44a4cc1c969afec97dbb2aedaf6f38eaa6253bb upstream.
> >
> > Unfortunately, there is no guarantee that KVM was able to instantiate a
> > debugfs directory for a particular VM. To that end, KVM shouldn't even
> > attempt to create new debugfs files in this case. If the specified
> > parent dentry is NULL, debugfs_create_file() will instantiate files at
> > the root of debugfs.
> >
> > For arm64, it is possible to create the vgic-state file outside of a
> > VM directory, the file is not cleaned up when a VM is destroyed.
> > Nonetheless, the corresponding struct kvm is freed when the VM is
> > destroyed.
> >
> > Nip the problem in the bud for all possible errant debugfs file
> > creations by initializing kvm->debugfs_dentry to -ENOENT. In so doing,
> > debugfs_create_file() will fail instead of creating the file in the root
> > directory.
> >
> > Cc: stable@kernel.org
> > Fixes: 929f45e32499 ("kvm: no need to check return value of debugfs_create functions")
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Link: https://lore.kernel.org/r/20220406235615.1447180-2-oupton@google.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Can you drop this patch from stable for the time being? There's a bug
> in it because KVM does init/destroy awkwardly. Sean working on a fix
> [1].
> 
> [1]: https://lore.kernel.org/kvm/20220415004622.2207751-1-seanjc@google.com/

Will do, I'll go drop it from everywhere.

greg k-h
