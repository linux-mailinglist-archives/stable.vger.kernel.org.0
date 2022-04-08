Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A900D4F9C52
	for <lists+stable@lfdr.de>; Fri,  8 Apr 2022 20:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiDHSRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Apr 2022 14:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238454AbiDHSRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Apr 2022 14:17:24 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2132.outbound.protection.outlook.com [40.107.92.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD37DF3E;
        Fri,  8 Apr 2022 11:15:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWMJ3nAAAMCYpGhCMwq9B2k09mfbb3jlp/N6NV4AvrWR+xAufvYg2IG78alsAe1vZL0VUoJgLU8+GYF0AOjiVe5rHbuCmGVMqyIWXcWfCK2+euekQozu9AeBmZpTtLjmcG660RcMLbD+JlBtU96v+P7OQSSoCcyDAGEKNeQv8VLyOn9kNYWDSXjqWBdfIyta15MlzdupNoNfplJAyQivt5ugm+Hu+P5AxlZMQC3ntzYKtBuGUMp115VyL/YzPvCA4GkJJGJkJx/TjQqau0blvkgAFTk7N5l++uWTGBv+wRNCA0muGQxmR5P6MmYvhvgNcEQ9hRgEnpChEpMT35LS5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9QI+w1/BvIPmkfKYE+ylnhfvkEv0cFnAgHxrkBC5DE8=;
 b=IAsTbblymgXJYsGAIjtCMQJT25sYwS29qUdp20+JtXG3D7grafS6rdGkLfUBRtB40cmfbpiSGlGeohjrXk9VXm/5/E/Ahx3H4XzNj74rULPsOTZs63q2sCOO/p1RoxdRP5nXJzryh43xOKWaQXk9ss/63OwHW5lCPb3Wy3FlaDa3VZw26F/KZi5kIXcTGMmH95UFsRj9os/IPzs4cOsKrbSW7nJAqIYZDKASHibUlC6804ZghgCBtWlmjRbkJqHOf5KKuxBcG4bRcobqreYRCAZ2rRiNo69sqjax0oW2GJZ6EjkRjHhUJGZSQv+vu5ywMi3C3AHxran7gxyxyafl6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9QI+w1/BvIPmkfKYE+ylnhfvkEv0cFnAgHxrkBC5DE8=;
 b=aBDkBvW8hGaOEbsiZ0H8ephSskBDHWqTYDj7hHt+23XMwyqFBh39tpi9/TAtEeiyh3yHKFk4maOuiGHk55sAuQvBzVkKiixHYjU3CbVrjSJubqlYb2pfh3ng3vD/BrOTlmI6uY3lX4eqgq+O+WHwZ6z6/sqAC7/aBZg/YXmpNCw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 DM6PR01MB3836.prod.exchangelabs.com (2603:10b6:5:91::10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.30; Fri, 8 Apr 2022 18:15:16 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5%9]) with mapi id 15.20.5123.031; Fri, 8 Apr 2022
 18:15:16 +0000
Date:   Fri, 8 Apr 2022 11:15:14 -0700
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Barry Song <21cnbao@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        Carl Worth <carl@os.amperecomputing.com>,
        stable@vger.kernel.org, Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH v4] topology: make core_mask include at least
 cluster_siblings
Message-ID: <YlB7sjPNo5irNOqU@fedora>
References: <3d58dc946a4fa1cc696d05baad1cf05ae686a86d.1649115057.git.darren@os.amperecomputing.com>
 <YkupgBs1ybDmofrY@fedora>
 <CAGsJ_4yUJXvLsGAmZ6fpHmccMLanFVVSiod_Agr+Uqzcu83h1g@mail.gmail.com>
 <YkxYOxXDfJIDtcte@fedora>
 <CAGsJ_4xgY27vZvBt8k4DaR0uJe8tRLgL=+M4-njrCM-KCuqscw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4xgY27vZvBt8k4DaR0uJe8tRLgL=+M4-njrCM-KCuqscw@mail.gmail.com>
X-ClientProxiedBy: CH2PR11CA0025.namprd11.prod.outlook.com
 (2603:10b6:610:54::35) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0dac5e4-72f6-4aeb-a3e6-08da198bbb5b
X-MS-TrafficTypeDiagnostic: DM6PR01MB3836:EE_
X-Microsoft-Antispam-PRVS: <DM6PR01MB3836639EC4A1CE367D80849FF7E99@DM6PR01MB3836.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8KyFZnIbo/WZN9NiuXM7YR9eJ4iuIHPLZ0aSHdJBi3Fah+fjMP/U33MjMWiLStc5MysE2dkVfxm8hiFkFFUHo9esrB8PGwwZF5VXc66jWQ6BBaHRGwMMlcSNsVIlcH/+SDfpivXcqm5uOdoiO8QpNXV6yEimTwE+EYgp5FAy70PZbJ5otyESeBJFqtdwnnILOi19DWLQ72weI9R/cTnDldMU2XkzYKSE7GoVhho5t4Niay8dwym9SV+KMcsgNh0WtiLZnuzaGQau4+pLScYLPzq13LDJY7v77KH2PglkMlK22KMef29QC5R3Xk+E4P5EbWsyHC8ozUNl7dYXfZ9qM+Q4bw3xFk7ea/6PM5LAYg1p6vC9Vk7Udjh1D4ZfPQNv/XhJs6vIqW6SlwcpYIB6pVU9HJbtGzudoxDo+PT4zEU+Yv6p3ARnAByQlHPgEjqn/3SqNSYvpQiKlHwMRHgbQywRhkSe3oo6JDE3Qc6pX0I3Kbl42+LuPW5FxqXyZ8X1+aR3Ge5Od9vmwCQXxUHPjo+BENwJX9hIcpfqBjxLswi1oMy+texrKoS7bwHTR2hzdBxerIOnC9WWeW5XY20n/CU+TIXyqX1MPDCzaw8l8UhXlgOriXTOsH3NhfoLySaZUPwZvd3ZPkkvDBGsv3WwuR7PE1yQ/NHMwn5H/c2xKez7HLI/9xEk33k/OWfCljhjkB+H2hyzaLdzy1SVK9gMRt81OUXGfZKAm/pXxeF3tZbh8nFybqOvMB8paw9jvGbVhP60m9MnhWpfESUY/ePSfUSHVb62CyGb9FnVqdANFXcJ86+5PbXJSapE6sUGOkJJvr8QupIrwWxvbbYCfMhbtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(186003)(38350700002)(6506007)(9686003)(38100700002)(52116002)(53546011)(26005)(6512007)(6916009)(86362001)(8936002)(5660300002)(8676002)(966005)(2906002)(316002)(6486002)(66946007)(7416002)(66476007)(4744005)(66556008)(4326008)(54906003)(508600001)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xV1bjJEdNxVBrgPylHCutXeBxciIZuA6Q7QhrfHnMA4H0SoxkLis3jkNlg+G?=
 =?us-ascii?Q?pR7AIKNuozUEfI0roy3W1Js6f+3IB4RJ5rq9zy93h0ufTttGu6fvdCNXXEFd?=
 =?us-ascii?Q?gJXLRJ8+FUkmus+gfvMiQ2ceOxA5ZjfO/ZMZxo62Ej43UcOoZD3vULngI1Ir?=
 =?us-ascii?Q?pXCZpfUIZFDqJh7ZOBeswzAdrZa0ZmX4fG+LRylVNPlHRAh7kf49Nd17BKbq?=
 =?us-ascii?Q?GFWM2MrbtPdfCXaHztVd0sdZRwo2GoxxtbFqR5iBvLrOWVjkmJP5mrrkzHWq?=
 =?us-ascii?Q?PIzvpPdboAi02IkKR8kKiuC7SO+ShCwHhhLCXmMy+RBUy9aFctOek++/kasA?=
 =?us-ascii?Q?cS9XRHWwrn3CWYoMYfGdDkuPQV9XVJL2/FJLADFTssGQJAz5G9RN0p8G4Kn2?=
 =?us-ascii?Q?bBZfVcR1DZhr137kg2NcQUbW/OQ1Fw0/L2vT439w9dIUGLv5fsyAPKHTWP+L?=
 =?us-ascii?Q?vpwXQODxpi08pQX790E/tltmUEs/E5vXe8wnq8CRDV6HS4w6yQ1UwLDxmSYM?=
 =?us-ascii?Q?sO25FXMsmhUZ3OAGC9tiKRMh8BXdhVYezTlHQ6EDl+Q+SBpv/8m7edwB9Zvj?=
 =?us-ascii?Q?v+hKGeFzxI2UeIoN3I6pqZftDD9rgBlawFtlbi78lpOXaGJREy4t8+Y6MHH8?=
 =?us-ascii?Q?AUnWPIsVQZBhXYBPiLu1RR0QLFbue7l/s3eJC5Lf25dRT8Cib6gUIBoXNd0h?=
 =?us-ascii?Q?ng9hifJut96tmFV0+86BXof80tdy52tCJgJClPOWfqVOnF4rYGdLPB/ot8ua?=
 =?us-ascii?Q?V0r0QHP/UZfxR06t+XWuMkUszcWd5ebI7cgS3Ub63XK8BDTKdgubRfC1m33h?=
 =?us-ascii?Q?wM/k2hgMl7Wgy+EJidcJYzu3gvMTvWQCZY7NYdWSpfg11OoZ5drIE83CzHgu?=
 =?us-ascii?Q?cRRvY8oNYCuDobAEbHBUCmlMzUwnfLkJhefohfy0w5Q/9VbN16LBwvLVb65j?=
 =?us-ascii?Q?N3UsImzphBZ4XJnSTFq8/N9ypfl7aT7kMCDfNC2yiNboiTshoPoKlw5CalHw?=
 =?us-ascii?Q?jU5VfUbfIMt35MNWRvcZQaLoxZaBi0Wvgd0H+PAu3d9RJkguH1NoOt8l0JeU?=
 =?us-ascii?Q?2KlEo6flq//X+8FF/sGtq71JSU1MZDLHo9PCNc3x0nPxX5ubuiVXttwm054o?=
 =?us-ascii?Q?D7dGzFvcH06Cg4rb5IMY81qsZCwKxDPM8pHdNtCbj9XMi1xbmDjqf68Z6Hcc?=
 =?us-ascii?Q?o1jILd9HytiUgb80vTcO09t2O/KcMk0UOIJwgGZ9wZZWVM0C4vyPhrX2K82D?=
 =?us-ascii?Q?KAXFNLBpA9z18To4AD32DZshG5VCF3ZKjnR8HADnVWNw1agN8HdpeJrN07WS?=
 =?us-ascii?Q?yQy/KgDmTxfMkGuCxNHu0IDvsd+NqTZfgCdPD/+4vfrKULtVxv8dKvxywLI8?=
 =?us-ascii?Q?qhIyZKmY24GOvIQ18FIuSH5DXcIVhk4fEVUZknEfq5nBBwL/6G1XYkz0XhfI?=
 =?us-ascii?Q?VmJ/2HlGh/0XfGmvyR5iPFE77I/aNQv4ReQoDullPlHIOiDv72ChfoNVeZec?=
 =?us-ascii?Q?3gMFgCoG271pdNkasa0hfGHUZElg6wvcYkssdk6KIyDggbO0O3ZRvE8bxkz8?=
 =?us-ascii?Q?cFJsAOlgB1PsXWIuGf2Jhkqlq0kHmHNdl2tnYPDod8Bbd11/SpProAk2ZIQ4?=
 =?us-ascii?Q?Gn0u7xrxN8itHRMsSgwRfafAO22qM0EeryxZTdaQYsG+T3Biz74/wzGvmkM1?=
 =?us-ascii?Q?UKpYyLB7wC8vJfPCU5IoqW/5tuK4j+0DCg6GZvjRTIU/MJoj3Orfd5PG3PbZ?=
 =?us-ascii?Q?UdPNzJc8hvqdYYibjrqEpfThuL5nNMixTwJYhDFVFSDbvgUCRwiG?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0dac5e4-72f6-4aeb-a3e6-08da198bbb5b
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 18:15:16.4132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2sledOgRjErR/DQJxu7LJckYsmcvQBAuQ14C6bQSBgU6MfFc1BO+oDtsv68X6HqPHz7YWdi9qp7HZzaGzoqe5SriShMxuhlt6KQrHMONtjQnpeRrknwhEYqPPuJ0jk1Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB3836
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 06, 2022 at 06:14:16PM +1200, Barry Song wrote:
> On Wed, Apr 6, 2022 at 2:55 AM Darren Hart
> <darren@os.amperecomputing.com> wrote:
...

> > Can we add your Reviewed-by here Barry?
> 
> Yes, please.
> 
> I think you should add
> 
> Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> according to:
> https://lore.kernel.org/lkml/e91bcc83-37c8-dcca-e088-8b3fcd737b2c@arm.com/
> 
> Acked-by: Sudeep Holla <sudeep.holla@arm.com>
> according to:
> https://lore.kernel.org/lkml/YiczzB92EcShyvLh@bogus/

Thanks Barry,

Greg, I am assuming you prefer I not resend the same patch with these added and
that your tooling automates most of this (b4 or similar). Please let me know if
you prefer a resend.

Thanks,

-- 
Darren Hart
Ampere Computing / OS and Kernel
