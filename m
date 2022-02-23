Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008BC4C180E
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 17:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242578AbiBWQEM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 11:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiBWQEM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 11:04:12 -0500
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CADC7C1149;
        Wed, 23 Feb 2022 08:03:44 -0800 (PST)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 21NFM0DW001673;
        Wed, 23 Feb 2022 09:22:00 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 21NFLvej001668;
        Wed, 23 Feb 2022 09:21:57 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Wed, 23 Feb 2022 09:21:57 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     mpe@ellerman.id.au, Arnd Bergmann <arnd@arndb.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3] powerpc: fix build errors
Message-ID: <20220223152157.GE614@gate.crashing.org>
References: <20220223135820.2252470-1-anders.roxell@linaro.org> <20220223135820.2252470-2-anders.roxell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223135820.2252470-2-anders.roxell@linaro.org>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

On Wed, Feb 23, 2022 at 02:58:19PM +0100, Anders Roxell wrote:
> Building tinyconfig with gcc (Debian 11.2.0-16) and assembler (Debian
> 2.37.90.20220207) the following build error shows up:
> 
>  {standard input}: Assembler messages:
>  {standard input}:1190: Error: unrecognized opcode: `stbcix'
>  {standard input}:1433: Error: unrecognized opcode: `lwzcix'
>  {standard input}:1453: Error: unrecognized opcode: `stbcix'
>  {standard input}:1460: Error: unrecognized opcode: `stwcix'
>  {standard input}:1596: Error: unrecognized opcode: `stbcix'
>  ...
> 
> Rework to add assembler directives [1] around the instruction. Going
> through the them one by one shows that the changes should be safe.  Like
> __get_user_atomic_128_aligned() is only called in p9_hmi_special_emu(),
> which according to the name is specific to power9.  And __raw_rm_read*()
> are only called in things that are powernv or book3s_hv specific.

Thanks for doing this.

> +	__asm__ __volatile__(".machine \"push\"\n"
> +			     ".machine \"power6\"\n"
> +			     "stbcix %0,0,%1\n"
> +			     ".machine \"pop\"\n"

Just leave out the quotes completely?  Assembler is not C, barewords are
normal and expected and better style.

Other than that this looks perfect to me :-)

Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>


Segher
