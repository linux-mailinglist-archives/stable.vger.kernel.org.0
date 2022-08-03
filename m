Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1561B588BBA
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 14:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237718AbiHCMDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 08:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234698AbiHCMDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 08:03:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE081A076
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 05:03:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A088611F3
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 12:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557C1C433C1;
        Wed,  3 Aug 2022 12:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659528212;
        bh=Q+2umkDv0DLuM2z7gXjt4cX9Ia/aOeWJ6SMeUjhR5XA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xe51DTe/uI4gqs0JKUoIa0Ut9QYzJ6jkCr5eVaeIsdTeEZr/fwd/oMyqKTU2eyLya
         bHYydUW9iqo4TeSn/FEhrbhtHeodl7zuCyFyOHnCSi1chXEqh2FoYk/JYxWxhA6tUU
         HWgYLq2mooeIMqyJuhWlJZGHZCl6AynggiPX53T8=
Date:   Wed, 3 Aug 2022 14:03:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH 5.10 1/2] selftests/bpf: Extend verifier and bpf_sock
 tests for dst_port loads
Message-ID: <YupkBhps9wUcNnya@kroah.com>
References: <20220801145703.1929060-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801145703.1929060-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 01, 2022 at 05:57:02PM +0300, Ovidiu Panait wrote:
> From: Jakub Sitnicki <jakub@cloudflare.com>
> 
> commit 8f50f16ff39dd4e2d43d1548ca66925652f8aff7 upstream.
> 
> Add coverage to the verifier tests and tests for reading bpf_sock fields to
> ensure that 32-bit, 16-bit, and 8-bit loads from dst_port field are allowed
> only at intended offsets and produce expected values.
> 
> While 16-bit and 8-bit access to dst_port field is straight-forward, 32-bit
> wide loads need be allowed and produce a zero-padded 16-bit value for
> backward compatibility.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> Link: https://lore.kernel.org/r/20220130115518.213259-3-jakub@cloudflare.com
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> [OP: backport to 5.10: adjusted context in sock_fields.c]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
> This series fixes the following bpf verfier selftest failures:
> root@intel-x86-64:~# ./test_verifier
> ...
> #908/u sk_fullsock(skb->sk): sk->dst_port [load 2nd byte] FAIL
> #908/p sk_fullsock(skb->sk): sk->dst_port [load 2nd byte] FAIL

All now queued up, thanks.

gre gk-h
