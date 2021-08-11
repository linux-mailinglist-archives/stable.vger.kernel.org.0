Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7EA3E9506
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 17:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbhHKPuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 11:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233215AbhHKPuj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Aug 2021 11:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72CF960F46;
        Wed, 11 Aug 2021 15:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628697015;
        bh=bAQmrlaUVkq13+zcTrfGl3O+cLvwRrRvfQjisxSvWgs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=IxRvROWUBR28R+IXOU9fS1Dek63Fcy/cb+8EDDi0xjS2/56FDRKhEdymIWuhtiuWn
         yWs1q+lZRbrB0SUx40bp79lSNFP16WjOGJgESmkwLV6a5jjj5Xu5Ni4nXXrOwV52xs
         vPTJolg/mNdtTbH0S7YL5Tc/BK9cJvxZdzJNuq5ri2IoLf9IUOLpGqZXVfLh1seYYC
         dxk6FklCAY6Bv4sdZN34BixjeNitUqdwRtC5ERdyYmVGXZKez6ntzv4sBRkI/XkzvU
         niscNOFikv5lqs0FtCTNXQfPZQ/nVl00I99MToVS76iJdIuaurC7igxL4DTF1FnA7d
         wtnpmc/33omRg==
Subject: Re: [PATCH 5.13 159/175] interconnect: qcom: icc-rpmh: Add BCMs to
 commit list in pre_aggregate
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Mike Tipton <mdtipton@codeaurora.org>
References: <20210810173000.928681411@linuxfoundation.org>
 <20210810173006.202673615@linuxfoundation.org>
From:   Georgi Djakov <djakov@kernel.org>
Message-ID: <b52559cd-7f4a-70af-8878-a9e513a66bcd@kernel.org>
Date:   Wed, 11 Aug 2021 18:50:12 +0300
MIME-Version: 1.0
In-Reply-To: <20210810173006.202673615@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.08.21 20:31, Greg Kroah-Hartman wrote:
> From: Mike Tipton <mdtipton@codeaurora.org>
> 
> commit f84f5b6f72e68bbaeb850b58ac167e4a3a47532a upstream.
> 
> We're only adding BCMs to the commit list in aggregate(), but there are
> cases where pre_aggregate() is called without subsequently calling
> aggregate(). In particular, in icc_sync_state() when a node with initial
> BW has zero requests. Since BCMs aren't added to the commit list in
> these cases, we don't actually send the zero BW request to HW. So the
> resources remain on unnecessarily.
> 
> Add BCMs to the commit list in pre_aggregate() instead, which is always
> called even when there are no requests.
> 
> Fixes: 976daac4a1c5 ("interconnect: qcom: Consolidate interconnect RPMh support")
> Signed-off-by: Mike Tipton <mdtipton@codeaurora.org>
> Link: https://lore.kernel.org/r/20210721175432.2119-5-mdtipton@codeaurora.org
> Signed-off-by: Georgi Djakov <djakov@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Hello Greg,

Please drop this patch, as people are reporting issues on some
platforms. So please do not apply it to any stable trees yet
(5.10 and 5.13). I will send a revert (or other fix) to you soon.

Thanks,
Georgi

> ---
>   drivers/interconnect/qcom/icc-rpmh.c |   10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> --- a/drivers/interconnect/qcom/icc-rpmh.c
> +++ b/drivers/interconnect/qcom/icc-rpmh.c
> @@ -20,13 +20,18 @@ void qcom_icc_pre_aggregate(struct icc_n
>   {
>   	size_t i;
>   	struct qcom_icc_node *qn;
> +	struct qcom_icc_provider *qp;
>   
>   	qn = node->data;
> +	qp = to_qcom_provider(node->provider);
>   
>   	for (i = 0; i < QCOM_ICC_NUM_BUCKETS; i++) {
>   		qn->sum_avg[i] = 0;
>   		qn->max_peak[i] = 0;
>   	}
> +
> +	for (i = 0; i < qn->num_bcms; i++)
> +		qcom_icc_bcm_voter_add(qp->voter, qn->bcms[i]);
>   }
>   EXPORT_SYMBOL_GPL(qcom_icc_pre_aggregate);
>   
> @@ -44,10 +49,8 @@ int qcom_icc_aggregate(struct icc_node *
>   {
>   	size_t i;
>   	struct qcom_icc_node *qn;
> -	struct qcom_icc_provider *qp;
>   
>   	qn = node->data;
> -	qp = to_qcom_provider(node->provider);
>   
>   	if (!tag)
>   		tag = QCOM_ICC_TAG_ALWAYS;
> @@ -67,9 +70,6 @@ int qcom_icc_aggregate(struct icc_node *
>   	*agg_avg += avg_bw;
>   	*agg_peak = max_t(u32, *agg_peak, peak_bw);
>   
> -	for (i = 0; i < qn->num_bcms; i++)
> -		qcom_icc_bcm_voter_add(qp->voter, qn->bcms[i]);
> -
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(qcom_icc_aggregate);
> 
> 

