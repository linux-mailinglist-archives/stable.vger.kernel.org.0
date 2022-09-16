Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339EE5BAB6C
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiIPKml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiIPKmU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:42:20 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6070BB693;
        Fri, 16 Sep 2022 03:24:02 -0700 (PDT)
Received: from [89.101.193.67] (helo=[10.119.25.151]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oZ8Tj-0005x7-Ln; Fri, 16 Sep 2022 12:21:47 +0200
Message-ID: <20ad29b8-be2c-8c1e-bd34-9709e5a9922f@leemhuis.info>
Date:   Fri, 16 Sep 2022 11:21:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH 5.15 102/107] kbuild: Add skip_encoding_btf_enum64 option
 to pahole
Content-Language: en-US, de-DE
To:     Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20220906132821.713989422@linuxfoundation.org>
 <20220906132826.180891759@linuxfoundation.org>
From:   Thorsten Leemhuis <linux@leemhuis.info>
In-Reply-To: <20220906132826.180891759@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1663323843;120a5380;
X-HE-SMSGID: 1oZ8Tj-0005x7-Ln
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06.09.22 14:31, Greg Kroah-Hartman wrote:
> From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> 
> New pahole (version 1.24) generates by default new BTF_KIND_ENUM64 BTF tag,
> which is not supported by stable kernel.

Martin, when you wrote "not supported by stable kernel", did you mean
just 5.15.y or 5.19.y as well? Because I ran into...

> As a result the kernel with CONFIG_DEBUG_INFO_BTF option will fail to
> compile with following error:
> 
>   BTFIDS  vmlinux
> FAILED: load BTF from vmlinux: Invalid argument

...this compile error when compiling 5.19.9 for F37 and from a quick
look into this it seems this was caused by a update of dwarves to 1.24
that recently landed in that distribution. This patch seems to fix the
problem (it got past the point of the error, but modules are still
compiling).

Ciao, Thorsten

> New pahole provides --skip_encoding_btf_enum64 option to skip BTF_KIND_ENUM64
> generation and produce BTF supported by stable kernel.
> 
> Adding this option to scripts/pahole-flags.sh.
> 
> This change does not have equivalent commit in linus tree, because linus tree
> has support for BTF_KIND_ENUM64 tag, so it does not need to be disabled.
> 
> Signed-off-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  scripts/pahole-flags.sh |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- a/scripts/pahole-flags.sh
> +++ b/scripts/pahole-flags.sh
> @@ -17,4 +17,8 @@ if [ "${pahole_ver}" -ge "121" ]; then
>  	extra_paholeopt="${extra_paholeopt} --btf_gen_floats"
>  fi
>  
> +if [ "${pahole_ver}" -ge "124" ]; then
> +	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_enum64"
> +fi
> +
>  echo ${extra_paholeopt}
> 
> 
