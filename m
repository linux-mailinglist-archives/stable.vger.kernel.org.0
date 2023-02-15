Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273D869775F
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 08:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbjBOH2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 02:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbjBOH2t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 02:28:49 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2115.outbound.protection.outlook.com [40.107.105.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE322914A;
        Tue, 14 Feb 2023 23:28:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rwqp5r+kip1j9FwywWSYcBqBvEfD1BZ5MmPnufDZycUvODEctECQFY1rq/uYbj77ckHHeqx9OPdHPRDZwlFLYGH2/rvOQunZHPn/kkOOn2fQK/1zXkJsC+5eOyKGvaNe4c1crqgtnzQS/a9H/SzqknT608YN62B8FrlF4GEW1Eb/k/cwYomF4I5GhdG5pL8jsTC+P5NzWt4216pXpXQB4DVlfUn5VQzqeOrVxGP1KDDWi/rJDD7GmTegytLXYlg5w0XbRMSK+gNg8ugmclJ6S3aBuKGSl/BJL/JzsOr/MGuEoSeOvOMOTaMRMBm49rwwFsqcCViPRpkhybH5LDVWOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6mcoG/1WDPB10a1rkIX/JiwBpRROe6d8Ry8jnchPUS0=;
 b=Npf8tiAlpCrKpWLnQKLRv11vVslSuN/RvmEtfAYxX7gI9FQN4Kmfhw61bNkrYdnuewmVR7WIzd90s6TCVpjsdJgrRGf+nKsDHpHDcL3n0LILNmdgjVuZCWS3iOh0VJmFJy8c0tyeNH1ncPjajKez0oci4zfvg2PMSy5TUL7fkAqEQzkMSeYS9XDUoo0R+lkWhR+j5dVgQv9LSnVhSa7eIJ7FJpCa02U16+3n+IYmK4J0L1UlFAU16ZcObMF719wfEW6BFjZ8gfrIvQZZqTsZILVv644mH+syoi8VC6sZzo1ISr6YW5O+lwa6bFBGyM1J3dWJblmcnU5pEqICg8Grwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mcoG/1WDPB10a1rkIX/JiwBpRROe6d8Ry8jnchPUS0=;
 b=Qt9Go6LkH2xgNIFVMhvaKqwYcAfZO676ngPW3zpoi2/nXy4mr2WfGEHqos5OmWRzXYUFI1Q+Ztt/VuFwqQkVutFQz3wLZeW6jEdYHdNj3jhRKNzAc5pzffmoIb8y6YciCEAjqEvwm3KOY/aVkOvuXie6WUQgP0n/Y24+b1P1ntg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=garyguo.net;
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:253::10)
 by CWLP265MB5673.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1a5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 07:28:44 +0000
Received: from LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::b96e:93ad:4043:6145]) by LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 ([fe80::b96e:93ad:4043:6145%5]) with mapi id 15.20.6086.023; Wed, 15 Feb 2023
 07:28:44 +0000
Date:   Wed, 15 Feb 2023 07:28:39 +0000
From:   Gary Guo <gary@garyguo.net>
To:     David Gow <davidgow@google.com>
Cc:     Miguel Ojeda <ojeda@kernel.org>,
        Alex Gaynor <alex.gaynor@gmail.com>,
        Wedson Almeida Filho <wedsonaf@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "=?UTF-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>,
        rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] rust: kernel: Mark rust_fmt_argument as extern "C"
Message-ID: <20230215072839.6cb94bbb.gary@garyguo.net>
In-Reply-To: <20230214224735.264894-1-davidgow@google.com>
References: <20230214224735.264894-1-davidgow@google.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0073.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::6) To LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:253::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P265MB5183:EE_|CWLP265MB5673:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ac27865-ddba-4b0e-0abe-08db0f26450f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gqDgy7Am5nSRIWNGpfZlbSylO3u2A9xEkJVRO5OsYncfmI8VBkyedP3wY3+31OWnBpOIrtmSse57/+l5wmC64DEUT4Cttm9JrDBa0AyLkk619/9kSGZahllM0i3NAI/lfi8DfKJnhHYniWvcbRJ7XHzAp57maVoeGzxOCeGlqngT7qaeEbYiv9kJIJ8XYIUpvpxzHO3n2qNg1VtjfszsTAGqAQWp6dAZCk2yYltgdgZ8qYPBlMEmtCMudoz4F4nvehZpVbT7XTxwGBBATFQguQTy4fgIR7J2C8aYBj4o0B64LCIS6kdudho3XtTNPVFPrg75VrswwBGooz4+QGQjisBF6DSqZ3C3myzBVwVTg0fWmJ2ym/UPaQAa9uB9YIxhsK0UxsQLQF5ZHu4BOgktPXP8oOG8Pig6SqrWSDMFerjsRtvZBN/fnRSseWxaq03jCDFyMf03iHCrQbtEtp1P+L+vrSGKVdXDVaT8YDg4RBn4DIOhfQaFImV4NQpJ5gnvWWIbnB8NiMKLI7gmoDetnr8Ui40r48C5cvyWVIx2clt0xGVGSsT7tDI+ORIW9SsnLNJkmuU4b15lfz/MIAriFM/8jiqF0HFiavxNwNq3rh/8+4jmpmc4gUpB69K7mZhV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(346002)(39830400003)(396003)(376002)(366004)(136003)(451199018)(8936002)(86362001)(41300700001)(38100700002)(5660300002)(66556008)(4326008)(2906002)(6916009)(8676002)(66946007)(66476007)(316002)(54906003)(2616005)(478600001)(83380400001)(6666004)(36756003)(6506007)(966005)(6486002)(1076003)(6512007)(186003)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oWlhfZpclnvF5DJQWDnRbBekD4miZXkwD1uSY7Caz9Prve9Jc8FKodKSgREi?=
 =?us-ascii?Q?Sd37aPDyKMcfMx208iGblQcyVQOBkniMFsUvfvGqskjnwdaXNra+CjQ0vTpz?=
 =?us-ascii?Q?4sNigKssKbJn0nt8XSPMsvNr3SnOa/zeNVRUMAYrcLI/afQs/foetSIKQ3D0?=
 =?us-ascii?Q?qlkKQGsswGJfFera0b1KTrkU7tdfRoK6UOknx5Y6GskY1AN6TOlfSvgEN7Ji?=
 =?us-ascii?Q?UbDKj4AjHY2tq7FpXpQ01svyi47m9R3o9XkGJdtKUvICUf8otJ/pcdhj/WEi?=
 =?us-ascii?Q?mTTW12Vb5/BQmNWpNg82/LpmYgFGjYxnjuqjQOUPQtQWYXrsKtDYv3gcV9cL?=
 =?us-ascii?Q?726rdJy6Q/meMJ1K6J9GdJh7Bva6HeXancnr/EUAZ1Tn1A5tV8GZ9AeyLavb?=
 =?us-ascii?Q?wMbuNHK6QcHQte8YfRcmRg0qlXnvxD/ueF+Zca/Xg2Icx4XXj+GyqhQ6UQdc?=
 =?us-ascii?Q?MUdl+c8D0sOyueY5twnyakU/gVEzvWDLqyaRRnPTnkDDSCUBamg6kc0g+8/p?=
 =?us-ascii?Q?nip9SaCdGmnMm/6WUUs1m8v21SLgqeMW1pBATZjWHm1UjiUgyHyxY32FA1pX?=
 =?us-ascii?Q?u78xvQxIX/gavieJPNMe3C27J2SMsqOc0B2SYjvfXMYIll3c2LxqEboVU+fP?=
 =?us-ascii?Q?8Bd3uxUDr7iTWoWIz7zlL8dwh6ijckOniUC04sl+i9LlMszWFOq7iEMuLWrZ?=
 =?us-ascii?Q?6kEhpPnUrxHc9UZpMtuvMNJaMnT71udtEx7QMkl9X/xmlla8AJO6hJF67Hc4?=
 =?us-ascii?Q?mndQiEfF11JTA/66x7y3Rz9/KTkxrRBRs9bhiSbyVr2tV41mDqegbtmn1vVO?=
 =?us-ascii?Q?gpw0nq1Pg94CkIY4IeHt+AyFMM2oXcgPcOKT0X98gmdFy9Izvoj0RfyoI31D?=
 =?us-ascii?Q?QPTEVap5CLfOdcZCCG2Eex3KgaY1qqAaC4KZ/hwusRAbp276Mkx1pCSg5ejd?=
 =?us-ascii?Q?8jV1XyFMSYrcKc7SVV2Y4Q3VTOiRS3zxAfAhAwewpSDrMHp4//lbxdanRdCF?=
 =?us-ascii?Q?RZElw178kpuETfZxX3ZXZKiGHYEvNRPsKoZ4JsWXV1oOf7MEICf8BBiwLMTK?=
 =?us-ascii?Q?1/HKGWBgzuZLFjuCU/X+pMSGl9hB1uyj2kfxWcl7+rJBKzA3wHNTny1PUKlB?=
 =?us-ascii?Q?JyNz+0/EZ9XHeQv5K0rgx7y8QuTG//TwGHtE/rubM1xKPd87F/HbNYrVpETx?=
 =?us-ascii?Q?nwtfMZbuN5efg1QXIAxftrcm0q+GNlE59Rxo9IeuipciBYuc3tPW0hcg1eLV?=
 =?us-ascii?Q?w+jXwL+JLjCoL/aSS8cxLighiUycmgwn5Jv+Sc+RY26RdXoIgP/FdLShthVg?=
 =?us-ascii?Q?DMjl5i+FaZEJlSj4awC2RHQa/R671mFfZVgjJhii+DioDTma8VSektFth0ho?=
 =?us-ascii?Q?w0M1LIY72a0RYbx5FBq3H6Ws20mcElgjX1CRmOrZvNnfEWJYFkuuINfK2VcP?=
 =?us-ascii?Q?MR0O3mO+8bAoknfUdFkUt+vzH6deO6q+pz8Kr3byjTcKAruxhgC7zHV/b3SZ?=
 =?us-ascii?Q?/3bP108/CGzkWUs1F1E4RGzwwvt1TFeUlm5SHR2UgOBJJDCpBO3A7rpT3vv+?=
 =?us-ascii?Q?xG6VHjsOTBAVujelXfWGrjJMT7fePIdEX/mk0quu?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac27865-ddba-4b0e-0abe-08db0f26450f
X-MS-Exchange-CrossTenant-AuthSource: LO2P265MB5183.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 07:28:44.6406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tc+czhxEacModekUPpjTfR1U83PUQH3zeAv8dVB+13L7967nqraDa1IjipMFOxBz2pMpv0hqbIyq/RVbcl3i+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB5673
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Feb 2023 06:47:35 +0800
David Gow <davidgow@google.com> wrote:

> The rust_fmt_argument function is called from printk() to handle the %pA
> format specifier.
> 
> Since it's called from C, we should mark it extern "C" to make sure it's
> ABI compatible.
> 
> Cc: stable@vger.kernel.org
> Fixes: 247b365dc8dc ("rust: add `kernel` crate")
> Signed-off-by: David Gow <davidgow@google.com>

Reviewed-by: Gary Guo <gary@garyguo.net>

> ---
> 
> See discussion in:
> https://github.com/Rust-for-Linux/linux/pull/967
> and
> https://github.com/Rust-for-Linux/linux/pull/966
> 
> ---
>  rust/kernel/print.rs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/rust/kernel/print.rs b/rust/kernel/print.rs
> index 30103325696d..ec457f0952fe 100644
> --- a/rust/kernel/print.rs
> +++ b/rust/kernel/print.rs
> @@ -18,7 +18,7 @@ use crate::bindings;
>  
>  // Called from `vsprintf` with format specifier `%pA`.
>  #[no_mangle]
> -unsafe fn rust_fmt_argument(buf: *mut c_char, end: *mut c_char, ptr: *const c_void) -> *mut c_char {
> +unsafe extern "C" fn rust_fmt_argument(buf: *mut c_char, end: *mut c_char, ptr: *const c_void) -> *mut c_char {
>      use fmt::Write;
>      // SAFETY: The C contract guarantees that `buf` is valid if it's less than `end`.
>      let mut w = unsafe { RawFormatter::from_ptrs(buf.cast(), end.cast()) };

