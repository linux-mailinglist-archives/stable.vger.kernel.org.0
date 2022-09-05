Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608E65ACE01
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 10:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237632AbiIEIkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 04:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237987AbiIEIjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 04:39:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69514F77;
        Mon,  5 Sep 2022 01:39:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8C07B80EFB;
        Mon,  5 Sep 2022 08:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5793FC433D6;
        Mon,  5 Sep 2022 08:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662367159;
        bh=uUei9mdyrhLtKkVtWe0fW5YWmHh6AQZ22dmi4FRW6LM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=okZvnY8uvuq4qrI+2cj5k/t/HjGqcxfzGINM4i2aPAmem5pD7PEXyZp96mAvzMeHz
         qYhvdKDP0BpInYNqPV/qeSTImkDmgA3ofaExX/1DCe0Vkt6SR7A6mI3Tmu2a3R8png
         JTxD2Y8JblPYBzA/r0sbO4sM26Fd4/KKeZbBW9YJL1+hBtxKyx8Uu6/hFaID4vZYmT
         Fj4FFebb0b/WQOVT/ar3mov06mYpZbDaP1fFp5ooeuzkBPhklPHSwPkYkY2a4V62v9
         YF9rk+ppk6S9Z+8aDP4lqML27dZnN7Othjw5ipuOXb/f1IYspIKxz3ey+k5MhOGtZE
         /UrH1cXm2r3WQ==
Date:   Mon, 5 Sep 2022 10:39:14 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Oleksandr Tymoshenko <ovt@google.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] seccomp: fix refcounter leak if fork/clone is terminated
Message-ID: <20220905083914.msdgd575tblq4syj@wittgenstein>
References: <20220902034135.2853973-1-ovt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220902034135.2853973-1-ovt@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 02, 2022 at 03:41:35AM +0000, Oleksandr Tymoshenko wrote:
> release_task, where the seccomp's filter refcounter is released, is not
> called for the case when the fork/clone is terminated midway by a
> signal. This leaves an extra reference that prevents filter from being
> destroyed even after all processes using it exit leading to a BPF JIT
> memory leak. Dereference the refcounter in the failure path of the
> copy_process function.
> 
> Fixes: 3a15fb6ed92c ("seccomp: release filter after task is fully dead")
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Oleksandr Tymoshenko <ovt@google.com>
> ---

Hey Oleksandr,

Thanks for the patch! I'm really puzzled as to why we never noticed this
and I'm trying to re-architect how this happend. But in any case,
there's a patch in the seccomp tree that fixes this:

https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?id=6d17452707ca

which is slighly different from your approach in that it moves
copy_seccomp() after the point of no return. Let us know if you see any
issues with this!

Christian
