Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D58697023
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 22:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbjBNVyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 16:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjBNVyK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 16:54:10 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF039BDCD;
        Tue, 14 Feb 2023 13:54:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTXMP9XiOkPnEAotjky1MNX/weNF6jcgPGHGMjTj8CldMzcZfVj/nlLYHPQ6TUfz6SPbAOZEwhQK/I+BzIrKePEgyJY7/4wsxdkHmOF0DYQQgF5Tats8hA80v0iMi0L3mGf2HmzQZ/Nz1spDJ3um/fD51QKYlmwj3JyRZe0Ql8sK57zJlK5QINHQTMw/RJD7GEj8l0c1LTqX5J0pVTFtEK1xkbw+lx6sFrzY38AjVFj4vz/Ma2GN6y1TBIzkL6w+vuNvrSLVYV2mXW5beylDEVpaA+egRmgP/r6RbxsizLQRSIFFn3W5UOPt8UMyAk01AmvqsNOzrPJVSe42wxuBwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hre9to8ddE2488MjnCmGPJYTu+zLTh7rPdL5cQWBgtc=;
 b=M4MTmmFCo2RmV1VWB9bHCxnk3HHDYV36EnSnQ5MAjhpxc/yx/1VOkyE3i4rDpFIiYfingA3ZDqh+5fK1vfboGPUkqkD8+IG59cE/1avnxVCoIqBJI4x6U3KV0ojY9OoYsoCqwn7MwYxNrKorxnCzXppynHXgqp8QGO1Tg5kM3lwdUoklM+seIhNEJYvjm9rdIJvD6l3nRFZ0x3qLUXVV0tcsOThPu+Y6BbBuF1IBF3igFrJO6CgymeGbMpLnZmacUvUeyZvixc1eGMimciEfczLGCPcu2B56R5cRV8kGlQrBmHJ6dQdkTsV3aaSk6a26ISMcbF3cTFVwWDdNs3fpXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=memverge.com; dmarc=pass action=none header.from=memverge.com;
 dkim=pass header.d=memverge.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=memverge.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hre9to8ddE2488MjnCmGPJYTu+zLTh7rPdL5cQWBgtc=;
 b=gMSlEO+pWPAywxJTW8p4Wo7S9NYXbo92pE2iDIF9Hfr/p0nnuAcANO5WLqlOGi8Tr4GRRqqjY+7hdBnxDwzAVwDRuR4lUEB2JxgDDiG70A7V6OyB3ap+Loc5UkIuKZpkT5UaOidIjfdYe0hnNqS9XymAHJGlRr52nHOihkSicR4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=memverge.com;
Received: from BN6PR17MB3121.namprd17.prod.outlook.com (2603:10b6:405:7c::19)
 by CO6PR17MB4979.namprd17.prod.outlook.com (2603:10b6:5:355::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 21:54:08 +0000
Received: from BN6PR17MB3121.namprd17.prod.outlook.com
 ([fe80::d253:1eb3:9347:c660]) by BN6PR17MB3121.namprd17.prod.outlook.com
 ([fe80::d253:1eb3:9347:c660%3]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 21:54:07 +0000
Date:   Tue, 14 Feb 2023 16:54:02 -0500
From:   Gregory Price <gregory.price@memverge.com>
To:     Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc:     Dan Williams <dan.j.williams@intel.com>, linux-cxl@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
 default
Message-ID: <Y+wC+rPRbAc9rudx@memverge.com>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
 <Y+vSj8FD6ZaHhfoN@memverge.com>
 <63ebd56e639e9_32d61294f4@dwillia2-xfh.jf.intel.com.notmuch>
 <Y+vag3hg3VRNRUti@memverge.com>
 <20230214211824.00007f91@Huawei.com>
 <Y+wCeSig++c3ACkj@memverge.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+wCeSig++c3ACkj@memverge.com>
X-ClientProxiedBy: BYAPR11CA0066.namprd11.prod.outlook.com
 (2603:10b6:a03:80::43) To BN6PR17MB3121.namprd17.prod.outlook.com
 (2603:10b6:405:7c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR17MB3121:EE_|CO6PR17MB4979:EE_
X-MS-Office365-Filtering-Correlation-Id: d94d1261-0c15-41ee-0901-08db0ed5ff56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k/v7jYLDrvLz4lGXwXPRvOocsrQG+b5jbler6O9235Y+wafNWkThydVf/S2veD1PxSY98AglHkV9tvw0ixXt8Uf+MVALbQzp9M2yvVOnOHbvrfEREwUrnp/dOQS5ivZO4WTp8r5Tk5STBNk/HX1PU5d1JnVZ+pVUZ3DG9kpBtHmNFGp1s/Ln9Du3zZv20SyPpJVCuTCaKJIyd/aW/ZXpHaUnPDcSCNGqlqQzkQNfnjtLnvKGP5uZN7VoFR3LKo0UysIPL6D+eNlSW/KC44/GKgfre23gyw7e68t6SkzUJ6VNHrG+m7wfSHtQR2mNwWRXftvjlFgec3FqgTuHoR9EhcgjrMm1vh5BrCVVjM4ZYT0lidGXHVA8Spc398tQSzeFT59EUiSpNL32j9VNMRhQjYiyNrd9qj3DV9MqQdyXJMR4EN/OX+zHKqUcKBPi82Sa6yobS7Pa3x5Njs68T2PktwXWJQ4OqRVh5zP8swvImmOyrhhINvS7JwEC0GRJbgnRurve6keGyFrlbPENaAnAcTRdNebO0JqtwjNa0l+41hZpIUwKqiNM0fSbMDBGD3l1Tlngum6Eufy7pZ6TZqiaVxVD0cRKtUa41Vsfi8BV09UXBNTZDTDyt5qpgIfYD3db
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR17MB3121.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(376002)(346002)(396003)(39840400004)(451199018)(66946007)(38100700002)(6666004)(66476007)(5660300002)(478600001)(2616005)(6486002)(966005)(41300700001)(36756003)(6916009)(4326008)(66556008)(8936002)(8676002)(2906002)(54906003)(316002)(83380400001)(26005)(86362001)(186003)(6512007)(6506007)(7416002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NjZLD0rfL3iAVaV0Uh4zVXIvZwbiyThlXBCrlS4YcEAUDaNt8zGPGnKeugLn?=
 =?us-ascii?Q?8XypxYbAUedod+4+x2KSXKW2wz1TpG3W2jrn8q1OsXzHbgdd3DdGSGsksiu9?=
 =?us-ascii?Q?KAVVa40VnzjsOCX6L2XfZWnRZpFot64hgyz8DNAL5v7nR3g0AAwAmSENrgAX?=
 =?us-ascii?Q?y4hC9Io+4lehpjFTQ267LYhvLLficfYMaOW/cFcc/WnTuw6No/E93khY//oU?=
 =?us-ascii?Q?kHU7R5e5tqOBrXcNhNQNyWViKaY2rRadS5svilW77JXJXG+YcN9NgpHK2j2d?=
 =?us-ascii?Q?jz5CFahpRAf0GFsJkIrnxIR8fAh8FtOT4HA9Y+iBA+eHFV5D0L0Mc+GcfcqI?=
 =?us-ascii?Q?2ja/QpSaA6E5QOGwd6WIxNJgIvnqeOEVDAiQgGkhNrjojz7vJqFc4RuHEozz?=
 =?us-ascii?Q?LZHjEr4S//ZLF4yLXIHF88ZJE3KVUppvA6wcHn9hGoOR6TcwZ/Tsgb8ZBp+V?=
 =?us-ascii?Q?zVgp143zlMSFTOHJYwEQguLWRMCJyLirf6ty2X6RKB7Kaw4Eppg8OLXiV0x+?=
 =?us-ascii?Q?o2OaO44tv12+q9KXIpbC22Wh+a8QXaN85iQ+6hxCLi+cEV+Lf+odifdRN8mJ?=
 =?us-ascii?Q?4KNg7C7BcWoi45u8Nh999/AtWimqMLizwLT8maZ8x23dTs8CuHmRoAvfBhat?=
 =?us-ascii?Q?e3Kbwmrp/ime1RCO8a7TGcXEK5KBbBLf8obgO8Ymy8EAYKo9StvkPM/dwh8l?=
 =?us-ascii?Q?snOPHkT3MyUNxLJjEJvGbxKBnCOgYRf22PcLkC5FmNgKe3ZzbkwIY/pngX19?=
 =?us-ascii?Q?SoCWf4leFFhKpFz76tH0hLfDxops6OHtN2AjyJ2OTzZvbiuVhFfR2yR5RWXQ?=
 =?us-ascii?Q?1SmWrn6JiI9Q7y9KyHpoKYS40Zi7tq5Vr1buUul/OdiT+Ecn//ftPIL8dlkN?=
 =?us-ascii?Q?EH+BwwY5Y4agPHPSh1eKWet+qCmr+RXDnsK7BNdGPeV0Wkf6h1812t5/WJs2?=
 =?us-ascii?Q?Reg6IiSiXhvMGnMWDrU9LylHUY+WtS5mMQomquSkpJt5skCL7s/NloO2ePXt?=
 =?us-ascii?Q?HNkw/KC8BmHWfPtYkCEf78JSOE4YMupuhvf0qMB9HdSubpRJw53my6LsY6iU?=
 =?us-ascii?Q?96fZgdBbchz1jpoG7b0XBWvPkAtZmJMoW0KqlaBoeHEQpPV7SsW3X3zNaFtK?=
 =?us-ascii?Q?EaRWKVFMgONu9sq5FBn4FaF/bfNWDDL2x/Fo3kL/AB32ZNDCb1l4Ji1Tn80U?=
 =?us-ascii?Q?CH4pssQuZ6hpkqCdhCt3KIKhbVC6LzXqHTsoJY7TyyB+6q3+dJCWQfjyohxI?=
 =?us-ascii?Q?UiqwbxGeJwjBZqopq8M9rwUIgAoqEgxftsUSzTp0c3o/SrsdNPveu+xdakdY?=
 =?us-ascii?Q?lRVMLoN1J7G7pXnMxB37DQpfRmmsrbwEZjIVAou8niYjlsU1FQkHTQZ0vISD?=
 =?us-ascii?Q?mXVvn9VOoO5k607Y4Tk15MvP/AM7Lze9iHTc/R4yuKQOEIqrntJcMw2Edm7K?=
 =?us-ascii?Q?e+E1Ec4zJF3OMenVYCSSFYuehwrHsoAdklbQ8JaGDOVzKxSbJX0oemAN/VUF?=
 =?us-ascii?Q?dKuRCdkrM3g3V+FxTMweGAhjVXZFjNcB7pXXAr7nG53CHEElgvaFMY3WYYU5?=
 =?us-ascii?Q?kO+5FySurNLBUp7dx22VoDOIWf8cLJ9TEO7au+BKhhD0BN8Ac0xUJysNAJrU?=
 =?us-ascii?Q?EQ=3D=3D?=
X-OriginatorOrg: memverge.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d94d1261-0c15-41ee-0901-08db0ed5ff56
X-MS-Exchange-CrossTenant-AuthSource: BN6PR17MB3121.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 21:54:07.8958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5c90cb59-37e7-4c81-9c07-00473d5fb682
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ug74ZcGSSnvI+f8AEbBlXmaapXONhTWMZugKiNV/7kjFZUBc8DZdY2umHtINV6mL9wQePLyhYum/PKxxJBna9im8K5aYQNnJs57bBqOqZvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR17MB4979
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 04:51:53PM -0500, Gregory Price wrote:
> On Tue, Feb 14, 2023 at 09:18:24PM +0000, Jonathan Cameron wrote:
> > On Tue, 14 Feb 2023 14:01:23 -0500
> > Gregory Price <gregory.price@memverge.com> wrote:
> > 
> > Could you test it with TCG (just drop --enable-kvm)?  We have a known
> > limitation with x86 instructions running out of CXL emulated memory
> > (side effect of emulating the interleave).  You'll need a fix even on TCG
> > for the corner case of an instruction bridging from normal ram to cxl memory.
> > https://lore.kernel.org/qemu-devel/20230206193809.1153124-1-richard.henderson@linaro.org/
> > 
> > Performance will be bad, but so far this is only way we can do it correctly.
> > 
> > Jonathan
> > 
> 
> Siiiggghh... i had this patch and dropped --enable-kvm, but forgot to
> drop "accel=kvm" from the -machine line
> 
> This was the issue.
> 
> And let me tell you, if you numactl --membind=1 python, it is
> IMPRESSIVELY slow.  I wonder if it's even hitting a few 100k
> instructions a second.
> 
> 
> This appears to be the issue.  When I get a bit more time, try to dive
> into the deep dark depths of qemu memory regions to see how difficult
> a non-mmio fork might be, unless someone else is already looking at it.
> 
> ~Gregory

Just clarifying one thing:  Even with the patch, KVM blows up.
Disabling KVM fixes this entirely.  I haven't tested without KVM but
with the patch, i will do that now.
