Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3FE51E62C
	for <lists+stable@lfdr.de>; Sat,  7 May 2022 11:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343969AbiEGJvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 May 2022 05:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244252AbiEGJva (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 May 2022 05:51:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487E03584A;
        Sat,  7 May 2022 02:47:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4AD66111A;
        Sat,  7 May 2022 09:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2A4C385A9;
        Sat,  7 May 2022 09:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651916863;
        bh=TN9Ln0eWjWSNpAaJly0A68+GoYhMTOpf7TMoBE/D/8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eAdWlOck68816ScoivDDAizGIIpMuirzXMEnhlTuCe0boQDQ2FAbiKVwBSDw+1PKQ
         eryZIke41EI7FBgz3rBhcOPXg+qn/NcT+7LTFVsoooc1kbcEGoItAutByNEbYrDgWK
         Ur0gbDNafQq8fsmSCP56cwhjhCdircLlP8pdtgic=
Date:   Sat, 7 May 2022 11:47:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chen Zhongjin <chenzhongjin@huawei.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arch@vger.kernel.org, stable@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, namit@vmware.com,
        gor@linux.ibm.com, rdunlap@infradead.org, sashal@kernel.org
Subject: Re: [PATCH 5.10 v3] locking/csd_lock: fix csdlock_debug cause arm64
 boot panic
Message-ID: <YnZAO+3Rhj0gwq38@kroah.com>
References: <20220507084510.14761-1-chenzhongjin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220507084510.14761-1-chenzhongjin@huawei.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 07, 2022 at 04:45:10PM +0800, Chen Zhongjin wrote:
> csdlock_debug is a early_param to enable csd_lock_wait
> feature.
> 
> It uses static_branch_enable in early_param which triggers
> a panic on arm64 with config:
> CONFIG_SPARSEMEM=y
> CONFIG_SPARSEMEM_VMEMMAP=n
> 
> The log shows:
> Unable to handle kernel NULL pointer dereference at
> virtual address ", '0' <repeats 16 times>, "
> ...
> Call trace:
> __aarch64_insn_write+0x9c/0x18c
> ...
> static_key_enable+0x1c/0x30
> csdlock_debug+0x4c/0x78
> do_early_param+0x9c/0xcc
> parse_args+0x26c/0x3a8
> parse_early_options+0x34/0x40
> parse_early_param+0x80/0xa4
> setup_arch+0x150/0x6c8
> start_kernel+0x8c/0x720
> ...
> Kernel panic - not syncing: Oops: Fatal exception
> 
> Call trace inside __aarch64_insn_write:
> __nr_to_section
> __pfn_to_page
> phys_to_page
> patch_map
> __aarch64_insn_write
> 
> Here, with CONFIG_SPARSEMEM_VMEMMAP=n, __nr_to_section returns
> NULL and makes the NULL dereference because mem_section is
> initialized in sparse_init after parse_early_param stage.
> 
> So, static_branch_enable shouldn't be used inside early_param.
> To avoid this, I changed it to __setup and fixed this.
> 
> Reported-by: Chen jingwen <chenjingwen6@huawei.com>
> Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
> ---
> Change v2 -> v3:
> Add module name in title
> 
> Change v1 -> v2:
> Fix return 1 for __setup
> ---
> 
>  kernel/smp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 65a630f62363..381eb15cd28f 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -174,9 +174,9 @@ static int __init csdlock_debug(char *str)
>  	if (val)
>  		static_branch_enable(&csdlock_debug_enabled);
>  
> -	return 0;
> +	return 1;
>  }
> -early_param("csdlock_debug", csdlock_debug);
> +__setup("csdlock_debug=", csdlock_debug);
>  
>  static DEFINE_PER_CPU(call_single_data_t *, cur_csd);
>  static DEFINE_PER_CPU(smp_call_func_t, cur_csd_func);
> -- 
> 2.17.1
> 


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
