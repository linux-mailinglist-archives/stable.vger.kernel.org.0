Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC5274CAB8B
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 18:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234961AbiCBR1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 12:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiCBR1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 12:27:32 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1BDCA324;
        Wed,  2 Mar 2022 09:26:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDDYlN8Z7pFbJjcv5ZVCCBBeGOgNsc+wPjbU/mm5Y+BKLhjJ34mpGkL2EOF0Czcu2ExOS6Nct32jCux6BcX/WQpnRfj86ezfZV1Zu+TnlTQwJvoAWMDxmEFeTAxnxgUdWt1pNOG80CkH9jWwrJd+uVW08Ex7F6E/sYF4oewDYsgH6mHj2vHDTtJM+9ju7PDc3EMF0Zti6jgWdY8HP147OLmgMLWsCqka4nTqoA+S+//m1RA1+kl94CNkVDJ/XfAMoE+AZhzvnejwSjI+csZlayxDhXm9+NaGd15n5lfPtYmHPQ/TLhs2aqauwzXLlxFsl/40KvSV8aOs6iiDrPmJEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=di/XHU4DwcFdoRGpIE4JLdvP7eayx9JMiKgLVQl/ES0=;
 b=H5np2sjC7t+H8TUhZBBqc+hSByevBFJswUFKcxuGGqGIV+cIak1e5UqV/wNEx/tuV7E8miVh1feIhfsXtfkkOHEP8+N1NNcmZdfaYSXwcIrPebKa8ktuPuPgHH9qeFjzHFeLY3Oxd9FPNW0qgGZSO7tF3SU05DCsqkBfPMgh2B7evluPozjxpiOWNlwXGT9o4oQjfKUHGJz1NMrZILkiBH8h0fSqz5b/0C8wnE0ZKfju7ZQHPLBJ9TewOV2j9uQJlJoYesro3/LsfctOASA/JmbF8jRG8qrAgv/O3btO3KZRCTlXT/s1kkg3vkfIYhbmlA2vU9oUf64VwNbYut+0tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=di/XHU4DwcFdoRGpIE4JLdvP7eayx9JMiKgLVQl/ES0=;
 b=rChSPMHWjtsf7hNapc4ecRZOhG9mbjrWpNNWnz2CXM93BsE25MfElWUa0RyzBNJ7g2QkYwaZ6OHDfMbXRtWsX7ac7hmvG6FwTuXsIsnPx/ST08prQxuqZCxOThuBapqthWB9A2LrHWczL+uUpvXwnG9wgPtyMf0MNT/uj2WZbGc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3108.namprd12.prod.outlook.com (2603:10b6:408:40::20)
 by DM6PR12MB3804.namprd12.prod.outlook.com (2603:10b6:5:1cd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 17:26:44 +0000
Received: from BN8PR12MB3108.namprd12.prod.outlook.com
 ([fe80::ad74:927:9e6:d2cd]) by BN8PR12MB3108.namprd12.prod.outlook.com
 ([fe80::ad74:927:9e6:d2cd%2]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 17:26:44 +0000
Date:   Wed, 2 Mar 2022 17:26:32 +0000
From:   Yazen Ghannam <yazen.ghannam@amd.com>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org,
        x86@kernel.org, stable@vger.kernel.org,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Jiri Hladky <hladky.jiri@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 2/2] x86/mce/amd: Fix memory leak when
 `threshold_create_bank()` fails
Message-ID: <Yh+oyD/5M3TW5ZMM@yaz-ubuntu>
References: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
 <20220301094608.118879-3-ammarfaizi2@gnuweeb.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301094608.118879-3-ammarfaizi2@gnuweeb.org>
X-ClientProxiedBy: CH2PR18CA0048.namprd18.prod.outlook.com
 (2603:10b6:610:55::28) To BN8PR12MB3108.namprd12.prod.outlook.com
 (2603:10b6:408:40::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37690116-803a-4829-5533-08d9fc71d27f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3804:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB3804347863C20C29D77010D8F8039@DM6PR12MB3804.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SwNWSdE8eSIoGjz0czUEP7Md4IsavWgxqW9fZhmm0nX2SRh/EY0SI40NRSEpL7eH/qZ+loVM6GU+MEYJERFrCPQ2fpPGCYkNESTdqzso/U6bI4CB0As6ZCJMzkk1vF3iCbJ/S9joOwQIMP7udohAlp8oiME83+24o0R3gG5k7O6QiHEI7yrcECgwDOq57W7byWGWLNHYLVQ2nc1b3KbkvAD5cTcPAPfQ1/rLfwk0Y+DjsMchfqGSuczoIbJLtLWB8iVULw1mXJy/UN9HtEAh0z2VX3RgxvvhOJX8S1xHtDtfkHfL1EHZa3DTkLrI7stsGgs/C5kHDdrtt8mEvI8+W6OMIMov+QY8O0oz6z8NVTHPGf7nsTHOkrHQKjfD+l2GchqB+WRJ69cwidMCwiaX6CCeanAqQNhLRrCEtjf3EVi9QjbbBNNhkXsNEYqyTUit/ue6c2pW3ERudY1ewj3Joi/hit90TEkd8Hr6cjdLypgiZTp5AzWBxFuNcN4aN45++U+Ylm3iFf4CG7xYJhPnnDnLZo8qvQr0PnVPCM9QzTZsAH1P/oX/yAQ+qurw+oT/O/KFDfoAA+0cQ5K1JDMX8WVbiDCVaFU25uCleI4tgMaci6WbCwqzYJ7VD+yBS0ctQneB1OLhE80ShCUXxC4x+e2ervzqYpBmU6TJ3CdQ5JuEiP4ZCqBGVdRz4IoP00XPhpAF+wrAgCc3C5ufaL9nBw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3108.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(54906003)(6512007)(44832011)(38100700002)(6916009)(7416002)(33716001)(83380400001)(2906002)(5660300002)(9686003)(8676002)(4326008)(66946007)(66476007)(66556008)(86362001)(316002)(6486002)(508600001)(186003)(8936002)(26005)(6506007)(6666004)(81973001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IwhIcfSiOuUBdyp3cri2hipuCC5y+7TCUEYvB3GIpehFNR0+DoO0OOrrrWqW?=
 =?us-ascii?Q?i4UNbeTBbSX/qi8OQUjWlvGuwQOC1u6bO+btdQN7T8MqLQUiuBu4b3FDfImc?=
 =?us-ascii?Q?ay90TWPhUqt77w+ANf3V0YveKYZitJrdKszggjQAN0GFYixYGYBOcxMG+P0m?=
 =?us-ascii?Q?1UivDnlyB2t2Ie596vfCYVw5VvKCbPGHTAoVNGTA9pNl58uYzkS2DbcbO7nk?=
 =?us-ascii?Q?WnXz/JSu2er7V2d0t44aQwJKIfsRTB+aa6MD2gxm14jkxPa1QTI42DKDQJzX?=
 =?us-ascii?Q?NYrxd+w/37t5L6ptFvtQAuCJhbKtjRHF1459l7CZmw4PkGPnI3Pr3yzlLRZX?=
 =?us-ascii?Q?5OZKg4pDsXsgvFEkLSdsamrTZXALsnLUhSrJNzhlQIgsfvdyUFiM7gevw25I?=
 =?us-ascii?Q?+r31UlXCJGJc7Poxk96mEjKKpCDv6PQRiMRWrPFNYp0ehiC+fLYlNV6L39ig?=
 =?us-ascii?Q?b243UT2KjLgSgK+4nPgqg1jsjFt1nyDo1VpO/sK6IRv+zobgtX1sL9bU75So?=
 =?us-ascii?Q?0xMQmZm5Lw2M6AR8Nax0Kt0v7WCIanf9y9QqwMAMv1nNQQuHq8mEtmfRGO05?=
 =?us-ascii?Q?t2o1W0x7FRIEB5WOhmC5k8ECZ/RshO245V9hnnrQpU0Jg/zoCX433zrmLRlV?=
 =?us-ascii?Q?pNUQu3Axxlhz9/XSy98nVTiA7Kpc9wxigFNjFht/sNWfqw8TMWeCy6dgpwCr?=
 =?us-ascii?Q?+DB2U1M8zLPjWBi2o7zRQOyQmOzSc9qz0HlqTA3ieb1/yDss2LCpFEftoLvt?=
 =?us-ascii?Q?sEDq6wmkPHo2nqbeopswFCXpmMlF8fVNr/3kCwE2CnKFQIIM5MHV70C8I0L6?=
 =?us-ascii?Q?IC1xAEc6o2OUVDplfvOA+18eVgVloaS2DOjr+k9YkNKZUF9TRqQtcaqw8KGn?=
 =?us-ascii?Q?HNCtZ2bRlZrbhNBkHWhviyEc9XYnirqcqQc8niOltf8kNCOTsBP5t+gyonoc?=
 =?us-ascii?Q?t514kyAOxvbkYHh+V+nSdOi71sMrepPysJ60m2y9jf1PbYM6uHqvCl8/aK8k?=
 =?us-ascii?Q?vkufKkB9alV3wdPbXGziPxhsp7UJMsZLH6QrJGZ8h8PVvBeraQWOq0Gkbxxm?=
 =?us-ascii?Q?5+SotAtp4hA+Xxsu6UwU4TdXAIg/wYk7m2Bo7mi0jh1qwySEru1M3akH4M3r?=
 =?us-ascii?Q?1upd1nQs3ZmHef0WSGlZFU3pStv8xoq+WFDFGXqOv32J3+nYUe5SpIzHiMjB?=
 =?us-ascii?Q?bDpRywzhNhtloN6GjhMMvstAirrJmBxHVZl56a144Nqp34NEdh/Ag4uthV73?=
 =?us-ascii?Q?NTs7OG2ADQHvtwpr8iwOxiEGNTtg7wSLftHbnpxhiHViSNvNA9HvFJ0lmDqH?=
 =?us-ascii?Q?789czc1fA12ZfJzMl3KUXbfvZT58Q/aJGMUiHjVBqJd4uOLBjPSfMPDDv3QW?=
 =?us-ascii?Q?F+ft8tncDCN30i0xK+CDUr0jsMNW6jZTsJ2LtL+SYGshLkKsWkqwVVyXnxDN?=
 =?us-ascii?Q?lQoSev+eFYJoibvYlToUq4RtDnsammUJMkqQVG40Eo0My6oRbpNXv8jtzlVr?=
 =?us-ascii?Q?H67fT6ludrA6gYpNkQcQ0Yw4zHct8Jn7TSuLJXUcodwEQIZ9Viix69+YVL3m?=
 =?us-ascii?Q?HHc9sbBnR84GD26AbB0kkkF0Pvoi3N+Ka0h9UK4JTuORcfCBnnimVhBc75Yj?=
 =?us-ascii?Q?TW36nbGTpmmw5aVSsbDo9Tg=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37690116-803a-4829-5533-08d9fc71d27f
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3108.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 17:26:44.7387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jsNSWK/Y6cv4EAX4VB7iEcedqXit1iJm5Edu8SlnA0B/yRdbFBMi0EqpmdaFSf/CHBfO3ATcNBkAGyRZkdE4oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3804
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 01, 2022 at 04:46:08PM +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 

Hi Ammar,

...

> diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
> index 9f4b508886dd..a5ef161facd9 100644
> --- a/arch/x86/kernel/cpu/mce/amd.c
> +++ b/arch/x86/kernel/cpu/mce/amd.c
> @@ -1346,19 +1346,23 @@ int mce_threshold_create_device(unsigned int cpu)
>  	if (!bp)
>  		return -ENOMEM;
>  
> +	/*
> +	 * If we fail, mce_threshold_remove_device() will free the @bp
> +	 * via @threshold_banks.
> +	 */
> +	this_cpu_write(threshold_banks, bp);
> +
>  	for (bank = 0; bank < numbanks; ++bank) {
>  		if (!(this_cpu_read(bank_map) & (1 << bank)))
>  			continue;
>  		err = threshold_create_bank(bp, cpu, bank);
> -		if (err)
> -			goto out_err;
> +		if (err) {
> +			mce_threshold_remove_device(cpu);
> +			return err;
> +		}
>  	}
> -	this_cpu_write(threshold_banks, bp);
>

The threshold interrupt handler uses this pointer. I think the goal here is to
set this pointer when the list is fully formed and clear this pointer before
making any changes to the list. Otherwise, the interrupt handler will operate
on incomplete data if an interrupt comes in the middle of these updates.

The changes below should deal with memory leak issue while avoiding a race
with the threshold interrupt. What do you think?

Thanks,
Yazen

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index 1940d305db1c..8f3b7859331d 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -1294,10 +1294,22 @@ static void threshold_remove_bank(struct threshold_bank *bank)
 	kfree(bank);
 }
 
+void _mce_threshold_remove_device(struct threshold_bank **bp)
+{
+	unsigned int bank, numbanks = this_cpu_read(mce_num_banks);
+
+	for (bank = 0; bank < numbanks; bank++) {
+		if (bp[bank]) {
+			threshold_remove_bank(bp[bank]);
+			bp[bank] = NULL;
+		}
+	}
+	kfree(bp);
+}
+
 int mce_threshold_remove_device(unsigned int cpu)
 {
 	struct threshold_bank **bp = this_cpu_read(threshold_banks);
-	unsigned int bank, numbanks = this_cpu_read(mce_num_banks);
 
 	if (!bp)
 		return 0;
@@ -1308,13 +1320,7 @@ int mce_threshold_remove_device(unsigned int cpu)
 	 */
 	this_cpu_write(threshold_banks, NULL);
 
-	for (bank = 0; bank < numbanks; bank++) {
-		if (bp[bank]) {
-			threshold_remove_bank(bp[bank]);
-			bp[bank] = NULL;
-		}
-	}
-	kfree(bp);
+	_mce_threshold_remove_device(bp);
 	return 0;
 }
 
@@ -1360,6 +1366,6 @@ int mce_threshold_create_device(unsigned int cpu)
 		mce_threshold_vector = amd_threshold_interrupt;
 	return 0;
 out_err:
-	mce_threshold_remove_device(cpu);
+	_mce_threshold_remove_device(bp);
 	return err;
 }
