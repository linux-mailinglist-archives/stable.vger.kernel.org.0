Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEDB37F1F2
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 06:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbhEMEZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 00:25:44 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:42423
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229504AbhEMEZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 00:25:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kydMDPnUAmyBvHuIqR5+k6jXaNRp1ZH4tTl8AwX5EyPjD6JuaZBbn4mEzJVUDAGGH4KKblnc2VKeSnoc8Ask5gqHGsiaZlx7WIwOBKMnG0uCFeUKWCU8rBUY0Dp175H840PabbfB6AA40LBlirNvYEs6ZptmgJQgtJ3nDgMzJP/BDPFxd+xH00xSH8Eopq7d0y2Z3hX8CQWxS0KtTBMqjUQOPgvEeHGLkyuNOY2f4VBTH2Ce23wRzEBfBWDIhGJZoze8m+xIgX+LsrqnTd/gk+VOww1ahY/SFALs67U+d1gdYVYopPGAhZs8gM3dPm/2W0K7xB1IvD/lNGF971IT0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4IiuI/Imf5iZFxLeTCTsIWDM81aI4iR79sc9t7EV0as=;
 b=VsVQdlHATQrMQxmJSJGNzJNvUp3Rr3+8M1nMXp5DkrLivmAPldYR3nn2N+xuAo2ZYPWOUld86T92TJGEo+13VQRvcsR37eg5CPW2GvDrJURcM0NyxOjsURi1IcqjOQjda/KUkRjY8LqRh0ZQ9vGLC9EqDalQ3zyLeCxOaTkcJdljqXYOWHF0ZMvQNP05pstvJSHt5DfXQ48WEgXWocebloe7nLTGCrQhA/1xz6DuEKLG8cVc5wouaqOqx700Z1AP3ndp8bWEwIQigkJxYM6PYNKWgk+Q6pNW/qcy4UKC2+T67I8VjYU4Zrevyho6zVbz6Al7y5lhKavDPb621SPU8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4IiuI/Imf5iZFxLeTCTsIWDM81aI4iR79sc9t7EV0as=;
 b=BCxeAuBT6SFQOM515wgUGq7BY5WDs65kHrlIjiWaCt1/ihK+1Oooq2OxRp2LWTjtcoRNr6jHLCSYh1UWUXibI4T7hVAOlajMDPRhEbjzamuznvH/1QwnZ6Io6iLlYltZRLPa8Ywfy0I7Cn9ax75oiN9qiDZDD6xseMWus0eznOM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1248.namprd12.prod.outlook.com (2603:10b6:300:12::21)
 by MWHPR1201MB0045.namprd12.prod.outlook.com (2603:10b6:301:5a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 13 May
 2021 04:24:30 +0000
Received: from MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c]) by MWHPR12MB1248.namprd12.prod.outlook.com
 ([fe80::f07c:dc0f:e7e8:416c%4]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 04:24:30 +0000
Date:   Thu, 13 May 2021 12:24:20 +0800
From:   Huang Rui <ray.huang@amd.com>
To:     Ingo Molnar <mingo@kernel.org>,
        Alexander Monakov <amonakov@ispras.ru>
Cc:     Alexander Monakov <amonakov@ispras.ru>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Jason Bagavatsingham <jason.bagavatsingham@gmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        "Fontenot, Nathan" <Nathan.Fontenot@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4] x86, sched: Fix the AMD CPPC maximum perf on some
 specific generations
Message-ID: <20210513042420.GA1621127@hr-amd>
References: <20210425073451.2557394-1-ray.huang@amd.com>
 <alpine.LNX.2.20.13.2105130130590.10864@monopod.intra.ispras.ru>
 <YJxdttrorwdlpX33@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJxdttrorwdlpX33@gmail.com>
X-Originating-IP: [165.204.134.251]
X-ClientProxiedBy: HK2PR02CA0158.apcprd02.prod.outlook.com
 (2603:1096:201:1f::18) To MWHPR12MB1248.namprd12.prod.outlook.com
 (2603:10b6:300:12::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from hr-amd (165.204.134.251) by HK2PR02CA0158.apcprd02.prod.outlook.com (2603:1096:201:1f::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.31 via Frontend Transport; Thu, 13 May 2021 04:24:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ab6cd0b-e986-42a5-e0f7-08d915c70092
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0045:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1201MB004571EB7510CA84E62FF4FFEC519@MWHPR1201MB0045.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vPCWlIyS/qcPYwC/knJIhOgG/BwxV4So5xagWOhhNo4U5kuIy2dbsY/6eXIj9tyeK6NK9FAC54lqwfTW1c3uhp9A9XjH/p9e+UjF9FxT/AaWHbejOWagiHHZ2iqHGKyHzzwahgtqLwajaJwRT2ndaAm1c1XxB7e8IhtosPQUd//Fy5QXbFMO1dX1h94+kV54qr7ce52ckg735FN6ulXu73i0S5Ryhp5gKum6y3WMWUEFunPCbYtsu61L3lbSEDBNcqxueODTTW4p8a7tmJrpejTVxa3tTmKboO0O3DjgSmYSaMUPnoBngGcx5nvnJxhZDNU6JIqW5dNTK38FFBnQckG2x0F18nVhvbL0bRRzYmxeAdmI9uuSx766ECdkbrPr9+FmJMDpjhs4Ox6T/e5sXRPaRVEN6aj9JYW3qAYoBbRyS5JHQwImKgoQYJk9XlqlqpkRGOOim/KpKJlDTi4LsmBotAOQB5GjEiQPqur+nog23w0zuC2siwekvTgVXzgD+40bfmO/FnJ9h4WWASWVDRQdB0QBzYJOmMjoGmDZdaNKD+dqyjp1/qOAcGw0FjLZJ1cE5L29JjcpFZjhTNQjCVWLLOJAmIIMYJnzIalJnRtfdkJ8rBI+YmhbfBBrX225t/DVEJpMJvzfjpu+zWMQST+WKq4YF2c+yqG2+aviPdE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(55016002)(9686003)(5660300002)(33656002)(1076003)(4326008)(54906003)(38100700002)(7416002)(2906002)(478600001)(86362001)(110136005)(956004)(52116002)(6666004)(16526019)(186003)(26005)(66556008)(66476007)(66946007)(6496006)(316002)(38350700002)(8936002)(83380400001)(33716001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fHnYelYDNEJo7xVPFMW0Hx3lBJHcVhAahvIlaULJiSigm8kY+rY8tDZLNAOv?=
 =?us-ascii?Q?T6FEV0c8IIg2jM1xWwu/xCcy7pFbqGXm42UyOMZlratQHKBoiuM6kiLutX5N?=
 =?us-ascii?Q?csOZ2M1Ld/UhcB/XcOXyuDFhQeu7KVGfMgqj3TmRxwMvAkTJzJYqNuPggpcj?=
 =?us-ascii?Q?KTe41hzXBis8jvw8kmKfVDeJMQR6zAx0EYde3y+AJergVyo1Izh3/DMdHfMs?=
 =?us-ascii?Q?kAtPUQVqL3LpS7ovDGtishCareE8VBCzoiA2XFhWJJy2C2Zv9gLusYGSg0vs?=
 =?us-ascii?Q?fS8xLU74/rsTEzQ1d/Rx3rnZhwldpW4ZMLUkRFEGnfhMbLcdl+N5gANTVGdr?=
 =?us-ascii?Q?ENUXRVXFy30PjUupbVHZbmh5GjoYgYLUzaa/2kHYm6z5gtNEAKWpqPA5XGS0?=
 =?us-ascii?Q?8oUfC6gnWiGTwIVWfqLNAHeXJyUMC82rcB/XAlSE7jrbqOM59mZUSyQX3LDH?=
 =?us-ascii?Q?eI2HwScD5IGBbRryrFbhcdfjOrhcEFehvcCbVykND3mqoz4nrbeKACGUT1vD?=
 =?us-ascii?Q?Jc9Nv4/W7Ttsv1Y9CdbeFZ+haHXQHruaiPklpLj1NnuFqTj3pKK3tcclGP0p?=
 =?us-ascii?Q?wVbzHm/VKfU0Wnms8jRr8XI6eCO9o8zCDA0XiH87X5Sg8v1N4sIix/pFTbHG?=
 =?us-ascii?Q?RRZmptTfpblyCeM18emTJdwMUMLlD7kvGqmIBHoHnK1sIvGJGqEnTWz7htQl?=
 =?us-ascii?Q?ujF3n7lSTUDgp8cnM06YaG82m5CBTHuekxX+3m85j5525PcSYnM6reZMmaDu?=
 =?us-ascii?Q?4M615P6jyWG5sMTWmbeq210k58Cpg5DbxXent1swJ9cPs/1UB0rfMd4Nzkue?=
 =?us-ascii?Q?/TJEJytFFuGYrCV4Eyu7/0ov2kCD1ZCmWqr+xX4Yj6L65ckQHhvY0trpfAdo?=
 =?us-ascii?Q?kWlyw48u6VtUXHKBaYWHE8qhzcbDSQm8aRlxTeQN0LgHD5yV2l7rEfORe8YX?=
 =?us-ascii?Q?Ss8SWlLoHAof7SmIFmi2LurLsNyRR2zRy64ElCy004Lt2WfEKsC8/UCHCCwz?=
 =?us-ascii?Q?kUo0/hLoj6kQiSun6uhScKu+PUcqFnLmhVQVidngKgEvmxksybUqpeI/5Sq7?=
 =?us-ascii?Q?ZlpoNWdjsmXscKKTuYsipda6PeFOIdmypHz8bxfWEVVzRm+En3Wpwnvp8gIC?=
 =?us-ascii?Q?yNuyHngqc7ruKG2xvzy0pBKjWy/0xkMwzomm/CQQD3H1g05/XdUYr+F0jW99?=
 =?us-ascii?Q?UC7NeEI11itrrWpEd+0jVTFCyEW9DmkJbdU4xV6RS7Skao9XdPRe+JEaspTN?=
 =?us-ascii?Q?N+Zw84qr8Vg4UdNOEhhnr0i4p3+sBrf/ooC+KSLSA8u4VQhJbTZZuB57B/L4?=
 =?us-ascii?Q?4EhiO5fhFv+I/40Z6R5lLJR/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ab6cd0b-e986-42a5-e0f7-08d915c70092
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 04:24:30.4125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9XbWVHN9h9YhYHgcMouMVkxNdOx5lq4XY/hI+w50Q7D6n4oZWW9w5wmG1Y7vDTZBCeALnsbMkH4R64ICSuyiJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0045
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 06:59:02AM +0800, Ingo Molnar wrote:
> 
> * Alexander Monakov <amonakov@ispras.ru> wrote:
> 
> > On Sun, 25 Apr 2021, Huang Rui wrote:
> > 
> > > Some AMD Ryzen generations has different calculation method on maximum
> > > perf. 255 is not for all asics, some specific generations should use 166
> > > as the maximum perf. Otherwise, it will report incorrect frequency value
> > > like below:
> > 
> > The commit message says '255', but the code:
> > 
> > > --- a/arch/x86/kernel/cpu/amd.c
> > > +++ b/arch/x86/kernel/cpu/amd.c
> > > @@ -1170,3 +1170,19 @@ void set_dr_addr_mask(unsigned long mask, int dr)
> > >  		break;
> > >  	}
> > >  }
> > > +
> > > +u32 amd_get_highest_perf(void)
> > > +{
> > > +	struct cpuinfo_x86 *c = &boot_cpu_data;
> > > +
> > > +	if (c->x86 == 0x17 && ((c->x86_model >= 0x30 && c->x86_model < 0x40) ||
> > > +			       (c->x86_model >= 0x70 && c->x86_model < 0x80)))
> > > +	    return 166;
> > > +
> > > +	if (c->x86 == 0x19 && ((c->x86_model >= 0x20 && c->x86_model < 0x30) ||
> > > +			       (c->x86_model >= 0x40 && c->x86_model < 0x70)))
> > > +	    return 166;
> > > +
> > > +	return 225;
> > > +}
> > 
> > says 225? This is probably a typo? In any case they are out of sync.
> > 
> > Alexander
> 
> Ugh - that's indeed a good question ...
> 

Ah sorry! It's my typo. It should be 255 (confirmed in the ucode).

Alexander, thanks a lot to catch this!

Ingo, would you mind to update it from 225 -> 255 while you apply this
patch or let me know if you want me to send v5?

Thanks,
Ray
