Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE2D7EBA8
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 06:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732072AbfHBEyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 00:54:32 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48620 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732011AbfHBEyc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 00:54:32 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1htPa4-0006FG-Ty; Fri, 02 Aug 2019 14:54:17 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1htPa2-0004iC-27; Fri, 02 Aug 2019 14:54:14 +1000
Date:   Fri, 2 Aug 2019 14:54:13 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
Cc:     "qat-linux@intel.com" <qat-linux@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - Silence smp_processor_id() warning
Message-ID: <20190802045413.GB18077@gondor.apana.org.au>
References: <20190723072347.16247-1-alexander.sverdlin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723072347.16247-1-alexander.sverdlin@nokia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 23, 2019 at 07:24:01AM +0000, Sverdlin, Alexander (Nokia - DE/Ulm) wrote:
> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> 
> It seems that smp_processor_id() is only used for a best-effort
> load-balancing, refer to qat_crypto_get_instance_node(). It's not feasible
> to disable preemption for the duration of the crypto requests. Therefore,
> just silence the warning. This commit is similar to e7a9b05ca4
> ("crypto: cavium - Fix smp_processor_id() warnings").
> 
> Silences the following splat:
> BUG: using smp_processor_id() in preemptible [00000000] code: cryptomgr_test/2904
> caller is qat_alg_ablkcipher_setkey+0x300/0x4a0 [intel_qat]
> CPU: 1 PID: 2904 Comm: cryptomgr_test Tainted: P           O    4.14.69 #1
> ...
> Call Trace:
>  dump_stack+0x5f/0x86
>  check_preemption_disabled+0xd3/0xe0
>  qat_alg_ablkcipher_setkey+0x300/0x4a0 [intel_qat]
>  skcipher_setkey_ablkcipher+0x2b/0x40
>  __test_skcipher+0x1f3/0xb20
>  ? cpumask_next_and+0x26/0x40
>  ? find_busiest_group+0x10e/0x9d0
>  ? preempt_count_add+0x49/0xa0
>  ? try_module_get+0x61/0xf0
>  ? crypto_mod_get+0x15/0x30
>  ? __kmalloc+0x1df/0x1f0
>  ? __crypto_alloc_tfm+0x116/0x180
>  ? crypto_skcipher_init_tfm+0xa6/0x180
>  ? crypto_create_tfm+0x4b/0xf0
>  test_skcipher+0x21/0xa0
>  alg_test_skcipher+0x3f/0xa0
>  alg_test.part.6+0x126/0x2a0
>  ? finish_task_switch+0x21b/0x260
>  ? __schedule+0x1e9/0x800
>  ? __wake_up_common+0x8d/0x140
>  cryptomgr_test+0x40/0x50
>  kthread+0xff/0x130
>  ? cryptomgr_notify+0x540/0x540
>  ? kthread_create_on_node+0x70/0x70
>  ret_from_fork+0x24/0x50
> 
> Fixes: ed8ccaef52 ("crypto: qat - Add support for SRIOV")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> ---
>  drivers/crypto/qat/qat_common/adf_common_drv.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
