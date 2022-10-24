Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F41A60B534
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiJXSOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbiJXSO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:14:26 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204DDD0CD3;
        Mon, 24 Oct 2022 09:56:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fPBfiHC8tilPoguY9GImxaQxVqF0dFQte0ISXdLyTBdVCHKHS4TKQ1lmU1MblS4F/FW4wnxPBqs1E8kpcKwl3mxTVH0wW37b/N23vNK0B8XNJDTCsMsYhs2uK3ht8XpKdIc09a8ZB7QIa0H4AiGYHivGC1WGzJnzPNEnxvKratKey5GDkOuzfum6DnfqwJ0LSGZGu6kapTflSc2EAIZmnPeeA2GwNPE8HQI93yOhd8zYO1oR8RKxXyEUN7GbBaqIOkuVM/9PnGd+ZZppbdZaeVugPfXvu2eMGbGvzIm7TwMK0/JCpUeR2uzs/Bq5jj7fTPZ+edUczMvcXBMRsRcHOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sY9tnJIyx7EFfUzzr720jPDfjNc4nmzjmXDsIQofzg0=;
 b=aCnbdLSihIarSlb4tJ++Oi0Qk8Am6bshxEYB81EWJ1u1APby4GN4baWIlFsOwZoFUf58GjJu4u9fSyTmmvIjF4Mr/UZAbF+N9AzTdNy3cjwR3YfdIxd50VMhulYCBOO88qMhYHdp94HVS7TA+bj3jLqvWGoy2XNXXjGSAlpIMCotBqGGicmLuu1wt0nYEnqUmAiZGP9ORfmqfK13ML0qlenWi1f18neevwiCMGTTZNNK2nPVTJ+HiB23fccJmCfNi+5WR1UzVOCmv09Im7J5NUtM8gGwbnN5FK03JDqH3UFu5IASEjaSb3hXfaz41FVQz2ulqAYJtiu7Hn3y0uKWJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sY9tnJIyx7EFfUzzr720jPDfjNc4nmzjmXDsIQofzg0=;
 b=RhB2Hv0TsC5Mrj1Xoj+ftapcV5MEFlVnuOIORIfwm6UtbtrrwtG+lHXhRSjCoqq7HxX7GnrMz7y3w7kPUAluCKbODfxIsIwX0h1IXIVYOLFtbUMbSlFSwyaUdyV7ETC0uVCtkBfQDZdlKqjzvCmHU0I+Eu+eYblJbI78xuJ1vmPMeTeSQDj7TscNHTpYud0k0dLfyWaIH/g2qSdIaLQptOlaL/lFV7FPkbaM6gRDbYTmgyDwTX83KvjB+IZKyYqDm8AQwLtjPIEL0qFrRUdFFrKO97O8aGAAtkyvWuehCA8QbYhvFSOhzs6lV14NIYX+gGdo+JGW80HxWTZBHtqn8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 MW4PR12MB5642.namprd12.prod.outlook.com (2603:10b6:303:187::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Mon, 24 Oct 2022 15:53:15 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::c0e5:f111:3e59:7c66%6]) with mapi id 15.20.5746.023; Mon, 24 Oct 2022
 15:53:14 +0000
Message-ID: <8a146e5a-b637-3e3d-49e8-3304bc41f94f@nvidia.com>
Date:   Mon, 24 Oct 2022 16:53:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Subject: stable request: 5.19+: clk: tegra: Fix Tegra PWM parent clock
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0014.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::19) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|MW4PR12MB5642:EE_
X-MS-Office365-Filtering-Correlation-Id: 2119d68e-098f-4a99-b411-08dab5d7dc52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N62jtmD8n+fF37esJYsOZgqj6vrZpEWZMLdYwUBXwHummMSPil1DZ1FmY0/DOAe5mVi6EYQzMa5OwVR2iktQyR55WRxFyEyVVWbIzEaE0Ngw2iRLJJPbvsQ7w9AzEwPGFTd+tNv1GMVZiTSBa5HksODNra+mi1JCQYc3X0JGkz5Cxd3iRnbnb8VPGpgNarP/IwaVDbGobNwMOC8J1zNGCl52/9Zh2pig0wPfs3o0MqSqgF0TYneRWtMRC6esphqY3SHT0Zrzv71Xeerbcv+eEWj/YXzxOXwj+GV576mhQhDpd02e9XILz92rFMswBPgbF9Ye1+S5qQ0IGRYITILbA6iyFsE1pFjW6cLszxzL21O4LKaU1mNA/iO1PiZB6pCQvkeGT6E2grW1Fujc1D6sIyE9wYE1RRHOJD3GfYIxuio6Qz/RJ2wYaKQbdfw4VW8ObIGnYveanDVkUc8xNiklheJS3DBhP+Q2muy1Q1D1S7/xbCGG26KgV0v1DQqHiDUTZH62oItucK7cYinS4aSIuMIPr4i/F+MPSFvUkky1ObjZ9RtFEywsvj2OCuUUwlBOLnzgQrDuuwyGRp/aXsxmMBEWTX1t60gM/61pJEmcksrhAj0BkNyUIhKGOAR/x6IuRj6Fay0TB57rfun47PVw1TKKbc7of1phia8KJM43PY8Ah66ryBozfOMQer+yzLB/8JofPZ0C4DB+YYHtCL7q0e6VqmDeJtEvuR5xfjElSXYBo/UedHtemmaS/6V9TuPZ9RJMa62v2F/WG2yLZrvH70QjtLPT92yy36C660/RtZE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(451199015)(31686004)(36756003)(558084003)(2906002)(86362001)(38100700002)(83380400001)(186003)(31696002)(5660300002)(6486002)(41300700001)(66946007)(66476007)(66556008)(6512007)(4326008)(478600001)(8936002)(6506007)(2616005)(6666004)(316002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3IvNVdaTXFDTjZsSGJJcUdFZFJtcDZHbFpxd2RhN1BZRUZGQ2kxQlpQeTFn?=
 =?utf-8?B?UUhoZVlsVWZPcmdWNVQ4ZlJBUWY3TFhCbTdiRDZWNFR4anRNdGlqdDJBL3k2?=
 =?utf-8?B?dnV1MnhRMUpFOC9xQmhpWjlTS0hYZW9TUklDZXJ1Vk5MMVY5K3JBVUhsK1FF?=
 =?utf-8?B?eXFJaEI0K1psdzVxdEdYbGl6MlY4QzltOVFoVU9lOWR2OEpiOVE4TE1kNE1i?=
 =?utf-8?B?dlpac3JJMmtzMTZLaEhGM3phUW84UVdLM3BIMFkvcVlrUVlQNXNQZjI1UFg2?=
 =?utf-8?B?TjVITGsvOUlDN1Q2cGlKQ2JQY2dpY0JVWElOYUNDNmZkYUcxQ3FTenVJWW9t?=
 =?utf-8?B?dGxpRGpWRFArWUY0cURsTE9HbDVZNWhvaTZoLzZtMDFjN1Q3Uk1jcDc4TW5I?=
 =?utf-8?B?OThEOWd3RGFLMmdNVVhURkxFRVRuSzVha3RYMHMwK2kvWnVvbGQ1RzNleG5K?=
 =?utf-8?B?RVdKVW44YjdIODBkS0xJLzVUNzRWbVRuTXRSQ0NWb2ZMU0ZpbW1RVWFjOFpD?=
 =?utf-8?B?REhmeXBVcnZIa1NVNHRCZGNrUE5tdHVseEV5aXVVUXZBT3BtLzFjQVg3WlVS?=
 =?utf-8?B?WFFvelhQeEJ4c0FWU3JwcEZXSTJESEszU3c0eC9hMEk4V29wUFFDRG1hREt3?=
 =?utf-8?B?TU1NN2dBR1F2SEU1cHRaVUd6TCs3YnF6ZlB2WFFDckNNN0JkVjB3dlZjSjBD?=
 =?utf-8?B?RDI4WDF6b05SdmdpUkJQZnBIMHg2SFpaOXJZWjhpQWVBZnFEa2wvamQvbWl3?=
 =?utf-8?B?N1ZRR1VENFJBL1l0cWdSSVJLZTBKUnVDNWRNZ2hhV3VoOWUrdkxXWjRFdC9H?=
 =?utf-8?B?TWVDdUQvaEdQN1BpQXY4bGZ6RkpzWThSaW84RXI0cCttcGZvclVkOWNPY1da?=
 =?utf-8?B?WXJwRTVqT2p4U1dLenBQWDZrMXRNTFd6TlgyM0VJNFcrTzUwWTVHZjUrYUFh?=
 =?utf-8?B?aWhYaVdyVkl1MlJKS0pHN3BGSkJ4ZnlYQWh4R3RqNXVDYXlEY3ZJcmtPVWF6?=
 =?utf-8?B?b3VMT3UySjNyQ285UjlNZ043WmI5WDlvWTd0U012SExwQUxxYnhrWGgyaDRX?=
 =?utf-8?B?WkJ4bUdnQnRGdnJURlcrTzJWK3pidUVKb0grTVc5MlhSbktWSm9PZlJpdGp6?=
 =?utf-8?B?WFF2aGpKaDlGTU4zZmxCb3M1WUxDTWFhRFZDdmJLYWd6bllmZ0VWY0JJdTJx?=
 =?utf-8?B?UW9MTmJwcWhsOFN0NEVWSHh1bENNMG12dStxSGxNcFd3dS9GdEd1L0pjcEdo?=
 =?utf-8?B?eFpkOVdSbXg0ZGFTbnRHSk1sSVYxYUJ4cjRXczZkQzQ2OVhibHlMTzZmQm5k?=
 =?utf-8?B?dWZYQkQzZlk4akFSdHZ1b21YSFUwcUtrU1RxUTQ0cTN6RWNVNnphZDNnWVVt?=
 =?utf-8?B?WGtrUm9oSmVNVGFPbjRxMzBGU0ltWEFtRnM4RkdmdEdSaEk0b3pxQUI4Tk5F?=
 =?utf-8?B?S1l5dG1WM1MrekNhVmtIS29UaGI4dlN3Ui91d1JoanRNVXAvSjhrdzhlWDhI?=
 =?utf-8?B?SndBVkZGSGVNcEI2ZDgyKytZZW5GTXlTV0ZhV0hsMGUwTG1wdjNNSGF0dWN1?=
 =?utf-8?B?L2l0amtQUC95NGJib0lOSDRGMFdWK1U5MGxkTE5jODRxTEQ2SXRlUnphck1C?=
 =?utf-8?B?THQ2bzduMGhJd0hPSDc5L1l3RXFiaDFGSEIyQWdNa2kwTzlYRFdJTzFqSVNw?=
 =?utf-8?B?eFdSUE9OZjBFWFRNZzY4akZPQVVaQjg5aU1WY0hoTDM0cnlpVjdNZy9Ma2JM?=
 =?utf-8?B?WjJlbXdyamc4SVJGNWpBTEw1a2ltQjQ2cS9pczdleWE5VElxaDlkV2NNOXZ2?=
 =?utf-8?B?VnBEbVg0VDRmMlluZ1FCMnAxNkdMcWdRVVNvZFJzMFl5T1FBNzZMOFB3ZlJy?=
 =?utf-8?B?RTN3dXBuRkRZWmRoTC9SMEwySzFxWjF5T1RTcmhXeGwrNklqUHhZRHYzZ2RX?=
 =?utf-8?B?dmdrZ2ZvZnlHS21FSWUwbktPNGVkWWJNK2YxZDgwczh2K1o0VU55S1pLZGpJ?=
 =?utf-8?B?NjRaUFZyMzhhSm1EY3hLbnVMd3FMMFNxQ1dJZUpoL0dQZ1ltS2dETFUxQ0RO?=
 =?utf-8?B?OUtGUmhPaHZhVkJwdzRFVkhuY3VranN3U3p4bGdDSFo0eFpHM3IrQUszbVRx?=
 =?utf-8?B?VDlUcGpoL1R4VTdxTVJQMnErbGtMYXFkZVBIMG5mMmFaN3NyWktGRHp4NWNu?=
 =?utf-8?Q?OCY/ENOUvHjRXTV9fHGCLEOf2akoUVcozaK/pJbW9yPS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2119d68e-098f-4a99-b411-08dab5d7dc52
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 15:53:14.8630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tXSMKrPPDvvWF4nT6XIrfOFq3PIaWBs14xR05KlauqHMHyBo4qNHQ2gMq7eJ+O1kVBOVZrdzbUPHEySbP5eJlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5642
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

Please can you apply the following mainline change to fix a regression 
for Tegra?

commit c461c677a8cb19026fd06741a23ff32d0759342b
Author: Jon Hunter <jonathanh@nvidia.com>
Date:   Mon Oct 10 11:00:46 2022 +0100

     clk: tegra: Fix Tegra PWM parent clock


Thanks!
Jon

-- 
nvpublic
