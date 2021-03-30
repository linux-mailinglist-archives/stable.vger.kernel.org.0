Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CF634EF45
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 19:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhC3RVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 13:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231650AbhC3RVj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Mar 2021 13:21:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C0CD619CD;
        Tue, 30 Mar 2021 17:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617124899;
        bh=7sR/yPFFyOwNvllvver8gm6SBuRY88GJZHFdgc+NA5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F3jqYA5ozO+5Ut6Fbkgj+1LV/d5JFgttUPvLWg47XSlbGOaYzc7uT4GordORe7GEA
         w2s9aegvN8rY6RVS77t4Y8zTUzbtOAa8q/xmxg7wzQufwc6nQIMsHgEZJJPvQf1/1P
         DF8EnJv+aaY5igb+gnnl5P2YySprN0eCSMLzTNQv4MdBNR9q8fxvfvhZDJCu37YVTW
         TgDUEZlSCRi926kn7g0YKn1ELPoVtnesLKNiVV/5AHSwx5q0/YSEe87JTnaccI+J8H
         m0+1HpkB49ys4ytZBOd1ZKVL879+ZWy83X7ch7j9L1P7kk7xksyt0TGlc+uazPfTYH
         48slTggqYVUcg==
Date:   Tue, 30 Mar 2021 13:21:38 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Zidenberg, Tsahi" <tsahee@amazon.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] bpf: fix userspace access for bpf_probe_read{, str}()
Message-ID: <YGNeIhMNjQ0RGUGr@sashalap>
References: <56be4b97-8283-cf09-4dac-46d602cae97c@amazon.com>
 <358062d4-fdf8-f3da-fd8e-c55cf1a089ec@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <358062d4-fdf8-f3da-fd8e-c55cf1a089ec@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 29, 2021 at 01:58:21PM +0300, Zidenberg, Tsahi wrote:
>commit 8d92db5c04d10381f4db70ed99b1b576f5db18a7 upstream.
>
>This is an adaptation of parts from above commit to kernel 5.4.

This is very different from the upstream commit, let's not annotate it
as that commit.

>bpf_probe_read{,str}() BPF helpers are broken on arm64, where user
>addresses cannot be accessed with normal kernelspace access.
>
>Upstream solution got into v5.8 and cannot directly be cherry picked. We
>implement the same mechanism in kernel 5.4.
>
>Detection is only enabled for machines with non-overlapping address spaces
>using CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE from commits:
>commit 0ebeea8ca8a4 ("bpf: Restrict bpf_probe_read{, str}() only to archs where they work")
>commit d195b1d1d119 ("powerpc/bpf: Enable bpf_probe_read{, str}() on powerpc again")
>
>To generally fix the issue, upstream includes new BPF helpers:
>bpf_probe_read_{user,kernel}_str(). For details on them, see
>commit 6ae08ae3dea2 ("bpf: Add probe_read_{user, kernel} and probe_read_{user, kernel}_str helpers")

What stops us from taking that API back to 5.4? I took a look at the
dependencies and they don't look too scary.

Can we try that route instead? We really don't want to diverge from
upstream that much.

-- 
Thanks,
Sasha
