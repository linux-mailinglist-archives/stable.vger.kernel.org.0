Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318EB480E21
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 01:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237949AbhL2ANm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Dec 2021 19:13:42 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38696 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbhL2ANm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Dec 2021 19:13:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C08FCB817AC;
        Wed, 29 Dec 2021 00:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6ABC36AEB;
        Wed, 29 Dec 2021 00:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640736819;
        bh=ltf/WPwx84zE0R9Hac2MImwYjCf5Sw4Yb6miKnuNiT4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GqmK1PICVAM4e7Eom9aL+Rf/z6ZrZ09XIAhJ8oM0ZLDn5x5vWes/x5Bk8+U5auBKt
         dwTg3uHRzd/voyf/g+4ME/fXQgu3Xkw8WJ7H+vUOwdO7VQP/SUH+T7TqgVsf+lzuf3
         hUflNSQeT+wCZUOHEU98Xn3DYgwLdqNAaJUu0Cd8t/0qzWH3wA5sZL9nd7sMb1MB/Y
         gUFReqQVWt0TNf0tRhcZe/MQf8rooE3khq6hRYed3Hd7+KFhh/lhbpthKfToZ7R9Ci
         KCq9Y8j0bWzhWEVfNaJD8GQz9HLV5nZQv6Qm6Y1/QD07eDkiqJo/knjLghvReGgWIy
         4ZZuH88itpVuw==
Date:   Wed, 29 Dec 2021 02:13:37 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     peterhuewe@gmx.de, jgg@ziepe.ca, p.rosenberger@kunbus.com,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] tpm: fix potential NULL pointer access in
 tpm_del_char_device
Message-ID: <YcuoMVn3eWm1fcLp@iki.fi>
References: <20211220150635.8545-1-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220150635.8545-1-LinoSanfilippo@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 04:06:35PM +0100, Lino Sanfilippo wrote:
> Some SPI controller drivers unregister the controller in the shutdown
> handler (e.g. BCM2835). If such a controller is used with a TPM 2 slave
> chip->ops may be accessed when it is already NULL:
> 
> At system shutdown the pre-shutdown handler tpm_class_shutdown() shuts down
> TPM 2 and sets chip->ops to NULL. Then at SPI controller unregistration
> tpm_tis_spi_remove() is called and eventually calls tpm_del_char_device()
> which tries to shut down TPM 2 again. Thereby it accesses chip->ops again:
> (tpm_del_char_device calls tpm_chip_start which calls tpm_clk_enable which
> calls chip->ops->clk_enable).
> 
> Avoid the NULL pointer access by testing if chip->ops is valid and skipping
> the TPM 2 shutdown procedure in case it is NULL.
> 
> Fixes: dcbeab1946454 ("tpm: fix crash in tpm_tis deinitialization")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

Thank you.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR,
Jarkko
