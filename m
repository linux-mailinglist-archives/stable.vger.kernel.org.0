Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8852426A046
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 09:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgIOH4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 03:56:30 -0400
Received: from smtp1.axis.com ([195.60.68.17]:5137 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbgIOHzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 03:55:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=863; q=dns/txt; s=axis-central1;
  t=1600156512; x=1631692512;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dek4fR23kmKc++Zq4K5OD1kLxJx46nFtzBjeQtXIDjE=;
  b=L05k4WGzUjbzT+9weU1zOXUhZjFzFFR1e+gA9WkTNBW++ldtdD4M/0H5
   mgyFWcFj87YYxAlbVX97sfGoqfhTlROmgklm+P+JKZtY/PnO2vE9zig/D
   GWhG2oVzq/vDXrzadJNMaF8H0IhFEiRnPSE0+RO4N/ey4tQSvj+M1C1NX
   tq8hl9OWF5PoxeuIjVYcHgehQxDx+tLNrzh5Dan0wXutNwHIO0f/rSQU3
   SY3P+mK+mtgKXKMQ37vg1SMPfxra71TM7itQEUv2GNH2pFvXjCkjqsxnT
   2btYPhoE9Ppd7Gw4veUt7FifJd5DLHd79rA7xTeTxxTsSgBUoUjXebYce
   g==;
IronPort-SDR: AeBkFv28uQdtChy5yxUo/ve3jrM7azum7NqSNhk7vZOwDByLH5y9a4dTS5tYmq9Oj0LEZjNkVX
 bVo42MYLOadQzw03FQK/cgtqnavf7SgQ10+Ote5D2Q0p+Eco+6BCuimwkSHDmlJSOD5sKHPz8l
 VPVNXNiDH4/sXQ5tzkqBmqtEgmdVwA5iivF8YhQwmiDZwAot+2WM0qoH2FngFzYt4t/vI+D3zj
 h/jJDGnhDBUfMHPESefBH7UddZ1v6xxQgsskt7uvfWzhtLI3QBNor7x73pwzrowy9rfAb6T/vT
 vVc=
X-IronPort-AV: E=Sophos;i="5.76,429,1592863200"; 
   d="scan'208";a="12945543"
Date:   Tue, 15 Sep 2020 09:55:08 +0200
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH AUTOSEL 4.14 05/15] regulator: pwm: Fix machine
 constraints application
Message-ID: <20200915075508.jddoubwnptjcqtru@axis.com>
References: <20200914130526.1804913-1-sashal@kernel.org>
 <20200914130526.1804913-5-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200914130526.1804913-5-sashal@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 14, 2020 at 03:05:16PM +0200, Sasha Levin wrote:
> From: Vincent Whitchurch <vincent.whitchurch@axis.com>
> 
> [ Upstream commit 59ae97a7a9e1499c2070e29841d1c4be4ae2994a ]
> 
> If the zero duty cycle doesn't correspond to any voltage in the voltage
> table, the PWM regulator returns an -EINVAL from get_voltage_sel() which
> results in the core erroring out with a "failed to get the current
> voltage" and ending up not applying the machine constraints.
> 
> Instead, return -ENOTRECOVERABLE which makes the core set the voltage
> since it's at an unknown value.

For this patch to work it needs 84b3a7c9c6befe5ab4d49070fe7 ("regulator:
core: Allow for regulators that can't be read at bootup") which was
merged in v4.18.  Without that this patch is not going to have any
effect so it probably shouldn't be backported to older kernels.
