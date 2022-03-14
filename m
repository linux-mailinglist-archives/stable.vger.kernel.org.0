Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009824D8A32
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 17:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbiCNQ5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 12:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbiCNQ5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 12:57:40 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2130.outbound.protection.outlook.com [40.107.243.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B498B3AA76;
        Mon, 14 Mar 2022 09:56:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J9O3pHVuOQLd2U6iyMdLoT3jdXvOFC+tz4IhKYen4kZtMD47NZDkcBiyraWofpc31btWhLuE2epG+6AIB5I/uy4shY8rJrvHcHgQbmnmzA2Oit8qJ9nDHRohI3uC4BI9hIiDWQsmIZu/iBMXbMz9fR9lw4jMdEAeQIys3YFfIJON+it5v00rXx1tYOwCLNVN+qSq4Y0OmsA+R7dV1ChFv7Oalkd46iUp5xi3lvPfCZHAZYfkvu4U4lrP1kltkhFQqZOZS8vNhQlmE5KVwulXIfm2MRj60kjXKqEe1UowRy1FgD06/DkGv79k8RRTWkcabETDzMG/Zo3PQPsIo3KMEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w4kWwoIei+3G9Rn6dL8cJLt5nNlNAi5/Twl0AxwhjBY=;
 b=E2CsDQ9LCOzKD7sEr1fzvZLuhFCBfUAVvRoiX111XpJ0ItgrSvtfSEULuBRQdO30imGVCa3+NYG3mASKKd8h//jnUlGiJ+63Cy2wfsU3lFbCNKVG71LSjZRDlBlkmcAuHcbLD6xEedw032Ro7mcli2LBBM+I8QwIODOBByforHKCAmlVl8vwhcwC/gcsmDU9kHvJnMSp4JeAALQl61GYuMOMc0Cw+7oJCo8gkgO4XIGnIV2VrmWyBRjTGDawNQ7KkFzJ+owLPtrCE3TKTNitPExGY0QVcqJJBJ3Hqpx/ljFAFjjU1sUwmVwThGJS04gdl+mtIeRa11wPLEU78taxHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4kWwoIei+3G9Rn6dL8cJLt5nNlNAi5/Twl0AxwhjBY=;
 b=bCBvUrr9+pIJomBmZnttob+yPBMyCInBWt7fpUdBjrACSSkonpGygsXh2HH1/9DGaSd1vV5NrW7AD6wI/MA0lFOKXClKYUR3g69xjhKTKtzj6jA7IgoiTBjdOyX8mx6Ufi3pe5bK3TNj42G7RmJ/fYX+rze2LEfmagBqGC6K+G0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SA0PR01MB6329.prod.exchangelabs.com (2603:10b6:806:ee::12) by
 BYAPR01MB3816.prod.exchangelabs.com (2603:10b6:a02:88::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.25; Mon, 14 Mar 2022 16:56:26 +0000
Received: from SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5]) by SA0PR01MB6329.prod.exchangelabs.com
 ([fe80::f56a:e18f:b6c4:ddb5%9]) with mapi id 15.20.5061.028; Mon, 14 Mar 2022
 16:56:26 +0000
Date:   Mon, 14 Mar 2022 09:56:24 -0700
From:   Darren Hart <darren@os.amperecomputing.com>
To:     Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Arm <linux-arm-kernel@lists.infradead.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        "D . Scott Phillips" <scott@os.amperecomputing.com>,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] topology: make core_mask include at least
 cluster_siblings
Message-ID: <Yi9zuL8RZyYu1dVL@fedora>
References: <f1deaeabfd31fdf512ff6502f38186ef842c2b1f.1646413117.git.darren@os.amperecomputing.com>
 <20220308103012.GA31267@willie-the-truck>
 <CAKfTPtDe+i0fwV10m2sX2xkJGBrO8B+RQogDDij8ioJAT5+wAw@mail.gmail.com>
 <e91bcc83-37c8-dcca-e088-8b3fcd737b2c@arm.com>
 <YieXQD7uG0+R5QBq@fedora>
 <7ac47c67-0b5e-5caa-20bb-a0100a0cb78f@arm.com>
 <YijxUAuufpBKLtwy@fedora>
 <35344252-5284-b08e-fec7-6dc99476b4b0@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35344252-5284-b08e-fec7-6dc99476b4b0@arm.com>
X-ClientProxiedBy: CH2PR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:610:54::38) To SA0PR01MB6329.prod.exchangelabs.com
 (2603:10b6:806:ee::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 143f1d32-07d8-44dd-764c-08da05db93c6
X-MS-TrafficTypeDiagnostic: BYAPR01MB3816:EE_
X-Microsoft-Antispam-PRVS: <BYAPR01MB3816725240122012D055A819F70F9@BYAPR01MB3816.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gSTKFrOvYMhSWCjWNWYzplUOp/5UacQGV9ZS7HxOUEk+tP7QR6tULEOWvTQuLvYjp5Z5MxpxBHqL1URdoZVjOEi2r1uHdDat8d3NOtK4T/skTek0VvOj8PSUH+8YprjlmDgHL9Bc9r7lD70JKjsf3cPv9LYC3hpuXCNS0pUWCYrIx8oHBHAgXKopavz8oC2qhid6MJrYArC7tvAyEP5/M4CD0kqOhkFrLcTTXiB8lmfUj4fteCa0JcKgeQpYSdzMnP7RsXBkCMT8T2Afi6Q9NEfWaxaLOq5lsciBmKJScl4LJ13Z57b6wd6ArgCKiZXjjs4MoVbtaCQflYcIOiwzIXIXB/cwNFSiVCOF4E7xxtpHKpwCDLFFytk/ZZnjXEjBhOHPx/jlZWUD0T7rrNTRXJg0N/smipaf0U+mS3FLF1zbjnwMBFOIEE63bxNx8EUontq3O3bKHGZz7Flwc8BJp7akcHqqMg11ZiSmoEMYMADRmSvjPPo9xYkT4CrHiJfkS8rRfeMzUbmfVTUTROYSO0MihqAJtwqFoUJU7sp5zp/87YCUDfCrAqi6H8FXL4tA+yeTMk0NrmfCeVj3P5z+Efnx75lmay7pls9gDiMFXxEC5sjRG1nUpT1tCUbRghh3bOFQ/qGh6WMEoEPOgSDFJMFEVVHGfBuC3GhSAVWPplGiY8HZWmkJqq/Caaz72b1JEetGlf6gLnSi89RdKt/Cxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR01MB6329.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(52116002)(53546011)(54906003)(83380400001)(6916009)(2906002)(316002)(6506007)(9686003)(6512007)(186003)(26005)(8676002)(38100700002)(66556008)(66946007)(86362001)(66476007)(5660300002)(38350700002)(8936002)(7416002)(4326008)(508600001)(33716001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iHvRxz7hz6B3NxtHOvqX1yxVYzT4ialVtUnTfpsXZXNkLz+j6FfNnQ6T7O8O?=
 =?us-ascii?Q?3UB37Ui+j+ZFVzMUzRZdkv/9aS1W8TTjatmQ1uq1NDEmCN5lxrE7BpbCD+xi?=
 =?us-ascii?Q?9cLQapOOexa/icuBpUxJvm5fpqsQU6VVEH2BNu0AcZ4A/MNxumVm5QvIu3hE?=
 =?us-ascii?Q?8lL8fIMajqM0Hwsqf1YN2leQ7SPFNkZxylTKd6R5H4N4fSvc67m8iGHHQ3xx?=
 =?us-ascii?Q?XORx9Zvu+l2vYUrNVAlCLj12iMHUxH6Ev0JzTBTybG+O0TVCGlDTqXbAFss0?=
 =?us-ascii?Q?p663uu7G6RE3TwmBCQPYWERcjdRcjVGWU8kKwUnUn6Ja/Z8N6Wkedn23S48f?=
 =?us-ascii?Q?qcFPHnF4ce5N5Gb+TeVIm6bV4ej38SXTMdIbGG2hJpfO4GVt9J/ixGqLbFey?=
 =?us-ascii?Q?UNnh8kIDKgAn6Q3oUF6e2EyhYI4Fpz6W4wnPJ8F5m3gUb+biqQ37id7MdnAC?=
 =?us-ascii?Q?kZvs2+tjb2kGC/HT5jqYZP3bEq5dJOeAK4N3Ko7Nx1gPNoTwM/OesP4XklX9?=
 =?us-ascii?Q?UT2ITCbHCxm/MQv1Wp4CECYN9sr2DBLSPXY5Ln347Mb2/z1WVIhvJS99chIQ?=
 =?us-ascii?Q?RlP7JzPpNn2Kl1r2rtwkM+IY1XC/keOSSG02FoM/93CxaiJ8iYKLB94xGXbS?=
 =?us-ascii?Q?WmYEFtB+/WaFIkg9FcOlzZmIE9jr0YmjJQufqQPlaHH0rhD9N9HfV8xNaOVi?=
 =?us-ascii?Q?J8VKtcZlSD8SOKR7GFhkJ/k4YGbWhJ0ExiX76/uIgV8AYyYajqVQbn6eGMA5?=
 =?us-ascii?Q?fGLbPY4H4ElUlhheJviOSZQ6O0WCv1AItowDny2+GmUfMd1EWyItLG4HsXNL?=
 =?us-ascii?Q?B/32a96vW1cRBR4IIXNVgsFpTo1cQzrW8hV2WhkziZrXwb0647DCXFVvgHrQ?=
 =?us-ascii?Q?KKQSdwfpBjW+I4FJN+GbPpMjusYqhudrFmP5wwSq62aC10y39FWFcL7wYXXV?=
 =?us-ascii?Q?R3BndDWazL3J7GA6PyMPfhleVztz7cZFagKjCBZVdwbrsiBW9UGPqgB6fyIZ?=
 =?us-ascii?Q?MYuYPt5PQKiBlJ/YV7bKtxgSB1QOcVdiWedS5VtBhtAdm9mrqtVHS7N5y2Pn?=
 =?us-ascii?Q?QDpvtA4sMuCaQSjPBtaEHlpNpdnyh8ALXUwgWUScJt9cTc6T9hnOb0yzjpbK?=
 =?us-ascii?Q?a1hwR4AE+vLoKrASodjnzc4lxmURJykHifdIzRBA/drqFjeMo5dcJfx6Yrai?=
 =?us-ascii?Q?QN2uXE+z2NESGfZqm7bkwZUmu3nWVTkZHrNZD6bbxjv8UIiuE6/PTf6gZobI?=
 =?us-ascii?Q?YRdwOiL1XgZ9pN76wHJvv6cmURhnTVSRQHooOaVmWXvIysaFl1ZZ0LO96F2r?=
 =?us-ascii?Q?1zaOLJl4qKkxO2zGtY1sM1gaXvTUDbLTlM5xLKYSr9tP6PeKChiAuM47Xe3q?=
 =?us-ascii?Q?4sHq7N2MbYIrPWMGC2d+sNvTXP1vM2d+c59S5/sJkcn+vqB76hNiEhaI12PR?=
 =?us-ascii?Q?TfkKGWlppmqG7jo5Jl/RDwUgTdiiGNtPa/7WOydfRQvo86LKNWVynIi8pBc+?=
 =?us-ascii?Q?Wi1/4Fua+An9foo=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 143f1d32-07d8-44dd-764c-08da05db93c6
X-MS-Exchange-CrossTenant-AuthSource: SA0PR01MB6329.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 16:56:26.3467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vTwAE4oEn8GJ3kDAqlwSp8AIbUXrM0xpQRNjPb5E40ZMNCSOPJHy4jzQIOLH+JdbskDAEkLAkXbFNvezNIet+VJBS8zJ+UE5VjZNQ7wIqeJ5OyAct9xD1emMXkebnXDl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB3816
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 14, 2022 at 10:37:21AM +0100, Dietmar Eggemann wrote:
> On 09/03/2022 19:26, Darren Hart wrote:
> > On Wed, Mar 09, 2022 at 01:50:07PM +0100, Dietmar Eggemann wrote:
> >> On 08/03/2022 18:49, Darren Hart wrote:
> >>> On Tue, Mar 08, 2022 at 05:03:07PM +0100, Dietmar Eggemann wrote:
> >>>> On 08/03/2022 12:04, Vincent Guittot wrote:
> >>>>> On Tue, 8 Mar 2022 at 11:30, Will Deacon <will@kernel.org> wrote:
> >>
> >> [...]
> >>
> >>>> IMHO, if core_mask weight is 1, MC will be removed/degenerated anyway.
> >>>>
> >>>> This is what I get on my Ampere Altra (I guess I don't have the ACPI
> >>>> changes which would let to a CLS sched domain):
> >>>>
> >>>> # cat /sys/kernel/debug/sched/domains/cpu0/domain*/name
> >>>> DIE
> >>>> NUMA
> >>>> root@oss-altra01:~# zcat /proc/config.gz | grep SCHED_CLUSTER
> >>>> CONFIG_SCHED_CLUSTER=y
> >>>
> >>> I'd like to follow up on this. Would you share your dmidecode BIOS
> >>> Information section?
> >>
> >> # dmidecode -t 0
> >> # dmidecode 3.2
> >> Getting SMBIOS data from sysfs.
> >> SMBIOS 3.2.0 present.
> >>
> >> Handle 0x0000, DMI type 0, 26 bytes
> >> BIOS Information
> >> 	Vendor: Ampere(TM)
> >> 	Version: 0.9.20200724
> >> 	Release Date: 2020/07/24
> >> 	ROM Size: 7680 kB
> >> 	Characteristics:
> >> 		PCI is supported
> >> 		BIOS is upgradeable
> >> 		Boot from CD is supported
> >> 		Selectable boot is supported
> >> 		ACPI is supported
> >> 		UEFI is supported
> >> 	BIOS Revision: 5.15
> >> 	Firmware Revision: 0.6
> >>
> > 
> > Thank you, I'm following internally and will get with you.
> 
> Looks like in my PPTT, the `Processor Hierarchy Nodes` which represents
> cluster nodes have no valid `ACPI Processor ID`.

Thanks, I'm looking for the right person to get us the latest information
available this. Will follow up once I have.

-- 
Darren Hart
Ampere Computing / OS and Kernel
