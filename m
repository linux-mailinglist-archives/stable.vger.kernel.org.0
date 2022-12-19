Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCD3650E94
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 16:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiLSP0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 10:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiLSP0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 10:26:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F40767D
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 07:26:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F34E861007
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 15:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AAEC433EF;
        Mon, 19 Dec 2022 15:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671463571;
        bh=Hu3FgL4IL2JBUaBE8gcwEdnNOK9X7aQnS/FovjtJwVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sLmlZ4DJOz+bov2ywGFmpGv2cnN9MmEWec4sgfMw02D/jehX/d0/+5kJ8laLaysM/
         KbWRAF4qtYRmG68V0ULPUWIjQqNbL8qecPsp5uDqLkPkOURdxruVfWcjodPW1deGjb
         e84/P3TY/X6+AZ+pP8/JXdvyRfb0dj/MjUCU+bPFKrw/TAHQuOGeNYPe/VXj3oyvsG
         4WHgx5wcqJtfPmMKfMGqi8w/XY0WLdPQIailN61lYb5u1mSrQ3icCVIZq6fsH6TM5k
         1IV5yDtm5zqQNCGomQIpaBmeX5LLXUhGrGSiy2D+Rw3L8u1uVVw2K56ryTxfxNv4IL
         /1tVZYHtYUtrw==
Date:   Mon, 19 Dec 2022 08:26:09 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>, llvm@lists.linux.dev,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <shuah@kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: Linux-stable-rc/ queue_5.10
Message-ID: <Y6CCkWLcNZMqN8UV@dev-arch.thelio-3990X>
References: <CA+G9fYs=G_AAbkNOfLv7Oyvt6uOZ8CYun8fUQ-GghoKtbD5WAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs=G_AAbkNOfLv7Oyvt6uOZ8CYun8fUQ-GghoKtbD5WAw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Naresh,

On Mon, Dec 19, 2022 at 08:47:32PM +0530, Naresh Kamboju wrote:
> The MIPS tinyconfig with clang nightly  build failed,
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build warnings / errors,
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=0
> ARCH=mips CROSS_COMPILE=mips-linux-gnu- HOSTCC=clang CC=clang
> tinyconfig
> 
> /tmp/calibrate-9ea8cf.s: Assembler messages:
> /tmp/calibrate-9ea8cf.s:134: Error: .module is not permitted after
> generating code
> /tmp/calibrate-9ea8cf.s:168: Error: .module is not permitted after
> generating code
> /tmp/calibrate-9ea8cf.s:192: Error: .module is not permitted after
> generating code
> /tmp/calibrate-9ea8cf.s:216: Error: .module is not permitted after
> generating code
> clang: error: assembler command failed with exit code 1 (use -v to see
> invocation)
> make[2]: *** [/builds/linux/scripts/Makefile.build:286:
> init/calibrate.o] Error 1

Thanks for the report. This is a toolchain regression that should
hopefully be resolved soon:

https://reviews.llvm.org/D138179#4002068

https://reviews.llvm.org/D140270

Cheers,
Nathan
