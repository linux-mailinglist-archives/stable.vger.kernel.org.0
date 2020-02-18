Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0DFA1633C3
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 22:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgBRVD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 16:03:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43374 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726339AbgBRVD1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 16:03:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582059806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vvczn1/7WH5ejB4qaPLsHmvxrtLN/Bp15yKQpp7R6F0=;
        b=QwCDv0hboCAaLDWChj6XXRgGq1Ws57vi5oy4DLC48OSFtcFUeTSsFFInbXTx0cvbSIWrsb
        66Ir0d8xHurl+eq5hwn5KDfUDXIPrhqz1aClQ64KnxaD8qPhnPjjsWOcKYEBXAGZIhSqRs
        w1W01A+fHBhGlv8Zwq+v209cY5PbbnQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-c49ZyBenPCSX0r2KfBpWTg-1; Tue, 18 Feb 2020 16:03:15 -0500
X-MC-Unique: c49ZyBenPCSX0r2KfBpWTg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EC5FE107ACC4;
        Tue, 18 Feb 2020 21:03:13 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C5C819E9C;
        Tue, 18 Feb 2020 21:03:13 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Vaibhav Jain <vaibhav@linux.ibm.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] libnvdimm/of_pmem: Fix leaking bus_desc.provider_name in some paths
References: <20200123031847.149325-1-vaibhav@linux.ibm.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Tue, 18 Feb 2020 16:03:12 -0500
In-Reply-To: <20200123031847.149325-1-vaibhav@linux.ibm.com> (Vaibhav Jain's
        message of "Thu, 23 Jan 2020 08:48:47 +0530")
Message-ID: <x49mu9fbobz.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vaibhav Jain <vaibhav@linux.ibm.com> writes:

> String 'bus_desc.provider_name' allocated inside
> of_pmem_region_probe() will leak in case call to nvdimm_bus_register()
> fails or when of_pmem_region_remove() is called.
>
> This minor patch ensures that 'bus_desc.provider_name' is freed in
> error path for of_pmem_region_probe() as well as in
> of_pmem_region_remove().
>
> Cc: stable@vger.kernel.org
> Fixes:49bddc73d15c2("libnvdimm/of_pmem: Provide a unique name for bus provider")
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
> ---
>  drivers/nvdimm/of_pmem.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
> index 8224d1431ea9..9cb76f9837ad 100644
> --- a/drivers/nvdimm/of_pmem.c
> +++ b/drivers/nvdimm/of_pmem.c
> @@ -36,6 +36,7 @@ static int of_pmem_region_probe(struct platform_device *pdev)
>  
>  	priv->bus = bus = nvdimm_bus_register(&pdev->dev, &priv->bus_desc);
>  	if (!bus) {
> +		kfree(priv->bus_desc.provider_name);
>  		kfree(priv);
>  		return -ENODEV;
>  	}
> @@ -81,6 +82,7 @@ static int of_pmem_region_remove(struct platform_device *pdev)
>  	struct of_pmem_private *priv = platform_get_drvdata(pdev);
>  
>  	nvdimm_bus_unregister(priv->bus);
> +	kfree(priv->bus_desc.provider_name);
>  	kfree(priv);
>  
>  	return 0;

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

