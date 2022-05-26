Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9C253479E
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 02:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344687AbiEZAl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 20:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242987AbiEZAlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 20:41:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732959EB44;
        Wed, 25 May 2022 17:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18B38B81EAA;
        Thu, 26 May 2022 00:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8414FC385B8;
        Thu, 26 May 2022 00:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653525681;
        bh=mEug+FNS3WAXtVD1YTd+ywizxj+k7diM1xohqO66iJ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XQPhmP8pgmq6nZ3qk05p/o5hHp6puXPtqeJVhD6j8wjQBFd2MdDJnkUrsJj2SqhYo
         pcwALRgvkDWrNcknXYYTCYrnyg00EhFKc4U2m6wEzQY/JjO1opRITP8WUBZPBgRjke
         yulFv7ieKYW0J6bxZmwWRjPy5NU0eD6zLnBRQSrLAmznMnR5cA8ZvlZynrrPpLldV/
         ZnhoOgXXNcI2dOchczXi6BcGT0Af6jlrjxdgW/9JmzDt48be7qmo/B852JAj+Zc63J
         NZcxbsTTKVMYBLO/Iw06c4dTLGvHQA7cNImKUkah1oW2cbpsWjkaezoZkN9QjVQyKw
         cYXKGSBtU7xuA==
Date:   Thu, 26 May 2022 03:39:39 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Shuah Khan <shuah@kernel.org>, dave.hansen@linux.intel.com
Cc:     stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Borislav Petkov <bp@suse.de>, linux-sgx@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/sgx: add test_encl.elf to TEST_GEN_FILES
Message-ID: <Yo7MS2+g9kcI39xq@iki.fi>
References: <20220523181120.54547-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523181120.54547-1-jarkko@kernel.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 09:11:20PM +0300, Jarkko Sakkinen wrote:
> TEST_GEN_FILES contains files that are generated during compilation and are
> required to be included together with the test binaries, e.g. when
> performing:
> 
> make -C tools/testing/selftests install INSTALL_PATH=/some/other/path [*]
> 
> Add test_encl.elf to TEST_GEN_FILES because otherwise the installed test
> binary will fail to run.
> 
> [*] https://docs.kernel.org/dev-tools/kselftest.html
> 
> Cc: stable@vger.kernel.org
> Fixes: 2adcba79e69d ("selftests/x86: Add a selftest for SGX")
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
> v2:
> Use TEST_GEN_FILES in the "all" target, instead of duplicating the path for
> test_encl.elf.
> ---
>  tools/testing/selftests/sgx/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/sgx/Makefile b/tools/testing/selftests/sgx/Makefile
> index 75af864e07b6..7f60811b5b20 100644
> --- a/tools/testing/selftests/sgx/Makefile
> +++ b/tools/testing/selftests/sgx/Makefile
> @@ -17,9 +17,10 @@ ENCL_CFLAGS := -Wall -Werror -static -nostdlib -nostartfiles -fPIC \
>  	       -fno-stack-protector -mrdrnd $(INCLUDES)
>  
>  TEST_CUSTOM_PROGS := $(OUTPUT)/test_sgx
> +TEST_GEN_FILES := $(OUTPUT)/test_encl.elf
>  
>  ifeq ($(CAN_BUILD_X86_64), 1)
> -all: $(TEST_CUSTOM_PROGS) $(OUTPUT)/test_encl.elf
> +all: $(TEST_CUSTOM_PROGS) $(TEST_GEN_FILES)
>  endif
>  
>  $(OUTPUT)/test_sgx: $(OUTPUT)/main.o \
> -- 
> 2.36.1
> 

Dave, would it be by any means possible to pick this? My workload is
kernel testing with buildroot [*].

[*] Related:
    https://lore.kernel.org/buildroot/2c42570b01b2b51cc33d6623b25a736e4f20c601.camel@iki.fi/T/#t

BR, Jarkko
