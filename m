Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEB6633A08
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 11:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbiKVK0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 05:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbiKVK0A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 05:26:00 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACAE59845
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 02:23:25 -0800 (PST)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AMAMrJE012379;
        Tue, 22 Nov 2022 10:23:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=gTLzA3LXLQ9+I0yCh8nPLXFbUSLs6nTY/IZBWvnaQ28=;
 b=YnJMUmG14msDguPmlViOiWpJIpd95AAgEkirbcYcVkNJd3U6bPR40fKOxZPKMvopPonB
 JDfpv+QqwLrkFkFk8co0BMtHJeTww/3YnfIk5TmdPR8A2sokMBTjtdsXWy5DT8PPl9EQ
 kOOxFxTdYYJx1UUxnT8rhcM6Vmf21ouQN335NHhSL/1EYB6zN1FHyH0sVGMnVoFotrbm
 Xowuu7C7ChQEUIEZZgDQaa5qGjEERcB4LRyiowJEA5AhhgISm0uqohQiet7+uS1mBSaE
 5HL3Wc6e1g8nqawxhtosSOCMrJOQUbzhmAexYzlYsxjZ4gxfzR1YZu4NRKSWiQXdJd/n PA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kxp48je4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Nov 2022 10:23:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPgP3aZumSL/be1AXIQ8YkWXM4Wv3pUjCJrSY2XvlXZ/rhEbuBJkyNZ45Z4nWCteF5S9M3t9ReqULfzKQyGzhVxZpj/Bokf2lLj9K1vVKncEqRGpZ3HRClRjswlMSGSaJ9Gbf7l57ov2VUrLoSnq2hmhq1+XFcbJDnaRLKojxbkksG+9WnW2muinxhv2/+IXHRicszlxxJbfpECv1ZOvnXN4Ygu4QBmHWTxGRk8gwzdERfYad/ch6IgKCSv6jZQZRQkOwOf+yONFRVYSe/qxtg4F9UBpncFzz8WHrvmcVuZAIooWO4vPEdVLsOMg5Z3kXoYwtwE1K74HG0P+UKKg6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gTLzA3LXLQ9+I0yCh8nPLXFbUSLs6nTY/IZBWvnaQ28=;
 b=a9m7OqPCL6Y8YjfyrepkVh89NBV9kwQJPRG4DL8nTQX6leXatULj5CjHpzAnK8PfXb2SAYDrwGxRYvL+k/QMkhWvZ9ZAwwDWtSmVxnBo1foTGPXOibC8owDSgq/R5CLQayUhus96lMbTeWJ3VkaCy0am69Yy2Dv4wBTwQshruyvOuvV2LN4lqYQ9SD43USS5zsJBvi8xjBJ5NfBR859dMzG3CRKHZ9bZFR2shws6UOvTVzflUgIM+hFbVN/1XhHiFVxD6trpLY+sxDbF0yEo/alSyFPMk8bOdb4LpOyT5nx+43GmoF5ErG7nHNfPfhHK/t/lNWS5xfD/a2s1eeYiRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SA3PR11MB7464.namprd11.prod.outlook.com (2603:10b6:806:31b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 10:23:11 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::da82:93c2:307:df99%8]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 10:23:11 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 1/2] nvme: restrict management ioctls to admin
Date:   Tue, 22 Nov 2022 12:22:44 +0200
Message-Id: <20221122102245.3397604-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0005.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:800:d0::15) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|SA3PR11MB7464:EE_
X-MS-Office365-Filtering-Correlation-Id: 10d2e587-027e-4e2e-3c17-08dacc738e93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aIWvRRZ+L29FbUwxxvSwvB3SdfSTKwZFTXDkzXUqmLe/+LEEVDMkJTL2dye08Q2cGWW3O/pqbud/Huq9jUk0B60l1WmpnbwqLwWq4Tj28ujRb+qLHk7JDZGHTG2Sa6aGqyAoEXXVhHSJaq1Pm8Ih4jiszolOeCIYmUAY8kSLPfYHGOeXQQyNiu2NN1c1tVTpePbMAyz7Cp8DtpCf3PKBAUiyQZdvlU74WkQsS8Vrr0SG9h+STZaizE8z9O+4Nf4GWaHCJNDL0voBnH8HxiZe/JmtkmheiAgzF9u9OxVSty5+5EY7tSK2bCg+XgDAmIQPPIBt/fGC1eX6GBK1Y7DxOIbJWioFZWmFazJLZmHVHp8aFYq682KWR3pSFnmcc8hATlsa0dUgEX//BdiSl/mXbicNT3yRSJ88/MkQjZCg6ss9DNm4vlStK/n4u2hcpL1tGU5S0ujptLmRFJHFxe5rfDhP8iRyKGjnDNCdPEIOxX8hLqI7Eq9Z31Rh4opI2NukhWCkSdIqO84BEFEJ1WpYFmQF7kCIfKtFQW8QlhxClXn306FQQMaT3owFem5Ieifg/ZzGq71OJf8moyU2rVbJwJkaikAYR89bxC97/oyFCuCYyJawl2tLGT3W8ogTSI1bPv4BZK79wSOBD5ecztqZ9DkiYljanQDVEYkkMmr+ldbZxrymtLwMZXQ59GA3RQ2I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39850400004)(366004)(346002)(136003)(376002)(451199015)(2616005)(2906002)(1076003)(186003)(4326008)(478600001)(6666004)(66556008)(26005)(66946007)(6512007)(6506007)(5660300002)(316002)(66476007)(38100700002)(107886003)(8676002)(6916009)(36756003)(52116002)(8936002)(83380400001)(44832011)(6486002)(38350700002)(86362001)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zx9HNijoddG6BF+uyKG+bFpx3ITwF9sTN9IDF0CVtyDCul4n7qYIlNNamaiD?=
 =?us-ascii?Q?ncKV/JBnIWj8xSnYfm9fUQjW8B4CfYwuxP3JYqzy26/qcDSffYWffsuDf0Xq?=
 =?us-ascii?Q?auTf4t7Arc8k/q5YsYpsmYXfDvuALxNnwrF3beDRb9Tset6gvBqxqFXNzx+Y?=
 =?us-ascii?Q?bv4kvbXJLqL8O9wOd0TGNnXAnrTZoSpmTsPZSiISdQUe1J35B/4vi/1JnNtR?=
 =?us-ascii?Q?YNGdcPIioM4v7U9xPPW3RHNxYMz2pSDfJinuIuWF6aZoR/mtLY6F/3VckGOT?=
 =?us-ascii?Q?CCw2nE8U2/1lqMLjBRoGTEzZuXcO4RCYRaC7rHGYTnV2R+pr/0hEMeahZRSu?=
 =?us-ascii?Q?Oh8GWIaR1KaJuFtk7QO8Y3QqN+rry65XoHR/JP4hird+i7q7EkgN168k7+DK?=
 =?us-ascii?Q?RheQ2T43KroGeCk9sG6/SKMkBZA8fZEOtPfyqxFn1kWx5peHXAgeoEneLSYu?=
 =?us-ascii?Q?i+t8d9k9R8JxWWcMHG8OY3mal2+dch7uy5l2AvlGedap79rnCKtSbZBl0NMw?=
 =?us-ascii?Q?iQq8tD+hhSxcHhO1NPdTBjvhNT7iuqhCOu0hmagH6o0twCFebxPowunNva6h?=
 =?us-ascii?Q?WeRJjCljb7xtN2BkNHfD1VkO396C6yF1muMvRSFqr8hqSYKzCRBj93E5w53w?=
 =?us-ascii?Q?oP7/8zgSYFTF4s+n26EhlrISTTYpea3lw3TvxaivxjuRPZ7kdiw0IqBPL7Mj?=
 =?us-ascii?Q?T4hP7J93Kr0evHgW6Qa093GR4NwooKdwy06FsYHJf5f1Uu6fkJgyc2mTAc94?=
 =?us-ascii?Q?s6DuscVCJPTmWgHmiGQW4Q8ekgDP7h6KzfVdXBY2cEfHM9vwTOCpPjLWHFBA?=
 =?us-ascii?Q?mc1lo97kbVrNScx+lPlibbJsRKJ4HhJ4XiMSkESH9426TtVUuIV0nmLS+c7j?=
 =?us-ascii?Q?Np8CHNnpePK0jsm4bst+RlM/IsaKh96hDO8WRmPmNJAdYKtKAwGry8PD1x/2?=
 =?us-ascii?Q?JRMHuECLeSVeIESxJJvj7VdXVp1+LZtKep709cDfXd3L3G0XWaZmXGWTTYpn?=
 =?us-ascii?Q?X3GKZm/3b+Uh52DL+MxW+viaruyjIfjk/KQIFJKK1pcZwp1M24wvR5HA1Q/S?=
 =?us-ascii?Q?bnubZmpwW0f3nc/t49zQCqYDhL5eFyUCaZY4pJbGdx+6mK1GVaSkYW+aF8KR?=
 =?us-ascii?Q?gnZVyVaOOBnVzDIkV6uv9UDuiGN7UWjYKhIQDA1tsF1mqXKNiWM4mzRvQE1W?=
 =?us-ascii?Q?73+mCPT3Rs57EEh8XZgZj4L5cp/urD8srODPEUCi+iorgyrtNDrlK6SMV89L?=
 =?us-ascii?Q?cF0jX5y/mXYsyMZ3S8fXP4i/BGc+eatVZdGH0v2yBVdBAp8nNo213SsecZHe?=
 =?us-ascii?Q?sYt9qUXjQFIWLf8vajiQFQvaxYTEHBRUcbmSHFR2NizPjkq5fbeaq8qEk+Rx?=
 =?us-ascii?Q?81KSUIsgYyHvWZ9hQ5l5nGGbTpkVbSfGGh6XVqPqsMvflXLfD0wbAe8qp9mI?=
 =?us-ascii?Q?c3JVVyJpS1umj7D3qCltJiWLbd8kQDWpx5ershJgO2UgxILH9qa6lAI8x5Fw?=
 =?us-ascii?Q?rxG0a94w1V6Cm9mNc6/mzOlpNl06Th0sr/kzj2vEzQpm91OnX4RltqPXVT9J?=
 =?us-ascii?Q?ELKov0Dg7fCoyicqZMGGG+ErUEuVsT3VUPw3/1wQFAInNt+P+IPaTbkvHVl1?=
 =?us-ascii?Q?cw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d2e587-027e-4e2e-3c17-08dacc738e93
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 10:23:11.4960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cSB2FLZ6FWg4FKzEyL+PRUTf8cvqp0yiQS//LH66zMayPW6lxEjWWTAXCzAf9+AJGGsmAxWigYouvV29irbisQIxod/wCss8dC9DF1FWRR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7464
X-Proofpoint-GUID: c4lfGjgUuuOkom1c6RV0zkbS_nCzBM3m
X-Proofpoint-ORIG-GUID: c4lfGjgUuuOkom1c6RV0zkbS_nCzBM3m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_04,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 impostorscore=0 clxscore=1011
 priorityscore=1501 suspectscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220075
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

 drivers/nvme/host/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 3f106771d15b..d9c78fe85cb3 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3330,11 +3330,17 @@ static long nvme_dev_ioctl(struct file *file, unsigned int cmd,
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

