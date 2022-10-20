Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DB06062C7
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 16:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiJTOSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 10:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiJTOR5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 10:17:57 -0400
Received: from smtp-42ac.mail.infomaniak.ch (smtp-42ac.mail.infomaniak.ch [IPv6:2001:1600:4:17::42ac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC545BCBF
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 07:17:54 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MtV751KH2zMpvj8;
        Thu, 20 Oct 2022 16:17:53 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4MtV743mFpzMppr1;
        Thu, 20 Oct 2022 16:17:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1666275473;
        bh=LZWC8UxLcV9OOushq91Z9hayKTSGjAFQWE6mrJiyBqQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=YgOI9BSw0LGdguK5OdLrhDKM+Zt6bStv8ekWLBVTVZMd5mWoYgfQyzzaGza4dYOjP
         7nvRoVV+uOhyxOGTwu4ITjrG3+ML57HJwlIPq0EZzng4igY9dSkWwDi4IQuBpAbQEN
         WNGlPtQqmshIRzvmf8Vw9K/ymlOoaBVz3UhZ4vk8=
Message-ID: <80053942-2e24-b31a-8795-1f81d4b52e67@digikod.net>
Date:   Thu, 20 Oct 2022 16:17:51 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v1] selftests: Use optional USERCFLAGS and USERLDFLAGS
Content-Language: en-US
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org
References: <20220909103901.1503436-1-mic@digikod.net>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20220909103901.1503436-1-mic@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shuah, what do you think about this patch?

On 09/09/2022 12:39, Mickaël Salaün wrote:
> This change enables to extend CFLAGS and LDFLAGS from command line, e.g.
> to extend compiler checks: make USERCFLAGS=-Werror USERLDFLAGS=-static
> 
> USERCFLAGS and USERLDFLAGS are documented in
> Documentation/kbuild/makefiles.rst and Documentation/kbuild/kbuild.rst
> 
> This should be backported (down to 5.10) to improve previous kernel
> versions testing as well.
> 
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Link: https://lore.kernel.org/r/20220909103901.1503436-1-mic@digikod.net
> ---
>   tools/testing/selftests/lib.mk | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index d44c72b3abe3..da47a0257165 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -119,6 +119,11 @@ endef
>   clean:
>   	$(CLEAN)
>   
> +# Enables to extend CFLAGS and LDFLAGS from command line, e.g.
> +# make USERCFLAGS=-Werror USERLDFLAGS=-static
> +CFLAGS += $(USERCFLAGS)
> +LDFLAGS += $(USERLDFLAGS)
> +
>   # When make O= with kselftest target from main level
>   # the following aren't defined.
>   #
> 
> base-commit: 7e18e42e4b280c85b76967a9106a13ca61c16179
