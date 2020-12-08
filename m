Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F5C2D33DD
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 21:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730980AbgLHUQG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 15:16:06 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60066 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731121AbgLHUOF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 15:14:05 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B8IWDfx037247;
        Tue, 8 Dec 2020 13:59:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=lzcqFEbU7NHYw8/l6ryWEuEiIWW0e5AiiKIv8SW4s9s=;
 b=WkwhUy1P3oBJR1D1c6YcuKi9T48Mnq7cAqgME1yB7DlA5LKVhlR4Sa82cIYUf5ojF8no
 bXs5w2hQ30/ZxjNuQMpN8i+Mlb7t3dRTdUw8cjMmwmGpl8Utsa4HeGiBczQGeyw9ZT2d
 KrREmo32iprqRinMTg/fC/66+O4whTqzRcWtulgwn6yjplnMeV1G2VNGjyCmUZp0OrjE
 VzrZS/Yw/RKUTgc/x6rpUqsIYPv8PGib7fogjIdidxMvDjoYFlNVyQYLRqf4pakfL52s
 EhJGHQj1oIeAT6JbTSqol2HF7ae9gE4gtkbAGiHJWzxeXecqysY9lzZw+RXCBghQc8ud lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35acf2wv90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 13:59:40 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B8IWEeY037385;
        Tue, 8 Dec 2020 13:59:40 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35acf2wv8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 13:59:40 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B8IwxVU007497;
        Tue, 8 Dec 2020 18:59:39 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 3581u96c6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 18:59:39 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B8IxdHc26280654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Dec 2020 18:59:39 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 405D3112065;
        Tue,  8 Dec 2020 18:59:39 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8005E112062;
        Tue,  8 Dec 2020 18:59:37 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.65.215.138])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  8 Dec 2020 18:59:37 +0000 (GMT)
Subject: Re: [PATCH v2 1/2] powerpc/rtas: Restrict RTAS requests from
 userspace
To:     Andrew Donnellan <ajd@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org
Cc:     nathanl@linux.ibm.com, leobras.c@gmail.com, stable@vger.kernel.org,
        dja@axtens.net
References: <20200820044512.7543-1-ajd@linux.ibm.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <e58e8c42-d422-1bd7-ab38-9a1fb118fca4@linux.ibm.com>
Date:   Tue, 8 Dec 2020 10:59:36 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200820044512.7543-1-ajd@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_14:2020-12-08,2020-12-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1011 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012080112
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/19/20 9:45 PM, Andrew Donnellan wrote:
> A number of userspace utilities depend on making calls to RTAS to retrieve
> information and update various things.
> 
> The existing API through which we expose RTAS to userspace exposes more
> RTAS functionality than we actually need, through the sys_rtas syscall,
> which allows root (or anyone with CAP_SYS_ADMIN) to make any RTAS call they
> want with arbitrary arguments.
> 
> Many RTAS calls take the address of a buffer as an argument, and it's up to
> the caller to specify the physical address of the buffer as an argument. We
> allocate a buffer (the "RMO buffer") in the Real Memory Area that RTAS can
> access, and then expose the physical address and size of this buffer in
> /proc/powerpc/rtas/rmo_buffer. Userspace is expected to read this address,
> poke at the buffer using /dev/mem, and pass an address in the RMO buffer to
> the RTAS call.
> 
> However, there's nothing stopping the caller from specifying whatever
> address they want in the RTAS call, and it's easy to construct a series of
> RTAS calls that can overwrite arbitrary bytes (even without /dev/mem
> access).
> 
> Additionally, there are some RTAS calls that do potentially dangerous
> things and for which there are no legitimate userspace use cases.
> 
> In the past, this would not have been a particularly big deal as it was
> assumed that root could modify all system state freely, but with Secure
> Boot and lockdown we need to care about this.
> 
> We can't fundamentally change the ABI at this point, however we can address
> this by implementing a filter that checks RTAS calls against a list
> of permitted calls and forces the caller to use addresses within the RMO
> buffer.
> 
> The list is based off the list of calls that are used by the librtas
> userspace library, and has been tested with a number of existing userspace
> RTAS utilities. For compatibility with any applications we are not aware of
> that require other calls, the filter can be turned off at build time.
> 
> Reported-by: Daniel Axtens <dja@axtens.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
> 
> ---
> v1->v2:
> - address comments from mpe
> - shorten the names of some struct members
> - make the filter array static/ro_after_init, use const char *
> - genericise the fixed buffer size cases
> - simplify/get rid of some of the error printing
> - get rid of rtas_token_name()
> ---
>  arch/powerpc/Kconfig       |  13 ++++
>  arch/powerpc/kernel/rtas.c | 153 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 166 insertions(+)
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 1f48bbfb3ce9..8dd42b82379b 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -989,6 +989,19 @@ config PPC_SECVAR_SYSFS
>  	  read/write operations on these variables. Say Y if you have
>  	  secure boot enabled and want to expose variables to userspace.
> 
> +config PPC_RTAS_FILTER
> +	bool "Enable filtering of RTAS syscalls"
> +	default y
> +	depends on PPC_RTAS
> +	help
> +	  The RTAS syscall API has security issues that could be used to
> +	  compromise system integrity. This option enforces restrictions on the
> +	  RTAS calls and arguments passed by userspace programs to mitigate
> +	  these issues.
> +
> +	  Say Y unless you know what you are doing and the filter is causing
> +	  problems for you.
> +
>  endmenu
> 
>  config ISA_DMA_API
> diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
> index 806d554ce357..954f41676f69 100644
> --- a/arch/powerpc/kernel/rtas.c
> +++ b/arch/powerpc/kernel/rtas.c
> @@ -992,6 +992,147 @@ struct pseries_errorlog *get_pseries_errorlog(struct rtas_error_log *log,
>  	return NULL;
>  }
> 
> +#ifdef CONFIG_PPC_RTAS_FILTER
> +
> +/*
> + * The sys_rtas syscall, as originally designed, allows root to pass
> + * arbitrary physical addresses to RTAS calls. A number of RTAS calls
> + * can be abused to write to arbitrary memory and do other things that
> + * are potentially harmful to system integrity, and thus should only
> + * be used inside the kernel and not exposed to userspace.
> + *
> + * All known legitimate users of the sys_rtas syscall will only ever
> + * pass addresses that fall within the RMO buffer, and use a known
> + * subset of RTAS calls.
> + *
> + * Accordingly, we filter RTAS requests to check that the call is
> + * permitted, and that provided pointers fall within the RMO buffer.
> + * The rtas_filters list contains an entry for each permitted call,
> + * with the indexes of the parameters which are expected to contain
> + * addresses and sizes of buffers allocated inside the RMO buffer.
> + */
> +struct rtas_filter {
> +	const char *name;
> +	int token;
> +	/* Indexes into the args buffer, -1 if not used */
> +	int buf_idx1;
> +	int size_idx1;
> +	int buf_idx2;
> +	int size_idx2;
> +
> +	int fixed_size;
> +};
> +
> +static struct rtas_filter rtas_filters[] __ro_after_init = {
> +	{ "ibm,activate-firmware", -1, -1, -1, -1, -1 },
> +	{ "ibm,configure-connector", -1, 0, -1, 1, -1, 4096 },	/* Special cased */
> +	{ "display-character", -1, -1, -1, -1, -1 },
> +	{ "ibm,display-message", -1, 0, -1, -1, -1 },
> +	{ "ibm,errinjct", -1, 2, -1, -1, -1, 1024 },
> +	{ "ibm,close-errinjct", -1, -1, -1, -1, -1 },
> +	{ "ibm,open-errinct", -1, -1, -1, -1, -1 },

There is a typo here. Should be ibm,open-errinjct.

kernel: [ 1100.408626] sys_rtas: RTAS call blocked - exploit attempt?
kernel: [ 1100.408631] sys_rtas: token=0x26, nargs=0 (called by errinjct)

Which is producing this when trying to invoke the errinjct tool.

I'll send a fixes patch out shortly.

-Tyrel

> +	{ "ibm,get-config-addr-info2", -1, -1, -1, -1, -1 },
> +	{ "ibm,get-dynamic-sensor-state", -1, 1, -1, -1, -1 },
> +	{ "ibm,get-indices", -1, 2, 3, -1, -1 },
> +	{ "get-power-level", -1, -1, -1, -1, -1 },
> +	{ "get-sensor-state", -1, -1, -1, -1, -1 },
> +	{ "ibm,get-system-parameter", -1, 1, 2, -1, -1 },
> +	{ "get-time-of-day", -1, -1, -1, -1, -1 },
> +	{ "ibm,get-vpd", -1, 0, -1, 1, 2 },
> +	{ "ibm,lpar-perftools", -1, 2, 3, -1, -1 },
> +	{ "ibm,platform-dump", -1, 4, 5, -1, -1 },
> +	{ "ibm,read-slot-reset-state", -1, -1, -1, -1, -1 },
> +	{ "ibm,scan-log-dump", -1, 0, 1, -1, -1 },
> +	{ "ibm,set-dynamic-indicator", -1, 2, -1, -1, -1 },
> +	{ "ibm,set-eeh-option", -1, -1, -1, -1, -1 },
> +	{ "set-indicator", -1, -1, -1, -1, -1 },
> +	{ "set-power-level", -1, -1, -1, -1, -1 },
> +	{ "set-time-for-power-on", -1, -1, -1, -1, -1 },
> +	{ "ibm,set-system-parameter", -1, 1, -1, -1, -1 },
> +	{ "set-time-of-day", -1, -1, -1, -1, -1 },
> +	{ "ibm,suspend-me", -1, -1, -1, -1, -1 },
> +	{ "ibm,update-nodes", -1, 0, -1, -1, -1, 4096 },
> +	{ "ibm,update-properties", -1, 0, -1, -1, -1, 4096 },
> +	{ "ibm,physical-attestation", -1, 0, 1, -1, -1 },
> +};
> +
> +static bool in_rmo_buf(u32 base, u32 end)
> +{
> +	return base >= rtas_rmo_buf &&
> +		base < (rtas_rmo_buf + RTAS_RMOBUF_MAX) &&
> +		base <= end &&
> +		end >= rtas_rmo_buf &&
> +		end < (rtas_rmo_buf + RTAS_RMOBUF_MAX);
> +}
> +
> +static bool block_rtas_call(int token, int nargs,
> +			    struct rtas_args *args)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(rtas_filters); i++) {
> +		struct rtas_filter *f = &rtas_filters[i];
> +		u32 base, size, end;
> +
> +		if (token != f->token)
> +			continue;
> +
> +		if (f->buf_idx1 != -1) {
> +			base = be32_to_cpu(args->args[f->buf_idx1]);
> +			if (f->size_idx1 != -1)
> +				size = be32_to_cpu(args->args[f->size_idx1]);
> +			else if (f->fixed_size)
> +				size = f->fixed_size;
> +			else
> +				size = 1;
> +
> +			end = base + size - 1;
> +			if (!in_rmo_buf(base, end))
> +				goto err;
> +		}
> +
> +		if (f->buf_idx2 != -1) {
> +			base = be32_to_cpu(args->args[f->buf_idx2]);
> +			if (f->size_idx2 != -1)
> +				size = be32_to_cpu(args->args[f->size_idx2]);
> +			else if (f->fixed_size)
> +				size = f->fixed_size;
> +			else
> +				size = 1;
> +			end = base + size - 1;
> +
> +			/*
> +			 * Special case for ibm,configure-connector where the
> +			 * address can be 0
> +			 */
> +			if (!strcmp(f->name, "ibm,configure-connector") &&
> +			    base == 0)
> +				return false;
> +
> +			if (!in_rmo_buf(base, end))
> +				goto err;
> +		}
> +
> +		return false;
> +	}
> +
> +err:
> +	pr_err_ratelimited("sys_rtas: RTAS call blocked - exploit attempt?\n");
> +	pr_err_ratelimited("sys_rtas: token=0x%x, nargs=%d (called by %s)\n",
> +			   token, nargs, current->comm);
> +	return true;
> +}
> +
> +#else
> +
> +static bool block_rtas_call(int token, int nargs,
> +			    struct rtas_args *args)
> +{
> +	return false;
> +}
> +
> +#endif /* CONFIG_PPC_RTAS_FILTER */
> +
>  /* We assume to be passed big endian arguments */
>  SYSCALL_DEFINE1(rtas, struct rtas_args __user *, uargs)
>  {
> @@ -1029,6 +1170,9 @@ SYSCALL_DEFINE1(rtas, struct rtas_args __user *, uargs)
>  	args.rets = &args.args[nargs];
>  	memset(args.rets, 0, nret * sizeof(rtas_arg_t));
> 
> +	if (block_rtas_call(token, nargs, &args))
> +		return -EINVAL;
> +
>  	/* Need to handle ibm,suspend_me call specially */
>  	if (token == ibm_suspend_me_token) {
> 
> @@ -1090,6 +1234,9 @@ void __init rtas_initialize(void)
>  	unsigned long rtas_region = RTAS_INSTANTIATE_MAX;
>  	u32 base, size, entry;
>  	int no_base, no_size, no_entry;
> +#ifdef CONFIG_PPC_RTAS_FILTER
> +	int i;
> +#endif
> 
>  	/* Get RTAS dev node and fill up our "rtas" structure with infos
>  	 * about it.
> @@ -1129,6 +1276,12 @@ void __init rtas_initialize(void)
>  #ifdef CONFIG_RTAS_ERROR_LOGGING
>  	rtas_last_error_token = rtas_token("rtas-last-error");
>  #endif
> +
> +#ifdef CONFIG_PPC_RTAS_FILTER
> +	for (i = 0; i < ARRAY_SIZE(rtas_filters); i++) {
> +		rtas_filters[i].token = rtas_token(rtas_filters[i].name);
> +	}
> +#endif
>  }
> 
>  int __init early_init_dt_scan_rtas(unsigned long node,
> 

