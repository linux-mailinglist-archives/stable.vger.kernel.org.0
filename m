Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8DF5009BA
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 11:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241729AbiDNJ3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 05:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241727AbiDNJ3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 05:29:03 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6790C52B18
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 02:26:38 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E8pF5G001147;
        Thu, 14 Apr 2022 09:26:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=PPS06212021;
 bh=7pGMOq2aZFGXYE6b+/SCRxMTyVANen/deKWPXQ3QnNU=;
 b=hlRYhMjKlq9HDu5183OOKkP45/VfP5QjhpVxvzadzhGUVGuePSEeZAD3ChVnutb61L9F
 6eyj+0xnuiNz/+Qr1Ez+8KwKsyOoU9stDlEQTjUWcWDEjIyUWTyyicSmQ6bX6EfPQlXz
 lc6bmG4J7U+GY6AGgjTOy6j+HPVsOA7Np4bbYFuNFz9IYPTgQ1ze4CD7CPNeSmBPLvuE
 BcpHDZ4adsHWxfzod1wEQQsd9TWDiS1/KZcIiyPjO7OYvQ4U6n6uFh+IptFrECwujSs6
 FoI0js8lrGJoW9F1Mvjlc/4SLLwfqrL7w/FxQYO0284fsfXIpBOSfBwYMNTe31LL/Jj/ Nw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb6fwbueh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 09:26:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKKTHRT9QiDRTnFo3oNZMD04hsGp8JvndqzgbMTnGqO1gVFN+lodBJEnVO9jQyH4DqDNVUNn6X4lFUZN+wXLY2dHEyl/g7g41zTYbJGCB+OiqY8bvsQgGdXBp/LaXjQmzwpizumAsPM/vrem8mOBzzZENyk4xPOkTuoFyNFxB9f+N0EOe8LTqURIVaeSlbVua4zpy37GBzufZzAFta8uXIALT6CJBrpchgafpma4CE0qEfUrjt+RT6Poeg0aI2ScatluixnXhoc4TXf2MwCe3QnFloJAKsZJ6S7i/FN4OJqHXyIZKxLnn89MUaB+9Mjs0n5o15HTKrk1vZzhJlnpCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7pGMOq2aZFGXYE6b+/SCRxMTyVANen/deKWPXQ3QnNU=;
 b=b+BbF+IDQIZqZkqF44xw8OtZzNMQHPKlq5BJ22/TQfbg6fsOk0Rwj6aMR8eEWU/vKZ1Ag4Ar0ph6YPRodS3eHhBUKTcc4GxobItdeFzSbSU4oyAuQrNsG03XMKaOP2i6M1CvAcfabVjXJLNvoe28JjBxGDFfhKzMzXS20GNOeT1+C+0s+H45mCh1rrgz4a4kWIQhelh7vna0gF9cyolIG690uMsQl/dvZhL0maMnnNZL9viF6/6rLMICc5f3N25rj8il4aBUUSC/Bjc5mQXMVBZdHJFFQjh+V6mXv53K34OtCf5uP+x7y2bi4wUU3K5ciPCNOudl957MGV3W5EgoAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CH0PR11MB5756.namprd11.prod.outlook.com (2603:10b6:610:104::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 09:26:23 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 09:26:23 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 4.14 0/3] cgroup: backports for CVE-2021-4197
Date:   Thu, 14 Apr 2022 12:24:18 +0300
Message-Id: <20220414092421.2730403-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VE1PR03CA0009.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::21) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f464de7d-fb7b-4fc7-5da0-08da1df8d785
X-MS-TrafficTypeDiagnostic: CH0PR11MB5756:EE_
X-Microsoft-Antispam-PRVS: <CH0PR11MB5756271C378AD480655CC6C3FEEF9@CH0PR11MB5756.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 87UIZ30EE/T14pVfggcgOvS7HrEjyVHV7jJr8zUbZbvcsuJ14RS2tG/t7TzCO4PtKjDg8sWdtywCHleiyrOmkM2GfHuiaRbrJqQQ37cEfm3WEUOOX9mksHqUqv1DezDzRZd2I6AsJSCoN39UB0lrRcHTRCfMiyCROi08BBi78GG/Vqxh4R4ctk8A6zSowyqREpRRd6TiGgLOLCH8lPtVGDY0xpygYzBHKnNxrammJlyRB9CsBE/4B/kIOBxUtdZIirMYyvQhWqJUv+RvhLXLCVD38CDwS64GPDAMg8c8Fmw8Ws4zMjVSDS9dbfnKcomefzsb/74evRWv5SVe9l8yyUXirBEIHvpLnYWQE0k+Z5G6GfjSy+41PvjVtzOAQlml3pXhZWd0clKvETpB8DuC8HP2v3daXzGRm0Fx3NyoxQBptinu+o7W6mEt5MYbvNCNaXcQoDP1YgpK92aR/R3R+EsgiCeGIK1r1egyqDiolkWY7+X5G3fNw3huG6FtyV0aPgVKOo/EXZ6ZdS3qZB5hkJzZ2J7gySV0/gbBZRmohBm9rCNO3C9PEJ+mkfaHfEpCxPxI64kOG6WZn2IuHr/Ar2q/oIUaKbXx0GXKhP09E/2sUL5RiwkEWdXOguhcoFTKHvr9Ueu2t8MjmjACBudQ5QI70xqgp0HQqmOhO+BGD1Dg40Z7vjdBMM2uY6J7IkoOAfMucA/koSnFwCAjn97o4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(8936002)(6666004)(38350700002)(38100700002)(52116002)(316002)(6916009)(508600001)(86362001)(66946007)(66476007)(8676002)(4326008)(66556008)(6506007)(6512007)(6486002)(186003)(1076003)(36756003)(26005)(83380400001)(2906002)(44832011)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clV2UU03KzI0elh4Wm9KaDBRWTlDdzV5UDdmY0dCcEI0VkFqU2lzczgyNFVl?=
 =?utf-8?B?WUpTMTIxelpXZHdtZTNiSWpuU0dydkdKUkU1VVVlTXhDQzk4M3ZjeU01ZWNu?=
 =?utf-8?B?M0ZURmZNWjgzTnFHTUdGMWFCdFZtNExDeU9jeHJUdW8zNWExZW5kb1BCczM0?=
 =?utf-8?B?Y21BSTBKbDhSUW5rekt5VSt2bHcydllDT08ya3JqelZmendkN0tlNHdGZUpw?=
 =?utf-8?B?c1BjUm5hODd2VllGQUlwbElpaURVb0c1WkR3bUZ2eERTVTV1NjlST2pBc0hT?=
 =?utf-8?B?bmNlcmNJblozdDZSTktsZHUwVTFhVmM2cWg3VVZROEljNHgwS05QZnhRSnRX?=
 =?utf-8?B?djB0UlQ3SFAxNHBJbG5RVXZ2QzhJZU9UamtNMEl1cmQ5aTFueUcvQzZabE8w?=
 =?utf-8?B?cU01SHBra3MzSUdMQVk3YmhnTWJRR3Q0VVRFYkVidnVucGxMdWlCTHRzS0ds?=
 =?utf-8?B?bXk3ZUV0NjF3V05VV1pNYkZDcVI1RFdHWkJOemRjamxnM1ZJZEhiL3BxWDNF?=
 =?utf-8?B?ajY2TVZacGJoVlBkSTV1Z21PZFF3YjVMUGVPWHA2NDhrUWVnZVl3STFOMHp6?=
 =?utf-8?B?emd5SDhtT0xlZE42UUs2OWNYZHBaQmRnMmRMU0k3cWJSQStXY3ZiV3BMQmty?=
 =?utf-8?B?Z0paUWhiWkMwZlFqQk9NM2RJUnZWbUZPYmdQY3RwQU1OR3VCY2c0Q09zNUpw?=
 =?utf-8?B?WDAvR2dIb1hqTzVPZi9VazlHdTRUcjdyWUs0cS9sTm9NeW5LV3ZJRnZrVlRS?=
 =?utf-8?B?dGtaWWcwK2hENWJYVTROQ3dwQWoxQ1AyNnFFRmZKZ3pPbDRCUHJlamZOSVdR?=
 =?utf-8?B?bE9KeWlDNDF6Vk0xUWNXbWlOV1c3RDhBcklNUEUyblNEZllpRWRGZitHelhC?=
 =?utf-8?B?VkYwNWU5Y25uakdaWVFOR3FDOEUzZWFkOUt2N0dVbmlqU25XN0xVNm9keHJh?=
 =?utf-8?B?RWEveWpQSHlldWZLa1lLVXR4TTFyRUlWdmw3M1psTXp3bTVoaHg0S0Z4ZW9W?=
 =?utf-8?B?NXMrYUkvMWU2RWtmR2JHYjBDZlFBZ3BNMEJwaCtCemJ0c0w3dnlETmY4aXZU?=
 =?utf-8?B?R3BHUTRVRDdpNkFtRzdSWittcDlKMU1pNG1sdks4WWhnV2lYekFGdmtZNlp4?=
 =?utf-8?B?c09pMUF5N0JxUWd1cGxYYnJ5eUZpbW5BWmRtODhOd0YvQUJJMlI0NjlGY2xQ?=
 =?utf-8?B?YkJGcmVQbmRxNVlySzYrblo3WXdDdzdXMFIvRUYyZDh6OW1yblZ4WEp4OHBY?=
 =?utf-8?B?TktlYkZKSWRnTWlCNXMxL2FZbkxKMzhxTlpkMzNObzF4UUVEeldRMUJCdjRr?=
 =?utf-8?B?Nlgwa1BESDh1Tm5BUUFHbllIVkpocmlFOXFRQ1JITnoyQ3JkRU01UWRDcTRy?=
 =?utf-8?B?ajFhQTU3L2ZHbVB5OW95Q0xVeEhqVFd1OFpJL3dUSnpNd2JOSXdPQlR6ZnJY?=
 =?utf-8?B?b2pLaGJBb0krZk10VVNuN3ZPVTV1WEZEbmJhR0FiWE1VbExLS2ZtUUZkTkJU?=
 =?utf-8?B?Vi9YL3BYUE1RV0dzVzl4dXlVMUNac3lsQUFlOHFVTlM2aFNmbWNxZGUyQ1NV?=
 =?utf-8?B?N29IdTA4MXBIeDZDMjFDcXpmU25YSkhoSERWRndjb2h4cVE4QzZlRlVtRm9H?=
 =?utf-8?B?US9mbGFmQzRnR0lNSDRWUnZYa0VERTZJT2hqa3NYYXpQdVFLMmhHUUFuempo?=
 =?utf-8?B?ZndkZTB3MGw0SEg5SUZvVjREQ3J5S3gvUDVIdkp0Y3M2M2tSKzI3OTB2R08x?=
 =?utf-8?B?UE0rQVUvRDNMYk1Ba29qRytxMU5Na1hWd0d6VDNNMFFSZG5Talk5a1psODR4?=
 =?utf-8?B?VUhHTjdRL1hZaTRIQ3lsSHVhcy9vMFF1MTlrN2d4YmlHUEtUL3hWd3RjbTBS?=
 =?utf-8?B?bDk0bmJ1L1hZeVZCN0M5RnB1TzhQNlRZcE5DWUZMTEhnRkdZcWtFUGxTTGJt?=
 =?utf-8?B?d3hTZFBwd1dFZENXRHhUclNOQ1puTm1oU2cxeVpvWmlsL3k1c1JHMktHeUVQ?=
 =?utf-8?B?ZFpKSHB3dVZDUlorUFkrZkd1RDk0bzFNbDRtUkFaVVkrYWxmMGJpeUVDeU9s?=
 =?utf-8?B?NnFuK0ZiVEtsN2JFWEVjUVpIK0lkWlV1V3p1dEZvNlU2ZjgzNzZ4Y01JMmVr?=
 =?utf-8?B?dFBPNjdaNG9MbFpxYjFtK21sbTlLdlhiRUpnWHpKVS9yaHRuTkkvNDFOWXJ6?=
 =?utf-8?B?enpvR1pNVHNUNjNielA1MGZoWkNUbUp3ck9qdGFucHFjcUIvdWJQMXRSMEtw?=
 =?utf-8?B?MVcraUJTZEtXV0pzVldCZDlqc2luV28wc0lzM1liUjRSUUUwRE1yQS9VNk9D?=
 =?utf-8?B?ZXVmamdpQkRYYldHeDZnN052c0U4Ly9NYWsxKzd5UlNLV01LWDQwY3FhS05O?=
 =?utf-8?Q?PYDIK3E9eHiMJidI=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f464de7d-fb7b-4fc7-5da0-08da1df8d785
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 09:26:23.2845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gXvgJQAb2HCjVbAmbrDbS2wlJqeYb3NIdJSqCd2C00e9EErCBPp69RRyC/NryjF7CtlySKVsZBibqntiHzLFXup/b5Qttp60Z3jrs18Gkn8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5756
X-Proofpoint-ORIG-GUID: 6tqoI67oec6IoKMYHHEfBNTnxObQnKcg
X-Proofpoint-GUID: 6tqoI67oec6IoKMYHHEfBNTnxObQnKcg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=468
 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 phishscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140052
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport summary
----------------
1756d7994ad8 ("cgroup: Use open-time credentials for process migraton perm checks")
	* Cherry pick from 4.19-stable, no modifications.

0d2b5955b362 ("cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv")
	* Cherry-pick from 4.19-stable, minor contextual adjustement.

e57457641613 ("cgroup: Use open-time cgroup namespace for process migration perm checks")
	* Cherry-pick from 4.19-stable, no modifications.

Testing
-------
There are no cgroup selftests in 4.14, but when running the ones from 4.19 on
the 4.14 kernel, all selftests pass:

root@intel-x86-64:~# ./test_core
ok 1 test_cgcore_internal_process_constraint
ok 2 test_cgcore_top_down_constraint_enable
ok 3 test_cgcore_top_down_constraint_disable
ok 4 test_cgcore_no_internal_process_constraint_on_threads
ok 5 test_cgcore_parent_becomes_threaded
ok 6 test_cgcore_invalid_domain
ok 7 test_cgcore_populated
ok 8 test_cgcore_lesser_euid_open
ok 9 test_cgcore_lesser_ns_open


Tejun Heo (3):
  cgroup: Use open-time credentials for process migraton perm checks
  cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv
  cgroup: Use open-time cgroup namespace for process migration perm
    checks

 kernel/cgroup/cgroup-internal.h | 19 ++++++++
 kernel/cgroup/cgroup-v1.c       | 33 ++++++++------
 kernel/cgroup/cgroup.c          | 81 +++++++++++++++++++++++----------
 3 files changed, 95 insertions(+), 38 deletions(-)

-- 
2.25.1

