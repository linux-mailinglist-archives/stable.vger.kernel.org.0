Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB05C194DBB
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 01:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgC0AHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 20:07:20 -0400
Received: from namei.org ([65.99.196.166]:43772 "EHLO namei.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbgC0AHU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 20:07:20 -0400
Received: from localhost (localhost [127.0.0.1])
        by namei.org (8.14.4/8.14.4) with ESMTP id 02R0771a016919;
        Fri, 27 Mar 2020 00:07:07 GMT
Date:   Fri, 27 Mar 2020 11:07:07 +1100 (AEDT)
From:   James Morris <jmorris@namei.org>
To:     Roberto Sassu <roberto.sassu@huawei.com>
cc:     zohar@linux.ibm.com, James.Bottomley@HansenPartnership.com,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, silviu.vlasceanu@huawei.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 2/7] ima: Evaluate error in init_ima()
In-Reply-To: <20200325104712.25694-3-roberto.sassu@huawei.com>
Message-ID: <alpine.LRH.2.21.2003271107000.14767@namei.org>
References: <20200325104712.25694-1-roberto.sassu@huawei.com> <20200325104712.25694-3-roberto.sassu@huawei.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 25 Mar 2020, Roberto Sassu wrote:

> Evaluate error in init_ima() before register_blocking_lsm_notifier() and
> return if not zero.
> 
> Cc: stable@vger.kernel.org # 5.3.x
> Fixes: b16942455193 ("ima: use the lsm policy update notifier")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  security/integrity/ima/ima_main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 9d0abedeae77..f96f151294e6 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -792,6 +792,9 @@ static int __init init_ima(void)
>  		error = ima_init();
>  	}
>  
> +	if (error)
> +		return error;
> +
>  	error = register_blocking_lsm_notifier(&ima_lsm_policy_notifier);
>  	if (error)
>  		pr_warn("Couldn't register LSM notifier, error %d\n", error);
> 


Reviewed-by: James Morris <jamorris@linux.microsoft.com>

-- 
James Morris
<jmorris@namei.org>

