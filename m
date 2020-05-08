Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F2D1CA50B
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 09:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgEHHVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 03:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727772AbgEHHVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 03:21:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DA0C05BD43
        for <stable@vger.kernel.org>; Fri,  8 May 2020 00:21:00 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pza@pengutronix.de>)
        id 1jWxJS-0001g6-HU; Fri, 08 May 2020 09:20:50 +0200
Received: from pza by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <pza@pengutronix.de>)
        id 1jWxJR-0002Lo-IX; Fri, 08 May 2020 09:20:49 +0200
Date:   Fri, 8 May 2020 09:20:49 +0200
From:   Philipp Zabel <pza@pengutronix.de>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sham Muthayyan <smuthayy@codeaurora.org>,
        stable@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/11] PCI: qcom: add missing reset for ipq806x
Message-ID: <20200508072049.GA31261@pengutronix.de>
References: <20200430220619.3169-1-ansuelsmth@gmail.com>
 <20200430220619.3169-5-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430220619.3169-5-ansuelsmth@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:18:34 up 78 days, 14:49, 108 users,  load average: 0.06, 0.16,
 0.24
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: pza@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ansuel,

On Fri, May 01, 2020 at 12:06:11AM +0200, Ansuel Smith wrote:
> Add missing ext reset used by ipq8064 SoC in PCIe qcom driver.
> 
> Fixes: 82a823833f4e PCI: qcom: Add Qualcomm PCIe controller driver
> Signed-off-by: Sham Muthayyan <smuthayy@codeaurora.org>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Cc: stable@vger.kernel.org # v4.5+
> ---
>  drivers/pci/controller/dwc/pcie-qcom.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
> index 7a8901efc031..921030a64bab 100644
> --- a/drivers/pci/controller/dwc/pcie-qcom.c
> +++ b/drivers/pci/controller/dwc/pcie-qcom.c
[...]
> @@ -347,6 +353,12 @@ static int qcom_pcie_init_2_1_0(struct qcom_pcie *pcie)
>  		goto err_deassert_ahb;
>  	}
>  
> +	ret = reset_control_deassert(res->ext_reset);
> +	if (ret) {
> +		dev_err(dev, "cannot assert ext reset\n");
                                     ^
This probably should say "cannot deassert ext reset". Apart from this,

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
