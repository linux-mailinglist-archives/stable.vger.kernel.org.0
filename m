Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25313633A5C
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 11:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiKVKo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 05:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbiKVKn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 05:43:59 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C99756D7F
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 02:39:26 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AM9gIxH023044;
        Tue, 22 Nov 2022 02:39:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=VpkDat/CIyteOGOFKflSnMT1MoKO68XU6gOQeAFeqNs=;
 b=a4x3RAKHXb4sezmAj5z/Hr0aNKt9w6q2PlizAvXMtWr3HMhns1JnsXFVHoIBjeA80BMf
 gV7vw8mkwVHRJeBoo3X6tU1rVuoLmXObAEHKCoM0w9bJj9tUgYievIxC48WsaRgzXNM9
 n3bOskRU5QK2rIHOEKw7YiGi2SgMv7GZb2umUccpi/actJv3NbF4F2+p9LtrjMcm9z/W
 inIpnQmh5ZklS+oMRTuidHOTtN1pmjOPv13MWnQrHyEz9DlpjQyQy059qXO+6J84aoKn
 uqmWhsqJ2agoBupwmgha7P48kDq35tN5jYdDsZf5ebMIfDsIgJuP+NG3Noi6Gf2z5kMQ CQ== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kxyhqa6vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 02:39:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hco/noWwrXMBOnniA+JiRefxUkNGnHP/8dJyUVJ1eLMG7Ae9/5NVKUtxyLORkEdYJ7hr0Xu7Ww/YK8VYZtBhetKWoYyWw2IwvHzgn6YzH8Z+V5L8xEI/j1LNWTiOPENeHmE4L+PTHmTHN/1EvCsmJjKnonDzQzMena+5aACkHCJ8FSaHF31ioKXcnMbYbgfEeYAjyYdnf3o1T/x1ZTVEWSNDW8F3zQlbia3Z9nvYVnjljSTva2ULF35z67VQClAYYmB7FLIq12YWkEbMupd84gx7OZnt8jysnuAHGKOv3SL48lfuizL2ccBgPRj7GQPRu38aP55h1HDjZi+Rv3+3uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VpkDat/CIyteOGOFKflSnMT1MoKO68XU6gOQeAFeqNs=;
 b=IPI1Li/YQ0ia+c5rKZTu3z81T5Mffbm1I4XfEDSZrHhCVxJ26SfA73nJpWG5mNOfsM2HzohqM/NBSJiIC4IKEkxaf8f/u76PaaVEsKZygFbfChIskZ4psoeiI3Xy2qpbdnpjMggTl4KmAw4K+hg3sbbiFMNANau9YlzzkaAMfGQeUjdKwz9b7bYpgIzflL/p1zdIefdKvJnNz9usoCEajrJK8ie1y7hFIbWiSc6dS4W6XbjVVi8OeusahOp0h56dVfgqKlhdWQ7ej5HUvnrUbTAY70dInFUORD8rBeXOzSMhfzFezQ/SEAcGrsZP6GYNC/hTQzngyyye+vk3+QuEyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SJ0PR11MB5167.namprd11.prod.outlook.com (2603:10b6:a03:2d9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 10:39:12 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99%8]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 10:39:12 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.15 1/2] nvme: restrict management ioctls to admin
Date:   Tue, 22 Nov 2022 12:37:53 +0200
Message-Id: <20221122103754.3501162-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0049.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:1bb::7) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|SJ0PR11MB5167:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e6ae5ec-4d34-4b39-5596-08dacc75cb3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yKfyshyvTuOUtE+FDzicC+tWY5DOMS29CwL7DRMQWpRWNRWzF97coIJoo1al8DKdqb/kc/KTZwFM1UNBe5kYbDlfWQUdQErb/zhhE6LWKHBCxzVrj/eChCM/HhRiHixk7FFUf/szuLmvzhSqBlC1432qiwVSSdGV2B2k2wOiEs7dPxxUlFLFYabA/A/R40vyilX2P2LvGG2VudyU0cDN/O0bPIkHIiSEs5Spmx92DL7fBu16IpTIjn41KrABugDpZWdq9d8497BAAT68Oz3JUFyfEkUoVIlREysoUgoE9KOaFm8M8ex0Bxf9lebPwvAD5fhyitpXlc+QcQTA0SuyPybaD6gzvmt1uobUWD1uZVPmAsaTofo23aAC5UQF2320KPQeonQYf1dQQPlgTqGvnNKcFXXEhqx2QxBqStK/0vA05ZsUXt+aLmVt3dvJH2qQAl01nPdhRoRTGUVW6Ydd4rQiE6pGfVXSRzsqh/njaiUXguhKa2EYc3VYJwIPplaKdixwg9OcM3uVwbo/Nmy9X2N50niqfpXoy7f1kpL9cNN0uK672JCJJ82x4l1D5x7sVTIH5vW/RyM8M4ZLgBEK3LJ04XkePMqhQuxavODLpKPyKChDhsAjFIQ1fSCHyGmSuEgGwyfuovyjaeFVdmmpPA7jV4ufAY8F5NpYutxI3j9Au2gUsR7F8RqKTbJouhSK97GavguCiA66MpA05RMDjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39850400004)(366004)(376002)(396003)(346002)(451199015)(2906002)(1076003)(2616005)(66946007)(41300700001)(36756003)(86362001)(66556008)(4326008)(6506007)(6916009)(54906003)(83380400001)(38100700002)(38350700002)(8936002)(6486002)(107886003)(8676002)(52116002)(186003)(66476007)(5660300002)(6512007)(478600001)(44832011)(316002)(6666004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F7wMAC0g4qbx+4aj7TvzRDYsYBRsDkehxRt6LGGzMRacKWe4CxHNKDsoVCiG?=
 =?us-ascii?Q?YgfrlJuBJcLYiC0SQ2uCf4nDdU8KM+WjErntD9X2PYezbLHTyoECb+y8INU0?=
 =?us-ascii?Q?VH/oJJZeCZzdqhc+BsK0MZj5VWLm9lnirTjp/bxE5ZWv636WDpJIeXjjNe5N?=
 =?us-ascii?Q?5BnLn5IE5ddKJLOrHUpRM2uoD1iSTryYbSBdr1ySMhi+5QXoD0BocZJXH1X8?=
 =?us-ascii?Q?aFg/cyfylCrV+V/CMHBjjO0ThaS+vuOoO4yYX1uKYCuf0cLcoosQ/sE3z4xP?=
 =?us-ascii?Q?HToIqXpUcD3I8IQ28+vODPO0HjgkewWDg2wIMg6QcW7WDwZPqTxm0mD5iUE7?=
 =?us-ascii?Q?17j7o4IlujlHy+ns0on5LmJasrplRO2J2gu+FSfNeHeKndhBIdJpKTQ+l39A?=
 =?us-ascii?Q?QSOlR4ltjYjJF/1elL5/Z/kRVr+HMqK66UAXTtip+mQOlHahsd7iGIq8becN?=
 =?us-ascii?Q?TMimnrgxW+P8VZc3Xb2OAG/ygx6EuDvdNn5enfOxnoJrmCLXmnx/r8x3zy9B?=
 =?us-ascii?Q?tvkA/Cvw/Op4O9aP2kGMkFU7/SW2Q4v1vc672/3J8wEm4E7nE0q7emhF/p7D?=
 =?us-ascii?Q?pA0KpMQ5f6IEOnJsXpDT+OqMSH0eEg/32Fe+qlnyKbZLxBwRMOu3Gjr26nzX?=
 =?us-ascii?Q?qwiHegd70MLfG0AEMuBxnbtc6V7eDH+muTh0O/U/arN+P+/ugCLExoAsYbkp?=
 =?us-ascii?Q?NsKJ2DBqfiCRRV/tHsiZruu6a2xcdlrMB0HDHFsaWhe7G3IKgeOA6HUUcEbZ?=
 =?us-ascii?Q?nj3stmbjMg8L8LrtM1lzgPhNT6nHmWi1BgnL/4JfawR+2mZrVmG2nRdkbiV7?=
 =?us-ascii?Q?0qFYSYF8Y3PPALKYE2UN372qOv1ZUFeq5LBBpRPKy3GCuyx7LCQzB3j42s0T?=
 =?us-ascii?Q?iSHX3+FXFcxAe8IpA7uaUbK6q3yF6liwiM5LjXea8FmddN4mxzZ4rvwxfiQM?=
 =?us-ascii?Q?nMHk6UlbYXULXs/zYG3hPD7EbttTdNPHl5Lxg3laJPe0+kH4K8eS/b9jGcQI?=
 =?us-ascii?Q?cTriRPjQzzr/ta+13Z0d1d9DjBuZH8sdnxbey0QPT6ZGSzTv7RIbdluzHQuI?=
 =?us-ascii?Q?AayadGR57s5EJUrEX8ARFHfJlwMcej+k9ZOu11e64M4RmS8qbCEnVJ5W+21y?=
 =?us-ascii?Q?WAiSf7Kn8OQIPObL8hFo0ga0HIcG6djUSySpfNf/wm8lPJfYSaCuG0aRy78X?=
 =?us-ascii?Q?3PsprzQx011KLf+cnMlcEqm0qoz6+Jx3Bjemaupj/r3mIslek6GRIQdfEAri?=
 =?us-ascii?Q?uEPndaPlChadSUU7+f4h8NTm5g/jmPBo15XW8/ArIpWOpJF1lE9Gy1FtUWt6?=
 =?us-ascii?Q?2wGEz7l3/z6E+Xsr0HpIWNDtJ6hAyybmHuBeVOEthIRBbPbrshs+l84zq6SH?=
 =?us-ascii?Q?nJzTbFVTrve9Ujymi1bKxTh6Mkm1oNVgwBcGZOKmv4r1yj4arG2ufs6x7p9d?=
 =?us-ascii?Q?Q+J3qMYlwGJ/SIlHK2NkYOdv9WH3NF0pd/ySw8ed2ciHvmXLl0H8RqaAFlZw?=
 =?us-ascii?Q?tUjmgt68AB4kOHS5exzaQ3OwySFOYBq03oiqT75Q0P3KhSyx/cnqjCobgkw5?=
 =?us-ascii?Q?ZbIV9/jHr1Hlayo9GRXp6JNsidcrAfofIm2hiYXF+XSii0JQ3ZdEBCEPCkq/?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e6ae5ec-4d34-4b39-5596-08dacc75cb3c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 10:39:12.2127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i1nywn1OVD0r6HBJ63pC/oBBt10qyGR7LmFlkNJG+8LR5b69I+PlPAED6w6LNgdmny7cILoeEkydGIPW6lcMvVewJhabvqWq3Ax1CcqgKM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5167
X-Proofpoint-ORIG-GUID: R_tlk3PlioNKZB981uItmCxz3RvF07rl
X-Proofpoint-GUID: R_tlk3PlioNKZB981uItmCxz3RvF07rl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220077
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

commit 23e085b2dead13b51fe86d27069895b740f749c0 upstream.

The passthrough commands already have this restriction, but the other
operations do not. Require the same capabilities for all users as all of
these operations, which include resets and rescans, can be disruptive.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
These backports are for CVE-2022-3169.

 drivers/nvme/host/ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 22314962842d..7397fad4c96f 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -484,11 +484,17 @@ long nvme_dev_ioctl(struct file *file, unsigned int cmd,
 	case NVME_IOCTL_IO_CMD:
 		return nvme_dev_user_cmd(ctrl, argp);
 	case NVME_IOCTL_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		dev_warn(ctrl->device, "resetting controller\n");
 		return nvme_reset_ctrl_sync(ctrl);
 	case NVME_IOCTL_SUBSYS_RESET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		return nvme_reset_subsystem(ctrl);
 	case NVME_IOCTL_RESCAN:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		nvme_queue_scan(ctrl);
 		return 0;
 	default:
-- 
2.38.1

