Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C37148AC2
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 15:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730547AbgAXO4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 09:56:09 -0500
Received: from mail-dm6nam10on2057.outbound.protection.outlook.com ([40.107.93.57]:31286
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729567AbgAXO4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 09:56:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fKdymGc9LhqzSmxumAdeX4sRmwF/0dJ1SdXe/iLXOoJQPJvMs1AJJ9M1QmEVA3niCyaHb3FUq2ZPR1Wbd+Gx6XXjEE3LuN1OVyR+LVO2MWthcH1EGLtjVAkD84QtXjxnxFg1gsZI9PsRYISYCOHYCnKN4oCy5RYff0QIHa3p08jzfeNnpEv4Or5j+TVroj/RfRZAbfZbyyxBXP+YNPgnb2FU7h7bgjwPbCUW4r1vrYOrXgIXZohNtoo29i8Bi08C8VRgobWUC+RCiVihiMWzZmNPjLlrvMM1SMIsLlL1plphTCJklYpE2nS22DTrim3ivgyytX/8yRUIFg72GeyKaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1T3CR72OPxP+skINAGHvXe3hM/JeIr676viU8BsZQo=;
 b=iNvBk4kVZzZ4ytx9mBANVfPRy8z3NfihQt9TQ91+X4ldinK4iM5xTgO/7efVUhptjfE4U5qsAGhEXmN5b0n7olp7E0GAJQYXvsT1PLU7QJ2DhrMMCtFU6P14zlUbP5Ku5ycBTmMxTfwnSAzDd3e6B1LmSI8ZaWxLVgaJ02OvphrTy80L7c34KdVjJdzEM1TtCoKqUiJY8/W9OSACmOFFWYTHoXqT+b1R1aqrtQHWYqJku6e9lVf2V3MRmzhKGj3agt/V7pPRpekqIoXg2XOqbcqALIP+hrJbo2J7Vc3gvuohdKlneeQfOjrXL+1iIVOGnStW8avMcW0nf/gpiaOrvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1T3CR72OPxP+skINAGHvXe3hM/JeIr676viU8BsZQo=;
 b=qK95yE14VadHm/ziFdrc6+xaORczO0enKBEsqKwfk7jmUXIqcsvkFARe/hnTLVpyZYXpwFKYlOy7Fg4qDMdUpGkU+2CavFr6WLYPDGpWLmRAEZYqJLyDHaDDlHVCDq1T6ZEFrJ9aalGrJLPb4GidLdIDfIJpzbTRi6owt3HZ+7g=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Harry.Wentland@amd.com; 
Received: from CY4PR1201MB0230.namprd12.prod.outlook.com (10.172.79.7) by
 CY4PR1201MB2487.namprd12.prod.outlook.com (10.172.116.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Fri, 24 Jan 2020 14:56:03 +0000
Received: from CY4PR1201MB0230.namprd12.prod.outlook.com
 ([fe80::4c09:215c:e5d2:3c8f]) by CY4PR1201MB0230.namprd12.prod.outlook.com
 ([fe80::4c09:215c:e5d2:3c8f%9]) with mapi id 15.20.2644.028; Fri, 24 Jan 2020
 14:56:02 +0000
Subject: Re: [PATCH] drm/amd/dm/mst: Ignore payload update failures on disable
To:     Lyude Paul <lyude@redhat.com>, amd-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        "David (ChunMing) Zhou" <David1.Zhou@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        David Francis <David.Francis@amd.com>,
        Martin Tsai <martin.tsai@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Alvin Lee <alvin.lee2@amd.com>,
        Jean Delvare <jdelvare@suse.de>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        "Lin, Wayne" <Wayne.Lin@amd.com>
References: <20200124000643.99859-1-lyude@redhat.com>
From:   Harry Wentland <hwentlan@amd.com>
Autocrypt: addr=hwentlan@amd.com; keydata=
 mQENBFhb4C8BCADhHHUNoBQ7K7LupCP0FsUb443Vuqq+dH0uo4A3lnPkMF6FJmGcJ9Sbx1C6
 cd4PbVAaTFZUEmjqfpm+wCRBe11eF55hW3GJ273wvfH69Q/zmAxwO8yk+i5ZWWl8Hns5h69K
 D9QURHLpXxrcwnfHFah0DwV23TrD1KGB7vowCZyJOw93U/GzAlXKESy0FM7ZOYIJH83X7qhh
 Q9KX94iTEYTeH86Wy8hwHtqM6ySviwEz0g+UegpG8ebbz0w3b5QmdKCAg+eZTmBekP5o77YE
 BKqR+Miiwo9+tzm2N5GiF9HDeI2pVe/egOLa5UcmsgdF4Y5FKoMnBbAHNaA6Fev8PHlNABEB
 AAG0J0hhcnJ5IFdlbnRsYW5kIDxoYXJyeS53ZW50bGFuZEBhbWQuY29tPokBNwQTAQgAIQUC
 WFvgLwIbAwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAAKCRAtWBXJjBS24xUlCAC9MqAlIbZO
 /a37s41h+MQ+D20C6/hVErWO+RA06nA+jFDPUWrDJKYdn6EDQWdLY3ATeAq3X8GIeOTXGrPD
 b2OXD6kOViW/RNvlXdrIsnIDacdr39aoAlY1b+bhTzZVz4pto4l+K1PZb5jlMgTk/ks9HesL
 RfYVq5wOy3qIpocdjdlXnSUKn0WOkGBBd8Nv3o0OI18tiJ1S/QwLBBfZoVvfGinoB2p4j/wO
 kJxpi3F9TaOtLGcdrgfghg31Fb48DP+6kodZ4ircerp4hyAp0U2iKtsrQ/sVWR4mbe3eTfcn
 YjBxGd2JOVdNQZa2VTNf9GshIDMD8IIQK6jN0LfY8Py2uQENBFhb4C8BCAC/0KWY3pIbU2cy
 i7GMj3gqB6h0jGqRuMpMRoSNDoAUIuSh17w+bawuOF6XZPdK3D4lC9cOXMwP3aP9tTJOori2
 8vMH8KW9jp9lAYnGWYhSqLdjzIACquMqi96EBtawJDct1e9pVgp+d4JXHlgIrl11ITJo8rCP
 dEqjro2bCBWxijsIncdCzMjf57+nR7u86SBtGSFcXKapS7YJeWcvM6MzFYgIkxHxxBDvBBvm
 U2/mAXiL72kwmlV1BNrabQxX2UnIb3xt3UovYJehrnDUMdYjxJgSPRBx27wQ/D05xAlhkmmL
 FJ01ZYc412CRCC6gjgFPfUi2y7YJTrQHS79WSyANABEBAAGJAR8EGAEIAAkFAlhb4C8CGwwA
 CgkQLVgVyYwUtuM72Qf+J6JOQ/27pWf5Ulde9GS0BigA1kV9CNfIq396TgvQzeyixHMvgPdq
 Z36x89zZi0otjMZv6ypIdEg5co1Bvz0wFaKbCiNbTjpnA1VAbQVLSFjCZLQiu0vc+BZ1yKDV
 T5ASJ97G4XvQNO+XXGY55MrmhoNqMaeIa/3Jas54fPVd5olcnUAyDty29/VWXNllUq38iBCX
 /0tTF7oav1lzPGfeW2c6B700FFZMTR4YBVSGE8jPIzu2Fj0E8EkDmsgS+nibqSvWXfo1v231
 410h35CjbYDlYQO7Z1YD7asqbaOnF0As+rckyRMweQ9CxZn5+YBijtPJA3x5ldbCfQ9rWiTu XQ==
Message-ID: <41187639-f077-0212-aa02-d5dcc96c442b@amd.com>
Date:   Fri, 24 Jan 2020 09:55:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200124000643.99859-1-lyude@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN6PR17CA0026.namprd17.prod.outlook.com
 (2603:10b6:405:75::15) To CY4PR1201MB0230.namprd12.prod.outlook.com
 (2603:10b6:910:1e::7)
MIME-Version: 1.0
Received: from [172.31.7.234] (165.204.84.11) by BN6PR17CA0026.namprd17.prod.outlook.com (2603:10b6:405:75::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Fri, 24 Jan 2020 14:55:56 +0000
X-Originating-IP: [165.204.84.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3ef5b1c1-57c3-4ca2-8c73-08d7a0dd87f1
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2487:|CY4PR1201MB2487:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB2487DB63BD1A1FAFB3CBC30A8C0E0@CY4PR1201MB2487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 02929ECF07
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(189003)(199004)(316002)(16576012)(4326008)(54906003)(5660300002)(6486002)(7416002)(36756003)(956004)(53546011)(26005)(16526019)(186003)(31696002)(2616005)(52116002)(31686004)(478600001)(2906002)(45080400002)(66476007)(81156014)(8936002)(8676002)(66946007)(81166006)(66556008)(15650500001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR1201MB2487;H:CY4PR1201MB0230.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3aX7LpUWp1TTu7P8P9ZbDOadAeyks44+xBgSfZdP5KJ8SMT3ZDWcFWdNVgIAafF2KtmQP8bh8QLV9+zd5Ez1gc4SmVrGx6E0f9eqP30MDh9HZAdm5HGSJR40BQksf0M/wj98Zakh7sCK6SJYSjStDM9fTISlSII5509m5FUjt/qdlHRpXr4rP6k8brDpAh0DEzDkPIV63USu/j1IDDluK/HjgwBiJnUF85a/uQPNNSQjmYS47+Gbx/19/IwZtzvbbxwt5shjQtNVmqSX5sJ/jS5hTlIeT9Jz+K8LybuiAf1eqn9k3erVs80zDgARin0HB+MJKS32tRsKSjTppQAFKDqXklbJDdiVFc71opF0IgTubdHZoBB+T6PY4sleprUGKB0PXinCamOE+TlVmgyfrKFfEBC0dkUv968bInajEYOiHOcWUANddX4kvLJJj0gq
X-MS-Exchange-AntiSpam-MessageData: tIJUJheGsHyjOnskux/bVeoetxZ+CHMbbaUL6786+BZ8aoT38MCJMA+bbaVj/xCSYC3YruhQq841dOhWdbCNlM85O4E33Zo4J/8Q4FMl1qsXtddUg+uNZdaUqRtLurtDa0GHUK4Qrj32GF2RPrIu2Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ef5b1c1-57c3-4ca2-8c73-08d7a0dd87f1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2020 14:56:02.7644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O5U+EScVazYoQeeEhiWa2pV26LM7txyXCwCbmKrpYNUZbZClNlph792Duz0arRxPwsSWNJTtIShYzF5djP1Cpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2487
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-01-23 7:06 p.m., Lyude Paul wrote:
> Disabling a display on MST can potentially happen after the entire MST
> topology has been removed, which means that we can't communicate with
> the topology at all in this scenario. Likewise, this also means that we
> can't properly update payloads on the topology and as such, it's a good
> idea to ignore payload update failures when disabling displays.
> Currently, amdgpu makes the mistake of halting the payload update
> process when any payload update failures occur, resulting in leaving
> DC's local copies of the payload tables out of date.
> 
> This ends up causing problems with hotplugging MST topologies, and
> causes modesets on the second hotplug to fail like so:
> 
> [drm] Failed to updateMST allocation table forpipe idx:1
> ------------[ cut here ]------------
> WARNING: CPU: 5 PID: 1511 at
> drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link.c:2677
> update_mst_stream_alloc_table+0x11e/0x130 [amdgpu]
> Modules linked in: cdc_ether usbnet fuse xt_conntrack nf_conntrack
> nf_defrag_ipv6 libcrc32c nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4
> nft_counter nft_compat nf_tables nfnetlink tun bridge stp llc sunrpc
> vfat fat wmi_bmof uvcvideo snd_hda_codec_realtek snd_hda_codec_generic
> snd_hda_codec_hdmi videobuf2_vmalloc snd_hda_intel videobuf2_memops
> videobuf2_v4l2 snd_intel_dspcfg videobuf2_common crct10dif_pclmul
> snd_hda_codec videodev crc32_pclmul snd_hwdep snd_hda_core
> ghash_clmulni_intel snd_seq mc joydev pcspkr snd_seq_device snd_pcm
> sp5100_tco k10temp i2c_piix4 snd_timer thinkpad_acpi ledtrig_audio snd
> wmi soundcore video i2c_scmi acpi_cpufreq ip_tables amdgpu(O)
> rtsx_pci_sdmmc amd_iommu_v2 gpu_sched mmc_core i2c_algo_bit ttm
> drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec drm
> crc32c_intel serio_raw hid_multitouch r8152 mii nvme r8169 nvme_core
> rtsx_pci pinctrl_amd
> CPU: 5 PID: 1511 Comm: gnome-shell Tainted: G           O      5.5.0-rc7Lyude-Test+ #4
> Hardware name: LENOVO FA495SIT26/FA495SIT26, BIOS R12ET22W(0.22 ) 01/31/2019
> RIP: 0010:update_mst_stream_alloc_table+0x11e/0x130 [amdgpu]
> Code: 28 00 00 00 75 2b 48 8d 65 e0 5b 41 5c 41 5d 41 5e 5d c3 0f b6 06
> 49 89 1c 24 41 88 44 24 08 0f b6 46 01 41 88 44 24 09 eb 93 <0f> 0b e9
> 2f ff ff ff e8 a6 82 a3 c2 66 0f 1f 44 00 00 0f 1f 44 00
> RSP: 0018:ffffac428127f5b0 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: ffff8d1e166eee80 RCX: 0000000000000000
> RDX: ffffac428127f668 RSI: ffff8d1e166eee80 RDI: ffffac428127f610
> RBP: ffffac428127f640 R08: ffffffffc03d94a8 R09: 0000000000000000
> R10: ffff8d1e24b02000 R11: ffffac428127f5b0 R12: ffff8d1e1b83d000
> R13: ffff8d1e1bea0b08 R14: 0000000000000002 R15: 0000000000000002
> FS:  00007fab23ffcd80(0000) GS:ffff8d1e28b40000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f151f1711e8 CR3: 00000005997c0000 CR4: 00000000003406e0
> Call Trace:
>  ? mutex_lock+0xe/0x30
>  dc_link_allocate_mst_payload+0x9a/0x210 [amdgpu]
>  ? dm_read_reg_func+0x39/0xb0 [amdgpu]
>  ? core_link_enable_stream+0x656/0x730 [amdgpu]
>  core_link_enable_stream+0x656/0x730 [amdgpu]
>  dce110_apply_ctx_to_hw+0x58e/0x5d0 [amdgpu]
>  ? dcn10_verify_allow_pstate_change_high+0x1d/0x280 [amdgpu]
>  ? dcn10_wait_for_mpcc_disconnect+0x3c/0x130 [amdgpu]
>  dc_commit_state+0x292/0x770 [amdgpu]
>  ? add_timer+0x101/0x1f0
>  ? ttm_bo_put+0x1a1/0x2f0 [ttm]
>  amdgpu_dm_atomic_commit_tail+0xb59/0x1ff0 [amdgpu]
>  ? amdgpu_move_blit.constprop.0+0xb8/0x1f0 [amdgpu]
>  ? amdgpu_bo_move+0x16d/0x2b0 [amdgpu]
>  ? ttm_bo_handle_move_mem+0x118/0x570 [ttm]
>  ? ttm_bo_validate+0x134/0x150 [ttm]
>  ? dm_plane_helper_prepare_fb+0x1b9/0x2a0 [amdgpu]
>  ? _cond_resched+0x15/0x30
>  ? wait_for_completion_timeout+0x38/0x160
>  ? _cond_resched+0x15/0x30
>  ? wait_for_completion_interruptible+0x33/0x190
>  commit_tail+0x94/0x130 [drm_kms_helper]
>  drm_atomic_helper_commit+0x113/0x140 [drm_kms_helper]
>  drm_atomic_helper_set_config+0x70/0xb0 [drm_kms_helper]
>  drm_mode_setcrtc+0x194/0x6a0 [drm]
>  ? _cond_resched+0x15/0x30
>  ? mutex_lock+0xe/0x30
>  ? drm_mode_getcrtc+0x180/0x180 [drm]
>  drm_ioctl_kernel+0xaa/0xf0 [drm]
>  drm_ioctl+0x208/0x390 [drm]
>  ? drm_mode_getcrtc+0x180/0x180 [drm]
>  amdgpu_drm_ioctl+0x49/0x80 [amdgpu]
>  do_vfs_ioctl+0x458/0x6d0
>  ksys_ioctl+0x5e/0x90
>  __x64_sys_ioctl+0x16/0x20
>  do_syscall_64+0x55/0x1b0
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x7fab2121f87b
> Code: 0f 1e fa 48 8b 05 0d 96 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff
> ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
> f0 ff ff 73 01 c3 48 8b 0d dd 95 2c 00 f7 d8 64 89 01 48
> RSP: 002b:00007ffd045f9068 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007ffd045f90a0 RCX: 00007fab2121f87b
> RDX: 00007ffd045f90a0 RSI: 00000000c06864a2 RDI: 000000000000000b
> RBP: 00007ffd045f90a0 R08: 0000000000000000 R09: 000055dbd2985d10
> R10: 000055dbd2196280 R11: 0000000000000246 R12: 00000000c06864a2
> R13: 000000000000000b R14: 0000000000000000 R15: 000055dbd2196280
> ---[ end trace 6ea888c24d2059cd ]---
> 
> Note as well, I have only been able to reproduce this on setups with 2
> MST displays.
> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Cc: stable@vger.kernel.org

LGTM but would like Mikita or Wayne to have a look as well.
Acked-by: Harry Wentland <harry.wentland@amd.com>

Harry

> ---
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> index 069b7a6f5597..252fa60c6775 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> @@ -216,6 +216,7 @@ bool dm_helpers_dp_mst_write_payload_allocation_table(
>  		drm_dp_mst_reset_vcpi_slots(mst_mgr, mst_port);
>  	}
>  
> +	/* If disabling, it's OK for this to fail */
>  	ret = drm_dp_update_payload_part1(mst_mgr);
>  
>  	/* mst_mgr->->payloads are VC payload notify MST branch using DPCD or
> @@ -225,7 +226,7 @@ bool dm_helpers_dp_mst_write_payload_allocation_table(
>  
>  	get_payload_table(aconnector, proposed_table);
>  
> -	if (ret)
> +	if (ret && !enable)
>  		return false;
>  
>  	return true;
> @@ -299,9 +300,9 @@ bool dm_helpers_dp_mst_send_payload_allocation(
>  	if (!mst_mgr->mst_state)
>  		return false;
>  
> +	/* If disabling, it's OK for this to fail */
>  	ret = drm_dp_update_payload_part2(mst_mgr);
> -
> -	if (ret)
> +	if (enable && ret)
>  		return false;
>  
>  	if (!enable)
> 
