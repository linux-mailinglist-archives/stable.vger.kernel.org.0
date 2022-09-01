Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C86E5A943E
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 12:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbiIAKW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 06:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233483AbiIAKWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 06:22:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE7A136098
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 03:22:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00AC5B82577
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 10:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F179EC433C1;
        Thu,  1 Sep 2022 10:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662027771;
        bh=iVjXPsx+NvVPb94c4Yk7iiPDu9J6s1Tp9rmUDJeoqYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mCSOuJ4U0QXkzDLk9qz2UYUB/MUga4f+//eUhuGl6KMV+vvx49IFHPZEfk8pG3+h4
         hQeM6FoyYdQB6oF5uBAHrLZs9BJibyAfSpObAP9+CYXDyT3WlmQKWN665X7SI6dbqq
         aI4Eu70NEAUSvn6rK8Uhnv9Ae5aVakAmHKt08dHM=
Date:   Thu, 1 Sep 2022 12:22:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nicolas Schier <n.schier@avm.de>
Cc:     stable@vger.kernel.org, Jing Leng <jleng@ambarella.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH 4.9/4.14/4.19] kbuild: Fix include path in
 scripts/Makefile.modpost
Message-ID: <YxCH9VPp1qJK/owu@kroah.com>
References: <20220831041726.1493298-1-n.schier@avm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831041726.1493298-1-n.schier@avm.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 31, 2022 at 06:17:26AM +0200, Nicolas Schier wrote:
> From: Jing Leng <jleng@ambarella.com>
> 
> commit 23a0cb8e3225122496bfa79172005c587c2d64bf upstream.
> 
> When building an external module, if users don't need to separate the
> compilation output and source code, they run the following command:
> "make -C $(LINUX_SRC_DIR) M=$(PWD)". At this point, "$(KBUILD_EXTMOD)"
> and "$(src)" are the same.
> 
> If they need to separate them, they run "make -C $(KERNEL_SRC_DIR)
> O=$(KERNEL_OUT_DIR) M=$(OUT_DIR) src=$(PWD)". Before running the
> command, they need to copy "Kbuild" or "Makefile" to "$(OUT_DIR)" to
> prevent compilation failure.
> 
> So the kernel should change the included path to avoid the copy operation.
> 
> Signed-off-by: Jing Leng <jleng@ambarella.com>
> [masahiro: I do not think "M=$(OUT_DIR) src=$(PWD)" is the official way,
> but this patch is a nice clean up anyway.]
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> [nsc: updated context for v4.19]
> Signed-off-by: Nicolas Schier <n.schier@avm.de>
> ---
>  scripts/Makefile.modpost | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 

This worked for 5.4.y as well, so I took it there too.

thanks,

greg k-h
