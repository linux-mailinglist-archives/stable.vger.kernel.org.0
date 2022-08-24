Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBFC59F413
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 09:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiHXHQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 03:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbiHXHQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 03:16:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F2309322D;
        Wed, 24 Aug 2022 00:16:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A711B820D8;
        Wed, 24 Aug 2022 07:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9DBC433D6;
        Wed, 24 Aug 2022 07:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661325396;
        bh=SG4pItFavxLFek9T12nP+I7YvMHy0NfLi3Oa+f9zCO0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LzwBf2sji2vMVXeenNfWp/ekWKLV+3Kj/PPjtBD8vSdal734cITyGwYsIviBbLdfQ
         eavfh1IaOhqvLrs0bAMdThVoPoxUMT2GNlkT1IednP+jgj/JrxbVTZGFqJjsTbtnwV
         uPg9pIdw0ipAenTknzHjGmU5aS1nkzcVIUz2CMAyN0Hn+JSXax1D+PhRzTY00k0AVA
         qZ2sZlSDljkrAxObgue93o08PSfZswaXJ1eyCn7TaL+JOKV7jNihaffdpCethZaajL
         4DduHY1cvRtcw7KfqQklqzbkGMw/FYYsjkZOoO3l/YwFilQh6eijd74VXO9E9XqW9P
         4Zjy5R4YBvKKA==
Date:   Wed, 24 Aug 2022 09:16:30 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Andrew Delgadilo <adelg@google.com>
Cc:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] selftests: remove unused variable in close_range test
Message-ID: <20220824071630.foz2k6ycwdn5vsdw@wittgenstein>
References: <20220823224811.12758-1-adelg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220823224811.12758-1-adelg@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 10:48:11PM +0000, Andrew Delgadilo wrote:
> From: Andrew Delgadillo <adelg@google.com>
> 
> commit 2c5db60e46ad ("tests: add close_range() tests") adds the
> close_range test under the core namespace. In its current form, the
> close_range test has an unused variable, namely, ret. For those building
> with -Werror,-Wall, this breaks the build.
> 
> Without this patch:
> $ make -C tools/testing/selftests/ TARGETS=core V=1 CFLAGS="-Werror -Wall"
> > make: Entering directory '/.../kernel-src/tools/testing/selftests'
> > make[1]: Entering directory '/.../kernel-src/tools/testing/selftests/core'
> > gcc -Werror -Wall    close_range_test.c  -o /.../kernel-src/tools/testing/selftests/core/close_range_test
> > close_range_test.c: In function 'core_close_range':
> > close_range_test.c:55:16: error: unused variable 'ret' [-Werror=unused-variable]
> >   55 |         int i, ret;
> >      |                ^~~
> > cc1: all warnings being treated as errors
> > make[1]: *** [../lib.mk:135: /.../kernel-src/tools/testing/selftests/core/close_range_test] Error 1
> > make[1]: Leaving directory '/.../kernel-src/tools/testing/selftests/core'
> > make: *** [Makefile:155: all] Error 2
> > make: Leaving directory '/.../kernel-src/tools/testing/selftests'
> 
> With this patch:
> $ make -C tools/testing/selftests/ TARGETS=core V=1 CFLAGS="-Werror -Wall"
> > make: Entering directory '/.../kernel-src/tools/testing/selftests'
> > make[1]: Entering directory '/.../kernel-src/tools/testing/selftests/core'
> > gcc -Werror -Wall    close_range_test.c  -o /.../kernel-src/tools/testing/selftests/core/close_range_test
> > make[1]: Leaving directory '/.../kernel-src/tools/testing/selftests/core'
> > make: Leaving directory '/.../kernel-src/tools/testing/selftests'
> 
> Fixes: 2c5db60e46ad ("tests: add close_range() tests")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Delgadillo <adelg@google.com>
> ---

Thanks,
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
