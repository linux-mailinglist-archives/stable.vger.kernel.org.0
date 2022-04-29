Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381FC5144FF
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 11:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356212AbiD2JFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 05:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbiD2JFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 05:05:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F10C4034
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 02:01:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 732F0621EF
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 09:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A212C385A7;
        Fri, 29 Apr 2022 09:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651222901;
        bh=2DqoSwylBrKKgy9BaMbcSp6ENbM+sZJeJ4Ysj6x0WWI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eXBM1DtYA/CshsNwcP1j1CA8zif3Pm+4CCP9WJXV7iJSu07ozVLiF9wCNlmit0JdQ
         jKCsTTPaFDdn3dDambM02LyaOkXYrK8QyXCrOLSDQhP4+QtR3UUBqseEtAq6GagQ8Z
         FRwqpM3X7FNqaERcLPn9/+6XuBDvVwbBVrcxggJk=
Date:   Fri, 29 Apr 2022 11:01:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hao Luo <haoluo@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, laura@labbott.name,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH stable linux-5.15.y 00/10] Fix bpf mem read/write
 vulnerability.
Message-ID: <Ymupcl2JshcWjmMD@kroah.com>
References: <20220428235751.103203-1-haoluo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428235751.103203-1-haoluo@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 28, 2022 at 04:57:41PM -0700, Hao Luo wrote:
> Hi Greg,
> 
> Please cherry-pick this patch series into 5.15.y stable. It
> includes a feature that fixes CVE-2022-0500 which allows a user with
> cap_bpf privileges to get root privileges. The patch that fixes
> the bug is
> 
>  patch 7/10: bpf: Make per_cpu_ptr return rdonly
> 
> The rest are the depedences required by the fix patch. Note that v5.10 and
> below are not affected by this bug.
> 
> This patchset has been merged in mainline v5.17 and backported to v5.16[1],
> except patch 10/10 ("bpf: Fix crash due to out of bounds access into reg2btf_ids."),
> which fixes an out-of-bound access in the main feature in this series and
> hasn't been backported to v5.16 yet. If it's convenient, could you
> apply patch 10/10 to 5.16? I can send a separate patch for v5.16, if you
> prefer.

5.16 is long end-of-life, sorry, I can't add any more patches to that
tree and no one should be using it anymore.

I'll go queue these up now for 5.15, thanks for the backports!

greg k-h
