Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E369C118169
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 08:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfLJHfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 02:35:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727004AbfLJHfR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 02:35:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D52E0206D5;
        Tue, 10 Dec 2019 07:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575963316;
        bh=Iwy41E1412qtJu4yL8Z2Y4kyV3cWQwGQ/BeHqr5pOZ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PTKtNDLZfTgVtZJErUc6lRjjDbc/nUMR0w1IQR+64FJSqsjaTxqfcVusM+q01kntT
         nCrJIkMPSXeMnz/nj+GCGm3ytZQ+1W8tIx9dRGIx/qFkVv65YQfw/AS77jhyzCtdxH
         UqA8fO79zYjwh6lMsvSN5zpvFPbKzyA4/7Q47J3M=
Date:   Tue, 10 Dec 2019 08:35:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>
Subject: Re: Linux 4.19.89-rc1 5944fcdd errors
Message-ID: <20191210073514.GB3077639@kroah.com>
References: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191209173637.GF1290729@kroah.com>
 <TYAPR01MB2285135B15E6A152163E1A1AB7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB2285135B15E6A152163E1A1AB7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 09, 2019 at 09:56:29PM +0000, Chris Paterson wrote:
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 09 December 2019 17:37
> > 
> > On Mon, Dec 09, 2019 at 04:29:22PM +0000, Chris Paterson wrote:
> > > 3)
> > > Config: arm shmobile_defconfig
> > > Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-
> > /jobs/373484089#L2249
> > > Probable culprit: 984d7a8bff57 ("pinctrl: sh-pfc: r8a7792: Fix VIN versioned
> > groups")
> > > Issue log:
> > > 2249 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:38: error: macro
> > "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> > > 2250   VIN_DATA_PIN_GROUP(vin1_data, 24, _b),
> > > 2251                                       ^
> > > 2252 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:2: error:
> > 'VIN_DATA_PIN_GROUP' undeclared here (not in a function); did you mean
> > 'PIN_MAP_TYPE_MUX_GROUP'?
> > > 2253   VIN_DATA_PIN_GROUP(vin1_data, 24, _b),
> > > 2254   ^~~~~~~~~~~~~~~~~~
> > > 2255   PIN_MAP_TYPE_MUX_GROUP
> > > 2256 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1751:38: error: macro
> > "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> > > 2257   VIN_DATA_PIN_GROUP(vin1_data, 20, _b),
> > > 2258                                       ^
> > > 2259 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1753:38: error: macro
> > "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> > > 2260   VIN_DATA_PIN_GROUP(vin1_data, 16, _b),
> > > 2261                                       ^
> > 
> > Now dropped for 4.19, 4.14, and 4.9 (2 patches for 4.19 here.)
> 
> Latest 4.19 now building, but I'm seeing a number of warnings and errors when trying to build the arm64 defconfig dtbs.
> https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/374092442
> arm/juno.dtb
> qcom/apq8016-sbc.dtb
> arm/juno-r2.dtb
> arm/juno-r1.dtb
> hisilicon/hi6220-hikey.dtb
> allwinner/sun50i-a64-pinebook.dtb
> qcom/msm8916-mtp.dtb
> qcom/msm8916-mtp.dtb
> qcom/sdm845-mtp.dtb

What are those warnings?
