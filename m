Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292616DECF1
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 09:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjDLHu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 03:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjDLHuV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 03:50:21 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CBD5FEA
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 00:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681285820; x=1712821820;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2d5SiBF8Ac2GhgRlxtzCo5IHP2K4xIIg3CU+Cr15UNE=;
  b=gyOJNHqgK5uenhIM362KdhKl3tZucun/EHGqyRvzXwo5qgL06op1R+E7
   5Spn2JvkDCrasyGlE0GDrrwU2LOSoNguOAeG0uBPdCUwfzQOTIhn/col/
   jRLt2xHFyKBx5zOmdgcYnB52b9jF+PHDd8HR/QYf1TFxq0ivYEbhNJ2Lt
   vz3EtUzZMwvesCqPD/hk44ODgQwIpR1U1RlIQIjJ/05j/GkLysB+Sc9ex
   XejleaSBjFphlxAQzAHhib1BuTt06Gc8NuleQkEsSLgXSeAjRx2ZqKTwV
   Rf61upiZz4JFLuOklg4Vi1LatB6XQ2CCGME+6T0l5cKESItCyRNTtLuQG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="342585920"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="342585920"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 00:50:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="753441989"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="753441989"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 12 Apr 2023 00:50:19 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 00:50:19 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 00:50:19 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 00:50:19 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 00:50:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JwV0s2UliPDv7VM3rmLiLgf/XAWC3z7v7RruXaRwW+sgSN2/Ma9PClWDIGT6chEJqcWNUgofx6Re3qdYfmbkKc+Y/dIhDBa5fOyI4D58fFd2HOMaMb1qdTcaA7g9TgmvQfJ30PAMX/kD2GOz3YZN+cbT9L4Ef01D21IX4MIyX1Od9d98iIkXnm6Xs9l5Jsu1wPXd7ytGp5jnYtwCTcSM+D+moWuh8v1aIP3hCFAfWyI/hWzfwKVDyLtJJ8P79H7QEifWgAAZ0/Hy1IdOcy0BY+U0x+TrdeMoMftQGVrvUw0fRjOpZ05lRBtaTlAu7zKcgx9txJQ333Fjs7RWL9IDUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aoN19lgpCCm/oTQU6/MTQHEiypr7j8t122DIPLH4CjM=;
 b=PM13j+Hn08O5bdZh+Jhg0O3PYhAN/7c5VKIvRIsTvhK4Ff/xqfnqG0g4tDBrZrOQ/QpOa6Rcq8fZ6AjVmW+y9xXa74BUl1SO1N4Ns2Bl0ZLt9i5SkRz4Ht6412Cf1dyVOPh/JV2erc4WI0cb31/eFaTCqgcK7FtFn8mz6KSJz3pY35ipLIqu4U3mhAq1Av3mW+XMtQHe7Np3QWzfqku/Dd44wEzpJDyIlFx60mciFyeq6UQlbQ1pppLr0SVPpEzrTbWQYH2bGKh1MNlgf/hFWl9zrlGZL/GhY9a1Z8Qvs3LTaidmmRuPsi/LtIUEKpAO2X8Jb6S6mJ1mYkPnSUUjyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by SA1PR11MB8253.namprd11.prod.outlook.com (2603:10b6:806:250::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Wed, 12 Apr
 2023 07:50:16 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::5ac7:aae0:92aa:74f0]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::5ac7:aae0:92aa:74f0%8]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 07:50:16 +0000
Date:   Wed, 12 Apr 2023 15:47:07 +0800
From:   Yujie Liu <yujie.liu@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Pratyush Yadav <ptyadav@amazon.de>
CC:     kernel test robot <lkp@intel.com>, <stable@vger.kernel.org>,
        <oe-kbuild-all@lists.linux.dev>
Subject: Re: [PATCH 5.4] cifs/smb3: Fix NULL pointer dereference in
 smb2_query_info_compound()
Message-ID: <ZDZh+7jJgg4DR+IA@yujie-X299>
References: <ZC1fJiHvpbXcysXi@ec83ac1404bb>
 <mafs0o7o2h7o7.fsf@amazon.de>
 <2023040539-cherub-flattered-bcc0@gregkh>
 <2023040528-maroon-running-0fe2@gregkh>
 <mafs0jzyqh2sf.fsf_-_@amazon.de>
 <2023040502-shortcut-curtly-cc96@gregkh>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2023040502-shortcut-curtly-cc96@gregkh>
X-ClientProxiedBy: SG2PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:3:18::31) To CY5PR11MB6392.namprd11.prod.outlook.com
 (2603:10b6:930:37::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6392:EE_|SA1PR11MB8253:EE_
X-MS-Office365-Filtering-Correlation-Id: 94d9d716-2a17-4414-bf70-08db3b2a8dc2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7z+0XMz+nMub+3TR2vuD9bIPyYR8quFLoJGwTAQg6Xl1UjWFn3D9XQL3Q8TSqiNtenS2I/uJzP/UVJwCQ8mUQiDzYBvlmCGV3NP7zKv8TYLiOztmc1ZYx/QGOBcjdswS0v1Zf/evzCQdWoVU4xZrCyOBFftvRW9ggWE2vqVP6p4LBh2O3xT9dGx3SXh7448KxbSUFZBurqkXwBNmCqgsj+EFy7v8TPvLH/9O1eNvMzQkOw5cKH3yW/y3KdlyHhZSEJUWRoYC1O1qQ6Q29jHjT7f1EEmcpanCezVb232ZpXhCZ3gLeo+Vpv+jLpXk2sC4R3uuTdl6pHcfUeAlZsRyXEy0pZr0s+emtEn32KCNaQdETwOF8nM293RkrwKwJnCt2AsonmiIR9ZnwRH1l4Y06K/HdizsRctYSM6X8erjxvUV70/0zdS4/tv/3pB7nk6ROLz4umzuM8cO+oAOBTCFM6N2JWol63mmc3fRhlJjUvk7Kh3MbuFOyv/yzChCq1FZMKAueC0QC+NS3soj3F2AAJsE9+EKbMwViglS4vg2WJOoSddBXdwxA3i7IaXlmo8PWONbrw4MQrr6UzrYrJZREA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(346002)(136003)(366004)(396003)(39860400002)(451199021)(478600001)(6512007)(26005)(6506007)(186003)(5660300002)(66556008)(9686003)(6486002)(966005)(110136005)(316002)(2906002)(44832011)(33716001)(66946007)(4326008)(41300700001)(6666004)(8936002)(8676002)(66476007)(38100700002)(82960400001)(83380400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0lGBqjRf3W9ctTr7z0ppRs6yKtrJ6YkuluElMWebE6AgqhGHPmmX0AkqciX1?=
 =?us-ascii?Q?mCnzjYuIOy/3b3NSe1uH83ely9KjknSUfQ5hXEurOQBM3wrVCm+tZ18O//4M?=
 =?us-ascii?Q?E972F22+dgG+GmvdCwKx1nWmfLHL7S5tgRdvKA5L26e67bEoJIgAe5xEq0GQ?=
 =?us-ascii?Q?wu7eJwv7PnJiZOa/yoCsV7Q4tBG6TGXnfJoKmSSmpgEGAGlqS6vzXyOftgDH?=
 =?us-ascii?Q?k+r63Wn1fsg5QBl4UMtha+YFpHQRM6+iE+GNSCPfJnb0dDZO9ykakLZMH7Sm?=
 =?us-ascii?Q?aJ0IOt+L0AWFxoL1ypdlMcDBqi5Aru30E9mAxqGTICz4gO07g8o1le2cpybW?=
 =?us-ascii?Q?BOAgG+wctuC5tvPZWSkNifFLklz52j/PvwURtmrvNr+3Lbp386uGqpp2oEtt?=
 =?us-ascii?Q?HYR2pfQLW0zOSTpCMj6metb8O12RynAh+mbUoLWSgnV8bzfan/Jb3U4Q91y5?=
 =?us-ascii?Q?VKEkDKnVkzC5Bj6AcLOdaEwyRX2wVLqoGapeuSzi4m7roNACRZSbgvWc9s0X?=
 =?us-ascii?Q?lNjZL4m1R3S9YnyUBlAHPK/4Q5dRLvhP6UplHPXCyhXVX+7ExRBk3OXg+HHF?=
 =?us-ascii?Q?Ki+K/ZksSIJ4IDKZOO9gKnVBEw2DHa5D2AndRbCnQCSo1skxv5b+pyGPJu6D?=
 =?us-ascii?Q?UApQZ5Jaube/+OfxOBqHb41/glskUiF1QLKRJlRAib48zyAVUlcHVKPbpfLC?=
 =?us-ascii?Q?lIZcZ9RqNBU5N145iLlm88860Gi5qeGRSDGhB+RphWrdSletncjshxS2VyDg?=
 =?us-ascii?Q?nRfK5fNCgbanBUEfby3Q4Dcca8GhVGCRHZo9uIg3mTX5gsvfPD3H3mn5+PlQ?=
 =?us-ascii?Q?DvJw1cG5Xgqfmyfw4RvYz+7KEckDhf+NJbiiqc9KZY/m0vqzGPGFv3rREVyM?=
 =?us-ascii?Q?gAtXFhAOP4/UfXJED/u3yx62Zi8zD2qxn3lDzZlSERGKKlibuK25DMkPnknp?=
 =?us-ascii?Q?/EEaH82kzroBPNl08Ar4d+s39AYiYg2RK9dtUAA8gsr/quDZlx+7N6Z06Qu8?=
 =?us-ascii?Q?mt7m6hq93BlVdypeCyGK76oZ00InZYIrDWUTSs5BtuP4ZE/5NtoGKhuptOE6?=
 =?us-ascii?Q?VL6Amat8MQGMr5O5cDuoHtMXM9dfT4J4AId+iYbZ/aSonkOd2tKohj+Sw8BC?=
 =?us-ascii?Q?Buh4XwSqdRDrDAxDRjhgbIK0avdd4G1IW27aMwsUwSCLKEc3sX3B9LVY1JHC?=
 =?us-ascii?Q?aGGpdA0ek1z0C6fdrzJ759A8rU3rNur9baTi0LrtzZtMhL/DJ9kL3RI9DOX3?=
 =?us-ascii?Q?AnfaJL5Tk0HtLcpCT50v7lKZ7YJdooax1mo0Z8Cx1lbrB8EbAtStoBFTQa89?=
 =?us-ascii?Q?Y/zKchy+0/5FpZ6bq67+J0NvP9hOXlvTp/BhnX5dgKwFnWO0SbFp31XAmdns?=
 =?us-ascii?Q?s68BE6iGR2J69fNUXudlI3c2SUXwTL3JyP59X+zbbhPkMvI0MTJC3Vo5EG7a?=
 =?us-ascii?Q?FXYgoCaAJ+tI01sqXrh8n7ASXM5/SllgE/se1xs/PfQqTVoGW/l+58eVn8A3?=
 =?us-ascii?Q?UQmBudXapN9MxL62nzUuy4epnvaVZTfY9YaEY+/3tQAtt12CFFDUU2aHc1Gf?=
 =?us-ascii?Q?bbyuI6G8MDqvaIDTdlfF0VgjX4gGKyCWjJCo8E8o?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 94d9d716-2a17-4414-bf70-08db3b2a8dc2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 07:50:15.7988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: frUXZq0MoDNiOmssgDuFHTzzSrN9/FQ+eAa4oNNvSdHDcWH2NyJqWKSv8Al/d5mpmfk95KWxTXQ9JIqxhqB+tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8253
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Hi Pratyush,

On Wed, Apr 05, 2023 at 04:22:58PM +0200, Greg KH wrote:
> On Wed, Apr 05, 2023 at 03:33:20PM +0200, Pratyush Yadav wrote:
> > On Wed, Apr 05 2023, Greg KH wrote:
> > 
> > > On Wed, Apr 05, 2023 at 02:26:04PM +0200, Greg KH wrote:
> > >> On Wed, Apr 05, 2023 at 01:47:52PM +0200, Pratyush Yadav wrote:
> > >> > On Wed, Apr 05 2023, kernel test robot wrote:
> > >> >
> > >> > > Hi,
> > >> > >
> > >> > > Thanks for your patch.
> > >> > >
> > >> > > FYI: kernel test robot notices the stable kernel rule is not satisfied.
> > >> > >
> > >> > > Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'

Sorry the info at here is not accurate enough. We will improve the
wording.

> > >> >
> > >> > I think the robot should also learn to look at the 'To:' header :-)
> > >>
> > >> Nope, the robot is correct, you submitted this incorrectly.
> > >
> > > Wait, maybe, I can't tell.
> > 
> > My point is that it does not matter much if stable@vger.kernel.org is in
> > Cc or To. It gets the email regardless. In fact, that seems quite a
> > common practice to me [0][1]. So I'd say it would be nice if the robot
> > did not needlessly complain about this.
> >
> > [0] https://lore.kernel.org/stable/20230403140414.236685532@linuxfoundation.org/
> > [1] https://lore.kernel.org/stable/20230403140415.140110769@linuxfoundation.org/
> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=87f93d82e0952da18af4d978e7d887b4c5326c0b

This warning is not caused by "stable@vger.kernel.org is in To or Cc".

The document at [3] gives three options for sending patches to stable,
and seems option 3 should apply on this patch:

[3] https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

Option 3

Send the patch, after verifying that it follows the above rules, to stable@vger.kernel.org. You must note the upstream commit ID in the changelog of your submission, as well as the kernel version you wish it to be applied to.

The examples in link [0][1] have "upstream commit" in the changelog, but
this patch doesn't, so the robot flags a warning.

> The robot replaces my bot (well, aguments this), and it rightfully flags
> many patches that are sent to stable that are not done so correctly, so
> that the submitter can then fix them up.  The number of "false
> positives" like this is pretty low, as hey, even I got it wrong when
> reading this "by hand".

Thanks for the affirmation of our robot. Could you help give some
suggestions so we can further improve the robot to reduce "false
positives"? Do we still need to check "upstream commit" in changelog for
similar cases?

--
Best Regards,
Yujie
