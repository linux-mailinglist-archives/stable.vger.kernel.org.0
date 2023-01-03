Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C3065BF60
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 12:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbjACLvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 06:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237459AbjACLvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 06:51:25 -0500
Received: from CY4PR02CU008-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11012007.outbound.protection.outlook.com [40.93.200.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC6DF35;
        Tue,  3 Jan 2023 03:51:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OmrmOkUWcCNoPmc/6pE//qlrXxrGiOLxejNbPU4XH/QKcrfZt6F7Dkb+9YkjnEqHcBSpKpFNNziZ00pRzBTv7COAdl3cVTSm4WvaTm8mW/ka3thwv1dx9DykpK5Yhta8sFks1RnS4qnx1P7Tmer4L4ZAgFJGrEqsxiklTABVQSGx2ke6j1WFYE43JUn7pYQ1suip/Q8okEJJEQKxghhoCiJxzwe9Db4z6MT5ek6NjM2izS2Mwt5IhPYHzapb1+AXAFaqQliqZyZg0EexcZ7qxCWo2khhfSwIUtapO7GPk7vR9iRIQXVTauccJYQhybUC2T7CtWPLGSm+00KYjmROiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RhmPgo7xfhaDnJ/S2TgGft8nchF1qsj/8Ze0Msc4eeI=;
 b=cKhLxv4t1G1FQbCz7R8eH1B8YWcDakjzPeQgK/+/sLQC/NuY9Wj5vwHGtwof6h4qFbyBi1SfizzcQ5uVIlASnfnQSBFSvsg+3Qy/a+okdHaea8vjVWlyGLfIbdc2KuComswslNi9gMaeyYkbH9630mrbB6hz+JBFQfLUMZHAhSFgy2FFiGDx+xqmBSxlcZvXXjXmPQU/VqirRzBw+4iUyWCCZ5B1BTetvZPgFGrR8lXA16j+3P4zHMaFZzeSbH1S+IRAZMEZo3QGiO5pBtSWUtpFkQYNpmb0UER9IsFYpYkhKYLSsCGt5b3X2XQuRwXxzbjYqwOd6LmtX2b4NhehvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RhmPgo7xfhaDnJ/S2TgGft8nchF1qsj/8Ze0Msc4eeI=;
 b=IHAsYfsp6IlCmAVhSeBxQXS7wQBys0tM17TmNDjfTnQHmvpl1NR3Y3BC0jn3zztUOzj90o2WG/x8ScZrZFt62nRSUcY9xrvcI4DtXIQriO2oJ+1wJazU8nPV+WgTz3dzAuvpuQXbXy41YLcJkPEygNDfrErRZ7PfUEU1uICgVuw=
Received: from PH0PR05MB7915.namprd05.prod.outlook.com (2603:10b6:510:95::13)
 by SN4PR0501MB3757.namprd05.prod.outlook.com (2603:10b6:803:4e::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.15; Tue, 3 Jan
 2023 11:51:19 +0000
Received: from PH0PR05MB7915.namprd05.prod.outlook.com
 ([fe80::7ac5:af08:f183:d834]) by PH0PR05MB7915.namprd05.prod.outlook.com
 ([fe80::7ac5:af08:f183:d834%3]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 11:51:19 +0000
From:   Bryan Tan <bryantan@vmware.com>
To:     Vishnu Dasa <vdasa@vmware.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Zack Rusin <zackr@vmware.com>, Nadav Amit <namit@vmware.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] VMCI: Use threaded irqs instead of tasklets
Thread-Topic: [PATCH] VMCI: Use threaded irqs instead of tasklets
Thread-Index: AQHZBIpEWYZfyKPY3ECQF0GRDuz2hK6MykwA
Date:   Tue, 3 Jan 2023 11:51:19 +0000
Message-ID: <35ED7409-6FCF-4740-920A-40231ECC957C@vmware.com>
References: <20221130070511.46558-1-vdasa@vmware.com>
In-Reply-To: <20221130070511.46558-1-vdasa@vmware.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR05MB7915:EE_|SN4PR0501MB3757:EE_
x-ms-office365-filtering-correlation-id: 66f59fda-be35-4ad4-e8ac-08daed80d40f
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uPr9b1Wh7l2dUXMbtrttWnPMgLWb8sPOizzk969l7GyEg/Ntua9WxcQrMznPq8rvlUuzGMFP75Z1zsDIUkiRplvcer3rfiWIwrV69Z2uRVJNEWG603dQv8coyqEdSNw4aufE08xo93I4R1LqI6DM7c6vGBVH+qe88N2KT6p3co5nJLHYs3hEkzV0HKX9XHgbPQx5pkOXXTlB1KJo7kbA542BLmZ6juqEZqEaH/u9HbcTJpNdPqu/EBlWPxne5htBYMYjuGgInn9jt8U8nbaYGMiR3eao31gm8ScxA8XjkT4cMDQnFoAN1goisHqfbYihc6fi4xOze7mXvm2WnwtppsHyOYwARNUemfzUR1rCK9SFAonr+1qwY+6cSr7SAAQebIYEl0XGGCWfYiP2/2an9goAEHZ2GnALRNRejAO523INjt3ap4D8rtJauL4UKryr05laFnvuYSei0KdCnVdZoWHsPZxPTONxAw998UD9AM5HSMNIlj8MBGEkT/Ie1zUAfUKxOSwIDz5N+jAEL0zhUe8mWCvecfktte65KmxQ5SvJpQgpsbh99EKbwYfqjwWAeJUOdvvcVqZ29Q5sNsQznTef7eFuTOReG2cAGxOsiGw+ARBy8Vej1cU6BTxPOKzIalGMxlcNJ0/7i3CCB9tP39ZE3ew8OxLliWuEgulIm+dx+DVTW9+xOU42OqLb6EaNnkH9Ps1b4p4b4MjNdX7HvrPof4yTmyoQzYJOkVXKbQ+0g6rEIMQRUdcqVCUToEz6iPsskh3ybqV0w2Pbb8OYCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR05MB7915.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(26005)(83380400001)(186003)(6512007)(2616005)(86362001)(33656002)(38070700005)(36756003)(122000001)(38100700002)(66556008)(64756008)(316002)(2906002)(37006003)(54906003)(6636002)(4326008)(6862004)(66946007)(8936002)(41300700001)(5660300002)(8676002)(91956017)(76116006)(66446008)(66476007)(478600001)(6486002)(53546011)(71200400001)(6506007)(22166006)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?i0HKA8skmorM5C9CciiDEKCL/2XuzpydVUgAEr3OvdMkWzb8gnDsMrgMTF5B?=
 =?us-ascii?Q?Ht7ISwaXFKYR6S8f3YlctgEcYKSdH+rZX81zx/ZrYAY21YmvB3nPYGxkIWvo?=
 =?us-ascii?Q?4CLxzBlmbhG6TehwRbYgqz8i76gVjFM/ZQ8nl6ZjVDcP2VgAOiVuutEAVUp8?=
 =?us-ascii?Q?A9QzdYftVVshm3d7uVSBhH2cbailUSW/lbi1cQnMyZ8COahP2t7o6DVD3o0c?=
 =?us-ascii?Q?tYkC4mW3UMO4xiSOCGbwctccKHdmn0ERF0xITiOlbln1bHkUvYgehv9JAlSC?=
 =?us-ascii?Q?7rwMZj138CQLtZOrQAP50k/AHCcAdDW961CxfPJJpYmzhOibjlGZEZYpOBgj?=
 =?us-ascii?Q?L0HgLNI9WSb0BOTKXI8ZJLqZMZd0GcqjDfOi8ySn3pkCPygOo1drkqTjODI9?=
 =?us-ascii?Q?XBA4KfD5MneZ4SXSMgenbqrxkKh7wBmsn36ZXk2FSM9gllCWJ6/oZABL3SAw?=
 =?us-ascii?Q?syBdvcnQTzwQHt248q+s2B5KHdbEseRuNVCLMTjJqCfLL0KPMOPnrf9ITOsR?=
 =?us-ascii?Q?VrC/TffPiyquBm6vK4FiC9aENs2+taMoInSTNLVtT6M127c7TEJCotDt9hnW?=
 =?us-ascii?Q?2KHSlCWPVIdPG6LG8cRICjrf1N0RN/+fk7ztLU7p1+gOYMPFAo1LCuJ8Avu/?=
 =?us-ascii?Q?v9VsOlebzyvyC5F/kQ/rFsVrW6iMOe8hO4Kjl80aooJexjslcQLsp/vanidM?=
 =?us-ascii?Q?MK28MG/QTwks6i5Olf7OV511cpB4R6ozni/ZnNwE/len/wncocSZ3H81bKSD?=
 =?us-ascii?Q?8VtW9x80Grbl0UdZRT3rJSu5nzBYbiIF7/PZdyzirRmhpcrKF1T+513xjL4+?=
 =?us-ascii?Q?uFW2xx9r04+CsN5Mvpyn8WYpT6/dWO3KjfMAwhQSXm0u9sxfEI06gRONc564?=
 =?us-ascii?Q?QN4plCvI17tSLue4fl+uayTPq+TLSpbd+toj6WiWG0z5qYsla2JyurQdUF5w?=
 =?us-ascii?Q?IYUX+kxS9I8eGE4tPE8jxj/J1nZmxxoq7PPO7bPdJ0GZvS2WYFgSpMCdz6kB?=
 =?us-ascii?Q?9uCLXTzHxUSetQ08eePDnhg5iY/6ckRug88fFDElYpPi9jgBOWCP1ESBLkEH?=
 =?us-ascii?Q?cAHwm1QAaT1DOPs1w4eqwo1v/uzUKv86rBpLv/t92Xg10YksxQN4zPRKoCne?=
 =?us-ascii?Q?pRRXa70jCBnqS3jTWlpsevYlHjZB3bJHDaZ+bLbEtdgMZlUcu1JDHvx50cXz?=
 =?us-ascii?Q?8GycYis55PHH3gGTFMo8OD0PZeZfTaDBlJJBTqh01M+VvlT8hmC4NpsbN5QM?=
 =?us-ascii?Q?rRpE/1je0o5SEDQE7ZEffyhki5g3Y+Obo338gwtIJAlb7HZm/pxE4rnfSvy5?=
 =?us-ascii?Q?AngbTbGLwqklE64EJ3qQnRBw3olBQ2bFHdBwpQNI8T6WsMu5adgLrlWtXQii?=
 =?us-ascii?Q?OwZnZwAE7YzbSLgAH7BQaXdvIfsNCkkxhQ/+2NDfMKAU4e4BFPkhpu7lSRDg?=
 =?us-ascii?Q?003d+EnS+FQ1ty7TwYOv7X0XrBRZ0BKqFTrv6PIhxbkExTXeMDvh0bez74HV?=
 =?us-ascii?Q?of3L4AhZGUdoou2r+e23/njOs1OVGqxtVuMy7/rVtC9N1TVYTVJpJH1FMKCV?=
 =?us-ascii?Q?OBPJuGiCt4hosA2uDRA66mA5ZQDqePzPMl0GKs9xwC3SlEHuZ7u9dY69SOVp?=
 =?us-ascii?Q?IQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C4ED9DDCD0652F4D830673C87CFC757B@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR05MB7915.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66f59fda-be35-4ad4-e8ac-08daed80d40f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2023 11:51:19.5130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AZucl/tD1Tg9UVcRlSzDYVGaqzgwTqnCrwHh5AFE9L2gDtROfOc1ydApXP08h3TIwgKU+HXqooyR8CJSJB9bjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0501MB3757
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On 30 Nov 2022, at 07:05, Vishnu Dasa <vdasa@vmware.com> wrote:
>=20
> From: Vishnu Dasa <vdasa@vmware.com>
>=20
> The vmci_dispatch_dgs() tasklet function calls vmci_read_data()
> which uses wait_event() resulting in invalid sleep in an atomic
> context (and therefore potentially in a deadlock).
>=20
> Use threaded irqs to fix this issue and completely remove usage
> of tasklets.
>=20
> [   20.264639] BUG: sleeping function called from invalid context at driv=
ers/misc/vmw_vmci/vmci_guest.c:145
> [   20.264643] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 762=
, name: vmtoolsd
> [   20.264645] preempt_count: 101, expected: 0
> [   20.264646] RCU nest depth: 0, expected: 0
> [   20.264647] 1 lock held by vmtoolsd/762:
> [   20.264648]  #0: ffff0000874ae440 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: =
vsock_connect+0x60/0x330 [vsock]
> [   20.264658] Preemption disabled at:
> [   20.264659] [<ffff80000151d7d8>] vmci_send_datagram+0x44/0xa0 [vmw_vmc=
i]
> [   20.264665] CPU: 0 PID: 762 Comm: vmtoolsd Not tainted 5.19.0-0.rc8.20=
220727git39c3c396f813.60.fc37.aarch64 #1
> [   20.264667] Hardware name: VMware, Inc. VBSA/VBSA, BIOS VEFI 12/31/202=
0
> [   20.264668] Call trace:
> [   20.264669]  dump_backtrace+0xc4/0x130
> [   20.264672]  show_stack+0x24/0x80
> [   20.264673]  dump_stack_lvl+0x88/0xb4
> [   20.264676]  dump_stack+0x18/0x34
> [   20.264677]  __might_resched+0x1a0/0x280
> [   20.264679]  __might_sleep+0x58/0x90
> [   20.264681]  vmci_read_data+0x74/0x120 [vmw_vmci]
> [   20.264683]  vmci_dispatch_dgs+0x64/0x204 [vmw_vmci]
> [   20.264686]  tasklet_action_common.constprop.0+0x13c/0x150
> [   20.264688]  tasklet_action+0x40/0x50
> [   20.264689]  __do_softirq+0x23c/0x6b4
> [   20.264690]  __irq_exit_rcu+0x104/0x214
> [   20.264691]  irq_exit_rcu+0x1c/0x50
> [   20.264693]  el1_interrupt+0x38/0x6c
> [   20.264695]  el1h_64_irq_handler+0x18/0x24
> [   20.264696]  el1h_64_irq+0x68/0x6c
> [   20.264697]  preempt_count_sub+0xa4/0xe0
> [   20.264698]  _raw_spin_unlock_irqrestore+0x64/0xb0
> [   20.264701]  vmci_send_datagram+0x7c/0xa0 [vmw_vmci]
> [   20.264703]  vmci_datagram_dispatch+0x84/0x100 [vmw_vmci]
> [   20.264706]  vmci_datagram_send+0x2c/0x40 [vmw_vmci]
> [   20.264709]  vmci_transport_send_control_pkt+0xb8/0x120 [vmw_vsock_vmc=
i_transport]
> [   20.264711]  vmci_transport_connect+0x40/0x7c [vmw_vsock_vmci_transpor=
t]
> [   20.264713]  vsock_connect+0x278/0x330 [vsock]
> [   20.264715]  __sys_connect_file+0x8c/0xc0
> [   20.264718]  __sys_connect+0x84/0xb4
> [   20.264720]  __arm64_sys_connect+0x2c/0x3c
> [   20.264721]  invoke_syscall+0x78/0x100
> [   20.264723]  el0_svc_common.constprop.0+0x68/0x124
> [   20.264724]  do_el0_svc+0x38/0x4c
> [   20.264725]  el0_svc+0x60/0x180
> [   20.264726]  el0t_64_sync_handler+0x11c/0x150
> [   20.264728]  el0t_64_sync+0x190/0x194
>=20
> Signed-off-by: Vishnu Dasa <vdasa@vmware.com>
> Suggested-by: Zack Rusin <zackr@vmware.com>
> Reported-by: Nadav Amit <namit@vmware.com>
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Tested-by: Nathan Chancellor <nathan@kernel.org>
> Fixes: 463713eb6164 ("VMCI: dma dg: add support for DMA datagrams receive=
")
> Cc: <stable@vger.kernel.org> # v5.18+
> Cc: VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Bryan Tan <bryantan@vmware.com>
> ---
> drivers/misc/vmw_vmci/vmci_guest.c | 49 ++++++++++++------------------
> 1 file changed, 19 insertions(+), 30 deletions(-)
>=20
> diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/v=
mci_guest.c
> index aa7b05de97dd..6ab717b4a5db 100644
> --- a/drivers/misc/vmw_vmci/vmci_guest.c
> +++ b/drivers/misc/vmw_vmci/vmci_guest.c
> @@ -56,8 +56,6 @@ struct vmci_guest_device {
>=20
> 	bool exclusive_vectors;
>=20
> -	struct tasklet_struct datagram_tasklet;
> -	struct tasklet_struct bm_tasklet;
> 	struct wait_queue_head inout_wq;
>=20
> 	void *data_buffer;
> @@ -304,9 +302,8 @@ static int vmci_check_host_caps(struct pci_dev *pdev)
>  * This function assumes that it has exclusive access to the data
>  * in register(s) for the duration of the call.
>  */
> -static void vmci_dispatch_dgs(unsigned long data)
> +static void vmci_dispatch_dgs(struct vmci_guest_device *vmci_dev)
> {
> -	struct vmci_guest_device *vmci_dev =3D (struct vmci_guest_device *)data=
;
> 	u8 *dg_in_buffer =3D vmci_dev->data_buffer;
> 	struct vmci_datagram *dg;
> 	size_t dg_in_buffer_size =3D VMCI_MAX_DG_SIZE;
> @@ -465,10 +462,8 @@ static void vmci_dispatch_dgs(unsigned long data)
>  * Scans the notification bitmap for raised flags, clears them
>  * and handles the notifications.
>  */
> -static void vmci_process_bitmap(unsigned long data)
> +static void vmci_process_bitmap(struct vmci_guest_device *dev)
> {
> -	struct vmci_guest_device *dev =3D (struct vmci_guest_device *)data;
> -
> 	if (!dev->notification_bitmap) {
> 		dev_dbg(dev->dev, "No bitmap present in %s\n", __func__);
> 		return;
> @@ -486,13 +481,13 @@ static irqreturn_t vmci_interrupt(int irq, void *_d=
ev)
> 	struct vmci_guest_device *dev =3D _dev;
>=20
> 	/*
> -	 * If we are using MSI-X with exclusive vectors then we simply schedule
> -	 * the datagram tasklet, since we know the interrupt was meant for us.
> +	 * If we are using MSI-X with exclusive vectors then we simply call
> +	 * vmci_dispatch_dgs(), since we know the interrupt was meant for us.
> 	 * Otherwise we must read the ICR to determine what to do.
> 	 */
>=20
> 	if (dev->exclusive_vectors) {
> -		tasklet_schedule(&dev->datagram_tasklet);
> +		vmci_dispatch_dgs(dev);
> 	} else {
> 		unsigned int icr;
>=20
> @@ -502,12 +497,12 @@ static irqreturn_t vmci_interrupt(int irq, void *_d=
ev)
> 			return IRQ_NONE;
>=20
> 		if (icr & VMCI_ICR_DATAGRAM) {
> -			tasklet_schedule(&dev->datagram_tasklet);
> +			vmci_dispatch_dgs(dev);
> 			icr &=3D ~VMCI_ICR_DATAGRAM;
> 		}
>=20
> 		if (icr & VMCI_ICR_NOTIFICATION) {
> -			tasklet_schedule(&dev->bm_tasklet);
> +			vmci_process_bitmap(dev);
> 			icr &=3D ~VMCI_ICR_NOTIFICATION;
> 		}
>=20
> @@ -536,7 +531,7 @@ static irqreturn_t vmci_interrupt_bm(int irq, void *_=
dev)
> 	struct vmci_guest_device *dev =3D _dev;
>=20
> 	/* For MSI-X we can just assume it was meant for us. */
> -	tasklet_schedule(&dev->bm_tasklet);
> +	vmci_process_bitmap(dev);
>=20
> 	return IRQ_HANDLED;
> }
> @@ -638,10 +633,6 @@ static int vmci_guest_probe_device(struct pci_dev *p=
dev,
> 	vmci_dev->iobase =3D iobase;
> 	vmci_dev->mmio_base =3D mmio_base;
>=20
> -	tasklet_init(&vmci_dev->datagram_tasklet,
> -		     vmci_dispatch_dgs, (unsigned long)vmci_dev);
> -	tasklet_init(&vmci_dev->bm_tasklet,
> -		     vmci_process_bitmap, (unsigned long)vmci_dev);
> 	init_waitqueue_head(&vmci_dev->inout_wq);
>=20
> 	if (mmio_base !=3D NULL) {
> @@ -808,8 +799,9 @@ static int vmci_guest_probe_device(struct pci_dev *pd=
ev,
> 	 * Request IRQ for legacy or MSI interrupts, or for first
> 	 * MSI-X vector.
> 	 */
> -	error =3D request_irq(pci_irq_vector(pdev, 0), vmci_interrupt,
> -			    IRQF_SHARED, KBUILD_MODNAME, vmci_dev);
> +	error =3D request_threaded_irq(pci_irq_vector(pdev, 0), NULL,
> +				     vmci_interrupt, IRQF_SHARED,
> +				     KBUILD_MODNAME, vmci_dev);
> 	if (error) {
> 		dev_err(&pdev->dev, "Irq %u in use: %d\n",
> 			pci_irq_vector(pdev, 0), error);
> @@ -823,9 +815,9 @@ static int vmci_guest_probe_device(struct pci_dev *pd=
ev,
> 	 * between the vectors.
> 	 */
> 	if (vmci_dev->exclusive_vectors) {
> -		error =3D request_irq(pci_irq_vector(pdev, 1),
> -				    vmci_interrupt_bm, 0, KBUILD_MODNAME,
> -				    vmci_dev);
> +		error =3D request_threaded_irq(pci_irq_vector(pdev, 1), NULL,
> +					     vmci_interrupt_bm, 0,
> +					     KBUILD_MODNAME, vmci_dev);
> 		if (error) {
> 			dev_err(&pdev->dev,
> 				"Failed to allocate irq %u: %d\n",
> @@ -833,9 +825,11 @@ static int vmci_guest_probe_device(struct pci_dev *p=
dev,
> 			goto err_free_irq;
> 		}
> 		if (caps_in_use & VMCI_CAPS_DMA_DATAGRAM) {
> -			error =3D request_irq(pci_irq_vector(pdev, 2),
> -					    vmci_interrupt_dma_datagram,
> -					    0, KBUILD_MODNAME, vmci_dev);
> +			error =3D request_threaded_irq(pci_irq_vector(pdev, 2),
> +						     NULL,
> +						    vmci_interrupt_dma_datagram,
> +						     0, KBUILD_MODNAME,
> +						     vmci_dev);
> 			if (error) {
> 				dev_err(&pdev->dev,
> 					"Failed to allocate irq %u: %d\n",
> @@ -871,8 +865,6 @@ static int vmci_guest_probe_device(struct pci_dev *pd=
ev,
>=20
> err_free_irq:
> 	free_irq(pci_irq_vector(pdev, 0), vmci_dev);
> -	tasklet_kill(&vmci_dev->datagram_tasklet);
> -	tasklet_kill(&vmci_dev->bm_tasklet);
>=20
> err_disable_msi:
> 	pci_free_irq_vectors(pdev);
> @@ -943,9 +935,6 @@ static void vmci_guest_remove_device(struct pci_dev *=
pdev)
> 	free_irq(pci_irq_vector(pdev, 0), vmci_dev);
> 	pci_free_irq_vectors(pdev);
>=20
> -	tasklet_kill(&vmci_dev->datagram_tasklet);
> -	tasklet_kill(&vmci_dev->bm_tasklet);
> -
> 	if (vmci_dev->notification_bitmap) {
> 		/*
> 		 * The device reset above cleared the bitmap state of the
> --=20
> 2.34.1

Reviewed-by: Bryan Tan <bryantan@vmware.com>=
