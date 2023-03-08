Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9896AFECB
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 07:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjCHGRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 01:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCHGRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 01:17:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C278FBF1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 22:17:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68783615C1
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 06:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB8EC433D2;
        Wed,  8 Mar 2023 06:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678256260;
        bh=7a8jwSZ00SsRskj163Xe9JcZKpW4sE63QdrI3OM7OaQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qtL59F2Dyjn7G+tDXXTp+DDjSMwYzS2AKdD6MQcemQhfnL+B44j9haChPv/VYlkCw
         qxq3jKEVBR5sD5j1Z67g+WOZ9eK125XWnZm6/ivie/4ptpycAb0Mh7Ehbm1PuXY9AH
         /9GW81QvHvj4e3hEcX5gzjI67oqRK77hVeS9XKrA=
Date:   Wed, 8 Mar 2023 07:17:37 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     bug-make@gnu.org, stable@vger.kernel.org,
        Dmitry Goncharov <dgoncharov@users.sf.net>
Subject: Re: No progress output when make 4.4.1 builds Linux 4.19 and earlier
Message-ID: <ZAgogdFlu69QlYwu@kroah.com>
References: <ZAgnmbYtGa80L731@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAgnmbYtGa80L731@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 07, 2023 at 10:13:45PM -0800, Eric Biggers wrote:
> After upgrading to make v4.4.1 (released last week), there's no longer any
> progress output from builds of the Linux kernel v4.19 and earlier.  It seems the
> actual build still works, but it's now silent except for warnings and errors.
> 
> It bisects to the following 'make' commit:
> 
>     commit dc2d963989b96161472b2cd38cef5d1f4851ea34
>     Author: Dmitry Goncharov <dgoncharov@users.sf.net>
>     Date:   Sun Nov 27 14:09:17 2022 -0500
> 
>         [SV 63347] Always add command line variable assignments to MAKEFLAGS
> 
> Is this an intentional breakage from the 'make' side?

Ah, thanks for figuring this out, it's been bugging me locally for a bit
as well!  The fact that kernels 5.4 and newer imply to me that there is
a kernel build fix that should resolve this if someone can take the time
to bisect it...

thanks,

greg k-h
