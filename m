Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FA547BB88
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 09:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbhLUINn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 03:13:43 -0500
Received: from mx07-00178001.pphosted.com ([185.132.182.106]:41834 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231443AbhLUINn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 03:13:43 -0500
Received: from pps.filterd (m0288072.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BL5YxKS014789;
        Tue, 21 Dec 2021 09:13:25 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foss.st.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=selector1;
 bh=maZSNZJEXk+v3gf/cuhFsQAVI0wk81zZoIV/aka8yJM=;
 b=Rzk5jmvO46qS77p39WPTv3GZ5mUVb90hNFhX5EB3RJkw4N5PzzTxSSBdo5j6XCdKnu6s
 9tnG1h81whI0SO8CfmEIjm0aLG647TBmhGXyGZLO0drKk1HGejRAc/Lb8b1L1UMp7zxE
 LEIQnXTige9dbk+kDL67j956UTwFrA4lCQ11knfVZDv6bXHW6IF7kNUBwNMg1sneVbRP
 vjqxARMqpzTNaHCKhxO2VGoSQOmOyTZSRD1izFpFgEd5FxHWwsv6XGIMS4ez1zCGXsjS
 +Ltgg8FrTtmfy9N4jtjxsPwmzppn2iIvRSM0igxLIBhn9SLYIfdhryu4MHSk0XNJ+p1y 1A== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com (PPS) with ESMTPS id 3d2keaxcvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Dec 2021 09:13:25 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 0DA8D10002A;
        Tue, 21 Dec 2021 09:13:22 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag2node2.st.com [10.75.127.5])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id DC65921BF6A;
        Tue, 21 Dec 2021 09:13:22 +0100 (CET)
Received: from gnbcxd0088.gnb.st.com (10.75.127.50) by SFHDAG2NODE2.st.com
 (10.75.127.5) with Microsoft SMTP Server (TLS) id 15.0.1497.26; Tue, 21 Dec
 2021 09:13:22 +0100
Date:   Tue, 21 Dec 2021 09:12:56 +0100
From:   Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>
X-X-Sender: toromano@gnbcxd0088.gnb.st.com
To:     Marek Vasut <marex@denx.de>
CC:     <linux-crypto@vger.kernel.org>,
        Lionel Debieve <lionel.debieve@st.com>,
        Nicolas Toromanoff <nicolas.toromanoff@st.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        <stable@vger.kernel.org>, Fabien Dessenne <fabien.dessenne@st.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Linux-stm32] [PATCH] crypto: stm32/crc32 - Fix kernel BUG
 triggered in probe()
In-Reply-To: <20211220195022.1387104-1-marex@denx.de>
Message-ID: <alpine.DEB.2.21.2112210826250.21632@gnbcxd0088.gnb.st.com>
References: <20211220195022.1387104-1-marex@denx.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
X-Originating-IP: [10.75.127.50]
X-ClientProxiedBy: SFHDAG1NODE2.st.com (10.75.127.2) To SFHDAG2NODE2.st.com
 (10.75.127.5)
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-21_03,2021-12-21_01,2021-12-02_01
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 20 Dec 2021, Marek Vasut wrote:

> The include/linux/crypto.h struct crypto_alg field cra_driver_name description
> states "Unique name of the transformation provider. " ... " this contains the
> name of the chip or provider and the name of the transformation algorithm."
>
> In case of the stm32-crc driver, field cra_driver_name is identical for all
> registered transformation providers and set to the name of the driver itself,
> which is incorrect. This patch fixes it by assigning a unique cra_driver_name
> to each registered transformation provider.
>
> The kernel crash is triggered when the driver calls crypto_register_shashes()
> which calls crypto_register_shash(), which calls crypto_register_alg(), which
> calls __crypto_register_alg(), which returns -EEXIST, which is propagated
> back through this call chain. Upon -EEXIST from crypto_register_shash(), the
> crypto_register_shashes() starts unregistering the providers back, and calls
> crypto_unregister_shash(), which calls crypto_unregister_alg(), and this is
> where the BUG() triggers due to incorrect cra_refcnt.
>
> Fixes: b51dbe90912a ("crypto: stm32 - Support for STM32 CRC32 crypto module")
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: <stable@vger.kernel.org> # 4.12+
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Fabien Dessenne <fabien.dessenne@st.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Lionel Debieve <lionel.debieve@st.com>
> Cc: Nicolas Toromanoff <nicolas.toromanoff@st.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> To: linux-crypto@vger.kernel.org
> ---
> drivers/crypto/stm32/stm32-crc32.c | 4 ++--

Hello Marek,

Thanks for the fix.

Acked-by: Nicolas Toromanoff <nicolas.toromanoff@foss.st.com>

