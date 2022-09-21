Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002685BF9F1
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 10:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiIUI7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 04:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiIUI7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 04:59:17 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01D47C1C4
        for <stable@vger.kernel.org>; Wed, 21 Sep 2022 01:59:14 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28L8Y1Dd027937;
        Wed, 21 Sep 2022 01:59:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=2XOG/T14e9EA0K9BUCR0/wlJrVzOO/+iJQboNE8wntE=;
 b=oVHCXs6RVMEtQTe6FYVa0c7jQ7u5/swLSd9BG9CWDBP4AZrJl6pfQPEGgto7lD7DIDAS
 JSn8HoGLsC8QdD+BpMfjHg5TxjHNhHzM4tzVlwmWYfQQtWlwAtiBO5vUUEUWgunS3z5q
 jNy1m9MOdjasK8oRPE2QEit4vYVaCtLkpC/EWBmSY/lkfs0Z420ZuuDKaojrWF7660q3
 Kv7M6RURa59SKrawFSzQDS/0lgeJ6nQwFwqXLhnO+h0EP3Kp+dYZ6eLaffkP8BtfkuvP
 qdcH3jTWKTX7RNNKU1HkE5jhkloZSyZfLuu8OA2o/RKFTI9TMFGhvRhw3U8ejQiNY6iu EQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3jn9h3u5kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Sep 2022 01:59:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VYWmWB9lGAz2WMMy3XipuMHt4djG4Lhnkp/Y+5Cf6e01s9vBkT4KhsRACA/KDexN8/6vU8cuquruJpRTw1d2BtHlkW7yc38EC6IG2Q9FBUdvhUtlc0ZGwa+pZlJyWWjYatLonZW8LzU62fy4D0swH+sPJn96Cu6vdsVavU+hsiDau+Z8h0glP/AEzWgFARzupksNyMp5rm1sCC3v7M8o+C2ei/4LMSwlAg5LezBUFQpUVacuNU9pGaTXDpEAfLRsXSxzlGK+6ultMVot/EDLJq/zV1kQGm1uA5lCbdvQDXRmbUHNhYiz4RHs4P/XlkkPj4az9/iwBpQgnk+mAXRdgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2XOG/T14e9EA0K9BUCR0/wlJrVzOO/+iJQboNE8wntE=;
 b=Oz43sQeIB2zB1+6WAqRNe3iGIZG8GZAvYv81p3tcfo8VR2G2HfQfvJ+uf3eLb3Eosn07E5i7RRTorUsm96SaZwYdsxDiyng+pnnTk4K4MdFNNvaxuDqm4NeQ7POWcFHwGt7IfoY2OsOmCcJ+c/wGAPVlB4Ik3U0/mQmkiCQJRDdwxRmgt554oHEtnDN+4l5Mb+G8HxCXZ7iPH6mti1ltuRDFGpYTG+OCjPMl2JG4iGeIY3KHTVfKe84+ydjkSOSCLg1pM2jHgQCfH+PL77DSZRJTjjLMtR6OH2H9+6nRSOaUY90gsvPxutOnGofWER+hETSSXXKzMOwWY/hwsahdQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5518.namprd11.prod.outlook.com (2603:10b6:5:39a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Wed, 21 Sep
 2022 08:59:07 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::d083:f4c9:aa7e:712a]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::d083:f4c9:aa7e:712a%3]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 08:59:07 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Mingwei Zhang <mizhang@google.com>,
        Sean Christpherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.15 1/1] KVM: SEV: add cache flush to solve SEV cache incoherency issues
Date:   Wed, 21 Sep 2022 11:58:51 +0300
Message-Id: <20220921085851.2097270-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0104.eurprd08.prod.outlook.com
 (2603:10a6:800:d3::30) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|DM4PR11MB5518:EE_
X-MS-Office365-Filtering-Correlation-Id: d3cb30a4-5e87-4d38-0686-08da9baf8aad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kZuQGUDi2i9oKQWGxil1MFJkNnm78XesjyU7dJ9qRELbKsGJ7VlZKLWftro4IXQDo2skvdUq7Fnp2YdhGQTV95uW4j8Z00mDfVB92pz1eXQZOvVSQarkmtCUWfOlly9MSJOUs9wUa0pprpHHhRyLNqOvh8XznXuCrk4n0w7/93Y8AK6BMywvflUfp+xKdkEvKygnRtU0bGoNf89a6tl7WA5bKVc4k6ODbtQma+l7C+p50y30ReFLoKGopPUjRRtz0lKYIbKQMsESikJkuGZrBRrkWa7xIQT1OS8YLc2I19miSSpuB6jLBtN5gdGa4Ik01o0XjyBRrREDAFgs4UnDGwQOC45HW595cOqU5yXXwReyzQONdQMm57iGbFekg26gX7ksDA1Q8JKau/+inOq5tA4jW/ZDm7ED1FeTQCnC6+VDmuN/X0HRF8RsjV1R5CHk7ZE7GIiKqzjlOON3kvWE9BiQxnOYsC4KTywxOL90vtf1CFj1rTgwC64/9UiHs8DUdBGBpLVIk8yM1soRrtI2gEOXUrOWDtrc7jOJAbXFE4G8BHdkpxNgzHqIPeLYHwnGKD/JCYEhnLjR9erWitG2DN1LFMJUcpvgy+G7+ujCmxUpsuvDkfDl+Gq+nXdithDsHzvtix227y3j89Jgc9E98aCoasBrIvTnC06l2I81hblki9R7WYXIKMqyfb+9rX7YcQUW+GwYFrPlZsiAcr5Dn4sJT0CrV3Km2eNTmZWclIs/e92lcEnZmx1N+fvMEViKGMU4qk5R0a1Yidwy8Zz7GA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(346002)(39850400004)(396003)(136003)(451199015)(38100700002)(107886003)(52116002)(2906002)(1076003)(186003)(6512007)(6506007)(86362001)(54906003)(2616005)(26005)(6486002)(6916009)(316002)(8676002)(4326008)(41300700001)(66946007)(66556008)(66476007)(6666004)(478600001)(36756003)(8936002)(5660300002)(38350700002)(83380400001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hcwt0fEy1UALWZAC++ghWUXWMkr4dPki1X/fZrgnibn5eNBafIPpZKFh4UMy?=
 =?us-ascii?Q?JTd++kthNtIHQccdegz0lnJii00ylbQIU/9uBu2b+wZqZt3WuXuaNtNPS6iA?=
 =?us-ascii?Q?eYGiF0XSHuNaFwke202gyOG5N5CN+1ZlGnJsazvoDzxyzdQ5vHsWIXK+3ZTY?=
 =?us-ascii?Q?/JNSqwMxwsyopioZgH3ygJ5hcB0rlKpVPg2Oj6BRjDk0mN1JzPKPhGHyQaEU?=
 =?us-ascii?Q?c6WwJMf0qlVkvEWuwddZ1RxaYx7dEa9RDj09aTAbQxUhs36LpVwo6OBe74fU?=
 =?us-ascii?Q?V3q+RNu+mkNs7pYlIVDPmuGyCXVhXgk2RwoVibCJqELxdr9ieXL2bPTYOfAJ?=
 =?us-ascii?Q?36H40sHD/3bChMxUMNn+qcAhTMCnjwxkLHWWHWmxyr/Iyi2n4e2AoKZ1j10j?=
 =?us-ascii?Q?HJDGJSu1/KByJnFJQQVDbtRvPFLeFIYG1qDKBFFpvPnKA28Ajxd1JBuWSJuV?=
 =?us-ascii?Q?a57k6NaaKGaHiZTbIeES2iXcF0beiN3Iqh0xgfv9P1o8Aa4Z64NpNExvSq2t?=
 =?us-ascii?Q?gZPNSFyGiRdoF3ofYG38aldDgO9LkM8XBA5q3WxvN3IS0/1w4voTqrEWhG5y?=
 =?us-ascii?Q?FhiZxbmOfxkv62fFgS6cbZkhaZmchk3OuvF4R3KTrIXGkRU0WmhEDN0Qm5Ih?=
 =?us-ascii?Q?JXGL7xqmmcvK3zHtGNu9vCGh8ttUkiSf17BsKShbyHzn0skT9EJ2z7kcpUE9?=
 =?us-ascii?Q?0oVStCrGXMQd7qbx4PhAC87ImgAt9z0EOVEFR+BVzqwl7wCfpg1gWc3BWlBP?=
 =?us-ascii?Q?Hy0AbMxj3NZn4peVIbj9QyP83pCSTH5GZv6bFYg6NNQuzUuUiA3vBdFkLD+M?=
 =?us-ascii?Q?ZU4cNyvPw0toD7d954uUNFCaYRuoc5qrcDW5/tdkLfIFZEzxhqCdv+B41F8a?=
 =?us-ascii?Q?pLAaV1Bjqd1amwFqe7+lB/+sY1HSEG3vroppbbB9sB70OHS/n+8SpE4LDqyx?=
 =?us-ascii?Q?d5VqlaFieX8BnHi+T8XJjqMoWADpiYQs77RvUuo9EoxJCgmByDJA6s8SKYJ6?=
 =?us-ascii?Q?aLHfUrqepUyhZu9xdR8dc82GnyoaRHfMRneF13tdAUrdFk9UeS0e6fcyeC/F?=
 =?us-ascii?Q?DlxoRRIGj1ldPcC7P0eX31/kr97Qcr8bnfu7e5BaEg33sd/d9CGAfM1OBPF5?=
 =?us-ascii?Q?e1fyHj25xrUm3ylVScmymdo4sMn4K8lbuUrFMgeB4cVHG7uk9RdPeKb5Oprh?=
 =?us-ascii?Q?b5nVvMn4sumW6nYNZ+Jeo3Tv6t4laPYZaxaoSn9UCmCk1cPb1W1/5989uUKZ?=
 =?us-ascii?Q?Yz6t9N6FgajsLpFtyE4SX0XvAqVLg0vSw0BFlY8u6CFdtC1RRglsZUpgx5zW?=
 =?us-ascii?Q?TJz5H8BKEJp3XDKYS7375EISgcP2UKUydP+OBaH4XccmJJoxVB5tGKHcJ0zL?=
 =?us-ascii?Q?nRKxo+dQ/zE0caB/9Fjbb2XbwvS6NKGal+uJOOXqD//D906DxHRD//JzyQto?=
 =?us-ascii?Q?JGeGfDSNdpuHAXqIJpZbHOi9LLM0x1E4qfbEmm9M3MdUbipv6eQREp56xPi8?=
 =?us-ascii?Q?KtdXuaM6xsONKEXVciCJPYa4GsLY3PvA28jdSIueIA8Tys/qhfElDkLdTUY4?=
 =?us-ascii?Q?JWdrwaCsczoazUrK8hZ0udMFkvilCvyHbo1Jw4s5w6Ngzzpc1IFpKCxKrZI4?=
 =?us-ascii?Q?Zg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3cb30a4-5e87-4d38-0686-08da9baf8aad
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 08:59:07.7492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kIODdQJdroSQNMwCrpcqcZoBYoR1W98TuZZ8ORGKdxyPGyQqcS0bdamp2+k7/47C4S5o4BmJI0+kZ4X5Wu4z6V1oQJdKb0t/De6nGcVeFYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5518
X-Proofpoint-GUID: 0h9W-GBi30ezrX8dfvaMSaja2JrgnQYY
X-Proofpoint-ORIG-GUID: 0h9W-GBi30ezrX8dfvaMSaja2JrgnQYY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_04,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 clxscore=1011
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209210060
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mingwei Zhang <mizhang@google.com>

commit 683412ccf61294d727ead4a73d97397396e69a6b upstream.

Flush the CPU caches when memory is reclaimed from an SEV guest (where
reclaim also includes it being unmapped from KVM's memslots).  Due to lack
of coherency for SEV encrypted memory, failure to flush results in silent
data corruption if userspace is malicious/broken and doesn't ensure SEV
guest memory is properly pinned and unpinned.

Cache coherency is not enforced across the VM boundary in SEV (AMD APM
vol.2 Section 15.34.7). Confidential cachelines, generated by confidential
VM guests have to be explicitly flushed on the host side. If a memory page
containing dirty confidential cachelines was released by VM and reallocated
to another user, the cachelines may corrupt the new user at a later time.

KVM takes a shortcut by assuming all confidential memory remain pinned
until the end of VM lifetime. Therefore, KVM does not flush cache at
mmu_notifier invalidation events. Because of this incorrect assumption and
the lack of cache flushing, malicous userspace can crash the host kernel:
creating a malicious VM and continuously allocates/releases unpinned
confidential memory pages when the VM is running.

Add cache flush operations to mmu_notifier operations to ensure that any
physical memory leaving the guest VM get flushed. In particular, hook
mmu_notifier_invalidate_range_start and mmu_notifier_release events and
flush cache accordingly. The hook after releasing the mmu lock to avoid
contention with other vCPUs.

Cc: stable@vger.kernel.org
Suggested-by: Sean Christpherson <seanjc@google.com>
Reported-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Message-Id: <20220421031407.2516575-4-mizhang@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[OP: adjusted KVM_X86_OP_OPTIONAL() -> KVM_X86_OP_NULL, applied
kvm_arch_guest_memory_reclaimed() call in kvm_set_memslot()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
This fixes CVE-2022-0171.

 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/svm/sev.c             |  8 ++++++++
 arch/x86/kvm/svm/svm.c             |  1 +
 arch/x86/kvm/svm/svm.h             |  2 ++
 arch/x86/kvm/x86.c                 |  5 +++++
 include/linux/kvm_host.h           |  2 ++
 virt/kvm/kvm_main.c                | 27 ++++++++++++++++++++++++---
 8 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 9e50da3ed01a..23ea8a25cbbe 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -115,6 +115,7 @@ KVM_X86_OP(enable_smi_window)
 KVM_X86_OP_NULL(mem_enc_op)
 KVM_X86_OP_NULL(mem_enc_reg_region)
 KVM_X86_OP_NULL(mem_enc_unreg_region)
+KVM_X86_OP_NULL(guest_memory_reclaimed)
 KVM_X86_OP(get_msr_feature)
 KVM_X86_OP(can_emulate_instruction)
 KVM_X86_OP(apic_init_signal_blocked)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 74b5819120da..9e800d4d323c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1476,6 +1476,7 @@ struct kvm_x86_ops {
 	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
+	void (*guest_memory_reclaimed)(struct kvm *kvm);
 
 	int (*get_msr_feature)(struct kvm_msr_entry *entry);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 86f3096f042f..eeedcb3d40e8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2037,6 +2037,14 @@ static void sev_flush_guest_memory(struct vcpu_svm *svm, void *va,
 	wbinvd_on_all_cpus();
 }
 
+void sev_guest_memory_reclaimed(struct kvm *kvm)
+{
+	if (!sev_guest(kvm))
+		return;
+
+	wbinvd_on_all_cpus();
+}
+
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2947e3c965e3..49bb3db2761a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4678,6 +4678,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.mem_enc_op = svm_mem_enc_op,
 	.mem_enc_reg_region = svm_register_enc_region,
 	.mem_enc_unreg_region = svm_unregister_enc_region,
+	.guest_memory_reclaimed = sev_guest_memory_reclaimed,
 
 	.vm_copy_enc_context_from = svm_vm_copy_asid_from,
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index cf2d8365aeb4..7004f356edf9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -555,6 +555,8 @@ int svm_register_enc_region(struct kvm *kvm,
 int svm_unregister_enc_region(struct kvm *kvm,
 			      struct kvm_enc_region *range);
 int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd);
+void sev_guest_memory_reclaimed(struct kvm *kvm);
+
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_set_cpu_caps(void);
 void __init sev_hardware_setup(void);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9109e5589b42..11e73d02fb3a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9557,6 +9557,11 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
 }
 
+void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
+{
+	static_call_cond(kvm_x86_guest_memory_reclaimed)(kvm);
+}
+
 void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 {
 	if (!lapic_in_kernel(vcpu))
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 38b7e9ab48b8..725f8f13adb5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1912,6 +1912,8 @@ static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
 void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 					    unsigned long start, unsigned long end);
 
+void kvm_arch_guest_memory_reclaimed(struct kvm *kvm);
+
 #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
 int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu);
 #else
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 86fc429a0e43..3ae5f6a3eae4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -162,6 +162,10 @@ __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 {
 }
 
+__weak void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
+{
+}
+
 bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
 {
 	/*
@@ -353,6 +357,12 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 }
 
+static void kvm_flush_shadow_all(struct kvm *kvm)
+{
+	kvm_arch_flush_shadow_all(kvm);
+	kvm_arch_guest_memory_reclaimed(kvm);
+}
+
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 					       gfp_t gfp_flags)
@@ -469,12 +479,15 @@ typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
 typedef void (*on_lock_fn_t)(struct kvm *kvm, unsigned long start,
 			     unsigned long end);
 
+typedef void (*on_unlock_fn_t)(struct kvm *kvm);
+
 struct kvm_hva_range {
 	unsigned long start;
 	unsigned long end;
 	pte_t pte;
 	hva_handler_t handler;
 	on_lock_fn_t on_lock;
+	on_unlock_fn_t on_unlock;
 	bool flush_on_ret;
 	bool may_block;
 };
@@ -551,8 +564,11 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	if (range->flush_on_ret && ret)
 		kvm_flush_remote_tlbs(kvm);
 
-	if (locked)
+	if (locked) {
 		KVM_MMU_UNLOCK(kvm);
+		if (!IS_KVM_NULL_FN(range->on_unlock))
+			range->on_unlock(kvm);
+	}
 
 	srcu_read_unlock(&kvm->srcu, idx);
 
@@ -573,6 +589,7 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 		.pte		= pte,
 		.handler	= handler,
 		.on_lock	= (void *)kvm_null_fn,
+		.on_unlock	= (void *)kvm_null_fn,
 		.flush_on_ret	= true,
 		.may_block	= false,
 	};
@@ -592,6 +609,7 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 		.pte		= __pte(0),
 		.handler	= handler,
 		.on_lock	= (void *)kvm_null_fn,
+		.on_unlock	= (void *)kvm_null_fn,
 		.flush_on_ret	= false,
 		.may_block	= false,
 	};
@@ -660,6 +678,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		.pte		= __pte(0),
 		.handler	= kvm_unmap_gfn_range,
 		.on_lock	= kvm_inc_notifier_count,
+		.on_unlock	= kvm_arch_guest_memory_reclaimed,
 		.flush_on_ret	= true,
 		.may_block	= mmu_notifier_range_blockable(range),
 	};
@@ -711,6 +730,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 		.pte		= __pte(0),
 		.handler	= (void *)kvm_null_fn,
 		.on_lock	= kvm_dec_notifier_count,
+		.on_unlock	= (void *)kvm_null_fn,
 		.flush_on_ret	= false,
 		.may_block	= mmu_notifier_range_blockable(range),
 	};
@@ -783,7 +803,7 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 	int idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	kvm_arch_flush_shadow_all(kvm);
+	kvm_flush_shadow_all(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
@@ -1188,7 +1208,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	WARN_ON(rcuwait_active(&kvm->mn_memslots_update_rcuwait));
 	kvm->mn_active_invalidate_count = 0;
 #else
-	kvm_arch_flush_shadow_all(kvm);
+	kvm_flush_shadow_all(kvm);
 #endif
 	kvm_arch_destroy_vm(kvm);
 	kvm_destroy_devices(kvm);
@@ -1588,6 +1608,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 		 *	- kvm_is_visible_gfn (mmu_check_root)
 		 */
 		kvm_arch_flush_shadow_memslot(kvm, slot);
+		kvm_arch_guest_memory_reclaimed(kvm);
 
 		/* Released in install_new_memslots. */
 		mutex_lock(&kvm->slots_arch_lock);
-- 
2.37.3

