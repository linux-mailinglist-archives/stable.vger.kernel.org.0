Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CBD409E1D
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 22:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbhIMU07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 16:26:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230404AbhIMU07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 16:26:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF2BF60F6D;
        Mon, 13 Sep 2021 20:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631564743;
        bh=LmrkTXGLxqB3M/lZRSixfuJmMep+oIFHcEcQHLhWbjo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bD0zV2AERL5+aWB0mht7HUBamoM+bg9Z4FTvRtjXvTGx8zrRPu61rq7ijHH8QVAcv
         rhtSnNWadVBvrAQ//PXe+cP31aD9YmpmH+hLTF+pS3kMq93BWzdJ6YRLoagobDFbF7
         nBtK0pZ9CmFnlrnjsFjM8ZjBZg4yXII6Nk2wq8M/gMRaRy0/Bn0yggPHhDxiOekg+S
         reiJycM5+TwKDL7tOc0JsBQBfqB9DbtLQ3tk9HWtwZuhSFHCJyBx/DvHtkzaKIYAra
         Eh0XzrixDikjqQFMy62i7vXG7b0QQ8HjWmd1MfrRQyeu6wln+mSMNkT15ziQVI3Xx7
         6F35FAXinP0/w==
Message-ID: <204a438b6db54060d03689389d6663b0d4ca815d.camel@kernel.org>
Subject: Re: [PATCH] tpm: fix potential NULL pointer access in
 tpm_del_char_device()
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        jgg@ziepe.ca
Cc:     p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Mon, 13 Sep 2021 23:25:40 +0300
In-Reply-To: <20210910180451.19314-1-LinoSanfilippo@gmx.de>
References: <20210910180451.19314-1-LinoSanfilippo@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-09-10 at 20:04 +0200, Lino Sanfilippo wrote:
> In tpm_del_char_device() make sure that chip->ops is still valid.
> This check is needed since in case of a system shutdown
> tpm_class_shutdown() has already been called and set chip->ops to NULL.
> This leads to a NULL pointer access as soon as tpm_del_char_device()
> tries to access chip->ops in case of TPM 2.
>=20
> Fixes: dcbeab1946454 ("tpm: fix crash in tpm_tis deinitialization")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> ---

Have you been able to reproduce this in some environment?

/Jarkko

