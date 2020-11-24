Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5994C2C2A81
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 15:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389250AbgKXOzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 09:55:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34038 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388165AbgKXOzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 09:55:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606229746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IDhfVYWGoL+IpVNQ3e9z+GzCQ3AwBmJ5YyBaFP+39/s=;
        b=PwiZZaYNGrh3xH73nYYkPq8EX8G2ae7u4whZsI3HS6KyctiPnYZwPTF4G7Vnf1OPR+qz43
        NDwtG9CAfySUAyhC+TpBhQ24Oc4pV6WMlU78MynQvzYZ8mkIIuHHWQJLZJXGKp0Pi+XvPh
        ULjj1lGRz5QfDl3DZOUD35KfjLFiRDw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-uhRFpvSLPfWubnd5bhYaXw-1; Tue, 24 Nov 2020 09:55:42 -0500
X-MC-Unique: uhRFpvSLPfWubnd5bhYaXw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E98ED9A229;
        Tue, 24 Nov 2020 14:55:40 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BDB65D6AB;
        Tue, 24 Nov 2020 14:55:40 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-nvdimm@lists.01.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] ACPI: NFIT: Fix input validation of bus-family
References: <160619566216.201177.9354229595539334957.stgit@dwillia2-desk3.amr.corp.intel.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Tue, 24 Nov 2020 09:55:44 -0500
In-Reply-To: <160619566216.201177.9354229595539334957.stgit@dwillia2-desk3.amr.corp.intel.com>
        (Dan Williams's message of "Mon, 23 Nov 2020 21:27:42 -0800")
Message-ID: <x49ft4yiz2n.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dan Williams <dan.j.williams@intel.com> writes:

> Dan reports that smatch thinks userspace can craft an out-of-bound bus
> family number. However, nd_cmd_clear_to_send() blocks all non-zero
> values of bus-family since only the kernel can initiate these commands.
> However, in the speculation path, family is a user controlled array
> index value so mask it for speculation safety. Also, since the
> nd_cmd_clear_to_send() safety is non-obvious and possibly may change in
> the future include input validation is if userspace could get past the
> nd_cmd_clear_to_send() gatekeeper.
>
> Link: http://lore.kernel.org/r/20201111113000.GA1237157@mwanda
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: 6450ddbd5d8e ("ACPI: NFIT: Define runtime firmware activation commands")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/nfit/core.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index cda7b6c52504..b11b08a60684 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -5,6 +5,7 @@
>  #include <linux/list_sort.h>
>  #include <linux/libnvdimm.h>
>  #include <linux/module.h>
> +#include <linux/nospec.h>
>  #include <linux/mutex.h>
>  #include <linux/ndctl.h>
>  #include <linux/sysfs.h>
> @@ -479,8 +480,11 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>  		cmd_mask = nd_desc->cmd_mask;
>  		if (cmd == ND_CMD_CALL && call_pkg->nd_family) {
>  			family = call_pkg->nd_family;
> -			if (!test_bit(family, &nd_desc->bus_family_mask))
> +			if (family > NVDIMM_BUS_FAMILY_MAX ||
> +			    !test_bit(family, &nd_desc->bus_family_mask))
>  				return -EINVAL;
> +			family = array_index_nospec(family,
> +						    NVDIMM_BUS_FAMILY_MAX + 1);
>  			dsm_mask = acpi_desc->family_dsm_mask[family];
>  			guid = to_nfit_bus_uuid(family);
>  		} else {

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

