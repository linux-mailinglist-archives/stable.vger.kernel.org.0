Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF7E768B8
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387830AbfGZNqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:46:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39074 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387711AbfGZNqt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:46:49 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CFBE630860D1;
        Fri, 26 Jul 2019 13:46:48 +0000 (UTC)
Received: from prarit.bos.redhat.com (prarit-guest.khw1.lab.eng.bos.redhat.com [10.16.200.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2E2579423;
        Fri, 26 Jul 2019 13:46:47 +0000 (UTC)
Subject: Re: [PATCH AUTOSEL 5.2 13/85] kernel/module.c: Only return -EEXIST
 for modules that have finished loading
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Barret Rhoden <brho@google.com>, David Arcari <darcari@redhat.com>,
        Jessica Yu <jeyu@kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20190726133936.11177-1-sashal@kernel.org>
 <20190726133936.11177-13-sashal@kernel.org>
From:   Prarit Bhargava <prarit@redhat.com>
Message-ID: <cb703dc8-03a3-a877-2e5f-72a349e0f2d7@redhat.com>
Date:   Fri, 26 Jul 2019 09:46:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190726133936.11177-13-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 26 Jul 2019 13:46:49 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/26/19 9:38 AM, Sasha Levin wrote:
> From: Prarit Bhargava <prarit@redhat.com>
> 
> [ Upstream commit 6e6de3dee51a439f76eb73c22ae2ffd2c9384712 ]
> 
> Microsoft HyperV disables the X86_FEATURE_SMCA bit on AMD systems, and
> linux guests boot with repeated errors:
> 

Hey Sasha, I'd prefer to leave this out of stable branches for now.  Linus is a
bit nervous about it and I like to get see more soak time before the patch is
backported to stable.

https://lkml.org/lkml/2019/7/18/680

FWIW we've been running this in RHEL for some time now without any issues.

P.

> amd64_edac_mod: Unknown symbol amd_unregister_ecc_decoder (err -2)
> amd64_edac_mod: Unknown symbol amd_register_ecc_decoder (err -2)
> amd64_edac_mod: Unknown symbol amd_report_gart_errors (err -2)
> amd64_edac_mod: Unknown symbol amd_unregister_ecc_decoder (err -2)
> amd64_edac_mod: Unknown symbol amd_register_ecc_decoder (err -2)
> amd64_edac_mod: Unknown symbol amd_report_gart_errors (err -2)
> 
> The warnings occur because the module code erroneously returns -EEXIST
> for modules that have failed to load and are in the process of being
> removed from the module list.
> 
> module amd64_edac_mod has a dependency on module edac_mce_amd.  Using
> modules.dep, systemd will load edac_mce_amd for every request of
> amd64_edac_mod.  When the edac_mce_amd module loads, the module has
> state MODULE_STATE_UNFORMED and once the module load fails and the state
> becomes MODULE_STATE_GOING.  Another request for edac_mce_amd module
> executes and add_unformed_module() will erroneously return -EEXIST even
> though the previous instance of edac_mce_amd has MODULE_STATE_GOING.
> Upon receiving -EEXIST, systemd attempts to load amd64_edac_mod, which
> fails because of unknown symbols from edac_mce_amd.
> 
> add_unformed_module() must wait to return for any case other than
> MODULE_STATE_LIVE to prevent a race between multiple loads of
> dependent modules.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Signed-off-by: Barret Rhoden <brho@google.com>
> Cc: David Arcari <darcari@redhat.com>
> Cc: Jessica Yu <jeyu@kernel.org>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Jessica Yu <jeyu@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/module.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 80c7c09584cf..8431c3d47c97 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3385,8 +3385,7 @@ static bool finished_loading(const char *name)
>  	sched_annotate_sleep();
>  	mutex_lock(&module_mutex);
>  	mod = find_module_all(name, strlen(name), true);
> -	ret = !mod || mod->state == MODULE_STATE_LIVE
> -		|| mod->state == MODULE_STATE_GOING;
> +	ret = !mod || mod->state == MODULE_STATE_LIVE;
>  	mutex_unlock(&module_mutex);
>  
>  	return ret;
> @@ -3576,8 +3575,7 @@ static int add_unformed_module(struct module *mod)
>  	mutex_lock(&module_mutex);
>  	old = find_module_all(mod->name, strlen(mod->name), true);
>  	if (old != NULL) {
> -		if (old->state == MODULE_STATE_COMING
> -		    || old->state == MODULE_STATE_UNFORMED) {
> +		if (old->state != MODULE_STATE_LIVE) {
>  			/* Wait in case it fails to load. */
>  			mutex_unlock(&module_mutex);
>  			err = wait_event_interruptible(module_wq,
> 
