Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9A931428A
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 23:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhBHWHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 17:07:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230090AbhBHWHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 17:07:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DA0664E27;
        Mon,  8 Feb 2021 22:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612822034;
        bh=d45fruyMe2LIRicqFUcbjfSPAJ46rlT885i916wbg1M=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=Rs/SGVlc5JYIWflp/bjz/2kv7Uf1Wopy2HTaSlo5yvxmjcx03ByKlXeJA4I3EZFx0
         0TIZZuY/TVTqaNtl1sjKQ9jP0jlB914X6JY40yQGOqRJO+nLq403dOcGt0r06mTxf4
         5sIAqMmgtFm5cau9bko2C0wJ5k3RdnEjcC9a+glDrQLIXVLcc3roEuoRyMUCW78r3J
         5fDZ7TXSfC3QRdMcqjREvl7Pf81ICj7YFN4ui9/p358cgzui19iRDpfoSPLtQuDPYF
         jJQgJPQULDCXSOOQEyREvnsEJYXkytV7uzeUQy85yUALxtIA0eCiHeyoVibDN+72kK
         L7Uy7fJLn0tAw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <1612812784-26369-1-git-send-email-subbaram@codeaurora.org>
References: <1612812784-26369-1-git-send-email-subbaram@codeaurora.org>
Subject: Re: [PATCH] spmi: spmi-pmic-arb: Fix hw_irq overflow
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>,
        Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        stable@vger.kernel.org
To:     Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        linux-kernel@vger.kernel.org
Date:   Mon, 08 Feb 2021 14:07:12 -0800
Message-ID: <161282203270.4168818.14030280893762596656@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Subbaraman Narayanamurthy (2021-02-08 11:33:04)
> Currently, when handling the SPMI summary interrupt, the hw_irq
> number is calculated based on SID, Peripheral ID, IRQ index and
> APID. This is then passed to irq_find_mapping() to see if a
> mapping exists for this hw_irq and if available, invoke the
> interrupt handler. Since the IRQ index uses an "int" type, hw_irq
> which is of unsigned long data type can take a large value when
> SID has its MSB set to 1 and the type conversion happens. Because
> of this, irq_find_mapping() returns 0 as there is no mapping
> for this hw_irq. This ends up invoking cleanup_irq() as if
> the interrupt is spurious whereas it is actually a valid
> interrupt. Fix this by using the proper data type (u32) for id.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
> ---

Applied to spmi-next
