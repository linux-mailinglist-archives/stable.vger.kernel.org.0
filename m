Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB544C16CE
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 16:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239592AbiBWPbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 10:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbiBWPbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 10:31:55 -0500
X-Greylist: delayed 313 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 23 Feb 2022 07:31:26 PST
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6DFF657AB;
        Wed, 23 Feb 2022 07:31:26 -0800 (PST)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 21NFRJFj001983;
        Wed, 23 Feb 2022 09:27:19 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 21NFRJU4001982;
        Wed, 23 Feb 2022 09:27:19 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Wed, 23 Feb 2022 09:27:19 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     mpe@ellerman.id.au, Arnd Bergmann <arnd@arndb.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/3] powerpc: lib: sstep: fix build errors
Message-ID: <20220223152719.GF614@gate.crashing.org>
References: <20220223135820.2252470-1-anders.roxell@linaro.org> <20220223135820.2252470-3-anders.roxell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223135820.2252470-3-anders.roxell@linaro.org>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 23, 2022 at 02:58:20PM +0100, Anders Roxell wrote:
> Building tinyconfig with gcc (Debian 11.2.0-16) and assembler (Debian
> 2.37.90.20220207) the following build error shows up:
> 
> {standard input}: Assembler messages:
> {standard input}:10576: Error: unrecognized opcode: `stbcx.'
> {standard input}:10680: Error: unrecognized opcode: `lharx'
> {standard input}:10694: Error: unrecognized opcode: `lbarx'
> 
> Rework to add assembler directives [1] around the instruction.  The
> problem with this might be that we can trick a power6 into
> single-stepping through an stbcx. for instance, and it will execute that
> in kernel mode.
> 
> [1] https://sourceware.org/binutils/docs/as/PowerPC_002dPseudo.html#PowerPC_002dPseudo

Wow, no wonder you think you need quotes after reading that.  I'll try
to get that fixed.

Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>


Segher
