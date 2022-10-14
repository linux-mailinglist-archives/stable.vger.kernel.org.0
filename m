Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B3F5FF030
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 16:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiJNOVb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 14 Oct 2022 10:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJNOVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 10:21:30 -0400
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA11A1CC747;
        Fri, 14 Oct 2022 07:21:29 -0700 (PDT)
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay05.hostedemail.com (Postfix) with ESMTP id B3E9D4099E;
        Fri, 14 Oct 2022 14:15:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf15.hostedemail.com (Postfix) with ESMTPA id 06F541C;
        Fri, 14 Oct 2022 14:14:56 +0000 (UTC)
Message-ID: <043b9474f83b2da34bce5ff94b9aa3b735b70d4f.camel@perches.com>
Subject: Re: [PATCH AUTOSEL 4.9 1/3] powerpc/selftests: Use timersub() for
 gettimeofday()
From:   Joe Perches <joe@perches.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>,
        Michael Ellerman <mpe@ellerman.id.au>, shuah@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Date:   Fri, 14 Oct 2022 07:15:08 -0700
In-Reply-To: <20221014135502.2110218-1-sashal@kernel.org>
References: <20221014135502.2110218-1-sashal@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Stat-Signature: 3zgjaw88zojn6q9khoy8omazrsq4orrh
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 06F541C
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX190Yuwm6bfJNyNHFDdGFIA6O0pYyJESv1I=
X-HE-Tag: 1665756896-52267
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-10-14 at 09:54 -0400, Sasha Levin wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> [ Upstream commit c814bf958926ff45a9c1e899bd001006ab6cfbae ]
> 
> Use timersub() function to simplify the code.

Why should a code simplification be backported?

> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/20220816105106.82666-1-ye.xingchen@zte.com.cn
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/testing/selftests/powerpc/benchmarks/gettimeofday.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/powerpc/benchmarks/gettimeofday.c b/tools/testing/selftests/powerpc/benchmarks/gettimeofday.c
> index 3af3c21e8036..7f4bb84f1c9c 100644
> --- a/tools/testing/selftests/powerpc/benchmarks/gettimeofday.c
> +++ b/tools/testing/selftests/powerpc/benchmarks/gettimeofday.c
> @@ -12,7 +12,7 @@ static int test_gettimeofday(void)
>  {
>  	int i;
>  
> -	struct timeval tv_start, tv_end;
> +	struct timeval tv_start, tv_end, tv_diff;
>  
>  	gettimeofday(&tv_start, NULL);
>  
> @@ -20,7 +20,9 @@ static int test_gettimeofday(void)
>  		gettimeofday(&tv_end, NULL);
>  	}
>  
> -	printf("time = %.6f\n", tv_end.tv_sec - tv_start.tv_sec + (tv_end.tv_usec - tv_start.tv_usec) * 1e-6);
> +	timersub(&tv_start, &tv_end, &tv_diff);
> +
> +	printf("time = %.6f\n", tv_diff.tv_sec + (tv_diff.tv_usec) * 1e-6);
>  
>  	return 0;
>  }

