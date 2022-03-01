Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8125E4C81A7
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 04:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbiCADf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 22:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiCADf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 22:35:26 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150070.outbound.protection.outlook.com [40.107.15.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6D17030E;
        Mon, 28 Feb 2022 19:34:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKN4yB93m7GIow1hvdHM/zd0J3HTmoLP6VR31sSobb6FdGok5L2q6NNvTVcMly7LdXVfSstsYS1tstPBtQmhSY4lrp/zIV+cY0+D6UXHM9C/XghS6YmcxLDqoAtCWnxUvX8HfUFyOKBTHEKSheorp+sQGLruj0858LPw5fQNOJmFcp6iZ8B1SJH1dToAVONzg91riyCLYVT9HDRVM4B06Wt0oWqG9D0PdFgAL2qw8aSOpKjbil0AHtu2Bf/EbAidVXit/HOmxh76mD9oRy4HkOYpPBiyXwTeaoFXq7fDCUW4rUhJZ8v01dUFh6Kb47mbWbRZPWpvISEtwlqLj+xcPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L9bAUNOJPR9gmK40TV8xVYS2UBDT8gn14L05I4EZzJA=;
 b=b05L70VVlz/GgVizYc8uLwPQSGMHffTQ8RQiWOQx5Tv9aLC8K4nEK1scnQtIx7m5A8TmEhPTiOipdPyW4UWivW3MALy7iXwhydMTDm3qThQaNQ9w5+r/eYPsYd/fbjxU5NSYcOGTOZXk6uaOkwgIdP2Z1zPoMohsZis/9THrpYc/YFz2HAdBqABGviZrvT8B15eYgPeOrkjsZNWrN8jZXcpnpINIKLw7jY1TzJAhMtlor1xDot+gSMlLWFGLSJ/7VeBabp0/ITOb/29//XyX4/ZW51xXiYfyT0uwddFo727rvLMP5O2AV30kmaB14avqU5roOHlRwsg8p6XqXfpDrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9bAUNOJPR9gmK40TV8xVYS2UBDT8gn14L05I4EZzJA=;
 b=cHJBwnfD+PlEX+bEF9f8lv/ZOu2Mczeg4S395OtZQYUjAXksT3BPyTxBc/cKgaynJO8lctRvRfMPM9D25sCVeds0iRmwjTGjTKpzjHnE9a07nN4DcqFEZne3p5PRm4bCXxazdDwESXQdI5/mF8dw8BZL6OaZRlasC0iEX4b4L8c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM7PR04MB7046.eurprd04.prod.outlook.com (2603:10a6:20b:113::22)
 by AM6PR04MB6069.eurprd04.prod.outlook.com (2603:10a6:20b:72::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Tue, 1 Mar
 2022 03:34:42 +0000
Received: from AM7PR04MB7046.eurprd04.prod.outlook.com
 ([fe80::ddca:beb1:95b0:1ae1]) by AM7PR04MB7046.eurprd04.prod.outlook.com
 ([fe80::ddca:beb1:95b0:1ae1%4]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 03:34:42 +0000
Message-ID: <f5b88701c709857489110f1b85d7a34fe1fe3082.camel@oss.nxp.com>
Subject: Re: [PATCH v2 2/2] drm/atomic: Force bridge self-refresh-exit on
 CRTC switch
From:   Liu Ying <victor.liu@oss.nxp.com>
To:     Brian Norris <briannorris@chromium.org>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>
Cc:     dri-devel@lists.freedesktop.org, Sean Paul <seanpaul@chromium.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sean Paul <sean@poorly.run>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Heiko Stuebner <heiko@sntech.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date:   Tue, 01 Mar 2022 11:34:46 +0800
In-Reply-To: <20220228122522.v2.2.Ic15a2ef69c540aee8732703103e2cff51fb9c399@changeid>
References: <20220228202532.869740-1-briannorris@chromium.org>
         <20220228122522.v2.2.Ic15a2ef69c540aee8732703103e2cff51fb9c399@changeid>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:194::15) To AM7PR04MB7046.eurprd04.prod.outlook.com
 (2603:10a6:20b:113::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 77d6a7d2-02b8-429c-0161-08d9fb346c28
X-MS-TrafficTypeDiagnostic: AM6PR04MB6069:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB6069520A925CEDCD2B2160E0D9029@AM6PR04MB6069.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xs7imqssqhHx2D5kC8K0IYjBmJdx2RjA9hn8EDm0ZAFA2YwWg/IOrZlrQcows0ewSBE610UjRgdnriZvk6svyTHG+aPDRybt5g/gJKcTHXeqKc2U6CYX9CLj7zHLgShhfpeYbj/K8GMJqIsdsMgZu+IX2m3PBvAdyJEKOMcr3PDKv9TR0m7j7Qxy6Xxfza/dQk+xrVIYeFOTMWsFclRwCu/q5dRE4923im2Ob9kmPXrpf8et8xSEdaEknfHvh3fcwkMa5K5hIBFW0HuoOHSC/Af3sD7ND7jNO/VTz8aduf4H26xEM5MDtPtc7x2hkoYFZvqUmMOO5qR1d8XL4YMO3l/mqqp6PhYUeO1UnlsJ2E3GSHlgGWWYG/lO1PNZiuQEAUxPHqKfF+VPyavJZUrgGb72fL8iPTlkJuE3TnNlj3rsmhs8HWH9NdIlMZ3UId0rLs/LSpErHb2FoibTXTowTGQm5sS6g3wCzrzqeIzS7uvjHNdPdyDJ0ZnO+kvQtDso1LVXjvRnD7pQUg/OecH3uyPKuFvciYBklapw9Il+/05WCzNem0XaobVm62YtgBP7V+PMHkQcsUzbOFXKKr4mij0xjOplZc3xsO0FIf9Tc83w4CPg0Qj3cR9ocJe0cgj/B0/noW+BR7Rc8c6SQvkRQ/SnjIkB2LhQLryS2rAELlUTsmYJCDR8boYn2ZJupV0AGrC/bkuiVV8x8bNEbuSS5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB7046.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(66476007)(54906003)(8676002)(316002)(2616005)(110136005)(8936002)(508600001)(6486002)(52116002)(4326008)(7416002)(5660300002)(6506007)(2906002)(6512007)(38100700002)(38350700002)(83380400001)(86362001)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWJSbmR5YXlHUkx3S3NvNkRGeEU3UUtzRSt5TGFmYzhyOHJndUVmUVkrdnRi?=
 =?utf-8?B?b2g3dHVLTUJVTWhycEZBRm4xb0k5am1GQ0hUWldZV2xGSUcxZG9CTWVmRE9y?=
 =?utf-8?B?SGxlMDVwUHdrWXg1UUJxTFkxdFVkaU5xNW5iOUZCSXpLZUVEdGZMUG1NemNC?=
 =?utf-8?B?THNlMVhtWFdwbmF2Q2RXU1ZlZ0w4bC9ZemVDUlM3NWg1MllacU8xZGFxZXVJ?=
 =?utf-8?B?aVNVMUNCZGQyb1lNaEdFV2w2RHA4UEtJM0JFc2hTYnZKWFVmcmNHL0tyZDRq?=
 =?utf-8?B?WHd1R3Y0UG5SRXNQN1dvNkNMNWNxNWY0QUZDdkhwVE9HU3lsNFByQVlaMnVB?=
 =?utf-8?B?cW50ay80b2tQc0JvbThpZ1lEeGw5MzlGQ3pCYVZTbG9jRXJnaGlUU2NwSHdy?=
 =?utf-8?B?N0hJY2hvQzFHdE9ZalV0cHhQQXp0aFVhUXhJcHI4MllvSlJhMUVaaDRVTGxi?=
 =?utf-8?B?OEVWdlg1RlJRQ1BYbmMrRHdweW1zQnJ4MHI0RXlOWUVPNVFqVHdValZVVHpi?=
 =?utf-8?B?MlBxSi9TNVYyZmNXdk1LSUxKbndza2FwM0gwdVBjR3BCVHlHQ1BnNXZpSW4z?=
 =?utf-8?B?ZXNMb1ZzaUZpaDlxTXBMWTBFTHI2b29NVFFUWUJDT3pyYitnSWROdit1aE1p?=
 =?utf-8?B?SWVORHVtOFNVS1pvd1BlZmQzVDVhQzl5MnQzRFVETmRveUVHb3A1L1dUOTR3?=
 =?utf-8?B?aE5XOFFyMmZrOFBQOUkwZGtMU1lad3NGeHVoTGprampFR3g3MkkxOXNyZXIv?=
 =?utf-8?B?MTRNam1Ic1Y5dGxJeFBGMzJQRE9zSjRoUS9ZaWtXdTVqOG1abVFQTnhyZW04?=
 =?utf-8?B?NHpiK2JPT041UnovZlprRTJlUk5mVEpaTDdWeUI0aDJwWlh0OU4yUzFjL3px?=
 =?utf-8?B?dnZBMU5ENlZpMXI2aU84YWU1d0hQRG1hMG1aQmQ0d21NRm9wMHFub3lHNS9n?=
 =?utf-8?B?SWhtcXN2emdXVlpVS3E4ZWhXN21VSCtBL0JhUHUxL0FYckU0RmZIekN1Uy90?=
 =?utf-8?B?YmpyMkk0dE0remFZVjJRTjRscTd6V1BPNHVBYkFMTUIrUXAyM1JzVlg1UDdX?=
 =?utf-8?B?Smx6aXFEeWx2U1haR3h2NWRFejNKYkZmRWVCRWt6SU5KUjNDdlh5L21DRzNu?=
 =?utf-8?B?UjRUaEdtRFBDZkJoRDA4MnhJc2ZldWMzWEpSemhtWiszeWh0aGJwZWFNb2g2?=
 =?utf-8?B?ZENMMjgvVzM3a1ZWUytRODJHcVZxYjVmTWVEd3JzejF5UU9UTXB2eFJuVnYw?=
 =?utf-8?B?L1lrSW9xNThSM1NtY051K1FVRllKVjdTUTg0V0RreTBWbVl6ZDR3TEFNczg2?=
 =?utf-8?B?MHB1UFhLY0Qza0JvUHR3eGh6R3dXa0lNR1dZZ21VdGVPV2dtR1FqQkhYcWFB?=
 =?utf-8?B?MjBaN041bTZMNkF5bnJ0NCtNdmx0dG91ZWhvTmNveEZrYytsREVTc21rVlNi?=
 =?utf-8?B?MEFCNDZURmtjWHR6S1psaTFhbWdDNlpUTnpPZjhGeUsxTUdiNjlhZ21Zc2wv?=
 =?utf-8?B?NTZUeWlQNEdralp2aDhTV25QVnc3cmJQQStsUzVnZEk5S1RxTWIxTUZmc2RQ?=
 =?utf-8?B?ZmhBQ3hWUVUxaVNOS1p0Q0E0VUZDcjk4QmVueU9XdTJZNmx3VDVUUkNDcGs5?=
 =?utf-8?B?MlRnUDRDMWxsOE01ZjRPRS9uRDF1Mk10VE1Vc3UvZ1Q4bFQ0Mi9rOFd0Yllt?=
 =?utf-8?B?M252Vm1KeVB6dVkyRDFiNmcxazExMXpwZ0YxRW9vVEJmMGtwdUMyMHhUWTJB?=
 =?utf-8?B?UUxKRE16K3FjWG5GeU9Md0tWYUtBNWc1S1ZVOEZSeGU2aHhwMGFPRitUQ2Yr?=
 =?utf-8?B?QjNJR0p4RXJlOGJDVVA1OW83N29uQWFleGxEcEszV2hhMnpnNG11NnNzYUZy?=
 =?utf-8?B?a3hjbG1YNERwKzh6azNHV2NYbDZRaE1iRXJkYVFVSnFqMnNuS0RkSDVCZ05Q?=
 =?utf-8?B?bVdjb2ZJbFVCVU1VTTNsYXk3aTlxMlBSdDBJMVhNSW8wMVMzeHluc1k4Q3gr?=
 =?utf-8?B?alZ6eDVVVTNwQm5zMmtlRDFUTUpVNGZKOHNYdTBWVkdIcTBQaHU4UGtiMjhu?=
 =?utf-8?B?eitrTVMvUENVVE10NnE2UE92Q1g2eHhxN1pUd2RoeDlZa09qTWFTc25lNTZT?=
 =?utf-8?B?emZFMWtkMCtPY0xsOWloTnhkRTBYR1pCRk5VZWxEZ0MvSHpsdXdqUEhSWW9S?=
 =?utf-8?Q?Cd9sknYvpU5y3jjLjC20fTs=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77d6a7d2-02b8-429c-0161-08d9fb346c28
X-MS-Exchange-CrossTenant-AuthSource: AM7PR04MB7046.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 03:34:42.6690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EEC6KmBJkSqWf5EAYsAW4xXt3hZ6UakKj4g6v7z46YBqyXw7BuhETOu+uWjgYsLN1rz1UAhqdjGseGmNB1oDvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6069
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2022-02-28 at 12:25 -0800, Brian Norris wrote:
> It's possible to change which CRTC is in use for a given
> connector/encoder/bridge while we're in self-refresh without fully
> disabling the connector/encoder/bridge along the way. This can confuse
> the bridge encoder/bridge, because
> (a) it needs to track the SR state (trying to perform "active"
>     operations while the panel is still in SR can be Bad(TM)); and
> (b) it tracks the SR state via the CRTC state (and after the switch, the
>     previous SR state is lost).
> 
> Thus, we need to either somehow carry the self-refresh state over to the
> new CRTC, or else force an encoder/bridge self-refresh transition during
> such a switch.
> 
> I choose the latter, so we disable the encoder (and exit PSR) before
> attaching it to the new CRTC (where we can continue to assume a clean
> (non-self-refresh) state).
> 
> This fixes PSR issues seen on Rockchip RK3399 systems with
> drivers/gpu/drm/bridge/analogix/analogix_dp_core.c.
> 
> Change in v2:
> 
> - Drop "->enable" condition; this could possibly be "->active" to
>   reflect the intended hardware state, but it also is a little
>   over-specific. We want to make a transition through "disabled" any
>   time we're exiting PSR at the same time as a CRTC switch.

Cool. I don't see any particular issue regarding the drop.

Liu Ying

>   (Thanks Liu Ying)
> 
> Cc: Liu Ying <victor.liu@oss.nxp.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 1452c25b0e60 ("drm: Add helpers to kick off self refresh mode in drivers")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>  drivers/gpu/drm/drm_atomic_helper.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
> index 9603193d2fa1..987e4b212e9f 100644
> --- a/drivers/gpu/drm/drm_atomic_helper.c
> +++ b/drivers/gpu/drm/drm_atomic_helper.c
> @@ -1011,9 +1011,19 @@ crtc_needs_disable(struct drm_crtc_state *old_state,
>  		return drm_atomic_crtc_effectively_active(old_state);
>  
>  	/*
> -	 * We need to run through the crtc_funcs->disable() function if the CRTC
> -	 * is currently on, if it's transitioning to self refresh mode, or if
> -	 * it's in self refresh mode and needs to be fully disabled.
> +	 * We need to disable bridge(s) and CRTC if we're transitioning out of
> +	 * self-refresh and changing CRTCs at the same time, because the
> +	 * bridge tracks self-refresh status via CRTC state.
> +	 */
> +	if (old_state->self_refresh_active &&
> +	    old_state->crtc != new_state->crtc)
> +		return true;
> +
> +	/*
> +	 * We also need to run through the crtc_funcs->disable() function if
> +	 * the CRTC is currently on, if it's transitioning to self refresh
> +	 * mode, or if it's in self refresh mode and needs to be fully
> +	 * disabled.
>  	 */
>  	return old_state->active ||
>  	       (old_state->self_refresh_active && !new_state->active) ||

