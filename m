Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214DF62C89E
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 20:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbiKPTCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 14:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiKPTCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 14:02:22 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8C731201;
        Wed, 16 Nov 2022 11:02:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fD+97ZWfd2MNUy+GOB4rDcgpeu9My/4R9M/o/JewSsMducDVQ8eTjpN/f8s3+51ZYDZgzr5XsuBeUMXiJBK1AL4I3QDfGZ0Mv12MqJEt4Uq62azpylHAGZLi9MyGzbZTL453pBQuaajiXALvnHCuWnzZQwzT9vHi4XjlvPa61dza4h+grxrWdEWJI7EGxIAxzD1I2TQ7cHNao8waoazNqbJPwzrE1ch/n1nL6R9fdNuUmrulfhgHWvuMya3IV/99KaX8Iv1bPCgGo5nIknIdr7mJFPMRabZpZY9nYWCXPlNH7UpR08WpYTtK3yklRnDi+mSo7uO0iEynU+2DrejCRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2M+zKUDQz+iz7jXx7oo3P/JPauyWDDTbL0Dy29TSSuM=;
 b=IQM8HgWxwjBH8vGVcVCCIKMMVnOPHgehgJnV0ECrp9AIIvTdZ+r47B0GxhtcxrKPezjcGd+S6As4jnr56E/17GqZ+rVpPVkzew9ddsnO+8CGFiXRzbG8rUQMn11tQwBAvmkDSWdpIvSO1i/AnSHdrPR4ql/09yxbXqcWvEQ+5LEwTxsoY0KnNL1ZbpJ9GelTi9aOkAMKsha9htS6VtgqLXekAkX4VuNXy74f2pzD26GqIlg5OblpN0uBVGuLxF1V4a/z+ykVnNnBrvPL/9W9KgB13CMdg9rf8PGwY2d+oG2yW3vTPlyp6zwaZN7/mcO25PGe9sxwxQpZiQ86Z3ehdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2M+zKUDQz+iz7jXx7oo3P/JPauyWDDTbL0Dy29TSSuM=;
 b=N8AsPToodJnyjSgS7Jf4VorMUffTNY8Ros2b1B9CiKsjoz/kFUIkJ9QsB4V+aIrTRUoh4ulbpXmED2aG144ZULg0xgCFeZRa8UJMlPjcdjlaAby/o+dEV+Grdf9f9c10O+NQvTS75otSSKiCReqNxkXjbAD3y/d5m8/+V71pMN8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by PH0PR12MB7096.namprd12.prod.outlook.com (2603:10b6:510:21d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Wed, 16 Nov
 2022 19:02:19 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 19:02:17 +0000
Message-ID: <3e50c258-8732-088c-d9d8-dfaae82213f0@amd.com>
Date:   Wed, 16 Nov 2022 13:02:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH V5] virt: sev: Prevent IV reuse in SNP guest driver
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     Borislav Petkov <bp@suse.de>, Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20221116175558.2373112-1-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20221116175558.2373112-1-pgonda@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR20CA0039.namprd20.prod.outlook.com
 (2603:10b6:208:235::8) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|PH0PR12MB7096:EE_
X-MS-Office365-Filtering-Correlation-Id: 5235e525-aa69-46dd-ac58-08dac805149e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yytGplZ719u4waJfX1gTOaJ8elo+EZuhHSDOtVJYZ3fsEPy/iyoRH1pv9Ynik8rqM66Z2KAl/gwzkqALuseArftZ1XuRO6gjp4NMoogiiIIUMM3nQv9LuBOfFuaqz8Yzdskx9iUW85mwSYHYup0L/O05LoX8uUG5CXxBhA2zx1ZQh7Tdv7f5/d+Thth73+Iypv1JHPWnXYtT1VVXk0YqZSp/BXxhJ55FT9YY5GmRufYRqmMiAlnhFifI6SPOLzEpur+NEIpVzG5NvCRsw3svkPDyTuhERwb8IpuUQBVG0iUiJ1WgiVM24k/AASgrUCn3WG+f6GJuKLUkQ1W0cwGMmIsL0/uYDaXcicPFoQIjeH0HyueK2ro3BelNqUfEIH6iBMZiHSGY9aibr8q4wCGSKWVQ4xdWWuqhym/Gtj8ToeUXJGitCCUH7J3Ekq6luXFtKxpqeUyp+thMAW5oQ1WuRe9H3jaCbwYEFcucrwlgeTmwSVda9ocaUPTmW7NvosKpHNW4SnNKQBR5D5khtU5eQDt1hhsGGvl4cBrzB+S4yOwkDx94ATBkg0hQ/TNYqO+6LOJ0SYp5iz2k0vnZtq5y2uEGLZ0cGeIjfzGxg0i+p+SqTTv3V+GVL5GXXFfDDtXUZwyRBvjthuYlRC5XaSApWGfmOJ8SgHYO3AHoRiQ6Ysk35kv6ZA/sdXoQkdig9csI2a1bR8S50k1aYVpINukNJOkogoi0vNfazriVWb8gjpVHueUbwT9YNrUE3/JtoYCyib8kjI3g1JBwfp+LEGfG6ztpNslD2qQG+4aYsXXFzMQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199015)(31686004)(8936002)(7416002)(5660300002)(66556008)(66476007)(8676002)(4326008)(41300700001)(66946007)(316002)(6916009)(54906003)(6486002)(36756003)(6512007)(26005)(6506007)(6666004)(53546011)(478600001)(31696002)(2616005)(2906002)(83380400001)(186003)(38100700002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0JocEp2elByTzNxUWNMRkM4TlF2YUhEbUtKd003VFFyZld3TnZ1RXdMbFM3?=
 =?utf-8?B?c2hzS25SOHdNTGNpbHpIWng3UDZMQUNIQTk0ZEFLZFVmUUxZWGhNcXVONEpW?=
 =?utf-8?B?Y0REMGkwWVVLRE5CbmxEcEptMGNmdVQ0bzA1NUd2MHJTM3hGMkxPNlJNZGo0?=
 =?utf-8?B?VXQ5Q0R0aWtocUljbENtTFBMMzdFUUFYRk5RVisxMk9NSlV3MUF3TW9WSWpt?=
 =?utf-8?B?QWJ4SVBoRDFmTE9jMnJNMkRpd25YNHNBZ2ltUDk2WmY1NGJNaGJBZzhOcTdh?=
 =?utf-8?B?ZnU0MWx0eTlUdVVEQ0xwNmtGK1lkZGgxMVFybXg3UkkyZHl6NkdyVTZQUldQ?=
 =?utf-8?B?UEFFTXpZTFJMSEw2YStZaHR3Q1pTQ1V2dldLcElwdVZhZUZjc3V0TlN4UWtp?=
 =?utf-8?B?Nmd1bnR6UWp6Q3lCTE11a3c2UUFNaEF5QWJwQk0wQ2Z5dDBzSWhTTnBiRnpv?=
 =?utf-8?B?MjdvNkh6SXNyTTFodFRUYk16Y3RBUVU2RkpPbklzWjRxQkNrY3c3bjByOXVk?=
 =?utf-8?B?bHlqYm56T1lIMXkwTk13bC8xdDJ4RFp6eWZJRlpURXBlRGVXVkFaYTFTdlpt?=
 =?utf-8?B?MFdxZVkwNVhZbjFJcDZleEhqQ3dDWnBqOHl4L2pKdUd1WnNrQ0w3VGl1My80?=
 =?utf-8?B?NzJ5RDd1MnpoOE1vVzJRMkNnTlAzM0VWWTJUZSs0VWdYTkJMRGY2Sm5KNjEx?=
 =?utf-8?B?R0tMbGJnUnFRTm5na1o3VlZCTjN2MFcybzZvNkRlby9kUDcyNjlDVS9GQVl4?=
 =?utf-8?B?TFpsNU9IUGhlcGl3YlVRZGlEYWg4MzBYUnpTVmVGaXg4NmZmK2Qya3NpT2or?=
 =?utf-8?B?ZXZaSkVKa3A0eEpzdjIxZVl0T3E1RFhSMElGcGpCaThvcTFJVWFQcDdTaDNl?=
 =?utf-8?B?QXNPRGlmNTAra1dtQVVST1QvdmRYL1l2c2wyQXM1VUNBOWNuRHhqWkExbktR?=
 =?utf-8?B?S1BWaDJzTFMxdW9TM1V5aGhsNWVGVVFTNHF5S1pEOGROOVZZR2R3ZkY2ZkNM?=
 =?utf-8?B?aTRyZDEyd3lNYTBDbmNZSWd0MmZEaXBjS2k4R25BdmN5UzlkaEpDeWk3S1FU?=
 =?utf-8?B?enBSaERMVEVqTEdacUFtdGRZdHZyU1kvemUydkN4VjduZ1BvRGVJTHRJaWxZ?=
 =?utf-8?B?cUN0RlYzZzdoRkJnczMreldEUlNiY1BnOWdxZWJKMVpndjdmWXQ3em4yNFlq?=
 =?utf-8?B?S3hUd2UybHdibGZLRVMrTzZoMWlTazZPOXN6ZVpjdmRpU0lNYVdZSTBnZDls?=
 =?utf-8?B?NTJyMVRLN0dyQUJiajdvQS9mQUlmRk9UbStoR0VRZjRPSFBOWVZuK3VRbTZv?=
 =?utf-8?B?OE5qbFNVeUF0ZDQydVcyVGlmZlNTcEJzS3FxbmZjbEp2a1BmM2JCRmtEZzJy?=
 =?utf-8?B?UFBNT1ZYQ2lMVitZWTlmRXdva0NNNTdOUlNidjQxKzNCWUVHcithR25iUDhF?=
 =?utf-8?B?enZCNEV5bUNXSDZ4OVR2UnZ0Q3VMUWJxRkV4ZkhyZ2NCN2w4eUdxam11UkZm?=
 =?utf-8?B?ZWVmV1hjdHBjRlpNVWY4TzNYMDFiZGpzQXpHYXVuZ0xOREtIR25qelpTWUs5?=
 =?utf-8?B?NFd0djV1eVNRajhjOUVQeEZFL1QwalVBTXMrVDlmUmZ2SjNVdlFHUXdTaVZE?=
 =?utf-8?B?Y05nRWdXVmJNc2VXb3J1YnZ2TCs0OHd6cW5sOGdtTWh2azJmUFRKS1hMSnVL?=
 =?utf-8?B?d3preFVzWWVGVFkxSWhaV2hLS2ZsZTA5aVNSTUVOUVh6RjhIV1JsWUNxdmp2?=
 =?utf-8?B?bU5zbGFhV3J6MjRoVUp1dnFmYSswbFh2N1NxZnBPU25JTFZoZmUzTExlSThs?=
 =?utf-8?B?U3FhZFNDNitod0xad1hSZXk2NmJRR0oxclU4SFBoM0oxdUt1OWhsZUxNQUJV?=
 =?utf-8?B?cFpMM2VxZmdXQ2ZqbXp0KzhZcFZISzArVTBBbFNGclUzZXNlejFVK2ZLdC9m?=
 =?utf-8?B?RDBxcEZ4K1VRbjNjTHBhSW44YWY1SEk1S2lQLzBWMURpUWlkeVNBYmtzdks1?=
 =?utf-8?B?b0tORm1EK1pMSE4zWlYyNXpNNCticU8zYkQwR1Ixb040Y1lUSm52L1ZtbW9K?=
 =?utf-8?B?ZDdGVlAxTWh4ZEFMRUFtRmRNUkZ6OS9xcmtZT1VjZTF6TXMrYzIxaHlweDlG?=
 =?utf-8?Q?PHlALw1UbgjWhpfanAQ1nWFNC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5235e525-aa69-46dd-ac58-08dac805149e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 19:02:17.4087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gvS+eWQxPf6udg+qDeYgNinNc5B0x0ueaJ1Q7mW8ESTBg2uJ3NX72GzPVtM78p6UIxniQJx6rJlIiXBXJCI2pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7096
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/22 11:55, Peter Gonda wrote:
> The AMD Secure Processor (ASP) and an SNP guest use a series of
> AES-GCM keys called VMPCKs to communicate securely with each other.
> The IV to this scheme is a sequence number that both the ASP and the
> guest track. Currently this sequence number in a guest request must
> exactly match the sequence number tracked by the ASP. This means that
> if the guest sees an error from the host during a request it can only
> retry that exact request or disable the VMPCK to prevent an IV reuse.
> AES-GCM cannot tolerate IV reuse see: "Authentication Failures in NIST
> version of GCM" - Antoine Joux et al.
> 
> In order to address this make handle_guest_request() delete the VMPCK
> on any non successful return. To allow userspace querying the cert_data
> length make handle_guest_request() safe the number of pages required by

s/safe/save/

> the host, then handle_guest_request() retry the request without

... then have handle_guest_request() ...

> requesting the extended data, then return the number of pages required
> back to userspace.
> 
> Fixes: fce96cf044308 ("virt: Add SEV-SNP guest driver")
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Reported-by: Peter Gonda <pgonda@google.com>

Just some nits on the commit message and comments below, otherwise

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Michael Roth <michael.roth@amd.com>
> Cc: Haowen Bai <baihaowen@meizu.com>
> Cc: Yang Yingliang <yangyingliang@huawei.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dionna Glaze <dionnaglaze@google.com>
> Cc: Ashish Kalra <Ashish.Kalra@amd.com>
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kvm@vger.kernel.org
> ---
>   drivers/virt/coco/sev-guest/sev-guest.c | 83 ++++++++++++++++++++-----
>   1 file changed, 69 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> index f422f9c58ba79..64b4234c14da8 100644
> --- a/drivers/virt/coco/sev-guest/sev-guest.c
> +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> @@ -67,8 +67,27 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
>   	return true;
>   }
>   
> +/*
> + * If an error is received from the host or AMD Secure Processor (ASP) there
> + * are two options. Either retry the exact same encrypted request or discontinue
> + * using the VMPCK.
> + *
> + * This is because in the current encryption scheme GHCB v2 uses AES-GCM to
> + * encrypt the requests. The IV for this scheme is the sequence number. GCM
> + * cannot tolerate IV reuse.
> + *
> + * The ASP FW v1.51 only increments the sequence numbers on a successful
> + * guest<->ASP back and forth and only accepts messages at its exact sequence
> + * number.
> + *
> + * So if the sequence number were to be reused the encryption scheme is
> + * vulnerable. If the sequence number were incremented for a fresh IV the ASP
> + * will reject the request.
> + */
>   static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
>   {
> +	dev_alert(snp_dev->dev, "Disabling vmpck_id: %d to prevent IV reuse.\n",
> +		  vmpck_id);
>   	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
>   	snp_dev->vmpck = NULL;
>   }
> @@ -321,34 +340,70 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
>   	if (rc)
>   		return rc;
>   
> -	/* Call firmware to process the request */
> +	/*
> +	 * Call firmware to process the request. In this function the encrypted
> +	 * message enters shared memory with the host. So after this call the
> +	 * sequence number must be incremented or the VMPCK must be deleted to
> +	 * prevent reuse of the IV.
> +	 */
>   	rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
> +
> +	/*
> +	 * If the extended guest request fails due to having too small of a
> +	 * certificate data buffer retry the same guest request without the
> +	 * extended data request in order to not have to reuse the IV.

... in order to increment the sequence number to avoid reuse of the IV.

> +	 */
> +	if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST &&
> +	    err == SNP_GUEST_REQ_INVALID_LEN) {
> +		const unsigned int certs_npages = snp_dev->input.data_npages;
> +
> +		exit_code = SVM_VMGEXIT_GUEST_REQUEST;
> +
> +		/*
> +		 * If this call to the firmware succeeds the sequence number can
> +		 * be incremented allowing for continued use of the VMPCK. If
> +		 * there is an error reflected in the return value, this value
> +		 * is checked further down and the result will be the deletion
> +		 * of the VMPCK and the error code being propagated back to the
> +		 * user as an IOCLT return code.

s/IOCLT/ioctl()/

Thanks,
Tom

> +		 */
> +		rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
> +
> +		/*
> +		 * Override the error to inform callers the given extended
> +		 * request buffer size was too small and give the caller the
> +		 * required buffer size.
> +		 */
> +		err = SNP_GUEST_REQ_INVALID_LEN;
> +		snp_dev->input.data_npages = certs_npages;
> +	}
> +
>   	if (fw_err)
>   		*fw_err = err;
>   
> -	if (rc)
> -		return rc;
> +	if (rc) {
> +		dev_alert(snp_dev->dev,
> +			  "Detected error from ASP request. rc: %d, fw_err: %llu\n",
> +			  rc, *fw_err);
> +		goto disable_vmpck;
> +	}
>   
> -	/*
> -	 * The verify_and_dec_payload() will fail only if the hypervisor is
> -	 * actively modifying the message header or corrupting the encrypted payload.
> -	 * This hints that hypervisor is acting in a bad faith. Disable the VMPCK so that
> -	 * the key cannot be used for any communication. The key is disabled to ensure
> -	 * that AES-GCM does not use the same IV while encrypting the request payload.
> -	 */
>   	rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
>   	if (rc) {
>   		dev_alert(snp_dev->dev,
> -			  "Detected unexpected decode failure, disabling the vmpck_id %d\n",
> -			  vmpck_id);
> -		snp_disable_vmpck(snp_dev);
> -		return rc;
> +			  "Detected unexpected decode failure from ASP. rc: %d\n",
> +			  rc);
> +		goto disable_vmpck;
>   	}
>   
>   	/* Increment to new message sequence after payload decryption was successful. */
>   	snp_inc_msg_seqno(snp_dev);
>   
>   	return 0;
> +
> +disable_vmpck:
> +	snp_disable_vmpck(snp_dev);
> +	return rc;
>   }
>   
>   static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
