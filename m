Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F3C62D221
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 05:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233096AbiKQEJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 23:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiKQEJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 23:09:03 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14F62338F;
        Wed, 16 Nov 2022 20:09:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cgEcqtPaQ5CyFzbBmDlvWx04oIVLY8jzaiRWBF+Ro+HHK5ZehXL5vxxxGm7AgLkKjrPOqrUEAifgarLpzGmknMluPNLR0IoCCB/B23fYVPVRPqnxKtgUXdGq+irA3reItq+tYb6cyIEFJIN3eRCahQRJ9ti7Ufa+6g5cuEDa3dPFrchiesJ1n5lRHrdKhZFD3S9KrRdIsEGsezbFjOv9yfv4YtzBYYenPpYn0wK2KNbGNAU61J/tZY3PvSwetloBQ8vh0qm/qsjNaZlgQTam5Dbw6nLdqouSHiId7Dhu18Q6vz8bHad1WEW9XbBzdvurauTJV9M5DrKzdK8oI6wa/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DaVPd8zq/43OS78AO3Q1hJYiLIR6N19oHQQOmQgtWaA=;
 b=btRal37LVhZ2I8EQc2++SI0jHJLb39b4tQXvdapzsQr86kSHKrexeDPeAIWQ30wXt7iH+ESWii99FAqE09bi5tE4DjlL599sxOTSCot28dW73C5BTclZ5RsJ+Fh400CAjSswrnKnZite4RfcrTjzFN0X10Xp5BJIGb0cIylFIp5oQmH6K/owH37qy5xDP6pXAmNXXCXYMAUY5Xy4l+sgHSoBdndxmY4pfgo79mliCFMHDoGGt4P7FEpbOO131Ggk9piWFaZxcIlOt+vWUYdFUivtAWEK2bxXLY+Jhsa4pk6KIiZdGdbqylQ8/sjxo3vj+VMMCOwpdmZgLsIaFU7lLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DaVPd8zq/43OS78AO3Q1hJYiLIR6N19oHQQOmQgtWaA=;
 b=jD8WUrEEKOZqZ419fWb4yvcoTedSLYRdfX1GGg0UUa3HQyZReAzBPaPibgh7NWq71ZrAjL9HsNHOxsJl+nhSAvtMead/6czE6fAyRM4kMjznicyc8JjvWRCUYRGrtaBwVt2tjprnPIWFpboj9rIzpMuJcHyRhxR+I6yhrC4QJ3c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BYAPR12MB3286.namprd12.prod.outlook.com (2603:10b6:a03:139::15)
 by DM4PR12MB6135.namprd12.prod.outlook.com (2603:10b6:8:ac::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.19; Thu, 17 Nov 2022 04:08:58 +0000
Received: from BYAPR12MB3286.namprd12.prod.outlook.com
 ([fe80::b1df:1303:4c2:b96b]) by BYAPR12MB3286.namprd12.prod.outlook.com
 ([fe80::b1df:1303:4c2:b96b%2]) with mapi id 15.20.5813.019; Thu, 17 Nov 2022
 04:08:58 +0000
Date:   Thu, 17 Nov 2022 09:38:46 +0530
From:   "Gautham R. Shenoy" <gautham.shenoy@amd.com>
To:     Perry Yuan <Perry.Yuan@amd.com>
Cc:     rafael.j.wysocki@intel.com, ray.huang@amd.com,
        viresh.kumar@linaro.org, Mario.Limonciello@amd.com,
        Nathan.Fontenot@amd.com, Alexander.Deucher@amd.com,
        Deepak.Sharma@amd.com, Shimmer.Huang@amd.com, Li.Meng@amd.com,
        Xiaojian.Du@amd.com, wyes.karny@amd.com, ananth.narayan@amd.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/5] cpufreq: amd-pstate: cpufreq: amd-pstate: reset
 MSR_AMD_PERF_CTL register at init
Message-ID: <Y3WzznD5GR120VM4@BLR-5CG11610CF.amd.com>
References: <20221117024955.3319484-1-Perry.Yuan@amd.com>
 <20221117024955.3319484-2-Perry.Yuan@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117024955.3319484-2-Perry.Yuan@amd.com>
X-ClientProxiedBy: PN3PR01CA0014.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::23) To BYAPR12MB3286.namprd12.prod.outlook.com
 (2603:10b6:a03:139::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3286:EE_|DM4PR12MB6135:EE_
X-MS-Office365-Filtering-Correlation-Id: 2630f7f6-2a82-4c7c-3e51-08dac8517333
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8qnOts05yJj911aFKR3oF+pvHOX7QNG5a6/SSkPvBrppPkbWK81IRvycm3LnZZvqAhzcPFkdOq1D6BMaI169cartsDgmC89TNUoiIpFPkSSys7l71PRtF6jchBsnBSwBBb6BPzxRGW5KetGdtMlqD2qkKRIJP/G0eoiksnojX6FKKyhkJyHyRbiCg/ZqlbUvxLTMZkiBdyfrHB72YE4I8ePQwC11bH+3ybFdTCKyv2XXcTe+0Vqem9TI+CQS2/NWnAHlmtNdbn1dy6DMwjtsNyKDBHVpUNT/yiU+FIlIslD1wPBXZ6/8CNcDJhIXpxe0p6F/aQShjNZrze2JwqmnL2SiSqBNY/IFibLZxlqodgi45zWC5dSwckAm5AKXvKrx5kcZozld82uLhpHQtZ0PynOLVaKod4cslBIM0uec/Z2hfMpfYse17GcgqfsgPIZS/fFRY3oNiHwbxneUoSYFootMkIzmH4vowrAcd9IId2X9ahAj3BUJ2Dp4Peh603UkX8bIZ0RQ9JrvOmg/BRzGfVU5e3FErIyYSDuEKUg1hvm3Jw165/zMU+jPYO6QYUSUcPKUHWxm3g5mlX5D8cGCoV2p7HsDL5AfWvrgqcL7CfSWu+Xik5L35MW7MO0Zi2dqZTOZeo2EmLEsYV2j/Spo5UqOqgTNfPsQYnFuw7eqMO1ueA0IToD6OamNwzIJULVfbSSbCUWsgkfTO7aOGvEyQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3286.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199015)(86362001)(38100700002)(6666004)(6512007)(66946007)(26005)(6636002)(66899015)(6506007)(316002)(66476007)(478600001)(2906002)(66556008)(83380400001)(6486002)(41300700001)(4326008)(8676002)(186003)(6862004)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?krjIfPL2x+U2uvj3wLQCfe+DKJyiwnwvW/wObRPzXkL1CTR2EPnA8jOA9I7T?=
 =?us-ascii?Q?XpodKA9Q/DQGfx/CqoHh+oppPrmWGvXguAvyPbxE+l2eAjIbz+oQfBhCro++?=
 =?us-ascii?Q?L0TrC5AF/AqjoWa80hIo7NhrcW706wXB8B+b8eKBim11bVkNMfnBlAmmdwUH?=
 =?us-ascii?Q?AUAhH54eYBUuDBBa9/ncfHN1i9aTpOHvcYOy/v1toRtxeRz9VSZ1uN81SJwL?=
 =?us-ascii?Q?ak7zYxd+bWDZmsUctBIhjgY442BfNoUf5nGFI3PSIF9AOqVB3xfI0bC/Se2a?=
 =?us-ascii?Q?LDVMSQjM3u67FMJSm1s3Vr0z+vWV0dR0J6HOL2E6nyfnilElNtPtgP1jWIcq?=
 =?us-ascii?Q?FlJ3SkgI9S7L1igrcMXKC7yFCyF0FzxAI3Tpb+1jggPVB4s6r4gxemI7lzQ2?=
 =?us-ascii?Q?ZbYPLzmExFNzZkxlSgWmN/+ASWKfcw9BZxJtIS002y9uIERFyGfJsDsy84Ks?=
 =?us-ascii?Q?QGC9V/DAjfaMzYm/deuuChsbr9mU4jQo2G17qJe0j/CZILpT9yb+W9olmh1h?=
 =?us-ascii?Q?K1yHfOGWJvnM5ywbsehy5m9+D+WOAXued+8EWHqzaGXCqKbqzPsb7j9Tvfxl?=
 =?us-ascii?Q?nhV2aT7craPNZVkxvd8M8wl7JTT4J0YDR7uhi4ipUU1Nbjd14i5yjt8nuaAt?=
 =?us-ascii?Q?b1EeOtS8LajgBgm0Gqoo6tBICi0IfbyOT3COEVgOVgP5We+cTvGqvPkl+ewy?=
 =?us-ascii?Q?1MjBZ6AVAABYelpKhq0yGAlCH4+eGY4Khrq2ZXcfHp18JeEE5E51X9V1KfS9?=
 =?us-ascii?Q?6ulflsYAjf8+TPwEG3anTsDc3f9ACPSZ/Jj4KG9CKHF2h13PRXg8wGh1YXnw?=
 =?us-ascii?Q?WO5dP4cuQPuDYoqs6zQRNVQM2m4J6Pz5HqrrUOnBCAsGRnK4W1QZ+V2CVBxw?=
 =?us-ascii?Q?fetvH72OJh1GEwOiW8U6QPv1wp3kuzzWsUIRC2pArGWxFu4p6RKqD0QHYd/G?=
 =?us-ascii?Q?x3oAru9JDEbWk2x7lqo95gRXylVwBgtWA/N+NtcfxUOLZC3FeA/YxQr+iXiP?=
 =?us-ascii?Q?2e5g7wf3NF1BRlvrL4vBi+4hoZYKVp92hkq2oBhE3zzMAy4sU7IucP+GBk3V?=
 =?us-ascii?Q?YCyzCIG3nqpY4yMRK32kbfWnE8yi2EhpziHmKV/kjmbuyuna8JekAyIKoIVj?=
 =?us-ascii?Q?YThErOt6KCT9DXJ0v/SbGDXSQOdpgsRpnrzKDtZ2D9sGjGMNdkVAYTsgfb0H?=
 =?us-ascii?Q?1xfL//aGtyPLarM1RZBaO2O29hcz7w0m3bcOzu6nm6XoKHU+GoW6F+mDsZ54?=
 =?us-ascii?Q?s614htCZGVY0v0+LB8M6QvrKCThXtxVE8IRWZB5AywEfrR88Y5nufvBjEFtd?=
 =?us-ascii?Q?NyND8nPo/q01c2lr5TvT5uVUGNQ9SHRBEgX7NLES4WB/qeozD/IGsKP57PEI?=
 =?us-ascii?Q?L9PoV7oktIhnpSL6fzfCFhBfPwNKq/q0Wv9S2qYZKXCiPkp7jVw78k2uY12A?=
 =?us-ascii?Q?RUF/t3SQ6j+acXNWgWSwWH1niDs/uXv9q5l0NrD1PRSD+TLnvzphfOTFS5zZ?=
 =?us-ascii?Q?/ZBFdlHTGSpk8vbwQK+m8M7tVTXZVEfqJZZGzFle7rnpDWXKnTgopp3gYxqx?=
 =?us-ascii?Q?w3iqCGunyVpfNOUDepXbJM/lgNKDiM+30dnfAaSq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2630f7f6-2a82-4c7c-3e51-08dac8517333
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3286.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 04:08:58.0896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ba0lIRf/mRNULitDnlJRDpYSWVMjG0QHSJpI/lfWC/J844ZlQL9ckhHFuUlyvNkppZsAZ9X31PPlaQ2iuDqm8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6135
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Thu, Nov 17, 2022 at 10:49:51AM +0800, Perry Yuan wrote:
> From: Wyes Karny <wyes.karny@amd.com>
> 
> MSR_AMD_PERF_CTL is guaranteed to be 0 on a cold boot. However, on a
> kexec boot, for instance, it may have a non-zero value (if the cpu was
> in a non-P0 Pstate).  In such cases, the cores with non-P0 Pstates at
> boot will never be pushed to P0, let alone boost frequencies.
> 
> Kexec is a common workflow for reboot on Linux and this creates a
> regression in performance. Fix it by explicitly setting the
> MSR_AMD_PERF_CTL to 0 during amd_pstate driver init.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Wyes Karny <wyes.karny@amd.com>
> Signed-off-by: Perry Yuan <Perry.Yuan@amd.com>

Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>

> ---
>  drivers/cpufreq/amd-pstate.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
> index ace7d50cf2ac..d844c6f97caf 100644
> --- a/drivers/cpufreq/amd-pstate.c
> +++ b/drivers/cpufreq/amd-pstate.c
> @@ -424,12 +424,22 @@ static void amd_pstate_boost_init(struct amd_cpudata *cpudata)
>  	amd_pstate_driver.boost_enabled = true;
>  }
>  
> +static void amd_perf_ctl_reset(unsigned int cpu)
> +{
> +	wrmsrl_on_cpu(cpu, MSR_AMD_PERF_CTL, 0);
> +}
> +
>  static int amd_pstate_cpu_init(struct cpufreq_policy *policy)
>  {
>  	int min_freq, max_freq, nominal_freq, lowest_nonlinear_freq, ret;
>  	struct device *dev;
>  	struct amd_cpudata *cpudata;
>  
> +	/*
> +	 * Resetting PERF_CTL_MSR will put the CPU in P0 frequency,
> +	 * which is ideal for initialization process.
> +	 */
> +	amd_perf_ctl_reset(policy->cpu);
>  	dev = get_cpu_device(policy->cpu);
>  	if (!dev)
>  		return -ENODEV;
> -- 
> 2.25.1
> 
