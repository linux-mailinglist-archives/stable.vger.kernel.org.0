Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B586D575AF7
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 07:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiGOF1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 01:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiGOF1L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 01:27:11 -0400
Received: from eu-smtp-delivery-197.mimecast.com (eu-smtp-delivery-197.mimecast.com [185.58.86.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 784A679EE1
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 22:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=camlingroup.com;
        s=mimecast20210310; t=1657862827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=109QY6VOR+mVOSJ2L322nVjAcaPG8/fpi7E6rdDEmtE=;
        b=MriIDDuqkvCMyqXCBWg9Fq4vDqdWrpBxR5XnUFYNXGQ3YadYzldqgE1yErMVtUgwtoCkK6
        jHKeWBBJraGY/cUDNyjTYX1+58kKhHRUl+iQ00VrHJyq2bSiGTyL2If2PKBa89tzAPj8DU
        8ccXPCqztiRUehoUI0Dagt1gUwlssp8=
Received: from GBR01-LO2-obe.outbound.protection.outlook.com
 (mail-lo2gbr01lp2051.outbound.protection.outlook.com [104.47.21.51]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 uk-mta-309-RzTTU3zgOv6upNlXtulcIQ-2; Fri, 15 Jul 2022 06:27:06 +0100
X-MC-Unique: RzTTU3zgOv6upNlXtulcIQ-2
Received: from CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:1ba::12)
 by CWXP123MB6143.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:1ab::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.17; Fri, 15 Jul
 2022 05:27:04 +0000
Received: from CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f56f:d3d:9a1a:5e4]) by CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f56f:d3d:9a1a:5e4%9]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 05:27:04 +0000
Message-ID: <fd830c7e94de6b4a0b532dfcf46cf1edd22b42fb.camel@camlingroup.com>
Subject: Re: [PATCH] mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on
 program/erase times
From:   Tomasz =?UTF-8?Q?Mo=C5=84?= <tomasz.mon@camlingroup.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-mtd@lists.infradead.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC:     Han Xu <han.xu@nxp.com>, kernel@pengutronix.de,
        stable@vger.kernel.org, k.drobinski@camlintechnologies.com
Date:   Fri, 15 Jul 2022 07:27:02 +0200
In-Reply-To: <c2d545d1f5478e66c0dac47f4bc4c04256ff44aa.camel@camlingroup.com>
References: <20220701110341.3094023-1-s.hauer@pengutronix.de>
         <c2d545d1f5478e66c0dac47f4bc4c04256ff44aa.camel@camlingroup.com>
User-Agent: Evolution 3.36.5-0ubuntu1
X-ClientProxiedBy: LO4P123CA0544.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::9) To CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:1ba::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2a74952-8730-4c10-97e0-08da6622a71f
X-MS-TrafficTypeDiagnostic: CWXP123MB6143:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0
X-Microsoft-Antispam-Message-Info: TgjaF0BKUAbiclCM0YbubHIRSUw0E9CLeWnUsrnXPZ5VnlaMgp83y45SZWCiXoZ8VbNQTmb26p+iVZ/8SMnwUc+3/7pM+0KmKSCdvGclHjVtveVzf1lYuAxpgxTRRWYESRAE6H1ky8UvOEqBry87bD/cuFxM+7pgu5d2W5cc1lNj13zM8l7x1nf55ynwfVNK7PfXa/J2HvWXa+u2/5znWcRW4sMu56eZtCKEP2U4UnZqfztPinvv/msNXCZU+IHrsGibVQ4ZV8BG/CMk3xLaCAIB9R63RJ5YmhLPXV3MIvifGgA6xe2BTyaZgZDDpJ8ZMkN4TRUGPbujoYFz+1Y/v9zG3VCPFfx850Xo0sRHta/qITlDUBAKMub680eAvO0Ix7gQFstSGEWt7hFwGPGktcKfE0gdxj3t6QQz0lV5fVpTJsseBHrrIxaiirps+GM41okQNvcpxJqN1vcpV1FECXTsHo+Luwl6AvLPXl7c6VSTOEbiFvuIq3QX5/5JhzjU14GDdAoLvC7RmY5muvBnLiWC9hy6i9uZi5pUSaEpYmi5jrSGX06z9eJNZCLpLxRaXRub2C0mJwG9xaOhiLH83AQi3G5O0J3wqlw9LZEEEzjSwxLW2xMOt6HQ+xmNVYK+OOD6msw+HOiaL2cWh59Jc6vn3W8E8yTgGamjekot9BiJJVKxQB1srxhvT0hO3iLFAoondiAo+oAprlRpuRnbydDzbr006uG8alJ/r7SphmYPfHufg8038CYr/ajmPkizBSEKCRiNwLS6WTqqUxH9QWH6mJFcN3DHn35s/qp9m6Qafn4ppqiwosy6ELIHW8FVmXILZi1ZzoMbCWrjGcYVEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(136003)(396003)(366004)(39850400004)(41300700001)(66556008)(2906002)(316002)(478600001)(8676002)(36756003)(110136005)(66476007)(52116002)(86362001)(6512007)(186003)(966005)(6486002)(4326008)(26005)(2616005)(8936002)(83380400001)(38100700002)(38350700002)(66946007)(5660300002)(107886003)(7416002)(6506007);DIR:OUT;SFP:1101
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B/1ncga0uHJhCNGaQUYPMcyHsMlWp3Q+YGVM+hhUk9tTtNCOcBgAivAqD0kx?=
 =?us-ascii?Q?YzssOL41nAAn62tO5xX7vZCQTEs6FeRxpSrDcTA10vZPLEauX9a8A7ZEf+sl?=
 =?us-ascii?Q?NSZyL5X+yBoWRZqSAIO3pD1Vnpk9dzEOCS4qUHhyEvnbMjosYpTkxuGCy/wj?=
 =?us-ascii?Q?/ceVg8OU0qR52/lYbZqdXAdI10nbxhROUz9oi9zwcgWTA4L1PxuAzoIW86wF?=
 =?us-ascii?Q?gL3LO7p0veIq8mQGfRswUL8e5UN9A42bhw4IX9ItzUsbLRT0HFozuGiNUyBI?=
 =?us-ascii?Q?PgLdF3HLc28EyY1S7cIR2UFylL9C/aMbK3h/NlsFXzUCue2JplagqOnSq16K?=
 =?us-ascii?Q?bVN8BVy1Bux48Bw3nxH5DewRA5fjkH8JGXzMaQwezPQgRG52MEBtCPG0Qzv0?=
 =?us-ascii?Q?gKSmXGK8Rm9TXIII/mUJQ4fi+WXoQh+shnkpWDJB59KVrvwnuPZZZYTiADsA?=
 =?us-ascii?Q?HwwmgR4Sp8/fu/xAq0DcbmTbDRT0nsOTZ93EhfX21JeItyOQAVzSgEKxtTX3?=
 =?us-ascii?Q?++FkzMqYDbDB1f4yLGIYhyMYpeGH4yRAgng1jGVx8hBDfWVrGtebbvb1SCFc?=
 =?us-ascii?Q?rK14W8SldB6Q7YvkWwajqW6XPc9xWtXDD3sUKfhx7rO94xkXf9zJHC9GQ52V?=
 =?us-ascii?Q?+lcrBvLkzXoB4gVrQ9gOGeik9KM+HclqJsHQUbl3anw2mqj3uB2nvlgjzYbS?=
 =?us-ascii?Q?uzey5ve1QTjDMvqBGhYuEHWdNw43pE7CrvSrmyugwnOLwAO38Gw4Q+W3S+bQ?=
 =?us-ascii?Q?9hnmToca+PyC+sR0fn6/cn7T7ImZVHg287ryHPvVbtV6xSF+d+yk4yQJJKyB?=
 =?us-ascii?Q?knMINlaWfDC+6UvjpuCjjxR3K4bZKg998U2RAblHHkmHzr9D8YZJgXwf4Vxo?=
 =?us-ascii?Q?t+bUbAcApHXKf7Hqjvvg31XPDCE6JMO6TUwtZV3B7Fc/IxXcUWRfIkWm1k7N?=
 =?us-ascii?Q?Zi26KZ8A31ifVODf2wYtBALtmxj5jVEj4VYbFLLPNd3cbcDVUrY7T7Li+ba/?=
 =?us-ascii?Q?QQuwfUfVcEHE+fU6SSpqJpiVb4UiSX5+PLTt5aNeYM9/TT+Bg/uwSpeuiw8c?=
 =?us-ascii?Q?xIQcTs84tsHk+O+jqWpYwL8CMA+qFjelIN99cHhk+aaGc7kX3CBorS94cvKV?=
 =?us-ascii?Q?7NPRz43bUSdjVM0+8yMuyCqfHIcEIuaAkyktAghULk2e1Ej2czJ9TFmBj0bB?=
 =?us-ascii?Q?S4eQS7jcTYUGGTp9OKV+piw4h/Ufae4YeWQJnnDYYS3G76NNbEIxbnVUy07f?=
 =?us-ascii?Q?9DoQSw7B+Di4eby43lBZ5wSINJFq0xcp9Q9xyCon5961JqkR33ji9YSTc8ig?=
 =?us-ascii?Q?lfTq75Co0J7Fbt+rgjJ+e377uW6ELcMNE4O5kkidG7TtkgyBG5zK/Bk4+OSv?=
 =?us-ascii?Q?mSB0tDUK5PXgSipQbW5/B6FM+oz4D2oSmUBYf2SomQTsmTnIYz3G233xHEYt?=
 =?us-ascii?Q?Tf+31lUxmunb889ZvAbolwOuuR5get+QQQfVqlsC+3GRCklViwyel6XNax97?=
 =?us-ascii?Q?5aHeSLgx/bRhvm330vHZbtTaHH/dA33LGB5DE/+1Hp9CLiEaVQAfykPFHH6j?=
 =?us-ascii?Q?L2pNHhxQJDUISAGTPH80BcjBOJdvOnoRGkkz5WcMQcSrm2RIz5Ds82G2IyXH?=
 =?us-ascii?Q?5w=3D=3D?=
X-OriginatorOrg: camlingroup.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a74952-8730-4c10-97e0-08da6622a71f
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB5747.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 05:27:04.6538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fd4b1729-b18d-46d2-9ba0-2717b852b252
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5VO0HHh21yk3g1TECeugq/2nWsix313rN1WXI9E2Wa2zORKDNNEXBgZFxQXFaYH85MV3x2teg2EzqM4/A4OljEP1CtqC2yOVtpJs2qBslwc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB6143
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUK97A341 smtp.mailfrom=tomasz.mon@camlingroup.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: camlingroup.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-07-11 at 11:12 +0200, Tomasz Mo=C5=84 wrote:
> On Fri, 2022-07-01 at 13:03 +0200, Sascha Hauer wrote:
> > 06781a5026350 Fixes the calculation of the DEVICE_BUSY_TIMEOUT register
> > value from busy_timeout_cycles. busy_timeout_cycles is calculated wrong
> > though: It is calculated based on the maximum page read time, but the
> > timeout is also used for page write and block erase operations which
> > require orders of magnitude bigger timeouts.
> >=20
> > Fix this by calculating busy_timeout_cycles from the maximum of
> > tBERS_max and tPROG_max.
>=20
> 06781a5026350 was merged in v5.19-rc4 and then was picked up by several
> stable kernels, including v5.15.51. After we have upgraded to v5.15.51
> we have observed the issue that Sascha mentioned in his email [1].
>=20
> As the v5.19-rc6 was released yesterday and this fix is still not
> applied, the v5.19-rc6 (and all stable kernels that picked up the
> backport) causes NAND flash data loss on imx targets.
>=20
> I have backported this patch to our internal v5.15.51 based kernel on
> 4th July 2022 and I can confirm that it does indeed solve the NAND data
> loss on imx targets.
>=20
> Is it possible for this patch to make it to the v5.19-rc7?

No response, so sending the email to more people so the voice is heard.
Sorry if this is not the proper way, but I think the issue is serious.

Current prepatch kernels starting with v5.19-rc4 and stable kernels
starting with v5.4.202. v5.10.127, v5.15.51, v5.18.8 contain a
  "[PATCH] [REALLY REALLY BROKEN] mtd: rawnand: gpmi: Fix setting busy time=
out setting"
that is wreaking havoc to i.MX[678] or i.MX28 devices with NAND
  "** THIS PATCH WILL CAUSE DATA LOSS ON YOUR NAND!! **" [1]

The solution is to either:
  * Revert 06781a5026350 ("mtd: rawnand: gpmi: Fix setting busy timeout
setting") and all its cherry-picks to stable branches, *OR*
  * Apply the fix ("mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout
based on program/erase times") [2]

Please do whatever you see fit.

Best Regards,
Tomasz Mo=C5=84

[1] https://lore.kernel.org/linux-mtd/20220701091909.GE2387@pengutronix.de/
[2] https://lore.kernel.org/linux-mtd/20220701110341.3094023-1-s.hauer@peng=
utronix.de/


