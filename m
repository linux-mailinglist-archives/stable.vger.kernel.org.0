Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A4F2E64F3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393170AbgL1Py6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:54:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:49210 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393182AbgL1Pyz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 10:54:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AA7A8AB8B;
        Mon, 28 Dec 2020 15:54:13 +0000 (UTC)
Date:   Mon, 28 Dec 2020 16:54:09 +0100
From:   Borislav Petkov <bp@suse.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 150/453] EDAC/mce_amd: Use struct
 cpuinfo_x86.cpu_die_id for AMD NodeId
Message-ID: <20201228155409.GA19838@zn.tnic>
References: <20201228124937.240114599@linuxfoundation.org>
 <20201228124944.423928426@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201228124944.423928426@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 01:46:26PM +0100, Greg Kroah-Hartman wrote:
> From: Yazen Ghannam <yazen.ghannam@amd.com>
> 
> [ Upstream commit 8de0c9917cc1297bc5543b61992d5bdee4ce621a ]
> 
> The edac_mce_amd module calls decode_dram_ecc() on AMD Family17h and
> later systems. This function is used in amd64_edac_mod to do
> system-specific decoding for DRAM ECC errors. The function takes a
> "NodeId" as a parameter.
> 
> In AMD documentation, NodeId is used to identify a physical die in a
> system. This can be used to identify a node in the AMD_NB code and also
> it is used with umc_normaddr_to_sysaddr().
> 
> However, the input used for decode_dram_ecc() is currently the NUMA node
> of a logical CPU. In the default configuration, the NUMA node and
> physical die will be equivalent, so this doesn't have an impact.
> 
> But the NUMA node configuration can be adjusted with optional memory
> interleaving modes. This will cause the NUMA node enumeration to not
> match the physical die enumeration. The mismatch will cause the address
> translation function to fail or report incorrect results.
> 
> Use struct cpuinfo_x86.cpu_die_id for the node_id parameter to ensure the
> physical ID is used.
> 
> Fixes: fbe63acf62f5 ("EDAC, mce_amd: Use cpu_to_node() to find the node ID")
> Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Link: https://lkml.kernel.org/r/20201109210659.754018-4-Yazen.Ghannam@amd.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/edac/mce_amd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
> index ea622c6f3a393..c19640a453f22 100644
> --- a/drivers/edac/mce_amd.c
> +++ b/drivers/edac/mce_amd.c
> @@ -975,7 +975,7 @@ static void decode_smca_error(struct mce *m)
>  	}
>  
>  	if (bank_type == SMCA_UMC && xec == 0 && decode_dram_ecc)
> -		decode_dram_ecc(cpu_to_node(m->extcpu), m);
> +		decode_dram_ecc(topology_die_id(m->extcpu), m);
>  }
>  
>  static inline void amd_decode_err_code(u16 ec)

I believe this one needs:

028c221ed190 ("x86/CPU/AMD: Save AMD NodeId as cpu_die_id")

to be backported too otherwise ->cpu_die_id will be uninitialized.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
