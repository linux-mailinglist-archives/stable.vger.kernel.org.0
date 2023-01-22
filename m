Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1FBC676D9A
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 15:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjAVOUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 09:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjAVOUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 09:20:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189C3144B7
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 06:20:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A858560BEA
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9BCC433EF;
        Sun, 22 Jan 2023 14:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674397232;
        bh=BGI8qTu84xmdmfjSVwwyMx+F6ROgPbQTXH4F97nRO/Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d1neSeGZUsFN7L4iz6Z9b8oY5lgXiUOavHD10F+pYhHJJlUm7SezX+pwLIeT+e8A7
         HuD5spWCDNbLIRgOIzyTPbH2DpMdVG9WiNoETjrBoNKILdkqlJAifIf7iAvpjIStos
         5ytDXzKLo3PGCZi9LNv/kje2Hih7TDFLtx9AAj10=
Date:   Sun, 22 Jan 2023 15:20:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        llvm@lists.linux.dev, Nick Desaulniers <ndesaulniers@google.com>,
        YingChi Long <me@inclyc.cn>, Borislav Petkov <bp@alien8.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: offsetof() backports for clang-16+
Message-ID: <Y81GLTbxc5NY6chR@kroah.com>
References: <Y8TWrJpb6Vn6E4+v@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8TWrJpb6Vn6E4+v@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 15, 2023 at 09:46:36PM -0700, Nathan Chancellor wrote:
> Hi Greg and Sasha,
> 
> Clang 16 (current main, next major release) errors when offsetof() has a
> type defintion in it, in response to language in newer C standards
> stating it is undefined behavior.
> 
> https://github.com/llvm/llvm-project/commit/e327b52766ed497e4779f4e652b9ad237dfda8e6
> https://reviews.llvm.org/D133574
> 
> While this might be eventually demoted to just a warning, the kernel has
> already cleaned up places that had this construct, so we can apply them
> to the stable trees and avoid the issue altogether.
> 
> Please find attached mbox files for all supported stable trees, which
> fix up the relevant instances for each tree using the upstream commits:
> 
> 55228db2697c ("x86/fpu: Use _Alignof to avoid undefined behavior in TYPE_ALIGN")
> 09794a5a6c34 ("tracing: Use alignof__(struct {type b;}) instead of offsetof()")
> 
> The fpu commit uses _Alignof, which as far as I can tell was only
> supported in GCC 4.7.0+. This is not a problem for mainline due to
> requiring GCC 5.1.0+ but it could be relevant for old trees like 4.14,
> which have an older minimum supported version. I hope people are not
> using ancient compilers like that but I suppose if they are using 4.14,
> they might just be stuck with old software...
> 
> If there are any issues or comments, please let me know.

Now queued up, thanks.

greg k-h
