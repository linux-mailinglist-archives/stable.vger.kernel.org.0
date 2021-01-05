Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17DA2EA955
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 12:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbhAELBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 06:01:06 -0500
Received: from mail-am6eur05on2136.outbound.protection.outlook.com ([40.107.22.136]:1376
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728507AbhAELBF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 06:01:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KsRMHZV4HiEfIS11gWcXN2iyrz+++LaRjGk9U02fIYR0B6sEdLvKeCHt1MD412zhrOl0QH7CM3/pE91hLTlHPxgs2cHOqzB5H5raTehSFFML6SSx1J8d4TOmN/u21nvJyiXBFBjmCkXmury5IwFJOJuMavcLOBoZdwM0iPr+rrHV3dPYs/AEtMC+jHx/6Ohbw/PDb3gB1Cdw3gIJwzUaZJKg44TVqIp1oAJRLsHOaXicTNmSzALILFSiff3grMUvtQrPvXVEGin6bTHTGObPbMfMKhzxagD0ujRLVRkHBhJUH6Us00LImE7CnQGnP0Qx2hCtPGpWXXuAmxisNfZxBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppjNOckObFFo53/KJrGbkpz1G22jsYWFiH2tYkG29vw=;
 b=dv0JvXoaGhE44rfqDNxI34CCEjnni1yP0Chvz0HQxw5meO/duqRVb1QNte2DiKCnnjZlL0FSSY/uJ/SiveIXeTQ8xEt5AwfLcxRbuiOappPl1Cm64NsD2joKj08jq76i+4NUUYc/xjhVb6OGdzme8FDhxq5PD26zk+6TDYVWUGquQlZHbUOwbF1f2w/z2nh+uao00dFjs/1pJNjIUWz/2agz0Is9up6iB8+PFBmPxtxBI/XT7JjUpvdr2hC4vg1vxGicPs9ewXsD1CoRo6Ea6uwXOtlFy8OMRGjFQu5vkWnhnm1YOnBy49BDOF1gNQoWS4TxvlZh7eXPnLTK+4tPQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppjNOckObFFo53/KJrGbkpz1G22jsYWFiH2tYkG29vw=;
 b=bGR7ri4Lctwy2ijGCL9xOOu+ajo/3mhy0XQssC+4CAbfEB+aTQ33ZE3VeZNtmzmcwS5v9kfsy96bEUeGv/QWdSPEzt06MhnDzSjNTKf4rK470psa0wCnQ8s9BuAux0vOKAjgCuK0QV5r9Vad4FzbhOOi4+XdD70Sjr6b/udmkX8=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM9PR10MB4183.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Tue, 5 Jan
 2021 11:00:17 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 11:00:17 +0000
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: RTC pcf2127 fix for 5.10-stable
Message-ID: <92f8f995-cd97-e978-c8d5-2093cd1fe16a@prevas.dk>
Date:   Tue, 5 Jan 2021 12:00:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR10CA0050.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:80::27) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6PR10CA0050.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:80::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20 via Frontend Transport; Tue, 5 Jan 2021 11:00:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92f68b06-817b-4893-bd59-08d8b169162f
X-MS-TrafficTypeDiagnostic: AM9PR10MB4183:
X-Microsoft-Antispam-PRVS: <AM9PR10MB4183986B6E875BADBA0BA70E93D10@AM9PR10MB4183.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:792;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3rBvXsiQEvOh69zFkl+WEdrO9+jXA5QH77SPUGd0L/A639RdTxWLlqvGkDgbYAzMt2nKLfcA37W8UuWAWFkz8fuUu1gqL1CS1GVmuyrmBX7GXyBYZTVrIv3IIKzpAyHJstl7noKHGJpPsF2Z22eeTtTLboE4AKH7PloU34vazWqHfjkuI50l8U3ybgFYmX4RKYZeQASW34z0M4GnUaDK98C0n1M7ssx+t/RcBHU1knzbtfNDH8IJoIuZHlAhl/1nLTd1HcZwdGaZ7H6V9I66KQ8uE0OFIHwufYql0805QRqVWHlTKZ5AaTTqhDmVqDynebyDgrskNdYYNegaE1nu2bFoej07ooJbMe+B4uR+D6OLHRtBMIms6HLwaDV8Xmxr4EzRHENZYmKR1X/hvDEIgW705KBpBk6S3bbw6AlfwpJW1+BW/Oa0SFzfnX/MbKV6Kl1TS8TUVy2OV2q6Bw7iCINRsiLipBwHjS9u8aFj/bo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(39840400004)(376002)(366004)(396003)(136003)(8976002)(31696002)(52116002)(86362001)(6486002)(26005)(478600001)(16576012)(4326008)(956004)(44832011)(66556008)(8936002)(66476007)(54906003)(316002)(2616005)(6916009)(66946007)(2906002)(16526019)(31686004)(186003)(4744005)(8676002)(5660300002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?3OeXl7GO1HDq3vI8dEUZkoJMgBy1AkA6QohY1sWCpnpDCiYcS6m9EyXZ?=
 =?Windows-1252?Q?0g5/q8eERxxTewHPmHZH/WV5NH/slGpI/WGs5cvHAE1Z5KlZEwUQzB3v?=
 =?Windows-1252?Q?MWMLx0+wAtLRm7LfyA0QOqtKxus3vuDlo82CVGiEE/Veydcb/xXaRIL0?=
 =?Windows-1252?Q?bO1viXm+dRvJqAOhPuvfxTTeBpWa18ekrFwa6blwLMpUnEYnG4aXG7dR?=
 =?Windows-1252?Q?albAH/+d6t0MoFx6J9S+tnrs1DB0I6hr1X8qOwbfur7ZbJpzEzn1DIYx?=
 =?Windows-1252?Q?7KmfwZSppLjfWW0c52QUJFfmi4+P44O5WbVctRVRwMv1YYNu4Q91zCJZ?=
 =?Windows-1252?Q?2PAMbykEaMjaSbPbbxCHjwKh2f/JZfdmvdngUGbFJCb9Uvnb7hGQtKwJ?=
 =?Windows-1252?Q?kHjelMQaYPLsCxiyDNiNGo+Qcim1L8wJZh7NYLH8jnFZrbVhtErX3prh?=
 =?Windows-1252?Q?2NU/ygUvoaJnGnj1Te3rl9eEvr7xNr0ShphOCqMweOQhXre7ezp5lPgA?=
 =?Windows-1252?Q?o7PTuJKaa5wqhS1pNA1ecBfd6FpO9Ozy8mgAOfx8rPB61gzhdWj+zbYX?=
 =?Windows-1252?Q?Gn/N9wA5g3AJd1D/CcTx4qelU6nAtLKlYFo0bC4lD/1AlcZSfUjOMzVN?=
 =?Windows-1252?Q?cn8gmghNi6Q77iP2tLcpb+mOCanG7VMQAwxvtILtFjoDKXMb65AwpVuE?=
 =?Windows-1252?Q?hTVusQQsnFqle+VJVHO+OzZVnyKeb+6b7ovaq1axL8tL4RD4izL6rYGQ?=
 =?Windows-1252?Q?VJtYL39NiTgsNuKqYBD83qRzvPcqsajUlySq45FzCRQ98u2w4lkOZgSD?=
 =?Windows-1252?Q?PIkEIPfL3hX70Nb429qc2DpuY0sCpEF+TcCay3uy3qri/EFOPoWNdb70?=
 =?Windows-1252?Q?qvmK7RMpUsuWySDasY+Muk+bLlIFW/Ot8ZhYyujB5xEYnp0tPyqQAPDo?=
 =?Windows-1252?Q?np9549vsMu1njEwf63pb5vNOJMj2pgtiyW6mP1yQeynboD77awMEI0bp?=
 =?Windows-1252?Q?oCXkEQ3aqIuxsSyLAdGpfu5lhwOhmdYe6bKYIl0psc5+zjvgOCVkoL3C?=
 =?Windows-1252?Q?q4fd8ySzny9R4nHd?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2021 11:00:17.4465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-Network-Message-Id: 92f68b06-817b-4893-bd59-08d8b169162f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IZ7RyNieS8vqdXGCkScKv84lzdHx6jXraTPBJbp03/ts99tKYmvHC09i037y1rzxqqP7XUWI5i/z/1CZMaoNh/nO7gcqhqOkGHO5Fpo1OU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4183
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

Please consider adding

commit 71ac13457d9d1007effde65b54818106b2c2b525
Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date:   Fri Dec 18 11:10:54 2020 +0100

    rtc: pcf2127: only use watchdog when explicitly available

to the 5.10 stable queue. You will need the preparatory refactoring patch

commit 5d78533a0c53af9659227c803df944ba27cd56e0
Author: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Date:   Thu Sep 24 12:52:55 2020 +0200

    rtc: pcf2127: move watchdog initialisation to a separate function

And if documentation is supposed to be kept up-to-date in the -stable
trees, you can pick

commit 320d159e2d63a97a40f24cd6dfda5a57eec65b91
Author: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Date:   Fri Dec 18 11:10:53 2020 +0100

    dt-bindings: rtc: add reset-source property

Thanks,
Rasmus
