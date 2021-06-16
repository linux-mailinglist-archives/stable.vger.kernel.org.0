Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB423AA4C0
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 21:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhFPT4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 15:56:09 -0400
Received: from mail-sn1anam02on2074.outbound.protection.outlook.com ([40.107.96.74]:55650
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233128AbhFPT4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 15:56:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOHfcCq4gYAuiyVFy0uqH/mvF7Wt7HLvOZrjPjhJ+Cfra9Pu0EomeSy2YAAdX8H+rleDJsgGg5VoRMYA9qN+XdyV0Jnv3zcODAuOTEnYeBYECDXowcFnasvJ3J+2j0DI+D6GSibyMt7ivT4N06E3XPQ29giG6nJVUlAjgm1pPoItVOEWHvv0hS8ljD2GNlMFR1hpLf5wG1QcHqPDGUsmjSFB/eWShdCB/QtNNJmf/AB+GCgP2Eajk0f8wwxB4sJpX74co68NY8X59CDiknITlFMgafsjx6r8Bjc3jEfQRjC8RtreMRTxOo41LP70RMHZDvogBaoD+/0o53aXxeJxaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+oSEArtS4aZlHubgjWz74T+HSs18L+WVwNLSxgNdkM=;
 b=e7Rr8xUf+hYp9OVfPrfurPK1JHfh67BLTX7fTKo7+lMEjQyFpxCp306ERlI8mCKdorzQGD1QmmnXnytxvZY64NopahekB2CDO2EuazMnCAYOHsUVNzOqNaqwX9JVRf8vulhCAtuDafHAV0n2ImDKloIRtZLQbweNCY6Ra4MNvpTq0NAuq3bxXvoxHpwoLt7v6Oun7vnSLGrgHLqZgdHS2ae41xgmFR8Xvj6PDrhdDSPmtA2wWCN/s7KuysqBsIZq3Qs75ZkrisvWUHKkJsEH4XK/F04OvmEsiCsiSVI3FliAYWh4I6hseBbzLyAxZElXiWnAu75VSn7JEbQKqWt/VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+oSEArtS4aZlHubgjWz74T+HSs18L+WVwNLSxgNdkM=;
 b=OZzznk6o4h9cy55akfkNDQxo+kTe+z1tqznjJcNBsj5VMBr2vChH0N9iaRcxpGEdGkKVi0CDynvLpW1RoGFHVIODAa90ijbmaUNN79UNLRVoGPv2pDTWoYg/eDKHmMmVhPKyFqq6EpasLTKXBLzMZe90bUZ2ocRMlNoetUPy8UI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CO6PR12MB5427.namprd12.prod.outlook.com (2603:10b6:5:358::13)
 by CO6PR12MB5396.namprd12.prod.outlook.com (2603:10b6:303:139::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16; Wed, 16 Jun
 2021 19:54:00 +0000
Received: from CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::401d:c7a2:6495:650b]) by CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::401d:c7a2:6495:650b%3]) with mapi id 15.20.4242.019; Wed, 16 Jun 2021
 19:53:59 +0000
Subject: Re: [PATCH v2 1/2] drm/dp_mst: Do not set proposed vcpi directly
To:     Wayne Lin <Wayne.Lin@amd.com>, dri-devel@lists.freedesktop.org
Cc:     lyude@redhat.com, Nicholas.Kazlauskas@amd.com, jerry.zuo@amd.com,
        aurabindo.pillai@amd.com,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>, stable@vger.kernel.org
References: <20210616035501.3776-1-Wayne.Lin@amd.com>
 <20210616035501.3776-2-Wayne.Lin@amd.com>
From:   Harry Wentland <harry.wentland@amd.com>
Message-ID: <b9eeec7d-c080-3c7f-706b-ce11c8533d16@amd.com>
Date:   Wed, 16 Jun 2021 15:53:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
In-Reply-To: <20210616035501.3776-2-Wayne.Lin@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [198.200.67.154]
X-ClientProxiedBy: YQBPR0101CA0158.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::31) To CO6PR12MB5427.namprd12.prod.outlook.com
 (2603:10b6:5:358::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.3] (198.200.67.154) by YQBPR0101CA0158.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:e::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 19:53:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ead0e22-6d12-498e-2bf0-08d931007baf
X-MS-TrafficTypeDiagnostic: CO6PR12MB5396:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR12MB5396249BE90D9A3C2DEAC3FC8C0F9@CO6PR12MB5396.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:36;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PhOQmXAgYIaXCp8zPhZU7qpqKFkqbSrW1DewCxDBEns22PNGXc+9UP1qlhalCFUw2zOPoQXxHJpOc4VWVsislLURu1bYQ7fH+3UZ06Wu6Fe3VuPHry8BoHDQf4Ke75qpVAEijYffQLIxAxMR01lQ89awhdUHWiWmidXqGmkSQkR4NPHFY0EDmxHGdngW1GwkkXHq+8yqU0qffWJm0KKoR5YhDXQAR1xOA/pGRd7IcLUDCtimPODuLfFZEsu5MnEOPeWBDilWPe08+kUL1skR6CoA/XUdyzQLhIHGbgy5F0AeA3ZEmCloTQvI8jYXvgjmQwNlHE1i5Hkns1jvS9V5tEVDmvGRv8GBSy/S87dcpAku6vKmtGFWczYA3n7btdn6ZsINHRJ1rNW4J4nlM53/jwRvHNr/ceRq/dLDDJXTeBW6Mp60KHIAgNtcfvjZaXPP7K5MG2W8ve/DCEcviBHun1a54xJPTe/4v13RP6Qi2E8u5xAburBjWrzmfCdq3/kRahBIN2hOYvpQTO3Zyi5V0tFSaduA/tIrNXcVAEkUgpWNbQN9u4zVDiKybCc5MyrkkxGNBZ4rNzmNWs+2FU37MN+y46ytEVTQmI8zhKKhn9z5vX0divyDJeqvhcMEzE5SvmkMLhIFiwsGUn6pIPYODeyEnG1wTy4F8PygQE8MaDVy/n3dVL6h1AyUomq3NOsf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5427.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(36756003)(8936002)(2906002)(83380400001)(4326008)(44832011)(54906003)(86362001)(956004)(38100700002)(26005)(6666004)(66556008)(66476007)(8676002)(478600001)(53546011)(2616005)(16526019)(16576012)(186003)(316002)(5660300002)(31696002)(31686004)(66946007)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVVNU0RUZkdyS1VlN2xIRXNFSHk4cWwrT3I4RmJSMVhuVTM5WjBKSGJaT2hy?=
 =?utf-8?B?S3AvVjYydkFrUDQzVjdHWFVHOXlWNlVrbU44UXpsK3dZYmZJYmU0VktHdnpV?=
 =?utf-8?B?eXRTcHI0YW8zamtMaFhkaDJVOFViM1lLaXl5WTNqYkVVZWhIY282S0duaGc4?=
 =?utf-8?B?OGhrdVJqZmFCbXpmSEZwL0FCZkhxRVA1d2ZKYzNnVG5oNDZOdWRQWUxuZDIy?=
 =?utf-8?B?TnphY1FRVWZFbytXSmJaaGJaZm9GMkJpSHpwUGtyM2ZCa0V5L2NBZ1lBVW5C?=
 =?utf-8?B?ai83cHdIdjNHUzNLZndsdDFUYmcyN0VldDlhR2RkbFI5ZzFpT2wxVUlueE5k?=
 =?utf-8?B?S29rZVlmSE9sbW9RQ2xKaHhVT0tkdnlUOFI1MGl3eVp2YkQrN3JHd1BYcXBM?=
 =?utf-8?B?RkdLSjdhM2hMNjJrczh6aWt3OEN5UzNQR3dmN0pFQ09Lci9hVXZDTjA0Vi9w?=
 =?utf-8?B?T1A0OUVQMUxReFFaWlhoWGFDendMaHN0Q0JtVXRxTFE1N3J5anF2aTRYME94?=
 =?utf-8?B?bXFnSEJLUFlveXFxOTF4Lzh6S3RKNmsveXRxVkt3WGx2RlhuMFJLdGRhSmFh?=
 =?utf-8?B?ZFEvanpudytqMzJOS3JxbHNOdDd3eUJ1RHJGQUlqbmpEN04vQ2l2RDcwVldh?=
 =?utf-8?B?Ykc1QTk1Rmpaa3B3d3U3NldDVm1vMkJyUlA5OWdnN01tcHZVVHp5bGl0TEw5?=
 =?utf-8?B?UTNWaHc5THhjMDBvM3NjM2Y4Yzc2UmY3ZEpTTUxkSUNMS2tPQ09zR0lERmho?=
 =?utf-8?B?SHAwdUV3RzAyWmZjNXBsdFE2cER4YTFKRklScVpmNTlMaDZZNTlQS0loTk12?=
 =?utf-8?B?amN0bE83ZTlaSXU2djBIUFRKMXlRVzdRbEdNUCswVFZidjBDVWlQV3ZYaW5T?=
 =?utf-8?B?ajF4VUs4R2FqWUVhVU1vMzdWZHlDckpZREI1dXNKbTNmNklUTnNYZG9EcUJp?=
 =?utf-8?B?RHc2QW41VlRseXhudGVxcVZ3clg0RnM3cmZyOWJZZnQrQnBOL2NVQ092NzZC?=
 =?utf-8?B?UWRHV1gzWW0xWHQ3NUFBQi9yUHFkQ0l1c1lrWS85aHdVZDcxVWF5a1IrMmcz?=
 =?utf-8?B?TlZhbWpHT0Q5N0RVcFJqUWZLOXUwaUMvUEZtcUJ6NWFCM1BEcVBnalIzMVNL?=
 =?utf-8?B?OW1RVFpZTDRHMDFZSkZhczBqdjMvZmgzMm12WDQrSjkrQVJMb1FkLytzaG1q?=
 =?utf-8?B?OWovU1R6SXVoR0h5TE5pMExwK2E5dVVzOCtQeEthbFpReHVSTHlPanNzZGZt?=
 =?utf-8?B?WjJwWVM1elIzcFRyUlJZU1NMaGVzSno5ZzlIbzllYm9CamZZT21Hem5ydXNS?=
 =?utf-8?B?VWFyUFBHUlloMWZ1ZERpMUFFdHBEY3JEejI3STIrdGJ4M2pyK252a1ZxNk9V?=
 =?utf-8?B?QzE5WDI5bmxYakdHQXMzMXpSVDR5R0ZRQStxUndKZWtvdHA3TG85bnBCUEF3?=
 =?utf-8?B?bnJDWVNram8xYzR6aDhPdHk4NGFyUlljS3cya1NkUTZhRlhDbGtlb2xnM1Vv?=
 =?utf-8?B?RlBhMGp1alRtVDQzZlJSaG9sWFhENCsrZGpvcFkzQ0F1VXJ2TklxbXhLbGRx?=
 =?utf-8?B?bWRwSGhHL0lrYnpFdVNvOEV6L1QyY2FBcktlRHU0THVzZGhXdFBYKzE3Tllh?=
 =?utf-8?B?b2IwaXpVQVk2OWN1R01WY1JmYzQ0OE9ocGVRRExWWm5jZkJxbE9qR1NxdGJV?=
 =?utf-8?B?N1cvTVZyNHBzZ3hBSTBGRDNaeHM4V2RvLzB3VVYvWmdBdll3eTlXaklVaGw2?=
 =?utf-8?Q?EejVaP7bUayYE6K1bE8l4jMo2RxMBkLZ79CHC19?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ead0e22-6d12-498e-2bf0-08d931007baf
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5427.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 19:53:59.8267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5UzuRNLACerzNwi7iQ09PB0q24vWhiiaQcZZ3fmNBIExt0/3e2BGvgSETmom8st2198XvTyIA87lBPAK+5ZH9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5396
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2021-06-15 11:55 p.m., Wayne Lin wrote:
> [Why]
> When we receive CSN message to notify one port is disconnected, we will
> implicitly set its corresponding num_slots to 0. Later on, we will
> eventually call drm_dp_update_payload_part1() to arrange down streams.
> 
> In drm_dp_update_payload_part1(), we iterate over all proposed_vcpis[]
> to do the update. Not specific to a target sink only. For example, if we
> light up 2 monitors, Monitor_A and Monitor_B, and then we unplug
> Monitor_B. Later on, when we call drm_dp_update_payload_part1() to try
> to update payload for Monitor_A, we'll also implicitly clean payload for
> Monitor_B at the same time. And finally, when we try to call
> drm_dp_update_payload_part1() to clean payload for Monitor_B, we will do
> nothing at this time since payload for Monitor_B has been cleaned up
> previously.
> 
> For StarTech 1to3 DP hub, it seems like if we didn't update DPCD payload
> ID table then polling for "ACT Handled"(BIT_1 of DPCD 002C0h) will fail
> and this polling will last for 3 seconds.
> 
> Therefore, guess the best way is we don't set the proposed_vcpi[]
> diretly. Let user of these herlper functions to set the proposed_vcpi
> directly.
> 
> [How]
> 1. Revert commit 7617e9621bf2 ("drm/dp_mst: clear time slots for ports
> invalid")
> 2. Tackle the issue in previous commit by skipping those trasient
> proposed VCPIs. These stale VCPIs shoulde be explicitly cleared by
> user later on.
> 
> Changes since v1:
> * Change debug macro to use drm_dbg_kms() instead
> * Amend the commit message to add Fixed & Cc tags
> 
> Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> Fixes: 7617e9621bf2 ("drm/dp_mst: clear time slots for ports invalid")
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Wayne Lin <Wayne.Lin@amd.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: dri-devel@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v5.5+
> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c | 36 ++++++++-------------------
>  1 file changed, 10 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
> index 32b7f8983b94..b41b837db66d 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -2501,7 +2501,7 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
>  {
>  	struct drm_dp_mst_topology_mgr *mgr = mstb->mgr;
>  	struct drm_dp_mst_port *port;
> -	int old_ddps, old_input, ret, i;
> +	int old_ddps, ret;
>  	u8 new_pdt;
>  	bool new_mcs;
>  	bool dowork = false, create_connector = false;
> @@ -2533,7 +2533,6 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
>  	}
>  
>  	old_ddps = port->ddps;
> -	old_input = port->input;
>  	port->input = conn_stat->input_port;
>  	port->ldps = conn_stat->legacy_device_plug_status;
>  	port->ddps = conn_stat->displayport_device_plug_status;
> @@ -2555,28 +2554,6 @@ drm_dp_mst_handle_conn_stat(struct drm_dp_mst_branch *mstb,
>  		dowork = false;
>  	}
>  
> -	if (!old_input && old_ddps != port->ddps && !port->ddps) {
> -		for (i = 0; i < mgr->max_payloads; i++) {
> -			struct drm_dp_vcpi *vcpi = mgr->proposed_vcpis[i];
> -			struct drm_dp_mst_port *port_validated;
> -
> -			if (!vcpi)
> -				continue;
> -
> -			port_validated =
> -				container_of(vcpi, struct drm_dp_mst_port, vcpi);
> -			port_validated =
> -				drm_dp_mst_topology_get_port_validated(mgr, port_validated);
> -			if (!port_validated) {
> -				mutex_lock(&mgr->payload_lock);
> -				vcpi->num_slots = 0;
> -				mutex_unlock(&mgr->payload_lock);
> -			} else {
> -				drm_dp_mst_topology_put_port(port_validated);
> -			}
> -		}
> -	}
> -
>  	if (port->connector)
>  		drm_modeset_unlock(&mgr->base.lock);
>  	else if (create_connector)
> @@ -3410,8 +3387,15 @@ int drm_dp_update_payload_part1(struct drm_dp_mst_topology_mgr *mgr)
>  				port = drm_dp_mst_topology_get_port_validated(
>  				    mgr, port);
>  				if (!port) {
> -					mutex_unlock(&mgr->payload_lock);
> -					return -EINVAL;
> +					if (vcpi->num_slots == payload->num_slots) {
> +						cur_slots += vcpi->num_slots;
> +						payload->start_slot = req_payload.start_slot;
> +						continue;
> +					} else {
> +						drm_dbg_kms("Fail:set payload to invalid sink");

drm_dbg_kms takes a drm_device as first parameter.

Harry

> +						mutex_unlock(&mgr->payload_lock);
> +						return -EINVAL;
> +					}
>  				}
>  				put_port = true;
>  			}
> 

