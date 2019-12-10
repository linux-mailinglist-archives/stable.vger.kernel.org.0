Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 531F1119297
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 21:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbfLJU7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 15:59:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:44264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbfLJU7z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 15:59:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4815D206EC;
        Tue, 10 Dec 2019 20:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576011593;
        bh=1X4DlZa1hl0dptU9hU3Bn0Tqt8yWeuB5dF76UTu7ZKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zOa8M292BMyLlygfRDmbPWkPdrutaOhUrFwBSDUyDyTRIjI2x1bafKDfSZzsq0ikX
         Idyuo32JypF19cuuKvm1PquhR5x6LChd3Y1DXzqEVucxDaJ1185/Z8I6QMri8RK+V9
         y9PhG260vSZitg8b3oG+AnoYcQah9QAIpnONe8SM=
Date:   Tue, 10 Dec 2019 21:59:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Paterson <Chris.Paterson2@renesas.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>
Subject: Re: Linux 4.19.89-rc1 5944fcdd errors
Message-ID: <20191210205951.GA4081499@kroah.com>
References: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191209173637.GF1290729@kroah.com>
 <TYAPR01MB2285135B15E6A152163E1A1AB7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191210073514.GB3077639@kroah.com>
 <TYAPR01MB2285B5834B1FBA71F8DA512BB75B0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
 <20191210145528.GA4012363@kroah.com>
 <TYAPR01MB2285433EA1E6DF9EC621E31AB75B0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAPR01MB2285433EA1E6DF9EC621E31AB75B0@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 03:20:22PM +0000, Chris Paterson wrote:
> > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > Behalf Of Greg Kroah-Hartman
> > Sent: 10 December 2019 14:55
> > 
> > On Tue, Dec 10, 2019 at 02:42:45PM +0000, Chris Paterson wrote:
> > > Hello,
> > >
> > > > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> > > > Behalf Of Greg Kroah-Hartman
> > > > Sent: 10 December 2019 07:35
> > > >
> > > > On Mon, Dec 09, 2019 at 09:56:29PM +0000, Chris Paterson wrote:
> > > > > > From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org>
> > On
> > > > > > Behalf Of Greg Kroah-Hartman
> > > > > > Sent: 09 December 2019 17:37
> > > > > >
> > > > > > On Mon, Dec 09, 2019 at 04:29:22PM +0000, Chris Paterson wrote:
> > > > > > > 3)
> > > > > > > Config: arm shmobile_defconfig
> > > > > > > Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-
> > > > > > /jobs/373484089#L2249
> > > > > > > Probable culprit: 984d7a8bff57 ("pinctrl: sh-pfc: r8a7792: Fix VIN
> > versioned
> > > > > > groups")
> > > > > > > Issue log:
> > > > > > > 2249 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:38: error: macro
> > > > > > "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> > > > > > > 2250   VIN_DATA_PIN_GROUP(vin1_data, 24, _b),
> > > > > > > 2251                                       ^
> > > > > > > 2252 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:2: error:
> > > > > > 'VIN_DATA_PIN_GROUP' undeclared here (not in a function); did you
> > mean
> > > > > > 'PIN_MAP_TYPE_MUX_GROUP'?
> > > > > > > 2253   VIN_DATA_PIN_GROUP(vin1_data, 24, _b),
> > > > > > > 2254   ^~~~~~~~~~~~~~~~~~
> > > > > > > 2255   PIN_MAP_TYPE_MUX_GROUP
> > > > > > > 2256 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1751:38: error: macro
> > > > > > "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> > > > > > > 2257   VIN_DATA_PIN_GROUP(vin1_data, 20, _b),
> > > > > > > 2258                                       ^
> > > > > > > 2259 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1753:38: error: macro
> > > > > > "VIN_DATA_PIN_GROUP" passed 3 arguments, but takes just 2
> > > > > > > 2260   VIN_DATA_PIN_GROUP(vin1_data, 16, _b),
> > > > > > > 2261                                       ^
> > > > > >
> > > > > > Now dropped for 4.19, 4.14, and 4.9 (2 patches for 4.19 here.)
> > > > >
> > > > > Latest 4.19 now building, but I'm seeing a number of warnings and errors
> > when
> > > > trying to build the arm64 defconfig dtbs.
> > > > > https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/374092442
> > >
> > > > > arm/juno.dtb
> > > 7150 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> > /etf@20010000/ports/port@1: graph node unit address error, expected "0"
> > > 7151 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> > /funnel@20040000/ports/port@1: graph node unit address error, expected "0"
> > > 7152 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> > /funnel@20040000/ports/port@2: graph node unit address error, expected "1"
> > > 7153 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> > /funnel@20040000/ports/port@3: graph node unit address error, expected "2"
> > > 7154 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> > /funnel@220c0000/ports/port@1: graph node unit address error, expected "0"
> > > 7155 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> > /funnel@220c0000/ports/port@2: graph node unit address error, expected "1"
> > > 7156 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> > /funnel@230c0000/ports/port@1: graph node unit address error, expected "0"
> > > 7157 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> > /funnel@230c0000/ports/port@2: graph node unit address error, expected "1"
> > > 7158 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> > /funnel@230c0000/ports/port@3: graph node unit address error, expected "2"
> > > 7159 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> > /funnel@230c0000/ports/port@4: graph node unit address error, expected "3"
> > > 7160 arch/arm64/boot/dts/arm/juno.dtb: Warning (graph_port):
> > /replicator@20120000/ports/port@2: graph node unit address error, expected
> > "0"
> > >
> > > > > qcom/apq8016-sbc.dtb
> > > 7173 arch/arm64/boot/dts/qcom/apq8016-sbc.dtb: Warning (graph_port):
> > /soc/funnel@821000/ports/port@8: graph node unit address error, expected
> > "0"
> > > 7174 arch/arm64/boot/dts/qcom/apq8016-sbc.dtb: Warning (graph_port):
> > /soc/replicator@824000/ports/port@2: graph node unit address error,
> > expected "0"
> > > 7175 arch/arm64/boot/dts/qcom/apq8016-sbc.dtb: Warning (graph_port):
> > /soc/etf@825000/ports/port@1: graph node unit address error, expected "0"
> > > 7176 arch/arm64/boot/dts/qcom/apq8016-sbc.dtb: Warning (graph_port):
> > /soc/funnel@841000/ports/port@4: graph node unit address error, expected
> > "0"
> > >
> > > > > arm/juno-r2.dtb
> > > 7181 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> > /etf@20010000/ports/port@1: graph node unit address error, expected "0"
> > > 7182 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> > /funnel@20040000/ports/port@1: graph node unit address error, expected "0"
> > > 7183 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> > /funnel@20040000/ports/port@2: graph node unit address error, expected "1"
> > > 7184 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> > /funnel@220c0000/ports/port@1: graph node unit address error, expected "0"
> > > 7185 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> > /funnel@220c0000/ports/port@2: graph node unit address error, expected "1"
> > > 7186 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> > /funnel@230c0000/ports/port@1: graph node unit address error, expected "0"
> > > 7187 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> > /funnel@230c0000/ports/port@2: graph node unit address error, expected "1"
> > > 7188 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> > /funnel@230c0000/ports/port@3: graph node unit address error, expected "2"
> > > 7189 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> > /funnel@230c0000/ports/port@4: graph node unit address error, expected "3"
> > > 7190 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> > /replicator@20120000/ports/port@2: graph node unit address error, expected
> > "0"
> > > 7191 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> > /funnel@20130000/ports/port@1: graph node unit address error, expected "0"
> > > 7192 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> > /etf@20140000/ports/port@1: graph node unit address error, expected "0"
> > > 7193 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> > /funnel@20150000/ports/port@1: graph node unit address error, expected "0"
> > > 7194 arch/arm64/boot/dts/arm/juno-r2.dtb: Warning (graph_port):
> > /funnel@20150000/ports/port@2: graph node unit address error, expected "1"
> > >
> > > > > arm/juno-r1.dtb
> > > 7195 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> > /etf@20010000/ports/port@1: graph node unit address error, expected "0"
> > > 7196 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> > /funnel@20040000/ports/port@1: graph node unit address error, expected "0"
> > > 7197 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> > /funnel@20040000/ports/port@2: graph node unit address error, expected "1"
> > > 7198 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> > /funnel@220c0000/ports/port@1: graph node unit address error, expected "0"
> > > 7199 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> > /funnel@220c0000/ports/port@2: graph node unit address error, expected "1"
> > > 7200 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> > /funnel@230c0000/ports/port@1: graph node unit address error, expected "0"
> > > 7201 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> > /funnel@230c0000/ports/port@2: graph node unit address error, expected "1"
> > > 7202 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> > /funnel@230c0000/ports/port@3: graph node unit address error, expected "2"
> > > 7203 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> > /funnel@230c0000/ports/port@4: graph node unit address error, expected "3"
> > > 7204 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> > /replicator@20120000/ports/port@2: graph node unit address error, expected
> > "0"
> > > 7205 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> > /funnel@20130000/ports/port@1: graph node unit address error, expected "0"
> > > 7206 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> > /etf@20140000/ports/port@1: graph node unit address error, expected "0"
> > > 7207 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> > /funnel@20150000/ports/port@1: graph node unit address error, expected "0"
> > > 7208 arch/arm64/boot/dts/arm/juno-r1.dtb: Warning (graph_port):
> > /funnel@20150000/ports/port@2: graph node unit address error, expected "1"
> > >
> > > > > hisilicon/hi6220-hikey.dtb
> > > 7209 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port):
> > /soc/funnel@f6401000/ports/port@1: graph node unit address error, expected
> > "0"
> > > 7210 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port):
> > /soc/etf@f6402000/ports/port@1: graph node unit address error, expected "0"
> > > 7211 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port):
> > /soc/replicator/ports/port@1: graph node unit address error, expected "0"
> > > 7212 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port):
> > /soc/replicator/ports/port@2: graph node unit address error, expected "1"
> > > 7213 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port):
> > /soc/funnel@f6501000/ports/port@1: graph node unit address error, expected
> > "0"
> > > 7214 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port):
> > /soc/funnel@f6501000/ports/port@2: graph node unit address error, expected
> > "1"
> > > 7215 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port):
> > /soc/funnel@f6501000/ports/port@3: graph node unit address error, expected
> > "2"
> > > 7216 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port):
> > /soc/funnel@f6501000/ports/port@4: graph node unit address error, expected
> > "3"
> > > 7217 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port):
> > /soc/funnel@f6501000/ports/port@5: graph node unit address error, expected
> > "4"
> > > 7218 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port):
> > /soc/funnel@f6501000/ports/port@6: graph node unit address error, expected
> > "5"
> > > 7219 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port):
> > /soc/funnel@f6501000/ports/port@7: graph node unit address error, expected
> > "6"
> > > 7220 arch/arm64/boot/dts/hisilicon/hi6220-hikey.dtb: Warning (graph_port):
> > /soc/funnel@f6501000/ports/port@8: graph node unit address error, expected
> > "7"
> > >
> > > > > allwinner/sun50i-a64-pinebook.dtb
> > > 7248 Error: arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:82.1-7
> > Label or path codec not found
> > > 7249 Error: arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:86.1-14
> > Label or path codec_analog not found
> > > 7250 Error: arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:91.1-5
> > Label or path dai not found
> > > 7251 Error: arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts:297.1-7
> > Label or path sound not found
> > >
> > > > > qcom/msm8916-mtp.dtb
> > > 7256 arch/arm64/boot/dts/qcom/msm8916-mtp.dtb: Warning (graph_port):
> > /soc/funnel@821000/ports/port@8: graph node unit address error, expected
> > "0"
> > > 7257 arch/arm64/boot/dts/qcom/msm8916-mtp.dtb: Warning (graph_port):
> > /soc/replicator@824000/ports/port@2: graph node unit address error,
> > expected "0"
> > > 7258 arch/arm64/boot/dts/qcom/msm8916-mtp.dtb: Warning (graph_port):
> > /soc/etf@825000/ports/port@1: graph node unit address error, expected "0"
> > > 7259 arch/arm64/boot/dts/qcom/msm8916-mtp.dtb: Warning (graph_port):
> > /soc/funnel@841000/ports/port@4: graph node unit address error, expected
> > "0"
> > >
> > > > > qcom/sdm845-mtp.dtb
> > > 7284 Error: arch/arm64/boot/dts/qcom/sdm845-mtp.dts:26.22-23 syntax
> > error
> > 
> > 
> > That's a lot, are these all new?
> 
> I've only just started building with this config in our CI setup, but
> building the dtbs locally with v4.19.88 didn't produce these results
> for me (and building locally with v4.19.89-rc1 does result in the
> above issues).

Any chance you can run 'git bisect' to track down the offending patch?

thanks,

greg k-h
