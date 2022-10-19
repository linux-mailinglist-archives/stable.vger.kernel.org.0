Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80747604312
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiJSLXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiJSLXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:23:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E46CE1903B;
        Wed, 19 Oct 2022 03:54:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FF53617EA;
        Wed, 19 Oct 2022 10:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C50C433C1;
        Wed, 19 Oct 2022 10:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666175989;
        bh=5cxq+cb4E7+tkhA+HkBKNPUn/GSR4PcLAxXbiT1ManQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cch0MZ0TyHqMYKXeYUYUhJ6OQ2vqgj1Q61mEQ01cPuHlqZXYZrcYOCFuTPkPElz5c
         fMoZ6K7q56u7osgco/ckSoRTSJ5gTbzgfYXBOigRTMPfAwFbaztzdtNEqHz+tQMHh7
         zBQR0Uta1udvrrQe6b/MMfEQnUbUhZaE3c0PHHvE=
Date:   Wed, 19 Oct 2022 12:39:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 659/862] =?us-ascii?B?PT9V?=
 =?us-ascii?B?VEYtOD9xP0FSTS9kbWEtbWFwcD1EMT05Nm5nOj0yMGRvbnQ9MjBvdmVycmlk?=
 =?us-ascii?B?ZT0yMC0+ZG1hPTVGY29oZT89ID0/VVRGLTg/cT9yZW50PTIwd2hlbj0yMHNl?=
 =?us-ascii?Q?t=3D20from=3D20a=3D20bus=3D20notifier=3F=3D?=
Message-ID: <Y0/T8phZ3PrnOSFN@kroah.com>
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083319.087440003@linuxfoundation.org>
 <Y0+/41/qY8DjVn23@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y0+/41/qY8DjVn23@shell.armlinux.org.uk>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 10:14:11AM +0100, Russell King (Oracle) wrote:
> Hi Greg,
> 
> I'm seeing:
> 
> Subject: [PATCH 6.0 659/862]
>         =?UTF-8?q?ARM/dma-mapp=D1=96ng:=20dont=20override=20->dma=5Fcohe?=
>         =?UTF-8?q?rent=20when=20set=20from=20a=20bus=20notifier?=
> 
> in mutt, and mutt seems to be unable to decode that. Either a mutt
> bug or a bug in your scripts or git...

It's probably between git and quilt and somewhere.  The issue is
that the original commit's subject line is:
	ARM/dma-mappіng: don't override ->dma_coherent when set from a bus notifier

Note the 'і' character in there, which then causes git to emit a subject
line that looks like:
	Subject: [PATCH] =?UTF-8?q?ARM/dma-mapp=D1=96ng:=20don't=20override=20->dm?=
	 =?UTF-8?q?a=5Fcoherent=20when=20set=20from=20a=20bus=20notifier?=

which is technically correct.

Then quilt comes along and adds it's own counting of the patch and
treats the whole thing as the subject and something gets confused.

Anyway, I'll go drop the funny 'і' and turn it into ascii only for the
subject line.

thanks,

greg k-h
