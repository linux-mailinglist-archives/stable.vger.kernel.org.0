Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9E856FC02
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbiGKJhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232807AbiGKJhF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:37:05 -0400
X-Greylist: delayed 306 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 11 Jul 2022 02:19:23 PDT
Received: from eu-smtp-delivery-197.mimecast.com (eu-smtp-delivery-197.mimecast.com [185.58.86.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5ACA44E605
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 02:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=camlingroup.com;
        s=mimecast20210310; t=1657531161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RulkO0mVldtubCvhxwBFbSRQB302WzG7TbJFwVeWKPk=;
        b=PRERfhR8DMEXJdT1ibx5xJKsQYkC1BKeA5ixoE8MXCcxHVyf+ZJQDUTWhcsGBMct0YBoTF
        E6DKthnsuw8bhwoqc1t9NbVOUej0PT1DIuXB/Lot08ZdiliKLVX5ZfX+SAddw6MibSm8IV
        B5Ii4BF1fXRK05sKCedZKYk0cpHDpQE=
Received: from GBR01-CWL-obe.outbound.protection.outlook.com
 (mail-cwlgbr01lp2054.outbound.protection.outlook.com [104.47.20.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 uk-mta-28-0LQW5gFiO5WTp0PjArz7RQ-1; Mon, 11 Jul 2022 10:13:09 +0100
X-MC-Unique: 0LQW5gFiO5WTp0PjArz7RQ-1
Received: from CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:1ba::12)
 by LOYP123MB3295.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:f2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.15; Mon, 11 Jul
 2022 09:13:07 +0000
Received: from CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f56f:d3d:9a1a:5e4]) by CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f56f:d3d:9a1a:5e4%9]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 09:13:07 +0000
Message-ID: <c2d545d1f5478e66c0dac47f4bc4c04256ff44aa.camel@camlingroup.com>
Subject: Re: [PATCH] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on
 program/erase times
From:   Tomasz =?UTF-8?Q?Mo=C5=84?= <tomasz.mon@camlingroup.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-mtd@lists.infradead.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>
CC:     Han Xu <han.xu@nxp.com>, kernel@pengutronix.de,
        stable@vger.kernel.org, k.drobinski@camlintechnologies.com
Date:   Mon, 11 Jul 2022 11:12:26 +0200
In-Reply-To: <20220701110341.3094023-1-s.hauer@pengutronix.de>
References: <20220701110341.3094023-1-s.hauer@pengutronix.de>
User-Agent: Evolution 3.36.5-0ubuntu1
X-ClientProxiedBy: LO4P265CA0224.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::8) To CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:1ba::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 106cca6b-7daa-4a7a-0c4c-08da631d915d
X-MS-TrafficTypeDiagnostic: LOYP123MB3295:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: tg+hXuPj2xMEfZ5H3H0U9gMpjyWFrC/7vKDN9yrHtvCdGWyZArqcq4PHR6xzUdUIxQ/QcXAePR3na3wSlpAGLrBNCnr+4Pb3oprEaxkQ105gSlf3LkFCLKiSk3EJ/2yzq36ZZiD1BvNQJ0g9cBncT1lZjE4ysY/ID2Bv56ESs8gNVa/74YEkM4Ox2EXQ6+NEZhpMsVUK8dXfiH21sU6EXXUB8mvmKyhlCCB0ImCTZuTTpaIdu8yytH6Ud/0VbkcvddkRlZq3GhB8OfLB68cHPmeEvGJEmSoNoZVLY4PUiTEQM1VY396Tap8ulrJh8yI1wOR7q109ANejPpsKxq5QeccT+cJMiSwQtEirQb6PtTCNNjuSdYAHkM/dfXruAiTAS1D/gqGLQstQxYqA+f8+6aytyAp6HXR8G0CIp/LydQQYWMUgzQzS+OJHOW8iCwOoeY7lXqtIm3JiQdJBCllzG8CdGvuZDuixsYG7cMklpoGWd4U70G2g7/0AU/daEfiySrsFCOF9kvUC7FM9pKUmOLfndTv4NpRUC3a1liQp/6w9khNTNWSn9XKLyynSLzq/Z9b1MNg3+iNtjzu/4eDzzrp0siDznXZszbiVdPGAviri7dUlq2jVkE3v7XMLJqCbxUWuvY3ACU5wt9R2IbzNBtC8wus1KYd4g0pPK8sCKiF8IDZPB0e9YGo+sDLA6nejiDWoBZvMHmOdH6MFu7AZLvIpGJtPjCoiHjKOF5PxQVaC8RojPex0yCL6EkGnRbvwUfXda8kmnTkNrSydIwCCtmEayToTalB8uDm5U9pqNEp2w8cC0hptshcp3OZZqsR9NrmYW4lMghsQ1+oDIAU8CQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39850400004)(376002)(346002)(396003)(5660300002)(110136005)(8936002)(86362001)(316002)(478600001)(66476007)(66946007)(4326008)(8676002)(66556008)(6486002)(966005)(2616005)(107886003)(52116002)(26005)(6512007)(83380400001)(186003)(6666004)(41300700001)(38100700002)(38350700002)(6506007)(2906002)(36756003);DIR:OUT;SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ouup6duelShQ4Q2OlTnksfaYj9Si2zKWq4SAJDFXQDhOrTxy6hrununiX/iG?=
 =?us-ascii?Q?r3LDcV5ol9Pabn1ofEp/nYcigQPVzJPatrqXmODgWw4jsVFP1j4rV/Vt8kRE?=
 =?us-ascii?Q?mTmkxGnlt65yj+PBYXbssoSrrWvNSyIsCskRZw3+L8UD1oGKTntCcdKG16ho?=
 =?us-ascii?Q?2VbjA3jTVC3DlkxJdh3S2c2ue5/A5X9izSSD1ztYuiMOenDzUTzwDJc1o/Ca?=
 =?us-ascii?Q?pwoJZBwa0yOJCoz9Z2pZnA542XHhfV3vNXUn3Bz+6EMWcJRFqWJfryPdfTWf?=
 =?us-ascii?Q?Pzv5H8HyV6PbhMfaZkeDlrejgMzqHHFdE/4RVwL71ORVn8+uGaTNkkK6vXlP?=
 =?us-ascii?Q?LUt1VdE8NpG3uuQRND6ON0QlYFcg94Hwv2Fd+amEqjsgo0duohfJvFBCInwY?=
 =?us-ascii?Q?8Xm2YZXv1ACmhrt0tv1Kp0cJtBzJCoflFZzWNUX3vuX0WE8bXpmtJMralPyc?=
 =?us-ascii?Q?0QvFbxWf1XtWoQKUEjj+NE9zUWvGjcLVQFlP6qzaZNRwn0brq+EO7Xx2r3r4?=
 =?us-ascii?Q?nMwoKL1mbkvyH30xX5DlJBlkxG/416/6LMcaF+KqYEa0A0MuBeonflnbRnQX?=
 =?us-ascii?Q?rK/rMVPUW2sL0oHvQCiAI9r4mkM6HXu8AC+T6A6w43ZUwrwlNWPyNHosGfmk?=
 =?us-ascii?Q?5B6ai/n30Rh7bFNwanpbRutOqmT1tceOdQap2bpppTMAqXZzNcVfU5byJl+l?=
 =?us-ascii?Q?pK5rT14kvQheE2ywNwrR9p+OKOBQX7T3MqGt3XoeT2U2JG3Q96HlcfwsrO4C?=
 =?us-ascii?Q?shLuCa5uhCfY5FuzYBD1sjqXez8OA81ZL3EKSxOu9w3r74IqwXtvKYPGrb40?=
 =?us-ascii?Q?yLiZd2NbNorLy8QKR3MJawA0EfDVAwHPkcsLp2cSHsaVanf9rNJmG/FFLVyQ?=
 =?us-ascii?Q?+Ba8GMkxM3d2di605eR4iZKETiVyIw0ZjdlEZ2/L/uT9jyidmw06N664yxWh?=
 =?us-ascii?Q?1zZSaJVaFsnrXeRBZwK8y6R7GlHspnm7WLdUNKF9T0HBC+s8jfqgJw3Hk2RB?=
 =?us-ascii?Q?ACCobOWKx1A6viE+Y55CfhhITreft4Zop2Hs3HrUcYHYRC9ZjCKErFzmZPN3?=
 =?us-ascii?Q?XvEzQQCEMI3a0BzVVleGuWDxu1HDVBIVeuUmzN4NSHAWzepcUh/zjIAg9QJu?=
 =?us-ascii?Q?abB1LVaqMzfks2q3M1DqBpwGZpFjtHKfEb58Mtu5mZSX+HohNu+0ksuZ/Yq+?=
 =?us-ascii?Q?FEkWBxBmZg2UkUhjoK7nR4qh+JzmvBm/Z601imw6Bx8zJ8LuwYpRtPQhrpXT?=
 =?us-ascii?Q?+U/rANaSde3tl0PNycAHsu+4/7RUKCa6ihacI3JIzlDwvxhx0hCH+rNfMGLd?=
 =?us-ascii?Q?LY/EBiTAlxNJHVRgVyDPiLVzujr0M8E5kWwUgjQOKLjAz2yg6sDt2q7Z1D+g?=
 =?us-ascii?Q?izSNBqRoT2Ya+VF8FS/t815HSWApr8ULlZYQ+2rTRwE+BenLz59rT6IBD7iK?=
 =?us-ascii?Q?7iqG2VOnueqdw7r5C9HXQY1YGmOF46EvLrE4yS6GBj9Z4ttqxdZLrxEZHweX?=
 =?us-ascii?Q?P1HDVYCYc1a4FNaClWBr+3Rfnud6ESTkc9ylF6o4BTvEw8zzXDT/V2VvIILK?=
 =?us-ascii?Q?dH9mFknQbxbeCW82uo1Suz5vSkpcITE/HQIelySAWdIrv8TNFeyW3y8g0XBh?=
 =?us-ascii?Q?HA=3D=3D?=
X-OriginatorOrg: camlingroup.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 106cca6b-7daa-4a7a-0c4c-08da631d915d
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 09:13:07.1904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UgIFV4wVBOUZ+s4uADzSDggunkuOW2JxpopBkYO8GFPaTWwo4adcSXRg3PtVPmO2QwMiCLV9/pYOOvh28ze7E0DAMOWP1rzgK8I2EfKhu28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LOYP123MB3295
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUK97A341 smtp.mailfrom=tomasz.mon@camlingroup.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: camlingroup.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-07-01 at 13:03 +0200, Sascha Hauer wrote:
> 06781a5026350 Fixes the calculation of the DEVICE_BUSY_TIMEOUT register
> value from busy_timeout_cycles. busy_timeout_cycles is calculated wrong
> though: It is calculated based on the maximum page read time, but the
> timeout is also used for page write and block erase operations which
> require orders of magnitude bigger timeouts.
>=20
> Fix this by calculating busy_timeout_cycles from the maximum of
> tBERS_max and tPROG_max.

06781a5026350 was merged in v5.19-rc4 and then was picked up by several
stable kernels, including v5.15.51. After we have upgraded to v5.15.51
we have observed the issue that Sascha mentioned in his email [1].

As the v5.19-rc6 was released yesterday and this fix is still not
applied, the v5.19-rc6 (and all stable kernels that picked up the
backport) causes NAND flash data loss on imx targets.

I have backported this patch to our internal v5.15.51 based kernel on
4th July 2022 and I can confirm that it does indeed solve the NAND data
loss on imx targets.

Is it possible for this patch to make it to the v5.19-rc7?

> Fixes: 06781a5026350 ("mtd: rawnand: gpmi: Fix setting busy timeout setti=
ng")
> Fixes: b1206122069aa ("mtd: rawniand: gpmi: use core timings instead of a=
n empirical derivation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Tested-by: Tomasz Mo=C5=84 <tomasz.mon@camlingroup.com>

[1] https://lore.kernel.org/linux-mtd/20220701091909.GE2387@pengutronix.de/

