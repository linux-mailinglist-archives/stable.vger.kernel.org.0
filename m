Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2079C2EBD11
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 12:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbhAFLUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 06:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbhAFLUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 06:20:45 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742CCC06134C;
        Wed,  6 Jan 2021 03:20:05 -0800 (PST)
Received: from zn.tnic (p200300ec2f096900a40cd61b64ba6652.dip0.t-ipconnect.de [IPv6:2003:ec:2f09:6900:a40c:d61b:64ba:6652])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D668D1EC04A6;
        Wed,  6 Jan 2021 12:20:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1609932003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=GkbOGO3ttAQssPFItWpFkdwfZXTITZYEyMkEOic6szc=;
        b=cXt344jMP5rmWn+UIdx3p+HWpGLCDOgbIkFDc7LG1jnLEbcTjm8T3k3cDkg0+F0RqhBClV
        bELDXZG/XkIUtiZydY4K+xgXNs3S6D+zmAOo9iz5ZehWoBGBsduDIxBf0qG1m2AWZW3Bq2
        Q3+kmIFcdpe4bwURYReTN9gsDk70zQk=
Date:   Wed, 6 Jan 2021 12:19:58 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     tglx@linutronix.de, fenghua.yu@intel.com, tony.luck@intel.com,
        kuo-lang.tseng@intel.com, shakeelb@google.com,
        valentin.schneider@arm.com, mingo@redhat.com, babu.moger@amd.com,
        james.morse@arm.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V2 1/4] x86/resctrl: Use IPI instead of task_work_add()
 to update PQR_ASSOC MSR
Message-ID: <20210106111958.GD5729@zn.tnic>
References: <cover.1608243147.git.reinette.chatre@intel.com>
 <17aa2fb38fc12ce7bb710106b3e7c7b45acb9e94.1608243147.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <17aa2fb38fc12ce7bb710106b3e7c7b45acb9e94.1608243147.git.reinette.chatre@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 17, 2020 at 02:31:18PM -0800, Reinette Chatre wrote:
> +#ifdef CONFIG_SMP
> +static void update_task_closid_rmid(struct task_struct *t)
> +{
> +	if (task_curr(t))
> +		smp_call_function_single(task_cpu(t), _update_task_closid_rmid,
> +					 t, 1);
>  }
> +#else
> +static void update_task_closid_rmid(struct task_struct *t)
> +{
> +	_update_task_closid_rmid(t);
> +}
> +#endif

Why the ifdeffery? Why not simply:

static void update_task_closid_rmid(struct task_struct *t)
{
        if (IS_ENABLED(CONFIG_SMP) && task_curr(t))
                smp_call_function_single(task_cpu(t), _update_task_closid_rmid, t, 1);
        else
                _update_task_closid_rmid(t);
}

?

If no particular reason, I'll change it before committing.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
