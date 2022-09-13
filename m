Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA2D5B7A92
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 21:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiIMTJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 15:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiIMTJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 15:09:32 -0400
Received: from fw2.prolan.hu (fw2.prolan.hu [193.68.50.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341EB1D0C7;
        Tue, 13 Sep 2022 12:09:25 -0700 (PDT)
Received: from imsva.intranet.prolan.hu (imss.intranet.prolan.hu [10.254.254.252])
        by fw2.prolan.hu (Postfix) with ESMTPS id 6F8D97F458;
        Tue, 13 Sep 2022 21:09:23 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5320D34064;
        Tue, 13 Sep 2022 21:09:23 +0200 (CEST)
Received: from imsva.intranet.prolan.hu (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 395903405A;
        Tue, 13 Sep 2022 21:09:23 +0200 (CEST)
Received: from fw2.prolan.hu (unknown [10.254.254.253])
        by imsva.intranet.prolan.hu (Postfix) with ESMTPS;
        Tue, 13 Sep 2022 21:09:23 +0200 (CEST)
Received: from atlas.intranet.prolan.hu (atlas.intranet.prolan.hu [10.254.0.229])
        by fw2.prolan.hu (Postfix) with ESMTPS id 077577F458;
        Tue, 13 Sep 2022 21:09:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=prolan.hu; s=mail;
        t=1663096163; bh=gcr1besCy5qG6Bb3Lbv9Z8Yk6ayOdWzKbJH3+PLUS0s=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=gnp9BMGfNTLam+gESMLUit5MMSnsZCe+ojSnGizzqLEt3vdBgQHT4GJaFj1y2ezJi
         RYSIb4HuE3BVm5OeQKqbjB1BvsTmZ2/TCRA9QBPfTARWdTMvlRZeVCP6NheiTW1Rbv
         ZPcEgrAdGSEOeuuKeBCcbZNM75t7BvZyb3l+y/fOSL7uFVESXq8DGLpNkXN9TeYKv8
         IaKo8T3/qKe2mHoW1XtmXv6ZUFi+KPxW8+seRp/H4Cz0QaU7UgB5yg3UTLRq0kZQBp
         X6CYJO+0nzSjWOImXEEMhiMsT9ysur9fV/dom+jKTr+E3hmeMaBuZaPHvutd9/Cejw
         qeGjXcKWWDIHg==
Received: from atlas.intranet.prolan.hu (10.254.0.229) by
 atlas.intranet.prolan.hu (10.254.0.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P521) id
 15.1.2507.12; Tue, 13 Sep 2022 21:09:22 +0200
Received: from atlas.intranet.prolan.hu ([fe80::9c8:3400:4efa:8de7]) by
 atlas.intranet.prolan.hu ([fe80::9c8:3400:4efa:8de7%11]) with mapi id
 15.01.2507.012; Tue, 13 Sep 2022 21:09:22 +0200
From:   =?iso-8859-2?Q?Cs=F3k=E1s_Bence?= <Csokas.Bence@prolan.hu>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Re: [PATCH 5.15 084/121] net: fec: Use a spinlock to guard
 `fep->ptp_clk_on`
Thread-Topic: [PATCH 5.15 084/121] net: fec: Use a spinlock to guard
 `fep->ptp_clk_on`
Thread-Index: AQHYx3vmuaPYHpMZD0W8vRjGbCgVN63dYleAgABWeZo=
Date:   Tue, 13 Sep 2022 19:09:22 +0000
Message-ID: <3ec73c64232f409babade38117551084@prolan.hu>
References: <20220913140357.323297659@linuxfoundation.org>
 <20220913140400.979880696@linuxfoundation.org>,<20220913155643.yxl27etklqql63fb@pengutronix.de>
In-Reply-To: <20220913155643.yxl27etklqql63fb@pengutronix.de>
Accept-Language: hu-HU, en-US
Content-Language: hu-HU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [152.66.181.220]
x-esetresult: clean, is OK
x-esetid: 37303A29971EF4566D7765
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> If possible please drop this patch, a revert for this is pending. For
> details see:
>=20
> https://lore.kernel.org/all/20220913141917.ukoid65sqao5f4lg@pengutronix.d=
e/

Agreed, please hold off on this patch. An updated patch is in the works.

Bence=
