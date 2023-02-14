Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663CA696CD9
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 19:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjBNS1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 13:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBNS1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 13:27:42 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211AA113D5;
        Tue, 14 Feb 2023 10:27:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PThb2bjkDD0PRCiZcBs8VfaFRfYouLk1BdK6RXz1F4cFDn8xtrfwWKWvS4nz6w/TM9isXpPdfI/wTjMHE2SfDwbcRfw24C7lt6ENEGlUvkmiKOWsfTeXoidNpXEyHiImQkla6rOdcPAz3dYZFlc7Cw9j4Y+aBC9g2gS2ULTp0JFqOKwgi4vIyygvmGeIXWiL+SpbFETPyeZ3F/yMEWM4ftH95fC0+oEiYPPAFJnOsSACfih3OFIAiTu74aMtaZDoN2+eBoKNv6rN0B93GqiFIm2h/HqyuktvRvhzHtxJxUrySAVB0pGf4PUHgVJWM54saXHr43QmnqKH+5Oj2l0d4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+pd7cdqWpF/JIwLOY/RRdcDDF1pX07cjgSqdjv/qcY=;
 b=axxeYTS4os7tx+9ynBSo0Q7uKhMsQbL2Kd1s+s/c103muCY5GPqvY+PQsUPixZctBO4kS7J0Oe7jhsaAqmESQ2328lvK4yfytmx5dxO8FFo3hRSXuvEE+y3gIOQ+MbOCceuPp9/zT9Tlu30YEsHHBuZio8j8J0aND0HtqQwqXrjVlNA1ABWb/VGS10rAmLWRXGeM+8+P9+AXJ959Q8fy3mjBLLBq+y72XsnHFmgfiE57aUNDi7KHFkrl50RwxlECtch5is9SaWGlTde16p5ImUU0OSk3DF+ohw9NYImYVzRaMglQp3Dfl4KLs0xutCV2FKHJlLxsTg+USrlCpz9ZyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=memverge.com; dmarc=pass action=none header.from=memverge.com;
 dkim=pass header.d=memverge.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=memverge.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+pd7cdqWpF/JIwLOY/RRdcDDF1pX07cjgSqdjv/qcY=;
 b=UPRllnkwJs3/nrtRHfcvCJ9Q1EliA7X8m70tUMTPFJ9Btev4ikOnM2ycycBGRYjWA+3fmJJC40mV1h+6L4lzGSmym2kEYokoW//XCjUFAh9oBE3NTQltsd9ZQvshvtsxnDOLKqXL3fBuLZ6anRoLhasDCiIvnP3D9JwMues9Zkc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=memverge.com;
Received: from BN6PR17MB3121.namprd17.prod.outlook.com (2603:10b6:405:7c::19)
 by PH0PR17MB4890.namprd17.prod.outlook.com (2603:10b6:510:e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 18:27:36 +0000
Received: from BN6PR17MB3121.namprd17.prod.outlook.com
 ([fe80::d253:1eb3:9347:c660]) by BN6PR17MB3121.namprd17.prod.outlook.com
 ([fe80::d253:1eb3:9347:c660%3]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 18:27:36 +0000
Date:   Tue, 14 Feb 2023 13:27:27 -0500
From:   Gregory Price <gregory.price@memverge.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-cxl@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
 default
Message-ID: <Y+vSj8FD6ZaHhfoN@memverge.com>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
X-ClientProxiedBy: SJ0PR03CA0292.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::27) To BN6PR17MB3121.namprd17.prod.outlook.com
 (2603:10b6:405:7c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR17MB3121:EE_|PH0PR17MB4890:EE_
X-MS-Office365-Filtering-Correlation-Id: 0265fe59-2746-4e16-a642-08db0eb9256d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b5u5CngNUXBWxx+cdUe2TCbi7FGuIcUnux8HCD/gWu4tKuEkvB3dx0A207zpj8bplFxVrxoQy/W+jPA3oY0xHRa+WdyN2AIruVNlF+SyNwN17iUsYFpA80QO3A5iGW90kbk3aJo8z1z3lEIhpW5GRBSctnUP5Zcv00335PcezGgeV2TxfH71FwquwpA/0zhJSfnPnNzIAOkm6/0tvJGB2L1sMdqeDLycS3sM2OwiRr3bGM+SRPQV43tPk9OSAVEvupaSKz3WvO5BHtqL7JwJlC4wux4ZzF8Ptybrv0A6w0bHspzQkj1otAx7VOdi7tRiCS9OQxQddCilUtIVRzAydNt4gctzSOBYUCulyN9f7yPRRUKtWTpBGj5wgOILsMr1mRViTCyV3rrmIxOyz7UDAxz6KvD4IFjCz6KLT+oQj1O3HMofGXiKGCWIuFunEn2gEkPhfzw4eOB4FN/glWHIZjM1zUcRuzcUE1RXtLwpLMHYU+c5yY28F18QI2lcnKPbY1dVVO6Yp3FiT+emVUKud3ZeTTAYzA1ueXS4aWUyx12XhGbT5vWkwjWI7bUXck01Ky0BfrwNc7MGFfIoNFe2uUKlOvG6H03CHQxXnnXiEfW+XW/hlNAZqWp/TkDriEU1eTfrWiZuevvQ17C2uK7UHjWS4xcIxJYHkQ4KILVEUQ9249nQ1gC3sWdLj0qLr67H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR17MB3121.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(136003)(39830400003)(366004)(346002)(451199018)(2906002)(6666004)(8936002)(41300700001)(66556008)(66946007)(4326008)(6916009)(66476007)(44832011)(8676002)(5660300002)(316002)(54906003)(83380400001)(6506007)(478600001)(6486002)(26005)(186003)(966005)(6512007)(36756003)(86362001)(2616005)(38100700002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlZUd3JtREpYOStDTXRBYjFrdnlza05wSnNyTElGYXhxN2tMTHUxT09YVGdy?=
 =?utf-8?B?MW1vaFc2YTRuYlNSdGFEeVcycmZrTDY5ZWx1dGVUMnZlaE5IMGFMNTNSejlD?=
 =?utf-8?B?dzQ1STFoZWxRaWpia1FsZHNhQWRHbWRrbXZzZHcza2h2aDhqZjNSd05jSXI3?=
 =?utf-8?B?SW1qY0ZSYnZqWitIU2gwNkR6U1dVNGRjTHBhZlNMMktGRWdWL2grdmlZbzQ1?=
 =?utf-8?B?dmxkaG1zMS84dCtpR3VqUEVxenhZVHJ2N1BGSGUydGZmNVlEbmQzdytpQXpm?=
 =?utf-8?B?N1ZIQ1J6UDZnQ3d5ekZ5Zm1BWk1JNHRnVXhodS9oUStBVys5RW4ySHJEellT?=
 =?utf-8?B?K2RVVUhUSnFaQTIzNzZIcG1zMGhhSjVRYXc0WVZLRjBrLysydGk3eTBWb1hL?=
 =?utf-8?B?cGN2T3BJZW5KZ3JQeTJtdnFydWV5bGU2c2h4cUNGQ21mUHc2T1QySk1oaGp0?=
 =?utf-8?B?NUQ2U21HY1Y3QjM5U1JUaUpFUGNFdzcwaEdqR243TGFjTjlIMHZabUZHMCtm?=
 =?utf-8?B?Vm9PN0lBSmZQTGxlOXVnY01qZGsvM2wzTzdkZE4xbkRmMkpTTCtOWlcyN3Nh?=
 =?utf-8?B?MVNoUFpvcllHOWFLMWVQUWhEbkh6QUdCcG9BYUdRVmdmdTY5TjZma2tGQ2dy?=
 =?utf-8?B?N3VEMUxQNzFWRHR6clE4NW8wZm5DMm93K0JRMEVsTXM0WXhXanpCL28xcTY2?=
 =?utf-8?B?OHY5NGx1RWJGOUErL012QkRYdytldURnK3oyMlVWUTRJMnN2NEVxcXpKNVlZ?=
 =?utf-8?B?bXJPeDZMeUN5cFpISFRJVVcxb3pqQ3VjTmxDdlpUeVNteEtTZ21XMThPcmxp?=
 =?utf-8?B?YTZycDZaK2t3eVBuVHdOd1hxOWhxOEJXcENEeFFpVk5IYVpaZ3cveEZEdWNS?=
 =?utf-8?B?TDdRNEZBTkNrN3J1S0pxU1R6K0dDTnE3ZStJWkJaV2txeXE5bHNENHd6MW5m?=
 =?utf-8?B?TWc0OXdVMklYWFdWQ3o4UVhFQnc0RVRDTkQxZ2t0NUtML2xzUmpUR1I3ZVNv?=
 =?utf-8?B?SXRBcFRuRm1ueHNpR1ZMSE9UQjlUek5VTTAzSTREam42VnltMFlPWk1LR1ly?=
 =?utf-8?B?bVlWZTVGSnIvS1E0U1QrSXg5NFR5TTg4OWZHTEFNaXU2RzZUc0RobFljTjhZ?=
 =?utf-8?B?NGdwMGhVcnR6YzdmbDh3UnB1d2RGTzNKekl3QWVZR0lTSFNYdU9vbE9hSkY2?=
 =?utf-8?B?cGM3TEZvSUs1RGptUVNvT25TUlFhY2RaYU02d1lVMmtxN21RSnVvVnpmdms4?=
 =?utf-8?B?VjFKcFpQRHQ2eUZ2VzB3Q3BpM3Z6eXNxSU4rcm5Ed3FuVHQwQkJvN1NodjBn?=
 =?utf-8?B?SWRkclhVRFpxUmlROXBkT3Z5b3UwSFZ2dThDbHVXSUhlUFpOb2JDS2tEQ3BJ?=
 =?utf-8?B?cDd5T2NOMkpTVjk5U1YrU1k3UmZRK0dDa2J5NU9xU0t6OFFGVkUxYkZpWFFO?=
 =?utf-8?B?ZjR0RDE5cEU3WFluSEc0K2xicU84YUhTbUFvc2tSa2NrTUZtVWR1anpHZjV4?=
 =?utf-8?B?VmtMRVZVcEgvUkFFc0I4YWg5TXZXdk8zcHNxUk4vRmw2blJFZU9nSGpPbDlv?=
 =?utf-8?B?ejI2ZFNHck5BMnh0WGtsOUV4RnZFdVI1T3FlQXJoR0lVRDIxUm5pZFdYME9v?=
 =?utf-8?B?ODIrVi9DOFV2UXJEUGdta1lYbjYvTDJEVHhQLzlmKzIwQitBYnNCYXhRYzZ4?=
 =?utf-8?B?QzBId00vM1EwTHFjdEZUVWxaWittSitUMVRERTVKNHNCZElMM0VPWld0ZW9p?=
 =?utf-8?B?eHR5TVJieXlGK2RJZlA5QzFsQlZaNHgxaEh1NmJ2Y3Q4TjNsMVI5anFiaFlh?=
 =?utf-8?B?ejAzV2M0Z1VLdC9pNTJ5cW1IRTNvQ3VsY1A0Z2hPam1DRVorSENvb2dRZEta?=
 =?utf-8?B?SHNRMjV0bmZ5a2FyU041TUFmWkpjNE1VekZ2eloyT0hCQ29JQUlja3NCUVFG?=
 =?utf-8?B?TUx5RThuY2RqVlZaMVVuS1NZWVFnNFcwZWNXdlN4c2tFV3pqUXZ6a2pPbm1m?=
 =?utf-8?B?OHByQ1JzT1JaYkhQTGJhOE5tOGo2QVArMFpOZWtLUXNiejFkcFBqYnJ2Tjd0?=
 =?utf-8?B?bktYa0lJM0tmUEdhSGxFZkRDTExzQzdyRTdENVdNOThEVGRuZ0thMENUQnNM?=
 =?utf-8?B?K20ybkp6SDlWTXBrNHA3SCtyVDg3cDU1c3hCQy84Q1RQNkk3L2VNWElZVU1I?=
 =?utf-8?B?N0E9PQ==?=
X-OriginatorOrg: memverge.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0265fe59-2746-4e16-a642-08db0eb9256d
X-MS-Exchange-CrossTenant-AuthSource: BN6PR17MB3121.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 18:27:36.4613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5c90cb59-37e7-4c81-9c07-00473d5fb682
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WEHBNeNouag7eX1IghtkA2V3GNqlRjQdC1D3wBVyLBDqSHtNhN8R6/CqX1TwoZPcRiTKQ87+9PLKXsI7WGmiEGzaRfUFzfPfgoxdIp6a1qA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR17MB4890
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 05, 2023 at 05:02:29PM -0800, Dan Williams wrote:
> Summary:
> --------
> 
> CXL RAM support allows for the dynamic provisioning of new CXL RAM
> regions, and more routinely, assembling a region from an existing
> configuration established by platform-firmware. The latter is motivated
> by CXL memory RAS (Reliability, Availability and Serviceability)
> support, that requires associating device events with System Physical
> Address ranges and vice versa.
> 

Ok, I simplified down my tests and reverted a bunch of stuff, figured i
should report this before I dive further in.

Earlier i was carrying the DOE patches and others, I've dropped most of
that to make sure i could replicate on the base kernel and qemu images

QEMU branch: 
https://gitlab.com/jic23/qemu/-/tree/cxl-2023-01-26
this is a little out of date at this point i think? but it shouldn't
matter, the results are the same regardless of what else i pull in.

Kernel branch:
https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/log/?h=for-6.3/cxl-ram-region
I had been carrying a bunch of other hotfixes and work like the DOE
patches, but but i wanted to know if the base branch saw the same
behavior.

Config:
sudo /opt/qemu-cxl/bin/qemu-system-x86_64 \
-drive file=/data/qemu/images/cxl.qcow2,format=qcow2,index=0,media=disk,id=hd \
-m 4G,slots=4,maxmem=8G \
-smp 4 \
-machine type=q35,accel=kvm,cxl=on \
-enable-kvm \
-nographic \
-netdev bridge,id=hn0,br=virbr0 \
-device virtio-net-pci,netdev=hn0,id=nic1 \
-device pxb-cxl,id=cxl.0,bus=pcie.0,bus_nr=52 \
-device cxl-rp,id=rp0,bus=cxl.0,chassis=0,port=0,slot=0 \
-object memory-backend-ram,id=mem0,size=4G \
-device cxl-type3,bus=rp0,volatile-memdev=mem0,id=cxl-mem0 \
-M cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.size=4G


boot is fine
# ./ndctl/build/cxl/cxl create-region -m -t ram -d decoder0.0 \
  -w 1 -g 4096 mem0

[   28.183276] cxl_region region0: Bypassing cpu_cache_invalidate_memregion() for testing!
{
  "region":"region0",
  "resource":"0x390000000",
  "size":"4.00 GiB (4.29 GB)",
  "type":"ram",
  "interleave_ways":1,
  "interleave_granularity":4096,
  "decode_state":"commit",
  "mappings":[
    {
      "position":0,
      "memdev":"mem0",
      "decoder":"decoder2.0"
    }
  ]
}
cxl region: cmd_create_region: created 1 region
[   28.247144] Built 1 zonelists, mobility grouping on.  Total pages: 979754
[   28.247844] Policy zone: Normal
[   28.258449] Fallback order for Node 0: 0 1
[   28.258945] Fallback order for Node 1: 1 0
[   28.259422] Built 2 zonelists, mobility grouping on.  Total pages: 1012522
[   28.260087] Policy zone: Normal


top shows the memory has been onlined
MiB Mem :   8022.1 total,   7631.6 free,    200.9 used,    189.7 buff/cache
MiB Swap:   3926.0 total,   3926.0 free,      0.0 used.   7567.8 avail Mem


Lets attempt to use the memory
[root@fedora ~]# numactl --membind=1 python
KVM internal error. Suberror: 3
extra data[0]: 0x0000000080000b0e
extra data[1]: 0x0000000000000031
extra data[2]: 0x0000000000000d81
extra data[3]: 0x0000000390074ac0
extra data[4]: 0x0000000000000010
RAX=0000000080000000 RBX=0000000000000000 RCX=0000000000000000 RDX=0000000000000001
RSI=0000000000000000 RDI=0000000390074000 RBP=ffffac1c4067bca0 RSP=ffffac1c4067bc88
R8 =0000000000000000 R9 =0000000000000001 R10=0000000000000000 R11=0000000000000000
R12=0000000000000000 R13=ffff99eed0074000 R14=0000000000000000 R15=0000000000000000
RIP=ffffffff812b3d62 RFL=00010006 [-----P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 0000000000000000 ffffffff 00c00000
CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
DS =0000 0000000000000000 ffffffff 00c00000
FS =0000 0000000000000000 ffffffff 00c00000
GS =0000 ffff99ec3bc00000 ffffffff 00c00000
LDT=0000 0000000000000000 ffffffff 00c00000
TR =0040 fffffe1d13135000 00004087 00008b00 DPL=0 TSS64-busy
GDT=     fffffe1d13133000 0000007f
IDT=     fffffe0000000000 00000fff
CR0=80050033 CR2=ffffffff812b3d62 CR3=0000000390074000 CR4=000006f0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
DR6=00000000fffe0ff0 DR7=0000000000000400
EFER=0000000000000d01
Code=5d 9c 01 0f b7 db 48 09 df 48 0f ba ef 3f 0f 22 df 0f 1f 00 <5b> 41 5c 41 5d 5d c3 cc cc cc cc 48 c7 c0 00 00 00 80 48 2b 05 cd 0d 76 01



I also tested lowering the ram sizes (2GB ram, 1GB "CXL") to see if
there's something going on with the PCI hole or something, but no, same
results.

Double checked if there was an issue using a single root port so i
registered a second one - same results.


In prior tests i accessed the memory directly via devmem2

This still works when mapping the memory manually

[root@fedora map] ./map_memory.sh
echo ram > /sys/bus/cxl/devices/decoder2.0/mode
echo 0x40000000 > /sys/bus/cxl/devices/decoder2.0/dpa_size
echo region0 > /sys/bus/cxl/devices/decoder0.0/create_ram_region
echo 4096 > /sys/bus/cxl/devices/region0/interleave_granularity
echo 1 > /sys/bus/cxl/devices/region0/interleave_ways
echo 0x40000000 > /sys/bus/cxl/devices/region0/size
echo decoder2.0 > /sys/bus/cxl/devices/region0/target0
echo 1 > /sys/bus/cxl/devices/region0/commit


[root@fedora devmem]# ./devmem2 0x290000000 w 0x12345678
/dev/mem opened.
Memory mapped at address 0x7fb4d4ed3000.
Value at address 0x290000000 (0x7fb4d4ed3000): 0x0
Written 0x12345678; readback 0x12345678



This kind of implies there's a disagreement about the state of memory
between linux and qemu.


but even just onlining a region produces memory usage:

[root@fedora ~]# cat /sys/bus/node/devices/node1/meminfo
Node 1 MemTotal:        1048576 kB
Node 1 MemFree:         1048112 kB
Node 1 MemUsed:             464 kB


Which I would expect to set off some fireworks.

Maybe an issue at the NUMA level? I just... i have no idea.


I will need to dig through the email chains to figure out what others
have been doing that i'm missing.  Everything *looks* nominal, but the
reactors are exploding so... ¯\_(ツ)_/¯

I'm not sure where to start here, but i'll bash my face on the keyboard
for a bit until i have some ideas.


~Gregory
