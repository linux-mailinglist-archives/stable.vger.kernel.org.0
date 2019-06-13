Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C188643CD0
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387813AbfFMPiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:38:02 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:50422 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbfFMKI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 06:08:58 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5DA8jPv011209;
        Thu, 13 Jun 2019 05:08:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1560420525;
        bh=AmxFLwpXraKUmTswXPL12WmFRbuYYcNhMefmN7KMU5M=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Upl3/dZ0hHzQSBndq0WSe19/HmcZZWEUHKx2eUVFdsXBLikXMUNTBmi+yAIDX/H+a
         etLt2SjnDTmmjpOpFxSySxJs69BZZIbRsBDzCuRSoL4lptN+hw4bOD9qJfz/3ZmO8W
         iOGum05nHyGUwq86+uRtoszMeecSMtzp2sVJqWVY=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5DA8jkJ000578
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 13 Jun 2019 05:08:45 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 13
 Jun 2019 05:08:45 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 13 Jun 2019 05:08:45 -0500
Received: from [172.24.190.172] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5DA8f1s028844;
        Thu, 13 Jun 2019 05:08:42 -0500
Subject: Re: [PATCH 5.1 101/155] usb: ohci-da8xx: disable the regulator if the
 overcurrent irq fired
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
References: <20190613075652.691765927@linuxfoundation.org>
 <20190613075658.675810826@linuxfoundation.org>
From:   Sekhar Nori <nsekhar@ti.com>
Message-ID: <8cd8d734-c865-d899-0db4-12dead817daa@ti.com>
Date:   Thu, 13 Jun 2019 15:38:41 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613075658.675810826@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 13/06/19 2:03 PM, Greg Kroah-Hartman wrote:
> [ Upstream commit d327330185f192411be80563a3c8398f4538cdb2 ]
> 
> Historically the power supply management in this driver has been handled
> in two separate places in parallel. Device-tree users simply defined an
> appropriate regulator, while two boards with no DT support (da830-evm and
> omapl138-hawk) passed functions defined in their respective board files
> over platform data. These functions simply used legacy GPIO calls to
> watch the oc GPIO for interrupts and disable the vbus GPIO when the irq
> fires.
> 
> Commit d193abf1c913 ("usb: ohci-da8xx: add vbus and overcurrent gpios")
> updated these GPIO calls to the modern API and moved them inside the
> driver.
> 
> This however is not the optimal solution for the vbus GPIO which should
> be modeled as a fixed regulator that can be controlled with a GPIO.
> 
> In order to keep the overcurrent protection available once we move the
> board files to using fixed regulators we need to disable the enable_reg
> regulator when the overcurrent indicator interrupt fires. Since we
> cannot call regulator_disable() from interrupt context, we need to
> switch to using a oneshot threaded interrupt.
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This is a preparatory patch for some clean-up. This should not be
backported to stable.

Thanks,
Sekhar
