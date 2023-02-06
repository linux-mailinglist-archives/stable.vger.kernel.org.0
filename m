Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9F468B54D
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 06:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjBFFkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 00:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBFFkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 00:40:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15529199D2;
        Sun,  5 Feb 2023 21:40:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 861A460C86;
        Mon,  6 Feb 2023 05:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F0FC433D2;
        Mon,  6 Feb 2023 05:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675662020;
        bh=GLINtM976v7wnJDP6drxyIgyjq9HzOGB48Ep5iyHurc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Llhf7WCls7W3D7CzLM63GJC9Khe7zzrP3EJ1sVS71VDRg89IGP2/lKGYKOWxuGqRd
         YAKo13TWIOBFE4mLiLg49fDIQsMSg+tu8VFBiuW2wA25q+accrviidObxcQamhTByB
         /d7HG5fP9X1UGSh+JVVPEOWDpb3s5cXL5Q1d+OCk=
Date:   Mon, 6 Feb 2023 06:40:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xinghui Li <korantwork@gmail.com>
Cc:     peterz@infradead.org, jpoimboe@redhat.com, tglx@linutronix.de,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, alexs@kernel.org
Subject: Re: [bug report]warning about entry_64.S from objtool in v5.4 LTS
Message-ID: <Y+CSwTDESQjTzS8S@kroah.com>
References: <CAEm4hYXr28O8TOmZWEKfp-00Y9R7Ky7C6X3JTtfm-0AD42KbrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEm4hYXr28O8TOmZWEKfp-00Y9R7Ky7C6X3JTtfm-0AD42KbrA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 06, 2023 at 11:09:48AM +0800, Xinghui Li wrote:
> Hi all
> We found a warning from objtool:
> arch/x86/entry/entry_64.o: warning: objtool: .entry.text+0x1d1:
> unsupported intra-function call
> 
> and if we enable retpoline in config:
> arch/x86/entry/entry_64.o: warning: objtool: .entry.text+0x1c1:
> unsupported intra-function call
> arch/x86/entry/entry_64.o: warning: objtool: If this is a retpoline,
> please patch it in with alternatives and annotate it with
> ANNOTATE_NOSPEC_ALTERNATIVE.
> 
> I found this issue has been introduced since “x86/speculation: Change
> FILL_RETURN_BUFFER to work with objtool( commit 8afd1c7da2)”backported
> in v5.4.217.
> Comparing with the upstream version(commit 089dd8e53):
> There is no “ANNOTATE_INTRA_FUNCTION_CALL” in v5.4 for missing
> dependency patch. When the “ANNOTATE_NOSPEC_ALTERNATIVE” is removed,
> this issue just occurs.
> 
> I tried to backport “ANNOTATE_INTRA_FUNCTION_CALL”and its dependency
> patchs in v5.4, but I met the CFA miss match issue from objtool.
> So, please help check this issue in v5.4 LTS version.

If you rely on the 5.4.y kernel tree, and you need this speculation
fixes and feel this is a real problem, please provide some backported
patches to resolve the problem.

It's been reported many times in the past, but no one seems to actually
want to fix this bad enough to send in a patch :(

Usually people just move to a newer kernel, what is preventing you from
doing that right now?

thanks,

greg k-h
