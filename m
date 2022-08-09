Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0177758D4C5
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 09:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239323AbiHIHkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 03:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239651AbiHIHkJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 03:40:09 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6511EED3
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 00:40:07 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2795fRYO003972
        for <stable@vger.kernel.org>; Tue, 9 Aug 2022 07:40:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=HgHeFVrHmZ53WqH5K0DDrMMiaFFOK2yMAZ0EGTNQHc8=;
 b=RLh22Pm4r0cVPNwaLyV+YBWVqwVaTxlmVV614shiiiZ+2G0efXWKKY2KiBysJaYAvsOi
 qPuQLgZPbhjw0vgkKqilWj/QdPjBioYWtqn5+xxriCJsbOTXntmL/RDLmexnw1eeyocg
 goA8dxTtL7Faj31bYm0qhKyPutSiklHyQ81eOraJ4+NyXq2I6nkn1SpWWgLc359JnOhP
 pC5ZlKG2z2XoJcmbUO7RUOI66x8scFlGKAzpI4LbF//yGstxdgR6qLV+Jd41SYcGb4AN
 GzzU7sD5RTwrwl1ACUle7/ZGGNm1zsRBIYMrHKOvmQJXYqKE8YvXrwINVcQ0n1Xjudnl Ww== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hsf9d2aja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 07:40:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AicCGlTuzADPfrKzJ25EM3n2RJcexC3k3414VSuumfjped8Q5ujYFpVDBNeODuIScUeIYHA11IxWtOXB1L9P5HrP4G2rR8NUYUKV/8kE4AcYwEkQEtSkkvpnkUQU5JNtUsXqvlx/dWaVrMJk5sbx8HWuut/4pffC98SnzDMlKwbAJushhX2WPXa7UKEiX7F4RfTQajXeqXcIhvJrxODcIYZRxzHTXGG7QoLwfqxZlOrXNxAxkzXFgT+9NvL7B1IaoRlYIgI190HRejF4VVLIWWQKgiqH5m9HaY930BmlMZphTqYPILC7MSFXhjmEfwurIL0lW+5rQX55ejd7WLmx0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgHeFVrHmZ53WqH5K0DDrMMiaFFOK2yMAZ0EGTNQHc8=;
 b=Y6jhDUOGE94x6AFHaQaqfqqwv/xcB2DGmS1AdZQXUG4VJfJZ6eClBZtAV8BfmwnnZJZfVNAKBmuUjQD0//UcKTga7ruYM3VoBNaufWazutFbFRoIbpzXHVao4Ll9DOg/dMtVqIwo2rDoifdii948YU/WtOzCwulMfrsDMo/WylW/zNoupyoimD96SzfC73erKg/dJ9Q2ASTLMCPZW9pIMq9OmCyYrRRmEGuxKb/KZGwR0wmbP3SIVgLUoLW7Q28cVzj/w+80tTLeWo2C3Sca03hhHgyR49ChqJpDNGvgswdJCunbW1Z70MLG9AoC9snINX06IPYIpzS3vCJsHsCL/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB4188.namprd11.prod.outlook.com (2603:10b6:5:198::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 9 Aug
 2022 07:40:04 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 07:40:04 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 0/4] bpf: fix CVE-2021-4159
Date:   Tue,  9 Aug 2022 10:39:43 +0300
Message-Id: <20220809073947.33804-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.37.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0060.eurprd09.prod.outlook.com
 (2603:10a6:802:28::28) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b53fe635-894f-4a92-595f-08da79da5f83
X-MS-TrafficTypeDiagnostic: DM6PR11MB4188:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 35H+njRcdhzcvX6mr5AAsmjp8YagI0l92SR/NULGcRKpDLmhU0lrhJ1KA3lsBcWE9CP7LWM3hTzPQYXdZVZvx1+nEKXonp+pFxCKNF5+vhPMqFnk/gA2hNZ3oRWypE+6h5jA5B7GWZum78Sjkmqld91r0SsTsp6iHQb0+kimQYpTdxhkxNivre0s63poj0+fdrm2hr3BiQqh+3okr/bHpxhJNusmLLfhevIBEEc7T+PTBOFiuVZQ7EsOmCFZvBpT7Tr7mhXvmsubg2BOffStdu+JwugkcLo3oy05m0CoDe9iJlVEbc6ADuEtjEkNJHPZJUsMVlAMIU8rueaBffbvnyqXOLQkobHl8HBwvRlLsTJGmDs8AKR5nk36w8Bp1hc/sRi8gF1dpYmmn9tM28Ps2NVX46+atE1Tdmt75DfAggIG8nV1fhw0s06GQRcCrr2CFPoC2odTqnP2UCDLtZKHnEmlZqZEBZENRGiK8xPWsbIPm87RX55/wl+XnOjQF/ne6PZ0yCL+TBItzr+EDmjloC6U9wutMj4KqeUrVfseoER8wkeOZUqt6Tlr0DrSgAXcUjPDFUn7GiswyWesWQc3c6+3waBulklXZvdBCYRFgXAfb8KaZH/jkpxN0+sgYlCeKoFIatd1VjnqE5TB6UcEiG6H+bd6XeqBqzUotp//J/dMW/5CzV9vE3+GBfOqoLM5izq9sDguCl0wtgjm3fOlTILlOSzIfMVThKhnqgQ8qQZ8KAfnYL2FLlbC+4bLwls5UIV+OIbuU/CHmblieky1bJUrcgRi8408bctpE90ZyIc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(136003)(39850400004)(366004)(396003)(38100700002)(38350700002)(26005)(6512007)(66946007)(4326008)(8676002)(66476007)(66556008)(36756003)(6916009)(316002)(6486002)(478600001)(86362001)(2616005)(107886003)(5660300002)(1076003)(8936002)(44832011)(4744005)(186003)(2906002)(41300700001)(6666004)(6506007)(83380400001)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CLjrA2GCp96ugNBQpGP/ozZrzdEZ9/VOTvoaHaOi3D/8oqys//phq/iLpoz6?=
 =?us-ascii?Q?tln2E2cVYPCduVaJ8orX6ijJn7l0nqC2gd8s6XSRUPDAUq1sYgM4t8VAIr+o?=
 =?us-ascii?Q?zoQNCX+1fu6KfzxOHgH6yrptqHFVlWU7nFdNV8fTvNo18prgPr39+IlVPrso?=
 =?us-ascii?Q?Bv+j2epvbuI4kbBmM4HHd3XbFliIXz+tORj5lKgh89V6Sgolx9HiCXicfpxn?=
 =?us-ascii?Q?Y/mcQuGmR42uKp+szlzuEVFmFz12QxPtIL8RD29W9Fo5w7+PKPT+f6FMGX6l?=
 =?us-ascii?Q?2gT5XtX6ginzffARKu6Xlje9py7YeNlOnzfvHpf3xciHGFQMwK/NC7gCizTw?=
 =?us-ascii?Q?Ob+FIXGONbAM9qvI8fYwKOZ3cSCCMTKGPqob+RBR1uV7oHciBG4zf9C7zk+P?=
 =?us-ascii?Q?KFYo1TSsL8buqMEJFLRSDzB3xXIbBtA+pPtezucf/oTICeocqUswsllXiF6Q?=
 =?us-ascii?Q?7Jo/LcPcX6bcthzv3UwNQNECPSrQOVhOlW0zERmDTPGWOJrkYw7E95sPtKyB?=
 =?us-ascii?Q?hYw/2iF/X06FrwuFuUMIbbC7SM0nbVVas+O7KsxvRg2UP/U2CTdNbpg9dk0O?=
 =?us-ascii?Q?gNktMeUaR+VTEQnZGcJTrLzHUNVSiIu7ZMsglyTjUAZ+m7KDf2uAjZW9b2NX?=
 =?us-ascii?Q?mH73nNw4mLM0DCMbi69Y/634cVjWP9QSOm+JwBk5w5x/tdw4R39qNTwL7evF?=
 =?us-ascii?Q?jxKOerYXTiW+8EsazuHi5fprOjgBGUmh1eoy+g7rrgmHbVqIP+us3rEF4GLn?=
 =?us-ascii?Q?aTz/uBPfBrZF5fTuL3hQoxdDz4Vqy749jtDKnne4s1RRINWLCfnusN4g/Vy2?=
 =?us-ascii?Q?JY3IlgBpp2K3zTU3qh6Cdw49Y9NncIQTGywrlAxbrV5zudteSwbkFhmqpIbx?=
 =?us-ascii?Q?LUM/VBZkw1KRzoM+sJCFoOLuGC0llwu8BAmqbaxhzuwT/X10YQeE/yBHd7xp?=
 =?us-ascii?Q?mvirbjhcl1GgMxvypymSQNtCAWxnLGtyoQUxbVeB7FBS0JNfxujGa2T57rzj?=
 =?us-ascii?Q?O/iNZ9grwiezo3+bociU+iT/wKQeC+/ekjoX1opqCQtC/Dlhr2dngKsVxAr+?=
 =?us-ascii?Q?Fhcqd6zWJLhbTQ8/EcWegogxeJdw69j3xefZgkb1Tq7xUXZiqeh7tua5ZpeI?=
 =?us-ascii?Q?1SfvvIxHvPLItpf9R9yk8AujH9uTxM8juzVMhuBVVofaA9oChqzmFmklv/as?=
 =?us-ascii?Q?MCsqe78TM5VYRAdy4FCuRiOgAw363quMKZJ8YyZrTeSotwzQmw1HyfruD4V+?=
 =?us-ascii?Q?OGUJH++LJWs3FqdkUmLD6CMh270Tn691/gIrQaqdqXuX3QdOF9gC/4Lr/Aov?=
 =?us-ascii?Q?Hf8iRQo17M4wl3l8lU/UMIq431nyCk59lqtUJoYMRXPhVTEBKbwiQN0HTmj2?=
 =?us-ascii?Q?xUpKZH3GyZii1UZx0rqbyys05q5NBYYU75vxww0dNpkp07mmAHrMWfjilbWt?=
 =?us-ascii?Q?L6SVCQHLVxOcXJ74gPssWfX+OrUEMm2WLBXO5KcmCQslI74SfefPvgCOwcTv?=
 =?us-ascii?Q?DVI0/HclbUHGDWG9Hq/poNENP2/b6YlIFVk5N4wT3IxO4OLTNqP8UO2hqc48?=
 =?us-ascii?Q?bBJiNSEH2JKEuKfbJvvYbqOhO93FFrcFGqCVbfh5AZmYXZ4n8RC8r0+3Dsjg?=
 =?us-ascii?Q?Tw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b53fe635-894f-4a92-595f-08da79da5f83
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 07:40:04.1602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AC2ya+Rda/SF68dFkCt2gXfsZ5sHxqghp5YVImLA+INumhJC0F9RCKrUoWbylzH+xjetnz+fouwySXEb5pBWJmY084KSqLpTQ+OsNrh7tqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4188
X-Proofpoint-ORIG-GUID: FopXDVyKzdTzUfIVHb0kil4DMoCeDLjw
X-Proofpoint-GUID: FopXDVyKzdTzUfIVHb0kil4DMoCeDLjw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-09_03,2022-08-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 impostorscore=0 mlxscore=0 spamscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=574 adultscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208090034
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

All verifier selftests pass in qemu for x86-64 with this series applied:
root@intel-x86-64:~# ./test_verifier
...
#664/p mov64 src == dst OK
#665/p mov64 src != dst OK
#666/u calls: ctx read at start of subprog OK
#666/p calls: ctx read at start of subprog OK
Summary: 932 PASSED, 0 SKIPPED, 0 FAILED

Jean-Philippe Brucker (1):
  selftests/bpf: Fix "dubious pointer arithmetic" test

John Fastabend (1):
  bpf: Verifer, adjust_scalar_min_max_vals to always call
    update_reg_bounds()

Maxim Mikityanskiy (1):
  selftests/bpf: add selftest part of "bpf: Fix the off-by-two error in
    range markings"

Stanislav Fomichev (1):
  selftests/bpf: Fix test_align verifier log patterns

 kernel/bpf/verifier.c                       |  1 +
 tools/testing/selftests/bpf/test_align.c    | 41 +++++++++++----------
 tools/testing/selftests/bpf/test_verifier.c | 32 ++++++++--------
 3 files changed, 38 insertions(+), 36 deletions(-)

-- 
2.37.1

