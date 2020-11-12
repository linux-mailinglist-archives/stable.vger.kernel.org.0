Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D352B089F
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 16:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgKLPmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 10:42:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35743 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728186AbgKLPmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 10:42:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605195761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OkqKowoD8Fa06FAQzWTJ5BsbzJb5y/T/C12+aEbnTNg=;
        b=GmOCRhZ10iuIVD6wiRiCmxkiAXM7ReC7ECQYUV4gcnr8o0a26j+wYttB7XIXdHGwQOTRt+
        FqPbbMdqVqx6cAPUDrI11BDO5urwxoh8M3H3uaQfSuEr2PX6u+7OU2cQJbDD9GcEHeeRAV
        aNTRxHTLnWhlf7W8sWoqp21N9Z/foCo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-w52zUyQtNfKblOANK_9b_Q-1; Thu, 12 Nov 2020 10:42:39 -0500
X-MC-Unique: w52zUyQtNfKblOANK_9b_Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8E94100F7A7;
        Thu, 12 Nov 2020 15:42:37 +0000 (UTC)
Received: from llong.remote.csb (ovpn-117-44.rdu2.redhat.com [10.10.117.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BA296EF7C;
        Thu, 12 Nov 2020 15:42:34 +0000 (UTC)
Subject: Re: [RHEL8.4 BZ1844297 CVE-2020-8694 v5] powercap: restrict energy
 meter to root access
To:     Donghai Qiao <dqiao@redhat.com>, rhkernel-list@redhat.com
Cc:     Len Brown <len.brown@intel.com>, stable@vger.kernel.org
References: <20201110210336.14326-1-dqiao@redhat.com>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <b4a9ffae-978e-1288-4531-e39a30ef3dc0@redhat.com>
Date:   Thu, 12 Nov 2020 10:42:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201110210336.14326-1-dqiao@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/20 4:03 PM, Donghai Qiao wrote:
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1844297
> Upstream status: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=949dd0104c496fa7c14991a23c03c62e44637e71
> Build info: https://brewweb.engineering.redhat.com/brew/taskinfo?taskID=32573686
> CVE: CVE-2020-8694
>
> author	Len Brown <len.brown@intel.com>	2020-11-10 13:00:00 -0800
> committer	Len Brown <len.brown@intel.com>	2020-11-10 11:40:57 -0500
> commit	949dd0104c496fa7c14991a23c03c62e44637e71 (patch)
> tree	a90cbfb8ceb195e7160105a272122f97bab99980
> parent	3d7772ea5602b88c7c7f0a50d512171a2eed6659 (diff)
> download	linux-949dd0104c496fa7c14991a23c03c62e44637e71.tar.gz
> powercap: restrict energy meter to root access
> Remove non-privileged user access to power data contained in
> /sys/class/powercap/intel-rapl*/*/energy_uj
>
> Non-privileged users currently have read access to power data and can
> use this data to form a security attack. Some privileged
> drivers/applications need read access to this data, but don't expose it
> to non-privileged users.
>
> For example, thermald uses this data to ensure that power management
> works correctly. Thus removing non-privileged access is preferred over
> completely disabling this power reporting capability with
> CONFIG_INTEL_RAPL=n.
>
> Fixes: 95677a9a3847 ("PowerCap: Fix mode for energy counter")
>
> Signed-off-by: Len Brown <len.brown@intel.com>
> Cc: stable@vger.kernel.org
>
> Signed-off-by: Donghai Qiao <dqiao@redhat.com>
> ---
>   drivers/powercap/powercap_sys.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
> index e85639f004cc..e2150c00b842 100644
> --- a/drivers/powercap/powercap_sys.c
> +++ b/drivers/powercap/powercap_sys.c
> @@ -379,9 +379,9 @@ static void create_power_zone_common_attributes(
>   					&dev_attr_max_energy_range_uj.attr;
>   	if (power_zone->ops->get_energy_uj) {
>   		if (power_zone->ops->reset_energy_uj)
> -			dev_attr_energy_uj.attr.mode = S_IWUSR | S_IRUGO;
> +			dev_attr_energy_uj.attr.mode = S_IWUSR | S_IRUSR;
>   		else
> -			dev_attr_energy_uj.attr.mode = S_IRUGO;
> +			dev_attr_energy_uj.attr.mode = S_IRUSR;
>   		power_zone->zone_dev_attrs[count++] =
>   					&dev_attr_energy_uj.attr;
>   	}

Acked-by: Waiman Long <longman@redhat.com>

