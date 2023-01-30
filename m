Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5FD681649
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 17:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbjA3Q0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 11:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjA3Q0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 11:26:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D6E3B0C3;
        Mon, 30 Jan 2023 08:26:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2043EB81257;
        Mon, 30 Jan 2023 16:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6A4C433EF;
        Mon, 30 Jan 2023 16:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675095999;
        bh=2/edSpatAbOcjKU7z4bnoHERt4ebGtnlgSVA1i9F/Qk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TnVjefY6nIit3aABg1sNDNhHGAUKRgyNq+kw6Ey0slvN/9oMXxaucu4gR/yioYQe/
         DOfYyvnp8iKgH3VxaHbUdh6ZYnsflELdoUpF06fj02iKbgP+4K0Srg9e9wnP1TN39O
         86AQ+h4ZUJ4O9/7nQbBpWBnvIC6+tYuNl7Nizuw6Jfbj4o9nIySU+y/NeUIX6/vjpu
         xv5+8kVtEMvDPD5xdPsMRmhpsoM33EXV/gZSuD1voZIqz8jVKz0EAT4u/ZjkXD31eS
         M7+MXmWQtyi+4tx+/WLtmHBVH5O1uyhtrCk+NXA4pI7ARKHuVYmS6TPjnpBXO3FuNR
         TXiuITer8QOeQ==
Date:   Mon, 30 Jan 2023 17:26:34 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 03/34] selftests: clone3: Fix incorrect kernel headers
 search path
Message-ID: <20230130162634.mauiboxfoxrjg4ma@wittgenstein>
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
 <20230127135755.79929-4-mathieu.desnoyers@efficios.com>
 <3e0af0da-a248-ea7a-e401-c1f3c01e7c75@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3e0af0da-a248-ea7a-e401-c1f3c01e7c75@linuxfoundation.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 30, 2023 at 09:15:13AM -0700, Shuah Khan wrote:
> On 1/27/23 06:57, Mathieu Desnoyers wrote:
> > Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
> > building against kernel headers from the build environment in scenarios
> > where kernel headers are installed into a specific output directory
> > (O=...).
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > Cc: Shuah Khan <shuah@kernel.org>
> > Cc: linux-kselftest@vger.kernel.org
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: <stable@vger.kernel.org>    [5.18+]
> > ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>

> >   tools/testing/selftests/clone3/Makefile | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/clone3/Makefile b/tools/testing/selftests/clone3/Makefile
> > index 79b19a2863a0..84832c369a2e 100644
> > --- a/tools/testing/selftests/clone3/Makefile
> > +++ b/tools/testing/selftests/clone3/Makefile
> > @@ -1,5 +1,5 @@
> >   # SPDX-License-Identifier: GPL-2.0
> > -CFLAGS += -g -std=gnu99 -I../../../../usr/include/
> > +CFLAGS += -g -std=gnu99 $(KHDR_INCLUDES)
> >   LDLIBS += -lcap
> >   TEST_GEN_PROGS := clone3 clone3_clear_sighand clone3_set_tid \
> 
> + brauner@kernel.org
> 
> Hi Christian,

Hey Shuah,

> 
> Would you me to take this patch through kselftest tree? If you


Feel free to take it through the kselftest tree. Thank you!
Christian
