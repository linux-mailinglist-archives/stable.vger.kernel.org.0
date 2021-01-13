Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FDE2F505D
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 17:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbhAMQtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 11:49:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727763AbhAMQtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 Jan 2021 11:49:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEAC3233F6;
        Wed, 13 Jan 2021 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610556510;
        bh=DnL73vKlQSXlWUYZg/eWP8NDNE5x28qj3Gv+Ku3NoTo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pkt1JARf98QPcGtbmKSASRKHfIk/DDZqSGH/Ea6KdL1TrPgS1tVUCvpA9nS+EbYF0
         qRri12p1oAw6iljdnizhmnxTMTBMv1vSLMmzmW1BsDXnOLLWc9SffaIGwDBSZ9r3D4
         UICd50FGkKfHNxkKMJdW6Il71G+UfH7J1L0TWu5kRQKV2KAEq/ynHMgMis7KFEkFcp
         oqkW38Qy5qmJLmnglO9YCoxAbpPyWNq5n5v6MhFCf+hnEi0IkllNrMa8SWJ8l+fqvO
         MbZCADTuC8e+CsVAxdOhxEk9G0/Xhaq52GtdqPKZeQRH9by3FlbrWA8b1xObyQCNR6
         BRX0ICm1+A96g==
Date:   Wed, 13 Jan 2021 11:48:28 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH for 4.9/4.14] powerpc: Fix incorrect stw{, ux, u, x}
 instructions in __set_pte_at
Message-ID: <20210113164828.GQ4035784@sasha-vm>
References: <af07f8f0bb734bc1f906c1f79219f81c13c6ad2c.1610521804.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <af07f8f0bb734bc1f906c1f79219f81c13c6ad2c.1610521804.git.christophe.leroy@csgroup.eu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 13, 2021 at 07:12:44AM +0000, Christophe Leroy wrote:
>From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>
>Backport for 4.9 and 4.14
>
>(cherry picked from commit d85be8a49e733dcd23674aa6202870d54bf5600d)
>
>The placeholder for instruction selection should use the second
>argument's operand, which is %1, not %0. This could generate incorrect
>assembly code if the memory addressing of operand %0 is a different
>form from that of operand %1.
>
>Also remove the %Un placeholder because having %Un placeholders
>for two operands which are based on the same local var (ptep) doesn't
>make much sense. By the way, it doesn't change the current behaviour
>because "<>" constraint is missing for the associated "=m".
>
>[chleroy: revised commit log iaw segher's comments and removed %U0]
>
>Fixes: 9bf2b5cdc5fe ("powerpc: Fixes for CONFIG_PTE_64BIT for SMP support")
>Cc: <stable@vger.kernel.org> # v2.6.28+
>Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
>Acked-by: Segher Boessenkool <segher@kernel.crashing.org>
>Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>Link: https://lore.kernel.org/r/96354bd77977a6a933fe9020da57629007fdb920.1603358942.git.christophe.leroy@csgroup.eu

I took this and the 4.4 backport, thanks!

-- 
Thanks,
Sasha
