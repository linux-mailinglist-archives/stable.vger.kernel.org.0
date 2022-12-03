Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3479B641747
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 15:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiLCO1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 09:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiLCO1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 09:27:17 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63DA20999
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 06:27:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2SyHUcr/zQ8VDg1EWkWMpgeXj1jyxNtXeP8FI+TdiIrQILDDHA7YqUEOzTBTG20iWrax4PdFliE1ssJhOKrnrfKm0PsOMmbTqeTsImOjuJVh/kEI05bndA/G2sOq1MzT6W6jNwl25lQRtnro/NovCJmWYXUunIaX3SAKlEUkIUNyJ5PVflPFRpgIL2qBmBaRc+SpHCuSzqohqvAqh77vdRtHa9hinVGDVTbVoxge7SnnRCiVH5mFtyHRDLpVg9+zS+N2HqZmAtDGveyZJPKqUPMhQSDtT3uJD3lM22GpOwqAt9oFrsTBMCVVO7y8ePIXwRIqmaV+aFR6VeoDEBfkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/JZq2Au/CRxenBMH38R2eFmPQRQf46iT2QzP3QYW2vo=;
 b=EIyXRNzMUbUf+/Tax1M5lsiP4sBL7gUmdeaZbBVQKP+oIRjS9we3bbwyiyVV4fuj1EYKJgR3N0HItumP+G/JfZNMi2B7UEhBPBMBqdC+rWLsv1b/NFe1IOSYdPxXbnJ5ZhoVpp8whITJLbZp96bIYAhDwwdiJiJEZt0jYvyx8XiuACs8Uq0i28M9AMI0O26XwjX9iv/J66/EgjNmOLlWLncIaCnBbSfsdxXOjI7XkTquJLjAItAGazFwgk9yh2zgTPhcq8+ieGX5i4l7gs2VOP3Gah3nmF4E16aVXx8UNbvEOaGE0BeCtp012IgVwZHRIKza3w7VRojgAHcx+iIT1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JZq2Au/CRxenBMH38R2eFmPQRQf46iT2QzP3QYW2vo=;
 b=NOrC3aau4D0Dd7cKG5R+0IwHfHOt/q8JED+a7kjn2QN317RIUJD/ikb7gQg99iATz2DO5Hv0WkJxhpl1rC9O/otb9pMuoDcqO82meWg6EmKcTws4oM028J3z835bkqO8wBpiuJyWr6PxagXKUAN6T3fOYoZUPtnHZ49CX4XpO7uWK2zmxOme3kkW/u+iSxTUnD1M6k+pWVXKwdoVAeMaO2SMfHa1Pb1z3KvqGQ5gJ0zA6SSGI70C8qLBwJsoz0sYT/ko1RSmm//kbXiclat1CzUYWAadFstbICiS3T/2ewBt+bKjYkG76kDpVT+w/MtimuMPji6HdrS7Yu7RU+MPag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB4271.namprd12.prod.outlook.com (2603:10b6:208:1d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Sat, 3 Dec
 2022 14:27:13 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.011; Sat, 3 Dec 2022
 14:27:13 +0000
Date:   Sat, 3 Dec 2022 16:27:06 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     gregkh@linuxfoundation.org
Cc:     dsahern@kernel.org, jonas.gorski@gmail.com, kuba@kernel.org,
        razor@blackwall.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ipv4: Fix route deletion when nexthop
 info is not specified" failed to apply to 6.0-stable tree
Message-ID: <Y4tcuoEGHI92wF3u@shredder>
References: <1670065201171234@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1670065201171234@kroah.com>
X-ClientProxiedBy: VI1PR04CA0066.eurprd04.prod.outlook.com
 (2603:10a6:802:2::37) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN2PR12MB4271:EE_
X-MS-Office365-Filtering-Correlation-Id: a90cfa30-5706-4996-9693-08dad53a7842
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OU1EXb3tPPbmpoCqijYR8SKJHZHNJ1DVfTI0aQmxhgr7viOknDlwyAgZp5uvyQ6eJu7mpsKjnwfDtPweg0Hv7W4MM07N3Hc5VHnCljLQ2pKjU22BxPojq0yv5aIUFhaoAovCQMVHdpqMeupGvvGeEfBuI4Jbihk3gALZkPNwOmmU5GQihq2EtidjLGe4tvaZjNlodDqs+OkEhs4Mo5R3pEK/LxuYc6ZnjHBQba65hSim/65CeGu0SGOwcLjopaeMgJB55k6h5niWLhtLq5UyVQECtiEj/5iq31oGw993Vzvc8f4O1KLDUxGMLIGfc32RU5ogp6tGVv6VRM5hP5/YrZv818+INMKHJT8kt+vd8hCjRB1rqKSfx4rE9TsDci4s8KEjzPIUX0AtpadJ9Ji88lGgfsP1jYcx++vQBzBCdYb/gpJfaNcbnieWLyg5tqdXYLSjN5iUOVwq4V7KjEnRMpwWz/R3BPidArWzURKTSkTJ2GotDy4iPGeyJMOz+xGYyotcQ1FdTjTNw1XDAvlENcXVXmWSFSEeNqHPQoBhoGRVKyYU+qOBG4WaC97P0gKPB1m7UGzfts/Yh8pNkRVwPiMdv6GQc7Dd7sYZAukSmCdRCrRLZfC3EFVPllWxlxL35zKdPVgmPEH+9zCXUt8Cww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(366004)(136003)(39860400002)(396003)(346002)(451199015)(86362001)(6486002)(6916009)(316002)(33716001)(8936002)(4744005)(41300700001)(66946007)(8676002)(66556008)(4326008)(478600001)(66476007)(83380400001)(38100700002)(6506007)(9686003)(2906002)(26005)(5660300002)(6666004)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tli8rYg1a59RniwiM+khCZEoOLiA2dRkQiMGDmQtjQgf1XJRBmkqpQUSQFYy?=
 =?us-ascii?Q?r0EyHkJOm/D3SiyboXm6UYknKvlmdbbwmfLlrZwoYWWvydRvEAhpHQSSXMDw?=
 =?us-ascii?Q?Bbcw4it/tFF6jYynAIiaEx6M3auBz5btAmSB4OAu7tHZqflXE+V8a6+i+A4U?=
 =?us-ascii?Q?n6pUwek9H9AeqOz/rDLw28vn/Un9W0BO/MBfoMUw6346e5TPGUJIAgEYSYBj?=
 =?us-ascii?Q?0SqPnrB7iWgxIvIzhwwrpTrYiP7wwvp7CkjmEzUZzgImvtb9zNFLzwWAqeH4?=
 =?us-ascii?Q?Dpyc74pIPSLo9NqV3U8HCERM88lQVQORuYbg/kQhQ+l8k4o0okX6HpaK/P05?=
 =?us-ascii?Q?3LhYIyfqj3kA3+KLFEAHuHfqISB9PUiCC5J4tPA6i9sM64XohSXstiwhsvHG?=
 =?us-ascii?Q?y9VS7McbnxQcrDE4PlLn20LF+CqRTYGJ/Y67KaRQGr8/4S90IaKWXQWnR0Ze?=
 =?us-ascii?Q?ykgRRK8sXvA9uRx9tbU+yjW0ehosJ9TYQ3Pb96V2fy+IxcA9iOsKDqgpWj8d?=
 =?us-ascii?Q?Awq8s1Camr2P1ICYKh9751OvCc/+UsMQFOkEIC9TENY0+1bzgrDB7TzwmN6b?=
 =?us-ascii?Q?5P6VTwJa2iDcSfvDY236uQV0dYs4lKQ2rvdneam+hFdFbcyElrWNqSvJ7+5o?=
 =?us-ascii?Q?GbUBPZq9MZSp3ymF/e1H+yF41TD3MSPyNAYOUY6O/IQYgkqdsra2hh9Y1OaN?=
 =?us-ascii?Q?PpAim845BTfuljWqSEFUHqys8NUAqpyWZQTXiBCeYNgCDjF6NBf4SiYMhnyC?=
 =?us-ascii?Q?KVLhZWUhFWc36M05JRHJ6QsNA94f4ijjSG0YMWK3h/0lVfVaEJVL+KWWksTS?=
 =?us-ascii?Q?45tHcnkVtMV1Qti1U0XYchhIwQzTagAsy7Nqiiwju0urMBQp6bSSE++pDsA8?=
 =?us-ascii?Q?UIQldn2oQnEQG3+QmnLu64xuYJf6kzLiFXx0jj1ciS5Km7mqPEVT/UU9Jlin?=
 =?us-ascii?Q?7gtY0Fr39atKOvJ69dn9c2vphGFHja8ZOOnOaRe5T5oi1LME+kJ1KS1lK1qw?=
 =?us-ascii?Q?oVpmYzjL0YBxerga/vg5VWYjkKFBFsFKnpnEOY7VE3difncUG7L3LkC4Jc6Q?=
 =?us-ascii?Q?93cSBLvKDUBdjihaxovJ7XnIevopTP8yvHpeSwK5/nc9vi6XElfP5bIARlQn?=
 =?us-ascii?Q?MXWlMrrcuvY8wDYV0o41pAeG8spWyvSjTbUTW2DJunqz/pkRIwaop00joNCR?=
 =?us-ascii?Q?Z1FKp1FVKmjSyFYJvETkVkTd5t+jrkh9hGJUjf1ewWs2l44+O5rtPdF5AWIz?=
 =?us-ascii?Q?Z88Wi+EDyIgJ68MTthNoGLAxWpgmBgMt7mtXtty7F2fuSf2FCSn0mILXanbd?=
 =?us-ascii?Q?OTFvj/ezBnAhI9RPiJ7QfhPIUFBpq9i1PH7EQTxyyuUhcKHzAj9+Vdirll9j?=
 =?us-ascii?Q?MCFfOXZWZuzLUfQwvVm/tFPVkswOekKQ749EOalU9iKfa56zSK4bZLd9FiCS?=
 =?us-ascii?Q?sSRa7heKlkx4fWda2Cj94iYP81h9roIZfgb627k/YGDi03SGpZLVyHb6oCfs?=
 =?us-ascii?Q?FEci6nMWbP4roy5yLwk3YpfxQ+MBeC02srfRv2f/x7AnOFbsSqAgzN/18tcZ?=
 =?us-ascii?Q?BfHYcMWpkouhLQl+f18deG6g5DDSXundIr+bCEg/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a90cfa30-5706-4996-9693-08dad53a7842
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2022 14:27:13.1607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 34NRp9ByNfC7lFnQLpcCe87kFU3fGlrAA6KxEROi07lARRD0Di3URQVjqdhVZSs72Q8fT8RQiPpgedlpk33+bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4271
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 03, 2022 at 12:00:01PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.0-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> Possible dependencies:
> 
> d5082d386eee ("ipv4: Fix route deletion when nexthop info is not specified")
> 61b91eb33a69 ("ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference")

Yes, this one is missing. Will send both.
