Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C3F588EEB
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 16:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbiHCOue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 10:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235945AbiHCOub (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 10:50:31 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C556567
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 07:50:25 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273BxHKH029871
        for <stable@vger.kernel.org>; Wed, 3 Aug 2022 14:50:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=/81a+iqZ28bzvGr3Eval4ouAMCtsrFmnmomCciaXewM=;
 b=V+o78MxLWmQspROheXs9pHGa3d+w5J9gTi/68HQdSFhzlKj64qyZqnNV3AuR0It+jjY3
 wadfurqYh0R0fnhBvKZHPXcmQtzCX5r6sCnMmnuNL0NRU6bcMY17c/G4B27TbnvFUUPG
 ZLVTCnIukkEeB6ZhCdo3TIdNeDarRT+EJ/ImBTBlfZiyO4g0NVL90d8vaKoSx2v5SQuj
 ICVd2NuiOOl1P1R/kc8wcqHytpCEEEYyFi/N8PReq5zHYKtXbojs+9DgPK6tRGgQABXn
 qxeb9V+OYx0cdKZvZy2ZxYRsoPKmoCs4H+/bsyXe+cr5aInw/0sxg50GjACiTaiDXw7q cQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hmsv23cm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 14:50:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHAvQs1FS38Dcpy/DYUL7ze+/BVhIXldFnbktDBpQgOAeq0eXSTGZJhSz6BdaqgbdzvfW7bfbjWL2PMLPwJ8gTiIAr2A9HP7yzDs0ETp0dJ41I8+UKDJTYiW9jd4PsPqj/se4CwUATHN8DfgqgUPsI6MJEBYP7CRsHolhD+CjscLZ01kIMz3TTHUbZJ1mezrHFE6rpiZr+SYMOmaMC5y/110PHg7ezE4RFyBnQrEKcX6ritRlKyJuluei+unRnBok5aGchU0UJWCXVljTTvMagBg1De+wAg6ySvVVgKxgyLxoyifnm6PJioi0LsuzIuc7dVIU5CH5Ib5yaSP3JD9rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/81a+iqZ28bzvGr3Eval4ouAMCtsrFmnmomCciaXewM=;
 b=NcQUK4f82bJH66zLW+EGe9lg0MnQ7FXEV0m+qDRypPPxYWAUpz9PRiMrU6jDH1lAW3pOaQwkwuqZAN7ibXZqTgOuO7wfIwuVftOe4N+QCTFUBS8t9ktVdpe3fn+T+MZG6asdhhAnuP+KrBE8VNxKrF1bJ5cGRvCDOxkTR6rsMXkde8FCb794Z5L8/vSE6NL8sEDA8wbDQkftg8eNC23CK3LP2Z6P2YrVWs+m+kL6lV1e5bNeylLO/Zfpm2M6i6q20o26GBMKiAI2P1aY4W2PRr9cT3cXWZB5O5oYJWMY1YdriLeeunZKAUB+/WWqVuZX8jP/LjhNjL+z6uEZTvz0Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BN6PR11MB4067.namprd11.prod.outlook.com (2603:10b6:405:7e::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Wed, 3 Aug
 2022 14:50:21 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5482.016; Wed, 3 Aug 2022
 14:50:20 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 0/5] bpf: fix CVE-2021-4159
Date:   Wed,  3 Aug 2022 17:50:00 +0300
Message-Id: <20220803145005.2385039-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0250.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::23) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be427632-492a-4d5f-fa0a-08da755f7ce4
X-MS-TrafficTypeDiagnostic: BN6PR11MB4067:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kQ+6ITMDMTyo7nM76P3krZ3VxAXlToPHeg7F85Hi78VIm4YCyN15Z93s3hwSWHTuOTCVLEyGl8gpfa7GzBQa7b7esQyEA2WEOibT9/xlJTyJTygrL24sIHeuhh0Kk3s2AkbFcTmwXlZJBNHerG8kdA6ye7yzU2P6batrkeSjfhbmy9gvERO7lpScQH4Mjw4ezIl5lVv1EmuO2XESrMuD5DwRHR9Pfu01tOHtPikt/DnsobYYhwzMXl1VnkZfaC1iPq/NKS9pQqtpV81zt9Cj1sj/Oc/NCsEJTRmCYavPLyvvDvnj8jjBeLr5qDbTUzYh7r63xIu1UD2gwce7UYq2HWoQQhGtn3z4QBAJ7I3wYIUVKLs06T2y4zNLGJGBmWQ+rYB8tLbBxd25SerLrdMSN1dDPNV/dWNIO85bjXEBlkqIgQnP88pPaddNBYUYNcN9ppcXTTh8Xyfvwh5jec8NqdsjjRglSxax20wqOlblASZYZX5LGfRcdLjlLrNvTsU0qiXXDHqsXhi/jHqFNlsXIm3eUbr+2V9oEG/BLgtbz9ASvwh5cEa4vrkxwMN0oapXMu5L3w1Sm5THLDZjWsvOahxh7EOsuX06n7S8YFIcMlr57z/nzxXASH8hkGF/r7NzFsjEbFWZILXPYJHjIKDr0k6xz4yPCC2P44+ir5XQK0pWfb9rVl8+RS8Yv23D0kjRPDrl1NWRPO03+0deL4+AbyezSznjLyQT2+KEDyeU+IIVGF8RfeTB/rqzCW7tjk7NAEP/5GMQzEVML8LHNpHoQVJBcBSaC946t/XlVrNXJuk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39850400004)(376002)(396003)(366004)(38100700002)(44832011)(66946007)(38350700002)(6512007)(26005)(6486002)(6506007)(52116002)(6666004)(41300700001)(478600001)(66476007)(66556008)(5660300002)(4326008)(8676002)(2906002)(86362001)(8936002)(83380400001)(36756003)(316002)(6916009)(1076003)(107886003)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vz29rUlpKGDoODTd8Xyo4u1PXe7F4Tlh9oD8ZCAL7RGofsuCj+rIX3xFKaHX?=
 =?us-ascii?Q?04z3PfiG0Ubiu5TxYDvWPagZvBwShoUL4ax1rEmWVUkJ3TLlIrZrfVjoF8YE?=
 =?us-ascii?Q?yIwHVd9EtBhud0+EJbKPseu/l4jNEJTo9uH8qkNy0wDMWFzzb3x0oN6w85lj?=
 =?us-ascii?Q?ehyrSwOW5KMoaagrhLxcGJ4gx7PpR97RtSeh3LCdnX/S+UaKFWlGL/GnyR8K?=
 =?us-ascii?Q?OrF2ZSSrFxFMLTS/LWw8p4FMnwFOFciDdFjIoQoWzpOq8gA8bFMlzWOKHnMZ?=
 =?us-ascii?Q?lj27MXS8rV6LBFiGhHg9yaUXvoUoUwpr8Vk4eCWrQHZo6Zn5zHuFhroB179h?=
 =?us-ascii?Q?FBzSVRZqqetB4MEjt4t1CPbdooQrEgRvDEWOVQz6dTPDJr615xz+U3txzyo9?=
 =?us-ascii?Q?0G9tVrDTHCl9uUrMnXRAF5lgY6sQy9SPqH/+fg8Nfyu2plonHAWvHb/kMjq8?=
 =?us-ascii?Q?qx7aErCEjub4SuH4bxmyyiXFgyh7nz9M1QrjxvLCFdnR+cFJh8EM2odYbgtO?=
 =?us-ascii?Q?gWGPePWSDymPCooYHEimW0WROOlXNI996hoscAOsE6PeS8Zkq/j4g/iOueCN?=
 =?us-ascii?Q?YIqVRr+Q4csgjBL2elC7c3LZv4qQIlZOQI7je6CgBFQejhO9LmXlR38JEpot?=
 =?us-ascii?Q?MnTMHInXN0NLaYKdZqySeLobTTIFLL/PVgbFnRojdkqNWOmxrJjfwOsdEx/t?=
 =?us-ascii?Q?jUVCuoAi8Rh0veBZQDhvGCz5+QHryyaNk5sktz+0y8CXgitAQrMBa+w0s3OM?=
 =?us-ascii?Q?qYJXTIvKNllZzv5FkqeXoLW8NdPhMsoNZIZ2Vxx3CwrbefZDYBwGlruN3qOO?=
 =?us-ascii?Q?DBFZ5g/cAHEr4et1HzKQqKykzwXHFetPsKeBYq6i3PKMfS2cEghhuXdbIflN?=
 =?us-ascii?Q?VCN53NOcAX3fx8VJuEf5obtXi/mOtwCoMFZPOni9NYO/tEWjjTzVBmRhYgT+?=
 =?us-ascii?Q?1GLKGdK7iZYiktcOVSvatxVlq18cznKccIIv13jArpn78gJ04fVOVlBpCUqb?=
 =?us-ascii?Q?dlOkD3dwb4qnDYIdFBrM87Y+E1RMWOqh5faEmqEXBeHOrQwOEqPT2XyoqbQO?=
 =?us-ascii?Q?IB2lbbBSVIDXp5lz6kzw6cE0H1Wx7ysBE/W/lbAa0XmLJMBtIPbPfKN6N3ex?=
 =?us-ascii?Q?CF94qzJjLqjFx7S9u5onAn+GK3sHInLWWCsp6Rgtrk/Ey91CY1DM5XFJysai?=
 =?us-ascii?Q?LUq49jEaT/dXXwUuebn8ys4VWPiXlAcD27e71ht3W8bmJSjdefI++0kTpGtQ?=
 =?us-ascii?Q?Q8qnBMItuswVWox/a9B/Kc1AYFW8WQNy8LcUjeJ/WGCxHxWUosIMAfGpq6V7?=
 =?us-ascii?Q?dxBDJ8CvuBa5JMGdKUijvyvbJIj0ht7qj9pFPnB+MqhQRhMubmWznuz+pluh?=
 =?us-ascii?Q?UVBHfJdXIKRCYXbhqedYsyzj3CDnLwGSwGZqt/CG7tcQ54vG3oLPmTgZBSZ2?=
 =?us-ascii?Q?d8s21h/XGjMvdpbzgoHZuFQGfWzjY2JltY6Mnr+LodgeKOf9DPD2tk6QdLzM?=
 =?us-ascii?Q?iCdqGDfd6TlFzJsUmuPtGwlTOA0BHXXKzuULmyAR4MUoxhkmgzH4DB9tiiTE?=
 =?us-ascii?Q?b2+aHDDwORpTPrhvTZDy+OjBdIebTCUMKL3Lv/juh6ISwHYo6S3pYu9HXelZ?=
 =?us-ascii?Q?fw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be427632-492a-4d5f-fa0a-08da755f7ce4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 14:50:20.7507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /amPKhLZYPihQc3+JsgAzIiwTownK4/65pUaWbSIDZfelrTSbIm9yu7N+yVLySwmNhB+C/F2iUpzbFdhPu2aq0Aze22cHHlv5VHD+J/Ltds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4067
X-Proofpoint-GUID: zMA-FcwSldY4CaRX2mC7-CH6uqoAU60r
X-Proofpoint-ORIG-GUID: zMA-FcwSldY4CaRX2mC7-CH6uqoAU60r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 clxscore=1015 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 mlxlogscore=681 impostorscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030066
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

All verifier selftests pass in qemu for x86-64 with this series applied:
root@intel-x86-64:~# ./test_verifier
...
#1093/p XDP pkt read, pkt_data <= pkt_meta', good access OK
#1094/p XDP pkt read, pkt_data <= pkt_meta', corner case -1, bad access OK
#1095/p XDP pkt read, pkt_data <= pkt_meta', bad access 2 OK
#1096/p XDP pkt read, pkt_data <= pkt_meta', corner case, good access OK
#1097/p XDP pkt read, pkt_data <= pkt_meta', corner case +1, good access OK
Summary: 1611 PASSED, 0 SKIPPED, 0 FAILED


Jakub Sitnicki (1):
  selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads

Jean-Philippe Brucker (1):
  selftests/bpf: Fix "dubious pointer arithmetic" test

John Fastabend (2):
  bpf: Verifer, adjust_scalar_min_max_vals to always call
    update_reg_bounds()
  bpf: Test_verifier, #70 error message updates for 32-bit right shift

Stanislav Fomichev (1):
  selftests/bpf: Fix test_align verifier log patterns

 kernel/bpf/verifier.c                         |  1 +
 tools/include/uapi/linux/bpf.h                |  3 +-
 tools/testing/selftests/bpf/test_align.c      | 41 +++++-----
 tools/testing/selftests/bpf/verifier/bounds.c |  6 +-
 tools/testing/selftests/bpf/verifier/sock.c   | 81 ++++++++++++++++++-
 5 files changed, 104 insertions(+), 28 deletions(-)

-- 
2.36.1

