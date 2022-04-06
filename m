Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F47C4F6AEC
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiDFULf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbiDFULI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:11:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E410652FA;
        Wed,  6 Apr 2022 11:13:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 317BEB8252B;
        Wed,  6 Apr 2022 18:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555C0C385A3;
        Wed,  6 Apr 2022 18:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649268819;
        bh=QMVfExX2amMvHMtMH2GP6BV4ahQ74qFyqqVQ9KVADKw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nVLUe7kjQEhu47BJhERVDSXy36Yev3KQsjVkpGHx4Xhpkkjbfpx+xmOXrE0vwvRH1
         izDi+3ku6R7AFPmW3NTCcJkcIWmMPWwHpQi5D65PUOkQaTLvTVm9zcgMF1Hzqcdrv/
         apzPtGjoyfCVSk3vOs4spS75LuzT+ireuOcoiQ84=
Date:   Wed, 6 Apr 2022 20:13:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     guoren@kernel.org
Cc:     arnd@arndb.de, palmer@dabbelt.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        Guo Ren <guoren@linux.alibaba.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH V3] riscv: patch_text: Fixup last cpu should be master
Message-ID: <Yk3YUFfvEszb+cXT@kroah.com>
References: <20220406141649.728971-1-guoren@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406141649.728971-1-guoren@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 06, 2022 at 10:16:49PM +0800, guoren@kernel.org wrote:
> From: Guo Ren <guoren@linux.alibaba.com>
> 
> These patch_text implementations are using stop_machine_cpuslocked
> infrastructure with atomic cpu_count. The original idea: When the
> master CPU patch_text, the others should wait for it. But current
> implementation is using the first CPU as master, which couldn't
> guarantee the remaining CPUs are waiting. This patch changes the
> last CPU as the master to solve the potential risk.
> 
> Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
> Signed-off-by: Guo Ren <guoren@kernel.org>
> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
> Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/riscv/kernel/patch.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

What commit id does this change fix?

