Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C84641B44
	for <lists+stable@lfdr.de>; Sun,  4 Dec 2022 08:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbiLDHO4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 02:14:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiLDHOz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 02:14:55 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961E2FCCC
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 23:14:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rw+uTRlm500ROSAE2FMVymytAF5+YD8maJGT9S42CG2jlpxY8f9jEalh8TpCPntAc5PfiHGEFwDpR6IXmUR2ORcbPXEHG8nDmy2AHmiXkjE3f5+tn1ZGmBBDIRKfBYXWF1joYI/Badn+ExOkfNvl/gd7xV1oi2wMrhVsEm3yv5LAdADeQS2AKDrdm/z7hvhe6uWTGACVZ6t2zXKp1QrdpsP/9ZZOAnUJetG7l9ReCSMNAbOd8nEwuY6HAketh/zFZgEiQxELcEZJkhS5IDzlvtoSPHEJ6EdCNhVMqL6coM5csqJQ9VhCT5cgmL6vHdnNf2xk4u437cSK8QTmBocA3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s5WLCvu7IjXSRym6MNo0cxlSaCbVLXExOMYbmrKf/gs=;
 b=YjsIUS9H6gAQvxbG/k3OcRDT3/pAH8SVuGtPy2dNrsp+G5zmzCJrvJSvF5yYwAa6SSuU51SzQ2pCSQBAGsrSr2P7Y5cijUgTwUdEg1YhTm8Cxz1i0Wl4OtG/DdyhJK6vnfkV7tIbQInJOlD01iuzHcp6kjZpuF1OUCBZxQ2pYNez3PPOcu62Qvhsu80D9EZYLL+9dD/F0mtnRNFgMoZ5ox6sQKHD8OiADfanwNvFt/2iUDoQhzkrhbEnKqtPG3mfoXMf5XetofYpnTJ4M2jr1UHjyD2amPIg4IfhXc1B6fV/vAFVh5avQfxtijFOnLMw98sIM9WYI+ecdp2F0iq0Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s5WLCvu7IjXSRym6MNo0cxlSaCbVLXExOMYbmrKf/gs=;
 b=ClWpsq62D0oHU3ushL1MfvPmvr75/dhfOxRbuM51gi+19iIJglejJQWZ/ibl658Hv2+88nkJaKT41niHnUzItM+I0YEBbC0WH8bck34TeeSAqJguP224TT1f3p8kxo6KsGK12Nq3vQdXPQ2fdi4+lArEazG/v6AAMGtshwVC0gIel6HK940pIGKl0YjF0ZuFWpaBJc8+0KX3lofHASn+4ZNrGlFu9YBGz8yv/bPChTem3MbMGGeLMfZ5208bPapMkCpTkin4JTamfKclAaFgKtRlhyEB3RuqD+/8RNIr6MeTkmkh1cl4kluHi7NXRfi2jVN3TBvgKQG0TC/FRI4HOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DS0PR12MB6392.namprd12.prod.outlook.com (2603:10b6:8:cc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Sun, 4 Dec
 2022 07:14:51 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.013; Sun, 4 Dec 2022
 07:14:51 +0000
Date:   Sun, 4 Dec 2022 09:14:44 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     gregkh@linuxfoundation.org
Cc:     dsahern@kernel.org, jonas.gorski@gmail.com, kuba@kernel.org,
        razor@blackwall.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ipv4: Fix route deletion when nexthop
 info is not specified" failed to apply to 6.0-stable tree
Message-ID: <Y4xI5C0bDilNwWm0@shredder>
References: <1670065201171234@kroah.com>
 <Y4tcuoEGHI92wF3u@shredder>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4tcuoEGHI92wF3u@shredder>
X-ClientProxiedBy: LNXP265CA0091.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::31) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DS0PR12MB6392:EE_
X-MS-Office365-Filtering-Correlation-Id: 5450fffb-10a2-42f8-e8c0-08dad5c73b7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FZBREbX9IACc42DD3SMF3OwF9pRPqTWlxPxOGAHB92hpymW6ZJsa7r/6PuNDAmbjsiGSKS7OOuAssNeLOcyACbWy8uwWpxTFdWKllXafvlaEr73pBlixi+oozyJXGFPnidt7yB7NEkHS8Ozf+EZBIfVYgnQfeKPiZM5JI3QRNGi34LDC0z/bewrdw1CDNwtuo71S0X88rDmoDWlfOYIdvLhhKdCyBJIfMGaj+d061mTyWrsQ5PznJM4kSg/xT8MYWRgKnCmNJZQ9cnamSoePJZqK/oihZFi/QgpDOV89C75d+EvvRVM3E2TB4W6jr4YNoPOz6hW+6/GGibeR0t8cYEUyHtyNhavDXBMDe/YCroPk812vA1btnx9UsAKNSGc3aFWl5VGZ59qOQzhi7wJVX+bRWGL8OcVzCtdPJmZLFSlDFtgvX6dLeXTlyNiUmA1hwD1KkzSKFszZfibK8GnGptEFD/29t2+Vd5AA925UV4wON1s46s+rtUtcw5XPaKXaZxL7Gj3CWqIN4vVokLYdpZ/f+4n4xvulOPnnOptMNPiKOewjYnHaTLAeUrLUEPsolOzv4b4DJ+tmpHpCJE9YalX6aabMHswruhQkYGdtXo5vDfytshpIPDUbA6TVp2SAVATfXjZuD7dOc9N9T9qcwZy5sAQDqQBvaGc5bZ0Dxu6S2hf/3Lx5ud8FQdfuJ4ywyumdEM0uuAKiW+P2g8nDKUDZK+MT3UaPDzOVfVbgXAFeFVnJc5Wrio8EsrsjXpcT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(2906002)(86362001)(83380400001)(316002)(6506007)(9686003)(6916009)(6512007)(6486002)(6666004)(26005)(186003)(966005)(478600001)(41300700001)(5660300002)(8936002)(38100700002)(4326008)(66556008)(66476007)(66946007)(8676002)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wg5dkGLS2csjhkbC4OuxUYarAyMJr1KIuKsVLGgByuF3SU/eZQplV0NNsnM6?=
 =?us-ascii?Q?PTib5j122tvBWFju+j8iAERP3nLKrAZjx4HUz0uxCiLR1/j3gf3eYPhVk1DR?=
 =?us-ascii?Q?Fqeh1pyre8FnWOI0aI4jN3as2efGUu4fga7dK8BThU5L3Tv1dBOkPre6xq61?=
 =?us-ascii?Q?KEmAOulHCqaS3//7HHTg0CIma97y7I18/LMSNO+MxUhtdvrjY36+8cLm8aC7?=
 =?us-ascii?Q?eGARMne5BIC/BOtqhK2N1tJAGfAR7QMlZv99tqwE0Eh9SySe3p1P2kql0ItZ?=
 =?us-ascii?Q?48h24p3kuUhNKSthkvFeSoANaJgRlfScKlJq9UAbRRZnlX6bHwW72HaeGNEC?=
 =?us-ascii?Q?4K9YxxIC2AtSflUAmbkuDarJD7s9+TXHSV9JMDXCckS1lHB9LJvCHgf07n+w?=
 =?us-ascii?Q?shdusqrUikTUbZdSbe89URy3t+HU04pcXFls5DSjf4ihN3iYUfnQb7oTiSdC?=
 =?us-ascii?Q?rcVx3Mllw1cu7cWnJLjDEnLGz1LX8isDM8PSMTIGv2a54U6e0tHeC0g3Fotl?=
 =?us-ascii?Q?7a//mGPWbIXg1CmYo/vYY2PbXMHmyv2Lr1D1HT/YEwDbjYNmZWiISh3uPKdW?=
 =?us-ascii?Q?NmVTZ5kkYSy8IV0L2TImKkQG4cUAn3ZbiqRDZBVvHTtmD+pxEjJiBsSSYB86?=
 =?us-ascii?Q?67UxH0czUVlnGwXkRHNHqlTrBD4ZPKu23aVeu//cw/qmQ7/q15qVY3orIgLx?=
 =?us-ascii?Q?jEhpYQYYmocPthnZYN+gPrsET4UCKFijD27rvXAn9OP8KkO/dTbZB+dJyvb6?=
 =?us-ascii?Q?o9a6XBLMK2XIijhij9XUAlyIAZt134vLswCKRpZeqPyKfsoZxj2+tDE/QAfp?=
 =?us-ascii?Q?7UZUK0eihWQgI9nvKlDZ0dAs5y8asDJqqqfskH0LgDKPr33OmOgR/ZN9/PKR?=
 =?us-ascii?Q?/odpXeb12yFDgpMpHfv8Uzi+LrrFAMIA+BrWjiPGdC6A4p7fMF9/ypUhzz3w?=
 =?us-ascii?Q?LdkFEWfd3EuGmYu+T9oLlwYxUhYqT5satFCT+OS8T5pCnxSx2+ytKvnVRPlu?=
 =?us-ascii?Q?qKtuIN+qtTw0tJwYWP3kBASiREHiXyYdxshwxlcyw6Gn/JlJ2F5hsBQRZyJA?=
 =?us-ascii?Q?S+zEU72mHF/0B33AeVSNeq9yxrHi9EckG+wWhsLVR5bqO5K61EzULfQoD4S/?=
 =?us-ascii?Q?oTrWyjYD6sDlMEX5AdjHH/Xh2ExeMLaZGovf8hHFVS6jpBMscqkVcaNYytg2?=
 =?us-ascii?Q?1UlFHhZH5wUC5qKlwjKDpxC/bNjPgvkE2ZLTf6kuviXrRRwAD4VLp9zJrFW2?=
 =?us-ascii?Q?LIuw9lIxkeQzN/qHtW80TsNWdPGSOdD1/Y7OyfUaU+JbvIq8y1JFPUx507+2?=
 =?us-ascii?Q?uBYEBYBaCoAJIPF5Z5kaJd9QTLZjqDu3hXF/VPAq3WGiC/7RNLe1uStfBRLF?=
 =?us-ascii?Q?I78S/7HhkvurQU/GLh2epI9umo5Lhm1WLt8pHwJ78IDI/LxuG0FkpYYFntCC?=
 =?us-ascii?Q?1xXdhwp5XNWzSKtC5lSgJkt2gwrwWYLACMzgseLpmiJUXH6w0L5po6z51oSI?=
 =?us-ascii?Q?q5uRPNns8xeCk9IOaAYKKe7FgTzeam2w5q91bkw2QjQyIQhynUdxYxkIEhYt?=
 =?us-ascii?Q?pHGJgKIGPIpr0TleW17l6g+Pag6c942dDlvOVDl1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5450fffb-10a2-42f8-e8c0-08dad5c73b7d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 07:14:51.2643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kQPAmuUtAsYu/rPuVsX5sP16b3qIFifTQFysYuTqX4tvtwEXaH3939GgD4TKQAotLW/rvoa7eqJAl85RhHtmFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6392
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 03, 2022 at 04:27:06PM +0200, Ido Schimmel wrote:
> On Sat, Dec 03, 2022 at 12:00:01PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 6.0-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > Possible dependencies:
> > 
> > d5082d386eee ("ipv4: Fix route deletion when nexthop info is not specified")
> > 61b91eb33a69 ("ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference")
> 
> Yes, this one is missing. Will send both.

Just saw the mail from Sasha. Looks like he already took care of it.
Both patches are in 6.0 queue:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-6.0/ipv4-handle-attempt-to-delete-multipath-route-when-f.patch
https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-6.0/ipv4-fix-route-deletion-when-nexthop-info-is-not-spe.patch

Thanks
