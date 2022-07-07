Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A34D56AA33
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 20:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbiGGSFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 14:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235575AbiGGSFP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 14:05:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4574B23BD4;
        Thu,  7 Jul 2022 11:05:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB87662039;
        Thu,  7 Jul 2022 18:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9070C3411E;
        Thu,  7 Jul 2022 18:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657217114;
        bh=MN9JIjhs22FoV1RIoIWhCdI8THtn7kp+XQKAOeRUbiw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PRBD+Ttf6rdClZze3V5fejwuW4/VuVerH1akyywSaPhP+2WAzdw6bEGWnQ4oErfo+
         j/jBq+2sSnTfOUjQWSSt18pVIIEUdj8hQhNmBIfJVXnD6in804kVEXMK0GuQertmEj
         FckUwSEpmJwNgAPla4GRfTKOlMr+pWG65fByN1Sk=
Date:   Thu, 7 Jul 2022 20:05:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     stable@vger.kernel.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH stable 5.15 0/1] Revert "selftests/bpf: Add test for
 bpf_timer overwriting crash"
Message-ID: <YscgV2/HW35p4yyi@kroah.com>
References: <20220707094207.229875-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707094207.229875-1-po-hsu.lin@canonical.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 07, 2022 at 05:42:06PM +0800, Po-Hsu Lin wrote:
> The bpf_timer overwriting crash test will cause bpf selftest build
> fail on the stable 5.15 tree with:
> 
> progs/timer_crash.c:8:19: error: field has incomplete type 'struct bpf_timer'
>         struct bpf_timer timer;
>                          ^
> /home/ubuntu/linux/tools/testing/selftests/bpf/tools/include/bpf/bpf_helper_defs.h:39:8:
> note: forward declaration of 'struct bpf_timer'
> struct bpf_timer;
>        ^
> 1 error generated.
> 
> Test shows this can only be built with 5.17 and newer kernels. Let's
> revert it for the 5.15 tree.
> 
> Po-Hsu Lin (1):
>   Revert "selftests/bpf: Add test for bpf_timer overwriting crash"
> 
>  .../testing/selftests/bpf/prog_tests/timer_crash.c | 32 -------------
>  tools/testing/selftests/bpf/progs/timer_crash.c    | 54 ----------------------
>  2 files changed, 86 deletions(-)
>  delete mode 100644 tools/testing/selftests/bpf/prog_tests/timer_crash.c
>  delete mode 100644 tools/testing/selftests/bpf/progs/timer_crash.c
> 
> -- 
> 2.7.4
> 

Now queued up, thanks.

greg k-h
