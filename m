Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D23B649D54
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 12:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiLLLRk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 06:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbiLLLRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 06:17:12 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD442AE6
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 03:15:36 -0800 (PST)
Received: from kwepemi500014.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NVzTM0zbhznTTv;
        Mon, 12 Dec 2022 19:11:19 +0800 (CST)
Received: from [10.174.187.90] (10.174.187.90) by
 kwepemi500014.china.huawei.com (7.221.188.232) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 12 Dec 2022 19:15:33 +0800
Subject: KVM: a issue which maybe a vulnerability
From:   Yilu Lin <linyilu@huawei.com>
To:     <pbonzini@redhat.com>, <stable@vger.kernel.org>
CC:     "security@kernel.org" <security@kernel.org>,
        caihe <caihe@huawei.com>,
        "Zhangzebin (Zebin, PSIRT)" <zhangzebin@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>,
        xingchaochao <xingchaochao@huawei.com>,
        "lishan (E)" <lishan24@huawei.com>, <subo7@huawei.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        <xiewenbo@huawei.com>
References: <1afb632c3c59499bb586d1c5287c92ec@huawei.com>
 <57d8b88a87754e9ab74be19139ea64a7@huawei.com> <Y5BOA69lp1LQ6F1m@kroah.com>
 <0167aa46-89da-9b91-f1bf-8023ab4b35c7@huawei.com>
 <Y5btJNMv1nXKLrPE@kroah.com>
 <743b09f8-3377-7556-2968-0607711b82cb@huawei.com>
Message-ID: <c77c791d-85b0-b799-8f1e-ec00645e976b@huawei.com>
Date:   Mon, 12 Dec 2022 19:15:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <743b09f8-3377-7556-2968-0607711b82cb@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.90]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500014.china.huawei.com (7.221.188.232)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello. There is a issue about the kvm module in kernel, which may be a vulnerability. And I need your adivce.

Here is affect version:
    Linux kernel version 3.10.The virtualization platform uses the general Linux version before 4.15, which may also involve.
    The issue is fixed in v4.15-rc1.Commit ID is dedf9c5e216902c6d34b5a0d0c40f4acbb3706d8. Link is https://github.com/torvalds/linux/commit/dedf9c5e216902c6d34b5a0d0c40f4acbb3706d8.

Here is prerequisites for issue exploitation:
    1. The attacker has root privileges on the virtual machine (GuestOS).
    2. The Linux kernel version of the host HostOS is less than 3.10 (theoretical analysis shows that versions less than 4.15 are affected).
    3. The CPU APIC timer type when GuestOS starts is deadline.
    4. The attacker resets the CPU APIC timer type to period within GuestOS.

Here is steps for loophole recurrence:
    1. Create and start GuestOS（The CPU APIC timer type is deadline when GuestOS starts）.
    2. Reset the CPU APIC timer type to period within GuestOS. HostOS panic will be triggered probability.

Here is description of the cause of the issue:
    This vulnerability is a vulnerability in the kvm module in the open-source linux kernel. There is a logic error in the processing interrupt of the kvm module lpaic. When the corresponding timing problem occurs, HardLock will reset the HostOS. Specific problem logic:
    1. After the virtual machine (GuestOS) is started, initialize the CPU ACPI timer type as deadline, and start the timer timer; The CPU APIC timer type of the GuestOS will be recorded in the HostOS KVM module.
    2. Modify CPU APIC timer to period type in GuestOS;
    3. The process of changing CPU APIC timer type will be executed in module of kvm in HostOS;
    4. When changing the CPU APIC timer type, it is possible to be interrupted by an interrupt whose timer has expired;
    5. If the interrupt processing function of the timer thinks that the CPU APIC timer type is period, the CPU APIC timer will be added to the timer task list again; However, in this process, the CPU APIC timer period type value is not initialized, which causes the timer timeout to remain unchanged. Therefore, the timer task will be added back to the task list repeatedly, causing an endless loop, which eventually causes HardLock to reset the host.

Here is the issue impact:
    The HostOS is panic. All virtual machines on the host are abnormal and cannot be used.
