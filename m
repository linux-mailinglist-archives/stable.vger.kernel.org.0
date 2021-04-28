Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FC136CFFE
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 02:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbhD1AeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 20:34:08 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58322 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230368AbhD1AeH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 20:34:07 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13S0FBgK117443;
        Tue, 27 Apr 2021 20:33:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Bqh0XR4uvdMmpYoD5Ge/9QTxs+C6jyiYEkkYUMqiENE=;
 b=kVTd2kdx+r6K1I1dp4HGBjmr6JjjLbauzSrfBrU2AelSa8JUmtN6OxHQh/UWbET/bbLM
 NLvmoudPkPxVRomnHy1zsni+EuvNBh5wap7WX5mj+aebk0k2flaevoghQjmlnjA+4Wvo
 f41lNiF50NKTL2lf1Ar4HG6Jo/si1BahYv8vKp2EP8GDz18SaKInkKds++tYIe1yWKvQ
 R6W8WuG4zrnLNohlaxuuOe4x7eLuEalgnKjxE2Xzx1lO4wQvuOVAfSpDIw+v56E/DPh4
 0Qu5MisgMnXYERp4PJqRme5wRjQO/NW5GV8KLq/6kcVkzGB3dcaOkTZVHoQdTY/0LT7C Dg== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 386w0a0b00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Apr 2021 20:33:17 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13S0X7fb015090;
        Wed, 28 Apr 2021 00:33:16 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01dal.us.ibm.com with ESMTP id 384ay97gw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Apr 2021 00:33:16 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13S0WsN929294964
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Apr 2021 00:32:54 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87E846A04D;
        Wed, 28 Apr 2021 00:32:54 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35B4F6A04F;
        Wed, 28 Apr 2021 00:32:53 +0000 (GMT)
Received: from oc6857751186.ibm.com (unknown [9.65.213.116])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 28 Apr 2021 00:32:52 +0000 (GMT)
Subject: Re: [PATCH v6] powerpc/kexec_file: use current CPU info while setting
 up FDT
To:     Sourabh Jain <sourabhjain@linux.ibm.com>, mpe@ellerman.id.au
Cc:     mahesh@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
        stable@vger.kernel.org, hbathini@linux.ibm.com,
        bauerman@linux.ibm.com
References: <20210427045120.2109980-1-sourabhjain@linux.ibm.com>
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
Message-ID: <8c3da505-f034-289a-819d-2841a5c7e580@linux.ibm.com>
Date:   Tue, 27 Apr 2021 17:32:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210427045120.2109980-1-sourabhjain@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tJrfGveXQOJMWSZ-aW_UGZIY2Y2N-ZXG
X-Proofpoint-ORIG-GUID: tJrfGveXQOJMWSZ-aW_UGZIY2Y2N-ZXG
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-27_13:2021-04-27,2021-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 clxscore=1011 priorityscore=1501 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104270165
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/21 9:51 PM, Sourabh Jain wrote:
> kexec_file_load uses initial_boot_params in setting up the device-tree
> for the kernel to be loaded. Though initial_boot_params holds info
> about CPUs at the time of boot, it doesn't account for hot added CPUs.
> 
> So, kexec'ing with kexec_file_load syscall would leave the kexec'ed
> kernel with inaccurate CPU info. Also, if kdump kernel is loaded with
> kexec_file_load syscall and the system crashes on a hot added CPU,
> capture kernel hangs failing to identify the boot CPU.
> 
>  Kernel panic - not syncing: sysrq triggered crash
>  CPU: 24 PID: 6065 Comm: echo Kdump: loaded Not tainted 5.12.0-rc5upstream #54
>  Call Trace:
>  [c0000000e590fac0] [c0000000007b2400] dump_stack+0xc4/0x114 (unreliable)
>  [c0000000e590fb00] [c000000000145290] panic+0x16c/0x41c
>  [c0000000e590fba0] [c0000000008892e0] sysrq_handle_crash+0x30/0x40
>  [c0000000e590fc00] [c000000000889cdc] __handle_sysrq+0xcc/0x1f0
>  [c0000000e590fca0] [c00000000088a538] write_sysrq_trigger+0xd8/0x178
>  [c0000000e590fce0] [c0000000005e9b7c] proc_reg_write+0x10c/0x1b0
>  [c0000000e590fd10] [c0000000004f26d0] vfs_write+0xf0/0x330
>  [c0000000e590fd60] [c0000000004f2aec] ksys_write+0x7c/0x140
>  [c0000000e590fdb0] [c000000000031ee0] system_call_exception+0x150/0x290
>  [c0000000e590fe10] [c00000000000ca5c] system_call_common+0xec/0x278
>  --- interrupt: c00 at 0x7fff905b9664
>  NIP:  00007fff905b9664 LR: 00007fff905320c4 CTR: 0000000000000000
>  REGS: c0000000e590fe80 TRAP: 0c00   Not tainted  (5.12.0-rc5upstream)
>  MSR:  800000000280f033 <SF,VEC,VSX,EE,PR,FP,ME,IR,DR,RI,LE>  CR: 28000242
>        XER: 00000000
>  IRQMASK: 0
>  GPR00: 0000000000000004 00007ffff5fedf30 00007fff906a7300 0000000000000001
>  GPR04: 000001002a7355b0 0000000000000002 0000000000000001 00007ffff5fef616
>  GPR08: 0000000000000001 0000000000000000 0000000000000000 0000000000000000
>  GPR12: 0000000000000000 00007fff9073a160 0000000000000000 0000000000000000
>  GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>  GPR20: 0000000000000000 00007fff906a4ee0 0000000000000002 0000000000000001
>  GPR24: 00007fff906a0898 0000000000000000 0000000000000002 000001002a7355b0
>  GPR28: 0000000000000002 00007fff906a1790 000001002a7355b0 0000000000000002
>  NIP [00007fff905b9664] 0x7fff905b9664
>  LR [00007fff905320c4] 0x7fff905320c4
>  --- interrupt: c00
> 
> To avoid this from happening, extract current CPU info from of_root
> device node and use it for setting up the fdt in kexec_file_load case.
> 
> Fixes: 6ecd0163d360 ("powerpc/kexec_file: Add appropriate regions for memory reserve map")
> 
> Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/powerpc/kexec/file_load_64.c | 88 +++++++++++++++++++++++++++++++
>  1 file changed, 88 insertions(+)
> 
>  ---
> Changelog:
> 
> v1 -> v5
>   - https://lists.ozlabs.org/pipermail/linuxppc-dev/2021-April/227950.html
> 
> v5 -> v6
>   - use exiting macro (for_each_property_of_node) to loop through all
>     properties of a node.
>   - removed devtree_lock while accessing the node properties.
>   - function name update, add_node_prop to add_node_props.
>  ---
> 
> diff --git a/arch/powerpc/kexec/file_load_64.c b/arch/powerpc/kexec/file_load_64.c
> index 02b9e4d0dc40..4f7d4c10f939 100644
> --- a/arch/powerpc/kexec/file_load_64.c
> +++ b/arch/powerpc/kexec/file_load_64.c
> @@ -960,6 +960,89 @@ unsigned int kexec_fdt_totalsize_ppc64(struct kimage *image)
>  	return fdt_size;
>  }
> 
> +/**
> + * add_node_props - Reads node properties from device node structure and add
> + *                  them to fdt.
> + * @fdt:            Flattened device tree of the kernel
> + * @node_offset:    offset of the node to add a property at
> + * @dn:             device node pointer
> + *
> + * Returns 0 on success, negative errno on error.
> + */
> +static int add_node_props(void *fdt, int node_offset, const struct device_node *dn)
> +{
> +	int ret = 0;
> +	struct property *pp;
> +
> +	if (!dn)
> +		return -EINVAL;
> +
> +	for_each_property_of_node(dn, pp) {
> +		ret = fdt_setprop(fdt, node_offset, pp->name, pp->value, pp->length);
> +		if (ret < 0) {
> +			pr_err("Unable to add %s property: %s\n", pp->name, fdt_strerror(ret));
> +			return ret;
> +		}
> +	}
> +	return ret;
> +}
> +
> +/**
> + * update_cpus_node - Update cpus node of flattened device tree using of_root
> + *                    device node.
> + * @fdt:              Flattened device tree of the kernel.
> + *
> + * Returns 0 on success, negative errno on error.
> + */
> +static int update_cpus_node(void *fdt)
> +{
> +	struct device_node *cpus_node, *dn;
> +	int cpus_offset, cpus_subnode_offset, ret = 0;
> +
> +	cpus_offset = fdt_path_offset(fdt, "/cpus");
> +	if (cpus_offset < 0 && cpus_offset != -FDT_ERR_NOTFOUND) {
> +		pr_err("Malformed device tree: error reading /cpus node: %s\n",
> +		       fdt_strerror(cpus_offset));
> +		return cpus_offset;
> +	}
> +
> +	if (cpus_offset > 0) {
> +		ret = fdt_del_node(fdt, cpus_offset);
> +		if (ret < 0) {
> +			pr_err("Error deleting /cpus node: %s\n", fdt_strerror(ret));
> +			return -EINVAL;
> +		}
> +	}
> +
> +	/* Add cpus node to fdt */
> +	cpus_offset = fdt_add_subnode(fdt, fdt_path_offset(fdt, "/"), "cpus");
> +	if (cpus_offset < 0) {
> +		pr_err("Error creating /cpus node: %s\n", fdt_strerror(cpus_offset));
> +		return -EINVAL;
> +	}
> +
> +	/* Add cpus node properties */
> +	cpus_node = of_find_node_by_path("/cpus");

Pretty sure that of_find_node_by_path() returns a device_node with its refcount
incremented.

> +	ret = add_node_props(fdt, cpus_offset, cpus_node);

Need a of_node_put(cpus_node) here.

-Tyrel

> +	if (ret < 0)
> +		return ret;
> +
> +	/* Loop through all subnodes of cpus and add them to fdt */
> +	for_each_node_by_type(dn, "cpu") {
> +		cpus_subnode_offset = fdt_add_subnode(fdt, cpus_offset, dn->full_name);
> +		if (cpus_subnode_offset < 0) {
> +			pr_err("Unable to add %s subnode: %s\n", dn->full_name,
> +			       fdt_strerror(cpus_subnode_offset));
> +			return cpus_subnode_offset;
> +		}
> +		ret = add_node_props(fdt, cpus_subnode_offset, dn);
> +		if (ret < 0)
> +			return ret;
> +	}
> +	of_node_put(dn);
> +	return ret;
> +}
> +
>  /**
>   * setup_new_fdt_ppc64 - Update the flattend device-tree of the kernel
>   *                       being loaded.
> @@ -1020,6 +1103,11 @@ int setup_new_fdt_ppc64(const struct kimage *image, void *fdt,
>  		}
>  	}
> 
> +	/* Update cpus nodes information to account hotplug CPUs. */
> +	ret =  update_cpus_node(fdt);
> +	if (ret < 0)
> +		return ret;
> +
>  	/* Update memory reserve map */
>  	ret = get_reserved_memory_ranges(&rmem);
>  	if (ret)
> 

