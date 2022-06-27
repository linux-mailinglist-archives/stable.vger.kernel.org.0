Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0CF55CEC9
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbiF0LCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbiF0LCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:02:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ED064CE
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 04:02:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23EA8B8108B
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 11:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C72C3411D;
        Mon, 27 Jun 2022 11:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656327727;
        bh=u6DhajP/0ySLcLIFRsTW3HROjv9eEG340EDccWiuabg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dYJPSJzkXBLVdJz45NpifduJ+MTqvOx1U9MaJtv2tRgVY7L1B1hKBmcjs2FYYl2hY
         +UrclJyvBaUMCmX6q6d5ADAAgGTc8b2QMFXE6g2199goJ2sPIQY0Oe5+WxYLQmR1iX
         ahTW5+IRHvHTzx/5LOP44JZwi00aYXzqsckZpai4=
Date:   Mon, 27 Jun 2022 13:02:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH stable 5.18 5.15 5.10 5.4] powerpc/pseries: wire up rng
 during setup_arch()
Message-ID: <YrmOLfbRIJuTnaOV@kroah.com>
References: <165632300131233@kroah.com>
 <20220627100158.526135-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627100158.526135-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 12:01:58PM +0200, Jason A. Donenfeld wrote:
> commit e561e472a3d441753bd012333b057f48fef1045b upstream.
> 
> The platform's RNG must be available before random_init() in order to be
> useful for initial seeding, which in turn means that it needs to be
> called from setup_arch(), rather than from an init call. Fortunately,
> each platform already has a setup_arch function pointer, which means
> it's easy to wire this up. This commit also removes some noisy log
> messages that don't add much.
> 
> Fixes: a489043f4626 ("powerpc/pseries: Implement arch_get_random_long() based on H_RANDOM")
> Cc: stable@vger.kernel.org # v3.13+
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Link: https://lore.kernel.org/r/20220611151015.548325-4-Jason@zx2c4.com
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  arch/powerpc/platforms/pseries/pseries.h |  2 ++
>  arch/powerpc/platforms/pseries/rng.c     | 11 +++--------
>  arch/powerpc/platforms/pseries/setup.c   |  2 ++

All now queued up, thanks.

greg k-h
