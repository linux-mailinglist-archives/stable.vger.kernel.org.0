Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC9B399CD
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 01:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbfFGX4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 19:56:50 -0400
Received: from mail-eopbgr740049.outbound.protection.outlook.com ([40.107.74.49]:53688
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730402AbfFGX4u (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 19:56:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XuFhF9oADHX5mPh0htvn/53bn2+Zax6UM5rypNPC7vs=;
 b=kSJ+KymFNXZu/GCt06u5SkWrowrM4G/rk+mDRInv/UeIxHwYzlYqyIUrq0M0k//xzosTVUi+igk014QS7VmNPsHEXBx4Kjhd8SK9XKezf3yCutoJjHJXr/NTkONxupvJR6DGrepwbMH4WSOAZJ1CZ4xa8XeCtKk71vkhCBiruIU=
Received: from BYAPR05MB4776.namprd05.prod.outlook.com (52.135.233.146) by
 BYAPR05MB5317.namprd05.prod.outlook.com (20.177.127.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Fri, 7 Jun 2019 23:56:46 +0000
Received: from BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::134:af66:bedb:ead9]) by BYAPR05MB4776.namprd05.prod.outlook.com
 ([fe80::134:af66:bedb:ead9%3]) with mapi id 15.20.1987.008; Fri, 7 Jun 2019
 23:56:46 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Francesco Ruggeri <fruggeri@arista.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: kprobe: kernel panic in 4.19.47
Thread-Topic: kprobe: kernel panic in 4.19.47
Thread-Index: AQHVHYxfyYiPVgd5LkOPo9E8JoeH3qaQ3jgA
Date:   Fri, 7 Jun 2019 23:56:45 +0000
Message-ID: <2FF9B175-E4D4-40A2-A960-52A33D87718E@vmware.com>
References: <20190607235437.CFF3F95C0244@us180.sjc.aristanetworks.com>
In-Reply-To: <20190607235437.CFF3F95C0244@us180.sjc.aristanetworks.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=namit@vmware.com; 
x-originating-ip: [66.170.99.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ff26ec2-10ce-448d-1bde-08d6eba3ccae
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR05MB5317;
x-ms-traffictypediagnostic: BYAPR05MB5317:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR05MB531795DDCBC3767C24550661D0100@BYAPR05MB5317.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39860400002)(346002)(396003)(376002)(189003)(51234002)(199004)(71190400001)(83716004)(81166006)(14444005)(486006)(71200400001)(14454004)(5660300002)(4326008)(66066001)(8676002)(6512007)(82746002)(2616005)(81156014)(7736002)(476003)(256004)(446003)(186003)(6506007)(76176011)(6306002)(26005)(53546011)(6486002)(99286004)(102836004)(8936002)(229853002)(53936002)(25786009)(11346002)(66946007)(66556008)(76116006)(64756008)(33656002)(305945005)(478600001)(36756003)(6246003)(45080400002)(86362001)(6436002)(73956011)(3846002)(316002)(68736007)(2906002)(6116002)(966005)(6916009)(66446008)(66476007)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB5317;H:BYAPR05MB4776.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FP8yv0c+Bc6FCkjcjBrMep2KLHvoswcTpnch88SGts9KN/9MZPBjDmbaB+QpbbNETMz8RVyOIBLKFqQfOZz+olcJ7fYIccJLxiESb7cCpy4cwOQ4Wtw1wyAKs1AfKPqKA/s/m3gU05m83rvxISeKw4IzMco8fj7f9tpXCQRRtSvA6pTpRs8fWQNAMszalMwvmO7x+2+olEkHKs4S/7DStqUxXiXrx4Yj63S+TfvgJY9Zc1m0rykLRxxocvvns5Hw+Z/Sj4c07gP/VxsgIBUhs21FhfVafUWl04p5cC5PlHTMEbZDG56lMUwY3Z+RL5TWmf1zR6Uig5LlWBAFKN46ZDOxGwAaFDgikJczydRw41dcWF0VoJ61VGUky3DjS6lIDPhBJheVSsiTwqVTaedGCM/wxfvWmHBBiaFGEqhymhI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <059173F9449B374C8CDC051D95EE78F2@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ff26ec2-10ce-448d-1bde-08d6eba3ccae
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 23:56:46.3374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: namit@vmware.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB5317
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are a couple of patches that were mistakenly not included in 4.19.47.

https://lore.kernel.org/stable/20190606131558.GJ29739@sasha-vm/

Sorry for that and thanks for reporting.

Regards,
Nadav

> On Jun 7, 2019, at 4:54 PM, Francesco Ruggeri <fruggeri@arista.com> wrote=
:
>=20
> I see the following kernel panic in 4.19.47 as soon as I hit a kprobe.
> In this case it happened right after
>=20
> # cd /sys/kernel/debug/tracing/
> # echo >trace
> # echo 'p rollback_registered_many' >kprobe_events=20
> # echo 1 >events/kprobes/enable=20
> # ip netns add dummy
> # ip netns del dummy
>=20
> but I have also seen it with other functions, or when I used kernel modul=
es
> to install kprobes.
> I bisected to=20
>=20
> 8715ce033e [ "x86/modules: Avoid breaking W^X while loading modules" ]
>=20
> in 4.19.47 (upstream commit f2c65fb322 in v5.2-rc1).
>=20
> Thanks,
> Francesco
>=20
> [  151.067082] kernel tried to execute NX-protected page - exploit attemp=
t? (uid: 0)
> [  151.074631] BUG: unable to handle kernel paging request at ffffffffa00=
0f000
> [  151.081661] PGD 200a067 P4D 200a067 PUD 200b063 PMD 1038324067 PTE 800=
000101cb73161
> [  151.089396] Oops: 0011 [#1] SMP
> [  151.092603] CPU: 12 PID: 1831 Comm: kworker/u64:1 Kdump: loaded Not ta=
inted 4.19.47-12345018.AroraKernel419.fc18.x86_64 #1
> [  151.103696] Hardware name: Supermicro X9DRT/X9DRT, BIOS 3.0 06/28/2013
> [  151.110298] Workqueue: netns cleanup_net
> [  151.114297] RIP: 0010:0xffffffffa000f000
> [  151.118286] Code: Bad RIP value.
> [  151.121562] RSP: 0018:ffffc90007947d60 EFLAGS: 00010206
> [  151.126835] RAX: ffff88901cbf8070 RBX: ffffc90007947d88 RCX: ffff88901=
cbf8070
> [  151.134033] RDX: ffffc90007947d88 RSI: ffffc90007947d88 RDI: ffffc9000=
7947d88
> [  151.141226] RBP: ffffc90007947d78 R08: 0000000000000001 R09: 000000000=
0020cc0
> [  151.148429] R10: ffffc900063ebe08 R11: 0000000000026cdc R12: ffffc9000=
7947d88
> [  151.155630] R13: ffffc90007947e38 R14: ffff88901cbc8110 R15: ffffc9000=
7947e10
> [  151.162817] FS:  0000000000000000(0000) GS:ffff88a03f900000(0000) knlG=
S:0000000000000000
> [  151.170964] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  151.176986] CR2: ffffffffa000efd6 CR3: 0000000002009006 CR4: 000000000=
00606e0
> [  151.184403] Call Trace:
> [  151.187150]  ? rollback_registered_many+0x5/0x3bc
> [  151.192123]  ? unregister_netdevice_many+0x1a/0x79
> [  151.197177]  default_device_exit_batch+0x137/0x15f
> [  151.202231]  ? __wake_up_sync+0x12/0x12
> [  151.206345]  ops_exit_list+0x29/0x53
> [  151.210181]  cleanup_net+0x189/0x240
> [  151.214030]  process_one_work+0x174/0x280
> [  151.218319]  ? rescuer_thread+0x277/0x277
> [  151.222610]  worker_thread+0x1b5/0x264
> [  151.226639]  ? rescuer_thread+0x277/0x277
> [  151.230922]  kthread+0xf5/0xfa
> [  151.234239]  ? kthread_cancel_delayed_work_sync+0x15/0x15
> [  151.239906]  ret_from_fork+0x1f/0x30
> [  151.243751] Modules linked in: ipt_MASQUERADE nf_conntrack_netlink ipt=
able_filter xt_addrtype xt_conntrack br_netfilter bridge stp llc macvlan sg=
 coretemp x86_pkg_temp_thermal ip6table_filter ip6_tables ghash_clmulni_int=
el pcbc bonding aesni_intel kvm_intel aes_x86_64 crypto_simd kvm igb cryptd=
 irqbypass glue_helper iTCO_wdt ioatdma iTCO_vendor_support hwmon joydev i2=
c_i801 i2c_algo_bit ipmi_si i2c_core pcc_cpufreq lpc_ich mfd_core ipmi_msgh=
andler fuse dca pcspkr xt_multiport iptable_nat nf_nat_ipv4 ip_tables nf_na=
t nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 x_tables tun loop 8021q raid45=
6 async_raid6_recov async_memcpy libcrc32c async_pq async_xor xor async_tx =
raid6_pq raid1 raid0 isci libsas ehci_pci crc32c_intel ehci_hcd scsi_transp=
ort_sas wmi autofs4
> [  151.312827] CR2: ffffffffa000f000


