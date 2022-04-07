Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687E44F89A5
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 00:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbiDGUyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 16:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiDGUyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 16:54:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16582F8455;
        Thu,  7 Apr 2022 13:50:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A4BE61F7C;
        Thu,  7 Apr 2022 20:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68752C385A8;
        Thu,  7 Apr 2022 20:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649364654;
        bh=1vFrHO/IV/OlcF4Lq304ipCo0E3OpEp58N3JX16PGRQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UINhBf9lLNG+xMtTtcUk2JIJy6jl18do1S006ZOXeNJ/aeVS8b7KCqu5js3b8QA3f
         euuuTPkACA2sC1+9nSZ/+PfYBJC8EUYQBIQ59JTcnJpO5yhXHjYWkmZMEPLu5X4kt/
         iRDaLH5yWwNaZ7VE7b1Abi+93mDrdpBLDac9EyYI=
Date:   Thu, 7 Apr 2022 13:50:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Axel Rasmussen <axelrasmussen@google.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Mike Rapoport <rppt@kernel.org>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: fix panic when growing a memfd_secret
Message-Id: <20220407135053.6652bdad545fe98fc9babfbc@linux-foundation.org>
In-Reply-To: <CAJHvVchqPygpw9DGYuab+2ymFtF41E7RUyUUOiRHh1wicRgqCA@mail.gmail.com>
References: <20220324210909.1843814-1-axelrasmussen@google.com>
        <YjzjiDFBgigPqEO9@casper.infradead.org>
        <CAJHvVcj90ROLGWGZi_f5b4VCugD4o7v3quCv-6A6jPUdMbqi6A@mail.gmail.com>
        <CAJHvVchqPygpw9DGYuab+2ymFtF41E7RUyUUOiRHh1wicRgqCA@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 31 Mar 2022 10:42:12 -0700 Axel Rasmussen <axelrasmussen@google.com> wrote:

> Any strong opinions on which error code is used? I think overall I
> would still pick EOPNOTSUPP, but happy to change it if anyone feels
> strongly.
> 
> - I think ENOSYS is specific to syscall nr not defined
> - I think ENOTTY is specific to ioctls
> - The kernel (sort of mistakenly) defines ENOTSUPP instead of ENOTSUP,
> but it's marked deprecated and it's recommended to use EOPNOTSUPP
> instead (despite POSIX saying these should be distinct and for
> different uses).

`man ftruncate' sayeth

       EINVAL The argument length is negative or larger than the maximum  file
              size.

which reasonably accurately describes what we're doing here?

+	if ((ia_valid & ATTR_SIZE) && inode->i_size)
+		return -EOPNOTSUPP;


