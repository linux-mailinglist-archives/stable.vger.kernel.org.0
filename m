Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBE35931DB
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 17:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbiHOPcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 11:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiHOPcK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 11:32:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA1017058
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 08:31:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4001610A3
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 15:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDDBC433C1;
        Mon, 15 Aug 2022 15:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660577518;
        bh=Y/p3TsCEECGeYnl7tWUyRhOlJ6BhHC93duBcdbGkMqU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yNznPZWxaOyGc1oRaWskk2fl3VIsdad0VkehEJOK5qHsM94RK+LFIBxC8qYuv8Bb0
         lgIJD+N+lj242/w4LeTHGcAQ8XrqchEHtBRIeAJ86ThA0fxIxZZHWkehuz3WkFnyCY
         LTuEap6JgLhpAqBD1bslTIleEsDDE8irI9Yw2kE8=
Date:   Mon, 15 Aug 2022 17:31:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: 5.18 queue aarch64 build =?utf-8?Q?iss?=
 =?utf-8?B?dWU6IGtleGVjX2tlcm5lbF92ZXJpZnlfcGVfc2ln4oCZ?= undeclared
Message-ID: <Yvpm6jzW840/7SZw@kroah.com>
References: <CA+tGwnk-zD0O_xV_LqUPa4XC-S9oCFbPvQf+8FkREqfZjqwHwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+tGwnk-zD0O_xV_LqUPa4XC-S9oCFbPvQf+8FkREqfZjqwHwg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 04:42:32PM +0200, Veronika Kabatova wrote:
> Hi,
> 
> CKI has been hitting the following build issue on aarch64 with the
> latest queues:
> 
> 00:00:12 arch/arm64/kernel/kexec_image.c:136:23: error:
> ‘kexec_kernel_verify_pe_sig’ undeclared here (not in a function)
> 00:00:12   136 |         .verify_sig = kexec_kernel_verify_pe_sig,
> 00:00:12       |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~
> 00:00:12 make[4]: *** [scripts/Makefile.build:289:
> arch/arm64/kernel/kexec_image.o] Error 1
> 00:00:12 make[3]: *** [scripts/Makefile.build:551: arch/arm64/kernel] Error 2
> 00:00:12 make[2]: *** [Makefile:1844: arch/arm64] Error 2
> 
> Seems to be caused by
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=queue/5.18&id=3d36f26a98be23c6fc48f4589030c87dc6e1a268
> 
> Full build log and kernel config used is available at
> 
> https://datawarehouse.cki-project.org/kcidb/builds/251196
> 
> or with other recent stable queue checkouts in DataWarehouse.

Thanks, I'll go drop that from everywhere, as it references commits that
are not in Linus's tree and I have no idea what to do with it.

greg k-h
