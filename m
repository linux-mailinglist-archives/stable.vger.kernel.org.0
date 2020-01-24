Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C79148EA2
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 20:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390466AbgAXTUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 14:20:34 -0500
Received: from mail-bn8nam11on2056.outbound.protection.outlook.com ([40.107.236.56]:58229
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387683AbgAXTUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 14:20:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AsX6BFoRUZwn0iw72ZYRqdBMvRNpGr6QsUQBAr6lwEuE8mL8T/YEPB5jgbRyw0Keqp3BeqdlmBXW+TS4TUJHL1wWrNsWwKMgInWG35Cfqfw/9Kh0WwPb04ODdaib9POnMFJUDjfGkLCFeznMjOxd4KGd1XUtQW+2LyLNcyPh7tUvfuyCra+yoZRATCWroJf+O2Rz+0L1wgH8SCAjgY0cfv5itmQPofjRbQiC4yP0T1uExs9Vxb+3tZ3njFA5+Ht4cEZ0hJi4nEZ89pjM9opVOMR0b7zRfBy66Gd6/yn0mVLUMIsfQ4fF2T3ceP2NDirs70TioTQjBAYofPVLRHznZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2mZs5WlFaz3tkODBem6We1gPHN7i2iAXaMa+aS8XgY=;
 b=VfH/QvG6GjJf9ZYQldLnaj+4zzPA9a/Y75ADdNHcYX0wpiGdscASnogakshuu0S+JJU/velKY6Ez41lbhPUZLKfSZFBEXJMr9sHhvg41gwRzKMoxI5uT8uBv//+usQPZlhyDHSL2UAZJsTv9kLD5jel3YfKED8YEhBj1o1hvPenyn8gJlwz4m9ZUsy2XNANBjMionU9qBoanpESZwZGidWEL9+8qPqUUsLDrP6MYcjl2gnaEg7aH1V+NpG2Z+c1pH/OPx9e1EEGQrQtgWAOiB9QU35AFCRT+3nFE7ndaa2C+/MtdAN5OmCW0p4h30oOqwO8Aw1MLGfzs/v/zDULzRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i2mZs5WlFaz3tkODBem6We1gPHN7i2iAXaMa+aS8XgY=;
 b=Ffw+RR9UbUCKc3WxU1NLVpqwBjqLeJkw5Cuq7hsLcCaLxKkGYgnFRg8sIK9pAxbOdVyEvJZVWe6iKG6nn+z9ueCBhZC/MLfgkXUBMeCISHFq3fWWRdRs201vTVnPgshz8JCaFY0DA2p+3NTMoVcqsQbf2QPrNPTzFBaHh1G/688=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Mikita.Lipski@amd.com; 
Received: from DM6PR12MB2906.namprd12.prod.outlook.com (20.179.71.212) by
 DM6PR12MB2620.namprd12.prod.outlook.com (20.176.118.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Fri, 24 Jan 2020 19:20:23 +0000
Received: from DM6PR12MB2906.namprd12.prod.outlook.com
 ([fe80::c4f1:5ec7:7314:75bf]) by DM6PR12MB2906.namprd12.prod.outlook.com
 ([fe80::c4f1:5ec7:7314:75bf%7]) with mapi id 15.20.2644.028; Fri, 24 Jan 2020
 19:20:23 +0000
Subject: Re: [PATCH v2] drm/amd/dm/mst: Ignore payload update failures
To:     Lyude Paul <lyude@redhat.com>, amd-gfx@lists.freedesktop.org
Cc:     Harry Wentland <harry.wentland@amd.com>, stable@vger.kernel.org,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        "David (ChunMing) Zhou" <David1.Zhou@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Martin Tsai <martin.tsai@amd.com>,
        David Francis <David.Francis@amd.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Alvin Lee <alvin.lee2@amd.com>,
        Jean Delvare <jdelvare@suse.de>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20200124000643.99859-1-lyude@redhat.com>
 <20200124191047.120064-1-lyude@redhat.com>
From:   Mikita Lipski <mlipski@amd.com>
Organization: AMD
Message-ID: <abc8346d-2b27-7f8f-a54d-9f22cba82b84@amd.com>
Date:   Fri, 24 Jan 2020 14:20:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200124191047.120064-1-lyude@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT1PR01CA0029.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::42)
 To DM6PR12MB2906.namprd12.prod.outlook.com (2603:10b6:5:15f::20)
MIME-Version: 1.0
Received: from [172.29.224.72] (165.204.55.250) by YT1PR01CA0029.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Fri, 24 Jan 2020 19:20:22 +0000
X-Originating-IP: [165.204.55.250]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e748da3b-a395-4894-c506-08d7a1027588
X-MS-TrafficTypeDiagnostic: DM6PR12MB2620:|DM6PR12MB2620:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB26204E4D80188498E642867FE40E0@DM6PR12MB2620.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 02929ECF07
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(189003)(199004)(8936002)(36756003)(8676002)(81156014)(81166006)(66946007)(66476007)(66556008)(52116002)(15650500001)(6486002)(45080400002)(53546011)(31696002)(16526019)(26005)(186003)(2906002)(478600001)(31686004)(956004)(5660300002)(316002)(16576012)(36916002)(4326008)(54906003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2620;H:DM6PR12MB2906.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YvvQgmwpzGMSQ4VExK7BOiexfaH9D3v+BW/s6GAS0MBk/9Tqe4MqmdTYpoK8XRPEQZB/BhbvYJXh+gwt7I/JvDin5p9mVEQI6FVGKd+qgKDQFhtPK4nHz4igRe9nB3BLAssOz12AjHX6BW30+1MaxRR45JGHQ3c7dpPLRKr5IeN5ib6w1OKTHaek2g4Xuf2D3vZ+c6bRoooaUiM4nS4IoCwb8C1BM7XfYS3JNJyj0WcsICAGycODqqWR7qoTo/bngcUCvYnyjXiKec0xFCWTOZPym+JjY/u7kqZhrIqdOiAL7hdk93aDQXp9jZ6ebOdc6ZeVYSItg1Te6as7ZTfTAjM4YeTm2pPMhVpM4upOwSL/Nf5NfybopfG+sA1HLrAEUs3buG6LYxFTWCMv4dTPKcJBlnLwELOnQBAJx26Iyb9oYq6hiYuXU4qdQQBKvHgS
X-MS-Exchange-AntiSpam-MessageData: qpMluPLgUdre/VKq9eSMBZE2RRViqZPBXoncX+ECpJMphZzIWBKnLSJAKZwbXe++w1pw9Wh85XQUjakwPQWnytRrJreZdqSwZBiL+OaZnc9w5lTTrXrqFLro140OW2XwoOcQXUpG+9S9bHvaQxEnYg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e748da3b-a395-4894-c506-08d7a1027588
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2020 19:20:23.2537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZ2jj/oEseXmuzCUKDHZ+W2QDyaj2yX1CULtfoPctvZNeD5m5gK9ID1tIl16+7pI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2620
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/24/20 2:10 PM, Lyude Paul wrote:
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
>   ? mutex_lock+0xe/0x30
>   dc_link_allocate_mst_payload+0x9a/0x210 [amdgpu]
>   ? dm_read_reg_func+0x39/0xb0 [amdgpu]
>   ? core_link_enable_stream+0x656/0x730 [amdgpu]
>   core_link_enable_stream+0x656/0x730 [amdgpu]
>   dce110_apply_ctx_to_hw+0x58e/0x5d0 [amdgpu]
>   ? dcn10_verify_allow_pstate_change_high+0x1d/0x280 [amdgpu]
>   ? dcn10_wait_for_mpcc_disconnect+0x3c/0x130 [amdgpu]
>   dc_commit_state+0x292/0x770 [amdgpu]
>   ? add_timer+0x101/0x1f0
>   ? ttm_bo_put+0x1a1/0x2f0 [ttm]
>   amdgpu_dm_atomic_commit_tail+0xb59/0x1ff0 [amdgpu]
>   ? amdgpu_move_blit.constprop.0+0xb8/0x1f0 [amdgpu]
>   ? amdgpu_bo_move+0x16d/0x2b0 [amdgpu]
>   ? ttm_bo_handle_move_mem+0x118/0x570 [ttm]
>   ? ttm_bo_validate+0x134/0x150 [ttm]
>   ? dm_plane_helper_prepare_fb+0x1b9/0x2a0 [amdgpu]
>   ? _cond_resched+0x15/0x30
>   ? wait_for_completion_timeout+0x38/0x160
>   ? _cond_resched+0x15/0x30
>   ? wait_for_completion_interruptible+0x33/0x190
>   commit_tail+0x94/0x130 [drm_kms_helper]
>   drm_atomic_helper_commit+0x113/0x140 [drm_kms_helper]
>   drm_atomic_helper_set_config+0x70/0xb0 [drm_kms_helper]
>   drm_mode_setcrtc+0x194/0x6a0 [drm]
>   ? _cond_resched+0x15/0x30
>   ? mutex_lock+0xe/0x30
>   ? drm_mode_getcrtc+0x180/0x180 [drm]
>   drm_ioctl_kernel+0xaa/0xf0 [drm]
>   drm_ioctl+0x208/0x390 [drm]
>   ? drm_mode_getcrtc+0x180/0x180 [drm]
>   amdgpu_drm_ioctl+0x49/0x80 [amdgpu]
>   do_vfs_ioctl+0x458/0x6d0
>   ksys_ioctl+0x5e/0x90
>   __x64_sys_ioctl+0x16/0x20
>   do_syscall_64+0x55/0x1b0
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
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
> Changes since v1:
> * Don't return false when part 1 or part 2 of updating the payloads
>    fails, we don't want to abort at any step of the process even if
>    things fail
> 
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Acked-by: Harry Wentland <harry.wentland@amd.com>
> Cc: stable@vger.kernel.org
> ---
>   .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c   | 13 ++++---------
>   1 file changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> index 069b7a6f5597..318b474ff20e 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> @@ -216,7 +216,8 @@ bool dm_helpers_dp_mst_write_payload_allocation_table(
>   		drm_dp_mst_reset_vcpi_slots(mst_mgr, mst_port);
>   	}
>   
> -	ret = drm_dp_update_payload_part1(mst_mgr);
> +	/* It's OK for this to fail */
> +	drm_dp_update_payload_part1(mst_mgr);
>   
>   	/* mst_mgr->->payloads are VC payload notify MST branch using DPCD or
>   	 * AUX message. The sequence is slot 1-63 allocated sequence for each
> @@ -225,9 +226,6 @@ bool dm_helpers_dp_mst_write_payload_allocation_table(
>   
>   	get_payload_table(aconnector, proposed_table);
>   
> -	if (ret)
> -		return false;
> -

Sorry for being picky, but I think this might cause compilation error on 
some systems for having unused variable (int ret). Its better just to 
strip out both ret integer declarations.

Otherwise the patch is good. Thanks again!

Reviewed-by: Mikita Lipski <Mikita.Lipski@amd.com>

Mikita

>   	return true;
>   }
>   
> @@ -285,7 +283,6 @@ bool dm_helpers_dp_mst_send_payload_allocation(
>   	struct amdgpu_dm_connector *aconnector;
>   	struct drm_dp_mst_topology_mgr *mst_mgr;
>   	struct drm_dp_mst_port *mst_port;
> -	int ret;
>   
>   	aconnector = (struct amdgpu_dm_connector *)stream->dm_stream_context;
>   
> @@ -299,10 +296,8 @@ bool dm_helpers_dp_mst_send_payload_allocation(
>   	if (!mst_mgr->mst_state)
>   		return false;
>   
> -	ret = drm_dp_update_payload_part2(mst_mgr);
> -
> -	if (ret)
> -		return false;
> +	/* It's OK for this to fail */
> +	drm_dp_update_payload_part2(mst_mgr);
>   
>   	if (!enable)
>   		drm_dp_mst_deallocate_vcpi(mst_mgr, mst_port);
> 
