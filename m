Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D880A65F362
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 19:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbjAESFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 13:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235589AbjAESEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 13:04:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DEB63389;
        Thu,  5 Jan 2023 10:04:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D1CC61BF2;
        Thu,  5 Jan 2023 18:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B540DC43392;
        Thu,  5 Jan 2023 18:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672941857;
        bh=MWzvNqHeXhu0ygnjZOdIpCpfRnQM6QUhfxgrbv5GoMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HyJLvjyve72FMAI4+BEgu0r45b53vrWabuX7QMfmvaXSYc2DXEJ63Zg1zgaSSB/6n
         y8vEQxSaam3H5jgW+4BGmWnsXesnJirEU9ZrNyfsuYJRBCccF+ijPVqSxXJfHyLpE6
         Yd1cIlTw0RHBhxFlB++sLcX6xs/6rzjmJT8CQG0vyO9ujyKFnrFQhHsxwXMiRvYTxA
         fHLnStI5pVUPpvU1DgxBhNeR4t40w/xxTcLt+LwmDsLrEBuN9Bqv4/6C9gx28NvNaq
         oeW5tYjBUIiKFzmR+dKVHOqxwd1Um0RmSgzeF4eFDW9GLTrJhccCQO6wiyf4K7devG
         7/EON2ZFrxHzQ==
From:   Will Deacon <will@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>,
        peterz@infradead.org, boqun.feng@gmail.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        arnd@arndb.de, steve.capper@arm.com
Subject: Re: [PATCH] arm64: cmpxchg_double*: hazard against entire exchange variable
Date:   Thu,  5 Jan 2023 18:04:00 +0000
Message-Id: <167293249648.1466799.3332324417306480778.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230104151626.3262137-1-mark.rutland@arm.com>
References: <20230104151626.3262137-1-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 4 Jan 2023 15:16:26 +0000, Mark Rutland wrote:
> The inline assembly for arm64's cmpxchg_double*() implementations use a
> +Q constraint to hazard against other accesses to the memory location
> being exchanged. However, the pointer passed to the constraint is a
> pointer to unsigned long, and thus the hazard only applies to the first
> 8 bytes of the location.
> 
> GCC can take advantage of this, assuming that other portions of the
> location are unchanged, leading to a number of potential problems.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: cmpxchg_double*: hazard against entire exchange variable
      https://git.kernel.org/arm64/c/031af50045ea

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
