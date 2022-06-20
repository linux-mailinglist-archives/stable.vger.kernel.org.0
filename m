Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E41B5525D4
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 22:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245505AbiFTUfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 16:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243673AbiFTUfE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 16:35:04 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D32F19280;
        Mon, 20 Jun 2022 13:35:03 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id B2B4EC01F; Mon, 20 Jun 2022 22:35:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655757300; bh=tYtUszc9zzrvsFDcvZRSmgfIOw95+uFnGbWke6FtW8g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zIlm2Ws4qdLF/t897tnGdNcbyPmW1Kw92abguwEr4tvT4x+j1WVjkiGAN/Qo7f3jH
         ahqXcNGQ/p5vpwmJLF/ivjcoD9rgr46aEbbyBgr/J+n5NS0XHyhHchqFi5caeYGfuX
         Nta4tlldtMBrySG5e59UNkGuZvh0NuX0z+eBfqtaDNe241vYNHbA+RoFSwczGbrgIk
         GFtegkhsm7j6uVUKwoUpVeEIvLraTZxYu6hIZMvLo3QtaZnosSXk4qtBLCZcHXZCBG
         f+4jBNFTXbzMRUErL+4oN9fRhGDUVUi5UKekrKNL9Q+geT4LPoseEiz7xEzwe44S3m
         EDvkCARr3II1Q==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 08EA1C009;
        Mon, 20 Jun 2022 22:34:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1655757300; bh=tYtUszc9zzrvsFDcvZRSmgfIOw95+uFnGbWke6FtW8g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zIlm2Ws4qdLF/t897tnGdNcbyPmW1Kw92abguwEr4tvT4x+j1WVjkiGAN/Qo7f3jH
         ahqXcNGQ/p5vpwmJLF/ivjcoD9rgr46aEbbyBgr/J+n5NS0XHyhHchqFi5caeYGfuX
         Nta4tlldtMBrySG5e59UNkGuZvh0NuX0z+eBfqtaDNe241vYNHbA+RoFSwczGbrgIk
         GFtegkhsm7j6uVUKwoUpVeEIvLraTZxYu6hIZMvLo3QtaZnosSXk4qtBLCZcHXZCBG
         f+4jBNFTXbzMRUErL+4oN9fRhGDUVUi5UKekrKNL9Q+geT4LPoseEiz7xEzwe44S3m
         EDvkCARr3II1Q==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id ab3519d4;
        Mon, 20 Jun 2022 20:34:53 +0000 (UTC)
Date:   Tue, 21 Jun 2022 05:34:38 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] 9p: fix EBADF errors in cached mode
Message-ID: <YrDZ3nlTFwJ4ytl8@codewreck.org>
References: <15767273.MGizftpLG7@silver>
 <20220616211025.1790171-1-asmadeus@codewreck.org>
 <1902408.H94Nh90b8Q@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1902408.H94Nh90b8Q@silver>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Christian Schoenebeck wrote on Mon, Jun 20, 2022 at 02:47:24PM +0200:
> Some more tests this weekend; all looks fine. It appears that this also fixed
> the performance degradation that I reported early in this thread.

wow, I wouldn't have expected the EBADF fix patch to have any impact on
performance. Maybe the build just behaved differently enough to take
more time with the errors?

> Again, benchmarks compiling a bunch of sources:
> 
> Case  Linux kernel version         msize   cache  duration (average)
> 
> A)    EBADF fix only [1]           512000  loose  31m 14s
> B)    EBADF fix only [1]           512000  mmap   44m 1s
> C)    EBADF fix + clunk fixes [2]  512000  loose  29m 32s
> D)    EBADF fix + clunk fixes [2]  512000  mmap   44m 0s
> E)    5.10.84                      512000  loose  35m 5s
> F)    5.10.84                      512000  mmap   65m 5s
> 
> [1] 5.19.0-rc2 + EBADF fix v3 patch (alone):
> https://lore.kernel.org/lkml/20220616211025.1790171-1-asmadeus@codewreck.org/
> 
> [2] 5.19.0-rc2 + EBADF fix v3 patch + clunk fix patches, a.k.a. 9p-next:
> https://github.com/martinetd/linux/commit/b0017602fdf6bd3f344dd49eaee8b6ffeed6dbac
> 
> Conclusion: all thumbs in my possession pointing upwards. :)
> 
> Thanks Dominique!

Great news, thanks for the tests! :)

--
Dominique
