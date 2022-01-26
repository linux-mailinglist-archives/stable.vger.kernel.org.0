Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E28549D220
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 19:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbiAZS53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 13:57:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48890 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240700AbiAZS52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 13:57:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B16E4B81FB3;
        Wed, 26 Jan 2022 18:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D5AC340E3;
        Wed, 26 Jan 2022 18:57:24 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Robin Murphy <robin.murphy@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] arm64: extable: fix load_unaligned_zeropad() reg indices
Date:   Wed, 26 Jan 2022 18:57:21 +0000
Message-Id: <164322343553.819367.16239308759447224919.b4-ty@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220125182217.2605202-1-eugenis@google.com>
References: <20220125182217.2605202-1-eugenis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 25 Jan 2022 10:22:17 -0800, Evgenii Stepanov wrote:
> In ex_handler_load_unaligned_zeropad() we erroneously extract the data and
> addr register indices from ex->type rather than ex->data. As ex->type will
> contain EX_TYPE_LOAD_UNALIGNED_ZEROPAD (i.e. 4):
>  * We'll always treat X0 as the address register, since EX_DATA_REG_ADDR is
>    extracted from bits [9:5]. Thus, we may attempt to dereference an
>    arbitrary address as X0 may hold an arbitrary value.
>  * We'll always treat X4 as the data register, since EX_DATA_REG_DATA is
>    extracted from bits [4:0]. Thus we will corrupt X4 and cause arbitrary
>    behaviour within load_unaligned_zeropad() and its caller.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64: extable: fix load_unaligned_zeropad() reg indices
      https://git.kernel.org/arm64/c/afa1bf69aac3

-- 
Catalin

