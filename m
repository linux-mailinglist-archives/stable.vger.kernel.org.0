Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFC54F7DE6
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 13:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244753AbiDGLXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 07:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244138AbiDGLXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 07:23:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339351F5188
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 04:21:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2C55B8269F
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 11:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413EAC385A4;
        Thu,  7 Apr 2022 11:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649330465;
        bh=XrmfOL7bFsRp8/cfQ/N7Ov/hpsl5dLAFvirPMJjTwlI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=McdjO+JUEU7h+hwevuMbXLLXPqptjmPJSBkr+WKMF+LoaZLheQgzGWLvZoImb1aqL
         8WZJLuqfHfNGvTbMKDYt7k277ihOgN62UzOUcQvohhqCtnrlcrc4FSsdc9fnP8I0Rt
         LVlaJxQNgI1AA2Qwd9bqKu5kByc+nYsmSZUYbojw=
Date:   Thu, 7 Apr 2022 13:21:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     achtol <achtol@free.fr>
Cc:     stable@vger.kernel.org
Subject: Re: CVE-2020-16120 and CVE-2021-3428
Message-ID: <Yk7JHhKI8um7bzCo@kroah.com>
References: <a362b7bc-8b30-bbe6-de37-9cc01cf42d9c@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a362b7bc-8b30-bbe6-de37-9cc01cf42d9c@free.fr>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 07, 2022 at 12:40:51PM +0200, achtol wrote:
> Hello,
> 
> It seems the fix commits for a couple of CVEs have not been cherry picked in
> the current linux-5.4.y branch (v5.4.188, currently):
> 
> ---
> 
> CVE-2020-16120:
> 
> <https://nvd.nist.gov/vuln/detail/CVE-2020-16120> references the following
> mainline commits:
> 
>     d1d04ef8572bc8c22265057bd3d5a79f223f8f52 "ovl: stack file ops" (break
> commit)
>     56230d956739b9cb1cbde439d76227d77979a04d "ovl: verify permissions in
> ovl_path_open()"
>     48bd024b8a40d73ad6b086de2615738da0c7004f "ovl: switch to mounter creds
> in readdir"
>     05acefb4872dae89e772729efb194af754c877e8 "ovl: check permission to open
> real file"
>     b6650dab404c701d7fe08a108b746542a934da84 "ovl: do not fail because of
> O_NOATIME"
> 
> The CVE description says the last commit in the list above fixes a
> regression introduced by these two commits:
> 
>     130fdbc3d1f9966dd4230709c30f3768bccd3065 "ovl: pass correct flags for
> opening real directory"
>     292f902a40c11f043a5ca1305a114da0e523eaa3 "ovl: call secutiry hook in
> ovl_real_ioctl()"
> 
> ---
> 
> CVE-2021-3428:
> 
> According to <https://bugzilla.suse.com/show_bug.cgi?id=1173485>, the
> mainline fix commits are:
> 
>     d176b1f62f24 "ext4: handle error of ext4_setup_system_zone() on remount"
>     bf9a379d0980 "ext4: don't allow overlapping system zones"
>     ce9f24cccdc0 "ext4: check journal inode extents more carefully"
> 
> Of these, only the first two have been cherry-picked.
> 
> ---
> 
> Half of these commits may be cherry-picked without a conflict.

Which half?

> I wonder why
> they have not been applied and cannot find any discussion about them on this
> mailing list. Is it an oversight? Or because the v5.4 line is not affected?
> Some other reason?

If you can provide a working set of patches backported, I will be glad
to review them and apply them if needed.

thanks,

greg k-h
